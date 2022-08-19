# Data Agreement DID Method Specification (did:mydata)

## Abstract

A Data Agreement (DA) exists between organisations and individuals in the use of personal data. This agreement can have any legal basis that is outlined according to any data protection regulation, such as the GDPR. This proposal envisions a decentralised identifier (did:mydata) for an associated Data Agreement for any personal data usage.

## Status of This Document

Version 2.0 (Supersedes [Version 1.1](https://github.com/decentralised-dataexchange/automated-data-agreements/blob/main/docs/did-spec.md))

## **Authors**

Mr. George Padayatti (iGrant.io, Sweden)

Mr. Lal Chandran (iGrant.io, Sweden)

## **Contributors and Reviewers**

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

### Create

The did:mydata identifier corresponds to an agreement in MyData ecosystem. Creation of the identifier assumes that through an out-of-band/didcomm interaction actors involved in the agreement has arrived at terms, i.e both (if 2 actors are involved) parties holds an agreement document with a proof chain ([Data Integrity Model](https://w3c.github.io/vc-data-integrity/)) in it. The agreement document must conform to JSONLD context matching the agreement type, for e.g. A Data Disclosure Agreement must conform to JSONLD context defined [here](https://github.com/decentralised-dataexchange/data-exchange-agreements/blob/main/interface-specs/data-disclosure-agreement-schema/data-disclosure-agreement-schema-context.jsonld).

Specification also assumes the parties involved in the agreement has created the cryptographic material to sign the agreement. The cryptographic material represented as decentralised identifiers based on the DID method chosen by the party. These DIDs then act as the controller for the DID document associated with did:mydata identifier. The DID document associated with the did:mydata identifier contains the agreement as payload. An example DID document is given below.

 

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

In the above document, controller property contains 2 did:key identifiers. These identifiers belong to the parties involved in the agreement. The payload property is an unregistered DID property extension used to contain the base64 encoded JCS canonicalised agreement document. An example payload base64 decoded in given below.

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

#### The did:mydata identifier creation algorithm

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

To be elaborated.

### Update

To be elaborated.

### Deactivate

To be elaborated.

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