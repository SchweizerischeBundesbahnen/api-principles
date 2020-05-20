---
layout: default
title: Organization
nav_order: 3
---

Organizational Requirements
===========================
{: .no_toc }

We define the most basic organizational requirements needed for an efficient collaboration between API Provider and Consumer.

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## `MUST` An API is owned by a business product owner

For the sake of short decision processes and clear definitions of the responsibilities of an API, every API must be owned by a business product owner. The business product owner acts "consumer driven". Means, he focuses on serving its API consumers in a best possible way. He treats the API as an internal and sometimes also external product. He is motivated to improve the API as part of his product with the aim of delivering its capabilities to as much consumers as possible (product thinking).

#### Rational
{: .no_toc }
- The definition of a product owner assures that there is always a team which is responsible for the maintenance and further development of the API. It also assures that there are appropriate financial resources and a constant invest in the API maturity.
- Product decisions and prioritization is owned by one single person (with support of the team), which shortens the decision process.
- An API is treated as a product, which usually leads to a higher reuse coefficient.

---

## `MUST` An API defines SLOs

An API must have well defined SLOs ([Service Level Objectives](https://en.wikipedia.org/wiki/Service-level_objective)). An API may provide different SLAs ([Service Level Agreements](https://en.wikipedia.org/wiki/Service-level_agreement)) as part of its subscription plans. SLOs and SLAs must be part of an API documentation.

Applications serving an API and it's operational processes must aim to match the SLAs between API provider and consumer. Breaches of SLAs or service outages (planned and unplanned) must be actively communicated through established communication channels.

#### Rational
{: .no_toc }
- API consumers better understand the risk of a dependency through an API, which increases operational stability.

---

## `MUST` An API has a support channel

An API must have a responsive support channel which responds on bugs, questions & contributions within a working day. Usually we use e-mail or a chat (e.g. Microsoft Teams) as channels. It is also a good practice to have a published and accessible FAQ and roadmap.

#### Rational
{: .no_toc }
- A well defined support channel and process leads to shorter MTR ([Mean Time To Repair](https://en.wikipedia.org/wiki/Mean_time_to_repair))
- Responsive support channels lead to lower costs, due to higher speed through a well known and efficient support for API consumers. Usually it also reduces the [feature lead time](https://en.wikipedia.org/wiki/Lead_time) of API consumer's feature requests.


## `MUST` Deprecation

Deprecation rules must be applied to make sure that necessary consumer changes are aligned and deprecated endpoints are not used before API changes are deployed.

#### Rational
{: .no_toc }
- Sometimes it is necessary to phase out an API endpoint (or version), for instance, if a field is no longer supported in the result or a whole business functionality behind an endpoint has to be shut down. There are many other reasons as well.
- As long as endpoints are still used by consumers breaking changes are not allowed. 

### Obtain Approval of Clients

Before shutting down an API (or version of an API) the producer **must** make sure, that all clients have given their consent to shut down the endpoint. Producers should help consumers to migrate to a potential new endpoint (i.e. by providing a migration manual). After all clients are migrated, the producer may shut down the deprecated API.

### Reflect Deprecation in API Definition

API deprecation **must** be part of the OpenAPI definition. If a method on a path, a whole path or even a whole API endpoint (multiple paths) should be deprecated, the producers must set `deprecated=true` on each method / path element that will be deprecated (OpenAPI 2.0 only allows you to define deprecation on this level). If deprecation should happen on a more fine grained level (i.e. query parameter, payload etc.), the producer should set `deprecated=true` on the affected method / path element and add further explanation to the `description` section.

If `deprecated` is set to `true`, the producer must describe what clients should use instead and when the API will be shut down in the `description` section of the API definition.


### External Partners Must Agree on Deprecation Timespan

If the API is consumed by any external partner, the producer **must** define a reasonable timespan that the API will be maintained after the producer has announced deprecation. The external partner (client) must agree to this minimum after-deprecation-lifespan before he starts using the API. Usually we prefer timespans between **3-6 months**.


### Not Start Using Deprecated APIs

Clients **must not** start using deprecated parts of an API.
