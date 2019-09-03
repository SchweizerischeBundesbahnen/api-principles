---
layout: default
title: Home
nav_order: 0
permalink: /
---

![API Principles](images/API-Principles-Logo.jpg)

Applications provide functionality via APIs, no matter if they are designed as Microservices or Monoliths. Their APIs purely express what systems do, and are therefore highly valuable business assets. Designing high quality, long lasting APIs has therefore become a business critical duty, which must be part of the development of every digitalized business capability or product. Our strategy emphasizes developing lots of internal APIs and also public APIs for our external business partners.

With this in mind, we’ve defined "API Principles" with the following key statements:

1. Every IT Solution publishes it's main capabilities over an API with a high [maturity](maturity/maturity.md)
2. APIs can be [synchronous](synchronousdesign/synchronousdesign.md) or [asynchronous](asynchronousdesign/asynchronousdesign.md)
3. Every API must fulfill the principles described on this site

Architecture Principles
=======================

This section lists all high level architectural principles that have a relevant aspect when dealing with dependencies between teams and applications. Keep in mind that this is a summarized subset of SBB's Architecture Principles, which actually covers a lot more aspects.

*Note: The following content has been contents-wise translated from German to English. Some parts have been summarized up for the sake of precision and shortness.*

## Architecture Design Principles
*@see also: the complete [Architecture Design Principles](https://sbb.sharepoint.com/teams/384/EA-eSpace/02_Querschnitt/06_Architekturprinzipien/GEP_Gestaltungsprinzip.pdf) \[internal link\]*

### Team decomposition and architecture decomposition are aligned
Development teams build the core unit in the phase of decomposition and separation of concerns into different applications ... Each application is assigned to exactly one development team ... Dependencies between applications are also dependencies between teams.

### We build tolerant dependencies
When building dependencies between teams and applications, we focus on loose coupling. We implement [tolerant readers](https://martinfowler.com/bliki/TolerantReader.html) and we strictly follow Postel's law:

>Be conservative in what you do, be liberal in what you accept from others

New versions of a dependency (API) must not be introduced, unless there is no other way. The evolution of an API must be compatible within one version as long as possible. Changes are breaking, when consumers need to change simultaneously. In that case a new version must be introduced and maintained. APIs should not have more than two concurrent supported versions. Dependencies are also built tolerant in terms of changing latencies or outages.

### Composition of applications is done over well defined APIs
Dependencies between applications are always built over well defined interfaces (APIs). There must be no quick-and-dirty workarounds like direct access to a database of an other application.

## Software Provisioning Principles
*@see also: the complete [Software Provisioning Principles](https://sbb.sharepoint.com/teams/384/EA-eSpace/02_Querschnitt/06_Architekturprinzipien/BEP_Bereitstellungsprinzip.pdf) \[internal link\]*

Teams must reuse functionality of other teams when the desired functionality is already existing. We prefer contributions to existing APIs (e.g. following [InnerSource](https://innersourcecommons.org) principles) than to rewrite already existing functionality of other teams.

During the process of software provisioning, the most actual and applicable [API Principles](https://schweizerischebundesbahnen.github.io/api-principles/) must be part of the decision criterias.

## Data and Integration Principles
*@see also: the complete [Data and Integration Principles](https://sbb.sharepoint.com/teams/384/EA-eSpace/02_Querschnitt/06_Architekturprinzipien/DIP%20Daten-%20und%20Integrationsprinzip.pdf)\[internal link\]*

### Teams share business capabilities and data over APIs
Teams must focus on collaborating with other teams. They consume existing business capabilities and data over APIs.

Applications and their data are very valuable assets. Every team must publish it's business capabilities and data over well defined APIs using the [synchronous](synchronousdesign/synchronousdesign.md) or [asynchronous](asynchronousdesign/asynchronousdesign.md) pattern. APIs are accessible, well documented and designed with consumer oriented focus.

The owner and master of data assets must always be clearly defined and well know to both sides of a dependency.

### We reuse existing APIs from the API Repository
Before building up a new dependency between applications and teams, we check for existing capabilities in the [API Repository](https://developer.sbb.ch).

Conventions Used in These Guidelines
====================================

#### Requirement level
The requirement level keywords "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" used in this document (case insensitive) are to be interpreted as described in [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

#### API Consumer vs. Provider
*Consumer* is used as a synonym for API Consumers (also known as clients of an API) and is referring the team which implements the client. On the other hand, we use *Provider* as a synonym for *API Provider*, referring the team maintaining the API.
