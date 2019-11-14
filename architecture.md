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

For engineering teams, focusing on building business capabilities, it is tempting to delegate the API capabilities to a team which is the expert of building and providing APIs. But during the last decades we have learned, that introducing an API team which publishes the API for an other team introduces an additional organizational and technical dependency which slows down evolution, complicates failure tracing and increases cost in creation and maintenance.

### `MUST` We build tolerant dependencies
When building dependencies between teams and applications, we focus on loose coupling. We implement [tolerant readers](https://martinfowler.com/bliki/TolerantReader.html) and we strictly follow Postel's law:

>Be conservative in what you do, be liberal in what you accept from others

New versions of a dependency (API) must not be introduced, unless there is no other way. The evolution of an API must be compatible within one version as long as possible. Changes are breaking, when consumers need to change simultaneously. In that case a new version must be introduced and maintained. APIs should not have more than two concurrent supported versions. Dependencies are also built tolerant in terms of changing latencies or outages.

### `MUST` Hide Complexity
The Design of an API must follow the principle of [information hiding](https://en.wikipedia.org/wiki/Information_hiding). As already described above, APIs transport business capabilities, but they **must not** transport the complexity of the system behind the API. This means it is relavant that an API hides implementation details. An API should be understandable and intuitive for humans that are not very familiar with the API's business domain.

*Example 1*:
One should not be able to recognize if an API is provided by a software system built with ABAP, or Java or .Net.

*Example 2*:
Several websites already have shown that it is possible to build understandable (user) interfaces on a complex business domain like payment. When possible with UIs, it is also possible with APIs.

## Software Provisioning Principles
*@see also: the complete [Software Provisioning Principles](https://sbb.sharepoint.com/teams/384/EA-eSpace/02_Querschnitt/06_Architekturprinzipien/BEP_Bereitstellungsprinzip.pdf) \[internal link\]*

### `MUST` Reuse before make
Teams must reuse functionality of other teams when the desired functionality is already existing. We prefer contributions to existing APIs (e.g. following [InnerSource](https://innersourcecommons.org) principles) than to rewrite already existing functionality of other teams.

During the process of software provisioning, the most actual and applicable [API Principles](https://schweizerischebundesbahnen.github.io/api-principles/) must be part of the decision criterias.

## Data and Integration Principles
*@see also: the complete [Data and Integration Principles](https://sbb.sharepoint.com/teams/384/EA-eSpace/02_Querschnitt/06_Architekturprinzipien/DIP%20Daten-%20und%20Integrationsprinzip.pdf)\[internal link\]*

### `MUST` Teams share business capabilities and data over APIs
Teams must focus on collaborating with other teams. They consume existing business capabilities and data over APIs.

Applications and their data are very valuable assets. Every team must publish it's business capabilities and data over well defined APIs using the [RESTful](restful/restful.md) or [Event-Driven](eventdriven/eventdriven.md) architectural style. APIs are accessible, well documented and designed with consumer oriented focus.

The owner and master of data assets must always be clearly defined and well know to both sides of a dependency.

### `MUST` We reuse existing APIs from the API Repository
Before building up a new dependency between applications and teams, we check for existing capabilities in the [API Repository](https://developer.sbb.ch).

### `SHOULD` Monitor API Usage

Owners of APIs used in production should monitor API usage to get information about its using clients. This information, for instance, is useful to identify partners for API changes and lifecycle management.

### `MUST` Design API First

In a nutshell API First requires two aspects:

-   define APIs first, before coding its implementation, using a standard specification language

-   get early review feedback from peers and client developers

By defining APIs outside the code, we want to facilitate early review feedback and also a development discipline that focus service interface design on…​

-   profound understanding of the domain and required functionality

-   generalized business entities / resources, i.e. avoidance of use case specific APIs

-   clear separation of WHAT vs. HOW concerns, i.e. abstraction from implementation aspects — APIs should be stable even if we replace complete service implementation including its underlying technology stack

Moreover, API definitions with standardized specification format also facilitate…​

-   single source of truth for the API specification; it is a crucial part of a contract between service provider and client users

-   infrastructure tooling for API discovery, API GUIs, API documents, automated quality checks

Elements of API First are also this API Guidelines and a standardized API review process as to get early review feedback from peers and client developers. Peer review is important for us to get high quality APIs, to enable architectural and design alignment and to supported development of client applications decoupled from service provider engineering life cycle.

It is important to learn, that API First is **not in conflict with the agile development principles** that we love. Service applications should evolve incrementally — and so its APIs. Of course, our API specification will and should evolve iteratively in different cycles; however, each starting with draft status and *early* team and peer review feedback. API may change and profit from implementation concerns and automated testing feedback. API evolution during development life cycle may include breaking changes for not yet productive features and as long as we have aligned the changes with the clients. Hence, API First does *not* mean that you must have 100% domain and requirement understanding and can never produce code before you have defined the complete API and get it confirmed by peer review. On the other hand, API First obviously is in conflict with the bad practice of publishing API definition and asking for peer review after the service integration or even the service productive operation has started. It is crucial to request and get early feedback — as early as possible, but not before the API changes are comprehensive with focus to the next evolution step and have a certain quality (including API Guideline compliance), already confirmed via team internal reviews.

### `MUST` Understand that APIs are (part of) the Product

As a company we want to deliver products to our (internal and external) customers which can be consumed like a service.

Platform products provide their functionality via (public) APIs; hence, the design of our APIs should be based on the API as a Product principle:

-   Treat your API as product and act like a product owner

-   Put yourself into the place of your customers; be an advocate for their needs

-   Emphasize simplicity, comprehensibility, and usability of APIs to make them irresistible for client engineers

-   Actively improve and maintain API consistency over the long term

-   Make use of customer feedback and provide service level support

Embracing 'API as a Product' facilitates a service ecosystem which can be evolved more easily, and used to experiment quickly with new business ideas by recombining core capabilities. It makes the difference between agile, innovative product service business built on a platform of APIs and ordinary enterprise integration business where APIs are provided as "appendix" of existing products to support system integration and optimised for local server-side realization.

Understand the concrete use cases of your customers and carefully check the trade-offs of your API design variants with a product mindset. Avoid short-term implementation optimizations at the expense of unnecessary client side obligations, and have a high attention on API quality and client developer experience.

API as a Product is closely related to the API First principle.