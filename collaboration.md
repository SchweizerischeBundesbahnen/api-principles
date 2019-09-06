---
layout: default
title: Collaboration
nav_order: 8
---

Collaboration
=============
{: .no_toc }

For the purpose of better collaboration on dependencies between teams, we suggest some methodologies that have proven to be very effective for teams working together over APIs.

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## `MUST` Consumers contribute to APIs

Teams of APIs are open to contributions of other teams by following the [InnerSource](https://innersourcecommons.org) culture. API Consumers contribute the following types of code:
- `MUST` Documentation
- `MUST` Consumer Driven Contract Tests
- `MUST` Bug-Reports and Feature-Requests
- `SHOULD` Bugfixes in the API
- `SHOULD` Simple API Features
- `MAY` Complex Features
- `MAY` Refactorings

Teams maintaining an API should actively foster collaboration on their API and should therefore actively maintain a consumer community.

#### Rational
{: .no_toc }

- APIs will eventually become "consumer driven" (see also the [API Maturity model](maturity/maturity.md)).
- The Design of an API is more consumer oriented and therefore provides a better developer usability and more functionality. This leads to lower costs through higher reuse.
- Better speed of API Consumer teams and much less waiting times of consumers for a feature. Solves the *backlog hibernation* and thus reduces [Cost of Delay](https://en.wikipedia.org/wiki/Cost_of_delay).

---

## `SHOULD` API Consumers provide interface tests

APIs should allow and engage consumers to provide *Consumer Driven Contract Tests*. Tests can be provided over a pact broker like [pacto](https://thoughtworks.github.io/pacto/patterns/cdc/) or over source code [contribution](collaboration.md/#must-consumers-contribute-to-apis).

#### Rational
{: .no_toc }

- With consumer tests, API consumers take on responsibility of the changeability and operational stability of APIs.
- This leads to early end-to-end testing of interfaces between teams. Early discussions between teams often lead to better collaboration, stability and quality.
- Consumers are motivated to contribute to APIs (CDC is a an important entry-level step for the path to an *InnerSource* collaboration model).
