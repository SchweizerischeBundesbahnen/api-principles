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

---

Chapters
========
[Architecture](architecture.md)
[Organizational Requirements](organization.md)
[Maturity](maturity/maturity.md)
[Synchronous-API Design](synchronousdesign/synchronousdesign.md)
[Asynchronous-API Design](asynchronousdesign/asynchronousdesign.md)
[API Security](security.md)
[Collaboration](collaboration.md)

Conventions Used in These Guidelines
====================================

#### Requirement level
The requirement level keywords "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" used in this document (case insensitive) are to be interpreted as described in [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

#### API Consumer vs. Provider
*Consumer* is used as a synonym for API Consumers (also known as clients of an API) and is referring the team which implements the client. On the other hand, we use *Provider* as a synonym for *API Provider*, referring the team maintaining the API.
