---
layout: default
title: Organizational Requirements
nav_order: 2
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

## `Must` An API is owned by a business product owner

For the sake of short decision processes and clear definitions of the responsibilities of an API, every API must be owned by a business product owner. The Business Product Owner acts "consumer driven". Means, he focuses on serving it's API consumers in a best possible way. He treats the API as an internal and sometimes also external product. He is motivated to improve the API as part of his product with the focus of delivering its capabilities to as much consumers as possible (product thinking).

#### Rational
{: .no_toc }
- The definition of a product owner assures that there is always a team which is responsible for the maintenance and further development of the API. It also assures that there are appropriate financial resources and a constant invest in the API maturity.
- Product decisions and prioritization is owned by one single person (with support of the team), which shortens the decision process.
- An API is treated as a product, which usually leads to a higher reuse coefficient.

---

## `Must` An API defines an SLO

An API must have well defined SLOs ([Service Level Objectives](https://en.wikipedia.org/wiki/Service-level_objective)). An API may provide different SLAs ([Service Level Agreements](https://en.wikipedia.org/wiki/Service-level_agreement)) as part of its subscription plans. SLOs and SLAs must be part of an API documentation.

Applications serving an API and it's operational processes must aim to match the SLAs between API provider and consumer. Breaches of SLAs or service outages (planned and unplanned) must be actively communicated through established communication channels.

#### Rational
{: .no_toc }
- API Consumers better understand the risk of a dependency through an API, which increases operational stability.

---

## `Must` An API has a support channel

An API must have a responsive support channel which responds on bugs, questions & contributions within a working day. Usually we use eMail or a Chat (e.g. Teams) as channels. It is also a good practice to have a published and accessible FAQ and roadmap.

#### Rational
{: .no_toc }
- A well defined support channel and process leads to shorter MTR ([Mean Time To Repair](https://en.wikipedia.org/wiki/Mean_time_to_repair))
- Responsive support channels lead to lower costs, due to higher speed through a well known and efficient support for API consumers. Usually it also reduces the [feature lead time](https://en.wikipedia.org/wiki/Lead_time) of API consumer's feature requests.