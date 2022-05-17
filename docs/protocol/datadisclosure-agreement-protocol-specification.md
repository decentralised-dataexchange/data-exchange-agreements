# Data Disclosure Agreement Protocol Specification

## Abstract
Data disclosure agreements focuses on enables automated agreement handling to enable data sharing and exchange between data sources and data using services. It helps organisations to continue leveraging data while being transparent and legitimate in their data usage in a scalable manner while adhering to data **regulations**. It also provides individuals control over how their data is used and exchanged.

## Status of This Document
Work in progress, version 0.9

## Authors
Mr. George Padayatti (iGrant.io, Sweden)  
Mr. Lal Chandran (iGrant.io, Sweden)

## Contributors and Reviwers
Dr. David Goodman (iGrant.io, Sweden)  
Mr. Jan Linquist (Linaltec, Sweden)  
Ms. Lotta Lundin (iGrant.io, Sweden)

## Introduction

To be written...

### Actors

1. Data Using Service
2. Data Source
3. Individual
4. Data Intermediary
5. Data Marketplace

## Protocol flow

### Pre-requisite

All the actors involved in the protocol flow is a DIDComm agent. Each interaction between the actors require a DIDComm message. Prior to the PS-SDA protocol flow, actors must establish connection [1] between each other and identify themselves by presenting the necessary proofs [2]. All the actors will have a wallet address and an associated public / private key pair. A wallet address is an external owned account ethereum address. Ethereum addresses are composed of the prefix "0x" (a common identifier for hexadecimal) concatenated with the rightmost 20 bytes of the Keccak-256 hash of the ECDSA public key with the curve secp256k1.

### DS publish DDA to Marketplace


![](../images/publish-dda-to-marketplace.png)

#### Sign a DDA template

Data Sources prepares a DDA template and signs it using the secp256k1 private key. The signature is prepared by performing the proof algorithm described by W3C Data Integrity 1.0 specification [3].

#### Publish signed DDA template to Data Intermediary

DS constructs a `dda/1.0/publish` DIDComm message and send it to Data Intermediary DIDComm agent. An example is provided below.

```
{
  "@type": "https://didcomm.org/dda/1.0/publish",
  "@id": "999f6c2b-b0e5-4123-aab0-b5f7bfc780c4",
  "created_time": "1639288911",
  "@from": "<sender did>",
  "@to": "<receipient did>",
  "body": {},
  "attachments": [
    {
      "id": "1",
      "description": "Data Disclosure Agreement",
      "data": {
        "base64": "<base64 encoded canonicalised dda>"
      }
    }
  ]
}
```

1. Data Intermediary stores the signed DDA to IPFS.
2. Execute the smart contract function `publishDDADoc` to publish the hash.
3. Data marketplace will subscribe to the smart contract events and display them.


## Security Considerations

## Privacy Considerations

## Implementation Considerations

## References

1. Aries RFC 0160 Connection protocol - https://github.com/hyperledger/aries-rfcs/tree/main/features/0160-connection-protocol
2. Aries RFC 0037 Present Proof protocol - https://github.com/hyperledger/aries-rfcs/tree/main/features/0037-present-proof
3. W3C Data Integrity 1.0 specification - https://w3c-ccg.github.io/data-integrity-spec

