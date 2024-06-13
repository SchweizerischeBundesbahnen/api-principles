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

## Design, Development and Operation Principles
We split up our applications along business functions, build them on the basis of development stacks and design them for sustainable and stable operational use.
*@see also: the complete [Design, Development and Operation Principle](https://confluence.sbb.ch/display/VORGABEN/DEB+Design-+Entwicklungs-+und+Betriebsprinzip) \[internal link\]*

### `MUST` Team decomposition and architecture decomposition are aligned
We design our applications along business functions in sizes that our teams can manage.

## Delivery Principles
For new applications, we prefer market solutions over in-house development. We support a business need with an existing application and reuse it through APIs.
*@see also: the complete [Delivery Principle](https://confluence.sbb.ch/display/VORGABEN/BEP+Bereitstellungsprinziphttps://confluence.sbb.ch/x/ugMtU) \[internal link\]*

During the process of software provisioning, the most actual and applicable [API Principles](https://schweizerischebundesbahnen.github.io/api-principles/) must be part of the decision criterias.

## Data and Integration Principles
We share and use SBB data and functions throughout the whole group. We handle data with care. When sharing and using the data, we adhere to its data privacy
requirements (e.g. data privacy regulations).
*@see also: the complete [Data and Integration Principle](https://confluence.sbb.ch/display/VORGABEN/DIP+Daten-+und+Integrationsprinzip) \[internal link\]*


### `MUST` Data master share business functions and data over APIs
As data masters, we share the data and functions of our business capabilities. We provide the functions and
data to other applications through over well defined APIs using the [RESTful](restful/restful.md) or [Event-Driven](eventdriven/eventdriven.md) architectural style.
We published them in the [API Repository](https://developer.sbb.ch) for further use in conformance to the API principles listed here.

### `MUST` We reuse existing APIs from the API Repository
We use existing functions and their data through the [API Repository](https://developer.sbb.ch). We obtain data from the leading application (data master).

## API best practices
While not part of an official regulation, following API principles have proven to be valuable at SBB and throughout the software industry.
We do recommend to read the best practices specifc to [RESTful](/api-principles/restful/best-practices/) and [Event-Driven](/api-principles/eventdriven/best-practices/) APIs before designing and implementing a new interface. It is quite a long lecture, but for a deep understanding of the implications of some design decisions, we believe that you will profit a lot from this common knowledge.

### `MUST` Hide Complexity
The Design of an API must follow the principle of [information hiding](https://en.wikipedia.org/wiki/Information_hiding). As already described above, APIs transport business capabilities, but they **must not** transport the complexity of the system behind the API. This means it is relevant that an API hides implementation details. An API should be understandable and intuitive for humans that are not very familiar with the API's business domain.

*Example 1*:
One should not be able to recognize if an API is provided by a software system built with ABAP, or Java or .Net.

*Example 2*:
Several websites already have shown that it is possible to build understandable (user) interfaces on a complex business domain like payment. When possible with UIs, it is also possible with APIs.

### `MUST` We build tolerant dependencies
When building dependencies between teams and applications, we focus on loose coupling. We implement [tolerant readers](https://martinfowler.com/bliki/TolerantReader.html) and we strictly follow Postel's law:

>Be conservative in what you do, be liberal in what you accept from others

New versions of a dependency (API) must not be introduced, unless there is no other way. The evolution of an API must be compatible within one version as long as possible. Changes are breaking, when consumers need to change simultaneously. In that case a new version must be introduced and maintained. APIs should not have more than two concurrent supported versions. Dependencies are also built tolerant in terms of changing latencies or outages.

### `SHOULD` Smart endpoints and dumb pipes
Each application owns its own domain logic. Outside of an application context, no protocol transformation, routing or business rules may be applied if this requires executable code / scripts or additional configurations on the middleware. (Exceptions are functions necessary for filtering messages or for housekeeping tasks that can be managed directly in the context of an application).

### `SHOULD` Monitor API Usage

Owners of APIs used in production should monitor API usage to get information about its using clients. This information, for instance, is useful to identify partners for API changes and lifecycle management.

### `MUST` Design API First

In a nutshell API First requires two aspects:

-   define APIs first, before coding its implementation, using a standard specification language

-   get early review feedback from peers and client developers

By defining APIs before starting its implementation, we want to facilitate early review feedback and also a development discipline that focus service interface design on…​

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

### `MUST` Expose standard APIs only when they fit to SBB's business domain language
APIs must be consumer oriented and developer friendly. We design and build APIs in the language which is used by SBB, because that is how our business partners and software development teams understand it's context and usage.

Applications using _of the shelf_ software can be separated into the following categories:
* **Type S** (Specific): The API uses a language that we also use within the SBB (often the case at very business specific software).
* **Type G** (Generic): The API uses a very product specific language which does NOT fit our domain language (ofthen the case at very technical and generic APIs of standard software), or it is very complex and requires a deep understanding of the software behind the API.

**Type S** applications can directly [publish](https://schweizerischebundesbahnen.github.io/api-principles/publication/) the API of the standard software over the [API Management](https://confluence.sbb.ch/x/noj5R) (_internal link_) infrastructure. Whereas **Type G** applications `MUST` write an own API which exposes the data and functionality of the application in the SBB's domain language, which is being understood by all the teams within the company (also outside of the company if it is a public API). We usually write **Type G** APIs using the [facade pattern](https://en.wikipedia.org/wiki/Facade_pattern).

#### When do we use standard APIs?
{: .no_toc }

Now let's imagine that application A is using  _of the shelf_ software and needs data and functions from application B, which is also using _of the shelf_ software and provides an API. Standard software often provides integrated solutions for connecting standard APIs. In this case, we use these out-of-the-box integrations over standard APIs to connect application A with application B.

If explicit domain logic from the domain of application B has to be built on the consumer side (application A) in order to connect to the standard API, it is a sign that this logic should be built within the domain of application B in the form of a facade.

Let's take the Graph API from AzureAD versus the SBB specific Employee API as an example. In most cases, standard solutions have native integrations with AzureAD in their system. If the connection can be made purely configurable, the standard AzureAD API should also be used. However, if SBB specific domain logic from HR is required, the Employee API should be used and extended, if necessary.

Also consider the following common guideline when building APIs:
> When building interfaces between applications, domain logic of application B `MUST` explicitly NOT be created on the side of application A (that's an often seen workaround for the problem of prioritizing foreign backlogs). It `MUST` always be implemented behind the API of application B.