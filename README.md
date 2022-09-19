<h1 align="center">
    Data Exchange Agreements - Making data transactions trustworthy, auditable and immutable
</h1>

<p align="center">
    <a href="/../../commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/decentralised-dataexchange/smart-data-agreements?style=flat"></a>
    <a href="/../../issues" title="Open Issues"><img src="https://img.shields.io/github/issues/decentralised-dataexchange/smart-data-agreements?style=flat"></a>
    <a href="./LICENSE" title="License"><img src="https://img.shields.io/badge/License-Apache%202.0-green.svg?style=flat"></a>
</p>

<p align="center">
  <a href="#about">About</a> •
  <a href="#release-status">Release Status</a> •
  <a href="#contributing">Contributing</a> •
  <a href="#licensing">Licensing</a>
</p>

## About

This repository will host the specifications for data disclosure agreements (DDA). This is part of the deliverables for the Provenance services with smart data agreement (PS-SDA) project that has received funding from the European Union’s Horizon 2020 research and innovation programme under grant agreement No 957338.

The PS-SDA project is an open-source contribution led by iGrant.io (Sweden), MyData (Sweden) and Linaltec (Sweden). Read more on the project at NGI [ONTOCHAIN page](https://ontochain.ngi.eu/content/ps-sda*).

## Release Status

The key deliverables of the project are as given. The table summarises the release status of all the deliverables.

| Identifier | Date             | Deliverable                                                                                                                                                                                                                                                     |
| :--------- | :--------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| D1 / D2    | 04-February 2022 | Function specification v1.0.0                                                                                                                                                                                                                                   |
|            | 28-April 2022    | Data Disclosure Agreement specification ([Latest version](https://github.com/decentralised-dataexchange/data-exchange-agreements/blob/main/docs/datadisclosure-agreement-specification.md))                                                                     |
|            | 09-June 2022     | Data Disclosure Agreement protocol specification ([Latest version](https://github.com/decentralised-dataexchange/data-exchange-agreements/blob/main/docs/protocol/datadisclosure-agreement-protocol-specification.md), published [here](https://dda.igrant.io). |
| D3 / D4    | 04-Aug 2022      | Data Disclosure Agreement protocol and Smart contract Implementation (See chapter [Sourcecode deliverables](#sourcecode-deliverables)                                                                                                                           |
## Sourcecode deliverables

| Repository                                                                                                              | Description                                                                                                                                                                                                                                                                                                                                                 |
| :---------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [dexa-smart-contract](https://github.com/decentralised-dataexchange/dexa-smartcontracts)                                | This repository hosts the source code for DEXA smart contracts.                                                                                                                                                                                                                                                                                             |
| [dexa-sdk](https://github.com/decentralised-dataexchange/dexa-sdk)                                                      | This repository hosts the source code for DEXA agent SDK.                                                                                                                                                                                                                                                                                                   |
| [dexa-protocol](https://github.com/decentralised-dataexchange/dexa-smartcontracts)                                      | This repository hosts source code for DEXA protocol plugin for ACA-Py.                                                                                                                                                                                                                                                                                      |
| [acapy-mydata-did-protocol](https://github.com/decentralised-dataexchange/dexa-protocol)                                | This repository hosts source code for did:mydata DIDCOMM protocol plugin for ACA-Py. This protocol will enable an ACA-Py instance to become a verifiable data registry for did:mydata.                                                                                                                                                                      |
| [aries-playground](https://github.com/decentralised-dataexchange/aries-playground/tree/master/automated-data-agreement) | This repository contains the updated aries-playground (originally created by the iGrant.io team). This provides a set-up for developers to perform API call flows during a data agreement-enabled verified data exchange process using Hyperledger Indy as the distributed ledger registry and Aries agent as the client app.                               |
| [universal-resolver](https://github.com/decentralised-dataexchange/universal-resolver)                                  | The Universal Resolver resolves Decentralized Identifiers (DIDs) across many different DID methods based on the W3C DID Core 1.0 and DID Resolution specifications. It is a work item of the DIF Identifiers & Discovery Working Group. As part of the ADA project, we have added the did:mydata driver that can be resolved at https://dev.uniresolver.io/ |
| [mydata-did-driver](https://github.com/decentralised-dataexchange/mydata-did-driver)                                    | This repository hosts the source code for the universal resolver driver for did:mydata.                                                                                                                                                                                                                                                                     |
## Other resources

* [Data Agreement Specification](https://dda.igrant.io)
* iGrant.io Whitepaper: [A Sustainable Data Exchange - An ethical approach to sharing personal data](https://igrant.io/papers/iGrant.io_Sustainable_Data_Exchange_v1.pdf)
* [DIF Interop WG: Enabling exchange of X.509 signed personal data using VC](https://us02web.zoom.us/j/87258415110?pwd=cFhwYkRsUjRsYnFZZFgyQVR6Zk0xZz09)
* [Consent Agreement Demo - Special Meeting of the DIF C&C WG](https://www.youtube.com/watch?v=Mq4oXEaOTwg)
* `DID:mydata` at [W3C DID Registry](https://www.w3.org/TR/did-spec-registries/)

## Contributing

Feel free to improve the plugin and send us a pull request. If you found any problems, please create an issue in this repo.

## Licensing
Copyright (c) 2021-23 LCubed AB (iGrant.io), Sweden

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.

You may obtain a copy of the License at https://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the LICENSE for the specific language governing permissions and limitations under the License.
