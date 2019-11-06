---
layout: default
title: Architecture
nav_order: 1
---

Architecture Principles
=======================
{: .no_toc }

This section lists all high level architectural principles that have a relevant aspect when dealing with dependencies between teams and applications. Keep in mind that this is a summarized subset of SBB's Architecture Principles, which actually covers a lot more aspects.

*Note: The following content has been contents-wise translated from German to English. Some parts have been summarized up for the sake of precision and shortness.*

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Architecture Design Principles
*@see also: the complete [Architecture Design Principles](https://sbb.sharepoint.com/teams/384/EA-eSpace/02_Querschnitt/06_Architekturprinzipien/GEP_Gestaltungsprinzip.pdf) \[internal link\]*

### `MUST` Team decomposition and architecture decomposition are aligned
Development teams build the core unit in the phase of decomposition and separation of concerns into different applications ... Each application is assigned to exactly one development team ... Dependencies between applications are also dependencies between teams.

### `MUST` Composition of applications is done over well defined APIs
Dependencies between applications are always built over well defined interfaces (APIs). There must be no quick-and-dirty workarounds like direct access to a database of an other application.

### `MUST` APIs belong to business capabilities
An API itself is not a business capability, but it transports the teams core business values to other teams. Therefore, a team providing a business capability must own and provide the according API. This API must explicitly not be own and/or maintained by other teams.

For engineering teams, focusing on building business capabilities, it is tempting to delegate the API capabilities to a team which is the expert of building and providing APIs. But during the last decades we have learned, that introducing an API team, which publishes the API for an other team introduces an additional organizational and technical dependency which slows down evolution, complicates failure tracing and increases cost in creation and maintenance.

### `MUST` We build tolerant dependencies
When building dependencies between teams and applications, we focus on loose coupling. We implement [tolerant readers](https://martinfowler.com/bliki/TolerantReader.html) and we strictly follow Postel's law:

>Be conservative in what you do, be liberal in what you accept from others

New versions of a dependency (API) must not be introduced, unless there is no other way. The evolution of an API must be compatible within one version as long as possible. Changes are breaking, when consumers need to change simultaneously. In that case a new version must be introduced and maintained. APIs should not have more than two concurrent supported versions. Dependencies are also built tolerant in terms of changing latencies or outages.

## Software Provisioning Principles
*@see also: the complete [Software Provisioning Principles](https://sbb.sharepoint.com/teams/384/EA-eSpace/02_Querschnitt/06_Architekturprinzipien/BEP_Bereitstellungsprinzip.pdf) \[internal link\]*

### `MUST` Reuse before make
Teams must reuse functionality of other teams when the desired functionality is already existing. We prefer contributions to existing APIs (e.g. following [InnerSource](https://innersourcecommons.org) principles) than to rewrite already existing functionality of other teams.

During the process of software provisioning, the most actual and applicable [API Principles](https://schweizerischebundesbahnen.github.io/api-principles/) must be part of the decision criterias.

## Data and Integration Principles
*@see also: the complete [Data and Integration Principles](https://sbb.sharepoint.com/teams/384/EA-eSpace/02_Querschnitt/06_Architekturprinzipien/DIP%20Daten-%20und%20Integrationsprinzip.pdf)\[internal link\]*

### `MUST` Teams share business capabilities and data over APIs
Teams must focus on collaborating with other teams. They consume existing business capabilities and data over APIs.

Applications and their data are very valuable assets. Every team must publish it's business capabilities and data over well defined APIs using the [synchronous](synchronousdesign/synchronousdesign.md) or [asynchronous](asynchronousdesign/asynchronousdesign.md) pattern. APIs are accessible, well documented and designed with consumer oriented focus.

The owner and master of data assets must always be clearly defined and well know to both sides of a dependency.

### `MUST` We reuse existing APIs from the API Repository
Before building up a new dependency between applications and teams, we check for existing capabilities in the [API Repository](https://developer.sbb.ch).

### `SHOULD` Monitor API Usage
==============================
Owners of APIs used in production should monitor API usage to get information about its using clients. This information, for instance, is useful to identify partners for API changes and lifecycle management.