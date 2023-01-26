# Data Agreement DID Method Specification (did:mydata)

## Abstract

A Data Agreement (DA) exists between organisations and individuals in the use of personal data. This agreement can have any legal basis that is outlined according to any data protection regulation, such as the GDPR. This proposal envisions a decentralised identifier (did:mydata) for an associated Data Agreement for any personal data usage.

## Status of This Document

Version 2.0 (Supersedes Version 1.1 - [https://github.com/decentralised-dataexchange/automated-data-agreements/blob/main/docs/did-spec.md](https://github.com/decentralised-dataexchange/automated-data-agreements/blob/main/docs/did-spec.md))

## Authors

Mr. George Padayatti (iGrant.io, Sweden)

Mr. Lal Chandran (iGrant.io, Sweden)

## Contributors and Reviewers

Mr. Mr. Jan Lindquist (Linaltec, Sweden)

Ms. Lotta Lundin (iGrant.io, Sweden)

## Introduction

This document proposes an update to the existing did:mydata v1.1 identifier to meet the updated set of requirements. Those are:

- Should be able to prove integrity of the agreement payload i.e. method specific identifier should be an immutable cryptographic commitment to the current state of the underlying agreement payload.
- Identifier not change, even if there are changes to agreement payload.
    - Ability to traverse to the latest version of the identifier and return the same on resolution.
- Identifier should visually indicate the type of the underlying agreement.
- Identifier should be resolvable from different did registries based on the location parameter.
    - Identifier should support indirection in the location parameter. i.e. if the location is blockchain transaction identifier, then the resolver will fetch the transaction and then obtain the hashlink which is resolved to the did document. This feature enables to maintain an optional central source of truth.

While designing the did:mydata v2.0 identifier we realised the following from the previous iteration of the identifier:

- For the *did:mydata* identifier format, in the previous iteration there was an optional *did-type-integer*, which conveyed the role of the did controller for .e.g. 0 would mean Data Source, 1 would mean Individual e.t.c. This is now dropped as v2 identifier does not require identifying the role of a did controller. The v2 method specific identifier is a immutable cryptographic commitment to the underlying the agreement object.
- In the previous iteration, the purpose of the *did:mydata* was to resolve into did document that contains the public keys, which can then be used to *authenticate* the signatures embedded in the agreement.
    - Side note: During the time did:key was considered, since did:key cannot contained service endpoints property, we based *did:mydata* on did:key with the additional property of supporting service endpoint in the did document.
    - This also meant, *did:mydata* requires a registry to resolve did document unlike *did:key*.
- In the latest iteration, since we realise there are other full fledged did methods that provide the function to resolve into the public key and service endpoints. For e.g. did:sov is one of them.
- In the previous iteration, did registry location cannot be passed along with did:mydata identifier while resolution, this would mean, the did:mydata identifier gets resolved from a *fixed* registry location as specified in the driver by its developer.

## The did:mydata format

The format for the `did:mydata` method conforms to the DID core specification [1] as outlined by W3C. It consists of the `did:mydata` prefix, followed by the `mb-value` value.

The `mb-value` is a Multibase [2] `base58-btc` encoded value of the first 16 raw bytes of sha256 hash for the JSON-LD context document corresponding to the agreement type concatenated with 32 raw bytes of sha256 hash of the merkle tree root created from n-quad normalised statements (N-Quads is the output format of the [Universal Dataset Normalization Algorithm](https://json-ld.github.io/normalization/spec/)
 (URDNA2015)) for the underlying agreement. The [iGrant.io](http://igrant.io/) DID scheme is defined by the following ABNF:

```
did-mydata-format := did:mydata:<mb-value>
mb-value := z[a-km-zA-HJ-NP-Z1-9]+
```

Generation of method specific identifier can be thought as a series of transformations applied on the raw public key bytes of the merkle root hash.

```
did-mydata-format := did:mydata:MULTIBASE(base58-btc, CONCATENATE(agreement-type-hash-bytes, agreement-merkle-root-hash-bytes))
```

Example, a valid MyData/iGrant.io DID for a Data Disclosure Agreement could be:

```
did:mydata:zJ53MfXX934iYwx6hdQRKonWkVj22t9NczBmwe7To2Yh2sTnS7W32ocTYgvwtQRB3K
```

## Operations

Each DID registry service will be exposing a DIDComm agent. CRUD operations on DID can then be performed using available DIDComm messages. A new DIDComm protocol (URI: did:sov:BzCbsNYhMrjHiqZDTUASHg;spec/mydata-did/2.0/) is specified below for performing CRUD operations. The DID registry service itself will be allocated a DID and an associated DID document will be publicly available at a well-known DID configuration endpoint (`"/.well-known/did-configuration.json"`) of the web server. The audience of this document is expected to be familiar with DIDComm message specification [4] and it’s extensions.

### Create

The did:mydata identifier corresponds to an artefact in any data ecosystem served by any data intermediation service such as iGrant.io. Supported artefacts are:

- Agreements - Records the conditions under which two parties have come to agreement. Meaning both parties are getting “informed” about the terms.
    - [Data Disclosure Agreement (DDA)](https://github.com/decentralised-dataexchange/data-exchange-agreements/blob/4cd82dac0926da89fa3cb180bbe89bd397170bbd/interface-specs/jsonld/contexts/dexa-context.jsonld#L176-L291)
    - [Data Agreement (DA)](https://github.com/decentralised-dataexchange/data-exchange-agreements/blob/4cd82dac0926da89fa3cb180bbe89bd397170bbd/interface-specs/jsonld/contexts/dexa-context.jsonld#L7-L175)
- Consents - Records the granular “consent” for personal data described in the data agreement.

Each artefact must conform to a JSONLD context. For e.g. a Data Disclosure Agreement (DDA) must conform to JSONLD context defined [here](https://github.com/decentralised-dataexchange/data-exchange-agreements/blob/main/interface-specs/data-disclosure-agreement-schema/data-disclosure-agreement-schema-context.jsonld). A genesis artefact must be created and did:mydata identifier is generated by embedding artefact as payload in the DID document. Each artefact will have cryptographic material associated to it. Cryptographic material represented as decentralised identifiers will be listed in the controllers property of the DID document. Controllers can make changes to the underlying artefact. Artefact should contains proofs that CONFORMS to  W3C [Data Integrity Model](https://w3c.github.io/vc-data-integrity/) and number of proofs should match the number of controllers. Creation of did:mydata identifiers occurs as result of [DDA protocols](https://dda.igrant.io/protocol/#smart-contracts) (To be elaborated further).

An example DID document is given below.

```json
{
  "@context": [
    "https://www.w3.org/ns/did/v1",
    "https://w3id.org/security/suites/ed25519-2020/v1"
  ],
  "id": "did:mydata:zJ53MfXX934iYwx6hdQRKonWkVj22t9NczBmwe7To2Yh2sTnS7W32ocTYgvwtQRB3K",
  "controller": [
    "did:key:z6MkhaXgBZDvotDkL5257faiztiGiC2QtKLGpbnnEGta2doK",
    "did:key:z6MkpTHR8VNsBxYAAWHut2Geadd9jSwuBV8xRoAnwWsdvktH"
  ],
  "payload": "eyJAY29udGV4dCI6WyJodHRwczovL3Jhdy5naXRodWJ1c2VyY29udGVudC5jb20vZGVjZW50cmFsaXNlZC1kYXRhZXhjaGFuZ2UvZGF0YS1leGNoYW5nZS1hZ3JlZW1lbnRzL21haW4vaW50ZXJmYWNlLXNwZWNzL2RhdGEtZGlzY2xvc3VyZS1hZ3JlZW1lbnQtc2NoZW1hL2RhdGEtZGlzY2xvc3VyZS1hZ3JlZW1lbnQtc2NoZW1hLWNvbnRleHQuanNvbmxkIiwiaHR0cHM6Ly93M2lkLm9yZy9zZWN1cml0eS92MiJdLCJAaWQiOiJ1cm46dXVpZDpubW1sIiwiQHR5cGUiOlsiRGF0YURpc2Nsb3N1cmVBZ3JlZW1lbnQiXSwiYWdyZWVtZW50UGVyaW9kIjozNjUsImNvZGVPZkNvbmR1Y3QiOiJhYmMuY29tL2NvZGVfb2ZfY29uZHVjdC5odG1sIiwiZGF0YUNvbnRyb2xsZXIiOnsiZGlkIjoiZGlkOmFiYyIsImluZHVzdHJ5U2VjdG9yIjoicmV0YWlsIiwibGVnYWxJZCI6ImxlaTphYmMiLCJuYW1lIjoiYWxpY2UiLCJ1cmwiOiJhbGljZS5jb20ifSwiZGF0YVNoYXJpbmdSZXN0cmljdGlvbnMiOnsiZGF0YVJldGVudGlvblBlcmlvZCI6MzY1LCJnZW9ncmFwaGljUmVzdHJpY3Rpb24iOiJFVSIsImluZHVzdHJ5U2VjdG9yIjoiUmV0YWlsIiwianVyaXNkaWN0aW9uIjoiRVUiLCJwb2xpY3lVcmwiOiJhbGljZS5jb20vcG9saWN5Lmh0bWwiLCJzdG9yYWdlTG9jYXRpb24iOiJFVSJ9LCJkYXRhVXNpbmdTZXJ2aWNlIjp7ImRpZCI6ImRpZDplZmciLCJpbmR1c3RyeVNlY3RvciI6InJldGFpbCIsImp1cmlzZGljdGlvbiI6IkVVIiwibGVnYWxJZCI6ImxlaTphYmMiLCJuYW1lIjoiYWJjIiwicHJpdmFjeVJpZ2h0cyI6ImFiYy5jb20vcHJpdmFjeV9yaWdodHMuaHRtbCIsInNpZ25hdHVyZUNvbnRhY3QiOiJhbGljZSIsInVybCI6ImFiYy5jb20iLCJ1c2FnZVB1cnBvc2VzIjoiYWJjIiwid2l0aGRyYXdhbCI6ImFiYy5jb20vd2l0aGRyYXdhbC5odG1sIn0sImV2ZW50IjpbeyJkaWQiOiJkaWQ6YWJjOmFsaWNlIiwiaWQiOiJ1cm46dXVpZDpldmVudCIsInN0YXRlIjoiYWNjZXB0IiwidGltZXN0YW1wIjoiMTIzNCJ9XSwibGFuZ3VhZ2UiOiJlbiIsImxhd2Z1bEJhc2lzIjoiY29uc2VudCIsInBlcnNvbmFsRGF0YSI6W3siYXR0cmlidXRlQ2F0ZWdvcnkiOiJwZXJzb25hbF9kYXRhIiwiYXR0cmlidXRlSWQiOiJhYmMxMjMiLCJhdHRyaWJ1dGVOYW1lIjoiYWJjIiwiYXR0cmlidXRlU2Vuc2l0aXZlIjoidHJ1ZSJ9XSwicHJvb2ZDaGFpbiI6W3siY3JlYXRlZCI6IjEyMzQiLCJpZCI6InVybjp1dWlkOnByb29mIiwicHJvb2ZQdXJwb3NlIjoiQXNzZXJ0aW9uIiwicHJvb2ZWYWx1ZSI6IngueS56IiwidHlwZSI6IkFzc2VydGlvbiIsInZlcmlmaWNhdGlvbk1ldGhvZCI6IkFzc2VydGlvbiJ9XSwicHVycG9zZSI6InNvbWUgcHVycG9zZSIsInB1cnBvc2VEZXNjcmlwdGlvbiI6ImRlc2NyaXB0aW9uIG9mIHRoZSBwdXJwb3NlIiwidGVtcGxhdGVJZCI6InVybjp1dWlkOnp5YyIsInRlbXBsYXRlVmVyc2lvbiI6IjAuMC4xIiwidmVyc2lvbiI6IjAuMC4xIn0="
}
```

In the above document, controller property contains 2 did:key identifiers. These identifiers belong to the parties involved in the agreement. The payload property is an *unregistered DID property extension* used to contain the base64 encoded JCS canonicalised agreement document. An example payload base64 decoded in given below.

```json
{
  "@context": [
    "https://raw.githubusercontent.com/decentralised-dataexchange/data-exchange-agreements/main/interface-specs/data-disclosure-agreement-schema/data-disclosure-agreement-schema-context.jsonld",
    "https://w3id.org/security/v2"
  ],
  "@id": "urn:uuid:nmml",
  "@type": [
    "DataDisclosureAgreement"
  ],
  "agreementPeriod": 365,
  "codeOfConduct": "abc.com/code_of_conduct.html",
  "dataController": {
    "did": "did:abc",
    "industrySector": "retail",
    "legalId": "lei:abc",
    "name": "alice",
    "url": "alice.com"
  },
  "dataSharingRestrictions": {
    "dataRetentionPeriod": 365,
    "geographicRestriction": "EU",
    "industrySector": "Retail",
    "jurisdiction": "EU",
    "policyUrl": "alice.com/policy.html",
    "storageLocation": "EU"
  },
  "dataUsingService": {
    "did": "did:efg",
    "industrySector": "retail",
    "jurisdiction": "EU",
    "legalId": "lei:abc",
    "name": "abc",
    "privacyRights": "abc.com/privacy_rights.html",
    "signatureContact": "alice",
    "url": "abc.com",
    "usagePurposes": "abc",
    "withdrawal": "abc.com/withdrawal.html"
  },
  "event": [
    {
      "did": "did:abc:alice",
      "id": "urn:uuid:event",
      "state": "accept",
      "timestamp": "1234"
    }
  ],
  "language": "en",
  "lawfulBasis": "consent",
  "personalData": [
    {
      "attributeCategory": "personal_data",
      "attributeId": "abc123",
      "attributeName": "abc",
      "attributeSensitive": "true"
    }
  ],
  "proofChain": [
    {
      "created": "1234",
      "id": "urn:uuid:proof",
      "proofPurpose": "Assertion",
      "proofValue": "x.y.z",
      "type": "Assertion",
      "verificationMethod": "did:key:z6MkhaXgBZDvotDkL5257faiztiGiC2QtKLGpbnnEGta2doK"
    }
  ],
  "purpose": "some purpose",
  "purposeDescription": "description of the purpose",
  "templateId": "urn:uuid:zyc",
  "templateVersion": "0.0.1",
  "version": "0.0.1"
}
```

The controllers should match the `verificationMethod` specified in the `proofChain`.

#### did:mydata identifier creation algorithm

Following algorithm is used to create the did:mydata identifier, if an agreement document is available.

1. Represent the agreement as Merkle Tree.
    1. Canonicalise the JSON-LD document using Universal Dataset Normalisation Algorithm (URDNA 2015) in to n-quad statements list.
    2. Create a Merkle Tree with n-quad statement list as input.
2. Obtain Merkle Root hash (SHA2-256).
3. Fetch the JSON-LD context document for the agreement type. For e.g. Context document for Data Disclosure Agreement is available [here](https://github.com/decentralised-dataexchange/data-exchange-agreements/blob/main/interface-specs/data-disclosure-agreement-schema/data-disclosure-agreement-schema-context.jsonld).
    1. Perform Json Canonicalisation Scheme ([IETF 8785](https://www.rfc-editor.org/rfc/rfc8785.txt))
    2. HASH the canonicalised document using message digest algorithm (SHA2-256).
4. Split the 32 byte hash for the context into 16 bytes.
5. Raw bytes of Merkle root hash obtained earlier is prefixed with first 16 bytes of the agreement context.
6. Perform MULTIBASE base58btc encoding on prefixed bytes to generate the method specific identifier.
7. The result identifier is prefixed with ‘did:mydata:’

> If the agreement type is Data Disclosure Agreement, then the resultant identifier will start with `zJ53`
> 

#### Optional anchoring of did:mydata identifier on a DLT

This will be further elaborated. 

After the parties involved in the agreement come into terms. The actor with the role of DS/DUS can optionally send back a DID registration receipt. The receipt will contain the following information.

- Fingerprint of the DID document
- URI to access the DID
    - Either a HTTP URL or a blockchain transaction identifier (Supported blockchain will be listed in the subsequent sections)

If the did:mydata identifier is anchored to a blockchain, a did with hashlink should be present in the transaction data to obtain the did document. This is a purposeful indirection for maintaining a central source of truth.

### Read

To resolve a did:mydata identifier, an identifier with following DID parameters must be available:

- `registryUrl` : Encoded URL for a remote DID registry. *(mandatory)*
- `versionId`: Identifies a specific version of a DID document to be resolved (the version ID is the merkle root of the specific artefact). If present, the associated value MUST be an ASCII string. *(optional, if not present, will return the latest version)*
- `token`: JWT token signed by the controller. This acts as the proof of possession of the private key associated with controller decentralised identifier  ***(optional, if not present, then confidential payload won’t be present in the diddoc)***
- `blink`: Blockchain link conforming to [W3C Blockchain Links](https://w3c-ccg.github.io/blockchain-links/) *(optional, if present, the did registry would check artefact merkle root in transaction, to be elaborated further)*

An example identifier with parameters is given below:

```bash
did:mydata:zJ53MfXX934iYwx6hdQRKonWkVj22t9NczBmwe7To2Yh2sTnS7W32ocTYgvwtQRB3K?registryUrl=https%3A%2F%2Fagent.igrant.io&token=<jwt>
```

To resolve a DID and fetch the associated DID document from the DID registry, a DIDComm plaintext message of type - [https://didcomm.org/mydata-did/2.0/read-did](https://didcomm.org/mydata-did/2.0/read-did) must be constructed. An example is given below:

```json
{
  "@id": "3e914e45-28f0-4009-b9c2-e2df2ba165b8",
  "@type": "https://didcomm.org/mydata-did/2.0/read-did",
  "to": "<recipient-did>",
  "created_time": "1622649143",
  "did": "did:mydata:zJ53MfXX934iYwx6hdQRKonWkVj22t9NczBmwe7To2Yh2sTnS7W32ocTYgvwtQRB3K",
  "token": "<token>",
  "~transport": {
    "return_route": "all"
  }
}
```

The `did` attribute in the message body represents the DID that will be resolved.

The above example requests DID registry service to resolve `did:mydata:zJ53MfXX934iYwx6hdQRKonWkVj22t9NczBmwe7To2Yh2sTnS7W32ocTYgvwtQRB3K` 

Notice the message json+ld doesn’t contain a **from** key, since the read operation can be performed without owning a DID. The packing algorithm used for constructing the DIDComm encryption envelope should be anoncrypt.

DID registry will check the merkle root in the deactivation tree and make sure it is not deactivated. DID registry service will respond to the above DIDComm message with an encryption envelope (JWE) which when unpacked will contain a DIDComm plaintext message of type - [https://didcomm.org/mydata-did/2.0/read-did-response](https://didcomm.org/mydata-did/2.0/read-did-response). An example is given below:

```json
{
  "@type": "https://didcomm.org/mydata-did/2.0/read-did-response",
  "@id": "4f4fbc78-be45-4029-ad18-a808c3a36ac2",
  "from": "<source>",
  "created_time": "1622649143",
  "~thread": {
    "thid": "3e914e45-28f0-4009-b9c2-e2df2ba165b8"
  },
  "body": {
    "diddoc": {},
    "merkleRoot": "",
    "merkleInclusionProof": [],
    "blink": "",
    "created": "",
    "updated": "",
    "deactivated": "",
    "nextUpdate": "",
    "versionId": "",
    "nextVersionId": ""
  }
}
```

If a problem arises while handling the `read-did` message, DID registry service will respond with a problem report message. An example is given below:

```json
{
  "@type": "https://didcomm.org/mydata-did/2.0/problem-report",
  "@id": "2c8579d3-ecdd-4427-9e2f-7f911917de6c",
  "~thread": {
    "thid": "3e914e45-28f0-4009-b9c2-e2df2ba165b8"
  },
  "description": "did:mydata identifier not found"
}
```

### Update

To update a DID document associated with a did:mydata identifier, a DIDComm plaintext message of type - [https://didcomm.org/mydata-did/2.0/update-did](https://didcomm.org/mydata-did/2.0/update-did) must be constructed by the controller. An example is given below:

```json
{
  "@id": "3e914e45-28f0-4009-b9c2-e2df2ba165b8",
  "@type": "https://didcomm.org/mydata-did/2.0/update-did",
  "to": "<recipient-did>",
  "created_time": "1622649143",
  "did": "did:mydata:zJ53MfXX934iYwx6hdQRKonWkVj22t9NczBmwe7To2Yh2sTnS7W32ocTYgvwtQRB3K",
  "token": "<token>",
  "payload": "<base64 artefact>",
  "~transport": {
    "return_route": "all"
  }
}
```

DID registry on receiving the message validates the payload against the JSONLD context of the artefact type. Once the data is validated against the schema, the data integrity is verified using [W3C DATA INTEGRITY MODEL](https://w3c.github.io/vc-data-integrity/). The new payload, is then added to the merkle tree and a merkle inclusion proof is provided in the response.

DID registry service will respond to the above DIDComm message with an encryption envelope (JWE) which when unpacked will contain a DIDComm plaintext message of type - [https://didcomm.org/mydata-did/2.0/update-did-response](https://didcomm.org/mydata-did/2.0/update-did-response). An example is given below:

```json
{
  "@type": "https://didcomm.org/mydata-did/2.0/update-did-response",
  "@id": "4f4fbc78-be45-4029-ad18-a808c3a36ac2",
  "from": "<source>",
  "created_time": "1622649143",
  "~thread": {
    "thid": "3e914e45-28f0-4009-b9c2-e2df2ba165b8"
  },
  "body": {
    "diddoc": {},
    "merkleRoot": "",
    "merkleInclusionProof": [],
    "blink": "",
    "created": "",
    "updated": "",
    "deactivated": "",
    "nextUpdate": "",
    "versionId": "",
    "nextVersionId": ""
  }
}
```

If a problem arises while handling the `update-did` message, DID registry service will respond with a problem report message.

### Deactivate

To deactivate a did:mydata identifier, a DIDComm plaintext message of type - [https://didcomm.org/mydata-did/2.0/deactivate-did](https://didcomm.org/mydata-did/2.0/deactivate-did) must be constructed by the controller. An example is given below:

```json
{
  "@id": "3e914e45-28f0-4009-b9c2-e2df2ba165b8",
  "@type": "https://didcomm.org/mydata-did/2.0/deactivate-did",
  "to": "<recipient-did>",
  "created_time": "1622649143",
  "did": "did:mydata:zJ53MfXX934iYwx6hdQRKonWkVj22t9NczBmwe7To2Yh2sTnS7W32ocTYgvwtQRB3K",
  "token": "<token>",
  "~transport": {
    "return_route": "all"
  }
}
```

DID registry on receiving the message validates the token and proceed to deactivate the did:mydata identifier. The did:mydata is deactivated by including in the revocation tree.

DID registry service will respond to the above DIDComm message with an encryption envelope (JWE) which when unpacked will contain a DIDComm plaintext message of type - [https://didcomm.org/mydata-did/2.0/deactivate-did-response](https://didcomm.org/mydata-did/2.0/deactivate-did-response). An example is given below:

```json
{
  "@type": "https://didcomm.org/mydata-did/2.0/deactivate-did-response",
  "@id": "4f4fbc78-be45-4029-ad18-a808c3a36ac2",
  "from": "<source>",
  "created_time": "1622649143",
  "~thread": {
    "thid": "3e914e45-28f0-4009-b9c2-e2df2ba165b8"
  },
  "body": {
    "deactivated": ""
  }
}

```

If a problem arises while handling the `deactivate-did` message, DID registry service will respond with a problem report message.

## Resources

1. DID core specification: [https://www.w3.org/TR/did-core/](https://www.w3.org/TR/did-core/)
2. IETF Multibase Data Format specification: [https://tools.ietf.org/html/draft-multiformats-multibase](https://tools.ietf.org/html/draft-multiformats-multibase) 
3. Multicodec - Compact self-describing codecs: [https://github.com/multiformats/multicodec](https://github.com/multiformats/multicodec)
4. DIDComm message specification: [https://identity.foundation/didcomm-messaging/spec/](https://identity.foundation/didcomm-messaging/spec/) 
5. Linked Data Cryptographic Suit Registry: [https://w3c-ccg.github.io/ld-cryptosuite-registry/](https://w3c-ccg.github.io/ld-cryptosuite-registry/) 
6. Aries RFC 0092 - Transports Return Route: [https://github.com/hyperledger/aries-rfcs/tree/master/features/0092-transport-return-route](https://github.com/hyperledger/aries-rfcs/tree/master/features/0092-transport-return-route) 
7. Aries RFC 0019: Encryption Envelope: [https://github.com/hyperledger/aries-rfcs/tree/master/features/0019-encryption-envelope](https://github.com/hyperledger/aries-rfcs/tree/master/features/0019-encryption-envelope)
8. IETF RFC 7516 - JSON Web Encryption: [https://datatracker.ietf.org/doc/html/rfc7516](https://datatracker.ietf.org/doc/html/rfc7516) 
9. Aries RFC 0035 - Report Problem Protocol 1.0: [https://github.com/hyperledger/aries-rfcs/tree/master/features/0035-report-problem](https://github.com/hyperledger/aries-rfcs/tree/master/features/0035-report-problem)
10. [Data Agreement Specification](https://github.com/decentralised-dataexchange/automated-data-agreements/blob/main/docs/data-agreement-specification.md), ADA Project, eSSIF-Lab Infrastructure 
