---
layout: default
title: Publication
parent: Organizational Aspects
nav_order: 1
---

# Publication
{: .no_toc }

For the purpose of higher reuse and facilitate the «Self-Service» for consumers, it is crucial that APIs are well understandable, documented and easily accessible to other teams and external partners.

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## `MUST` APIs are findable

APIs must be published in the central API Repository, also known as the [SBB Developer Portal](https://developer.sbb.ch). An exception are application-internal interfaces, such as an interface between the UI and the backend. APIs may be logically ordered and grouped by domains for better findability. APIs must have a unique name and short description of the data and functions of business capabilities they support.

## API Names
{: .no_toc }

The name of an API must refer to the business capability that it supports, focusing on the data and functions it provides in order for consumers to understand what to expect of the API. Organizational names must not be used for API Names. API names should be as unique as possible.

### Rational
{: .no_toc }

- Better transparency and findability leads to a higher reuse which again leads to lower redundancy and costs.
- Correct, relatable and understandable naming, which is business capability-oriented, enhances the discoverability of APIs and thus facilitates collaboration between consumers and providers.

---

## `MUST` Explorability and Sign-Up as Self-Service

For the sake of agility and more speed in development, it is very important that consumers can consume data and functions of business capabilities over APIs without the need of human interaction. This is especially important for early prototyping, fast ramp-up, agile development and for creating new partnerships. Usually teams will nevertheless collaborate and talk together before production readyness.

### Rational
{: .no_toc }

- Managed APIs provide automated transparency of technical interfaces between teams.
- We expect a much higher speed and efficiency when implementing new interfaces, which leads to reduced [Cost of Delay](https://en.wikipedia.org/wiki/Cost_of_delay).

---

## `MUST` Centralized API documentation in English

Each API must be documented in English by focusing on API consumers. To foster reuse, it is crucial that APIs are well documented. Good documentation fulfills the following properties:

- It describes the provided data and functions of the supported business capability in 1-3 sentences.
- It puts the API in a well understandable context.
- It provides all important information that a developer needs to consume the API (specification, security, access-codes, ...).
- It is understandable to internal and external developers.

For a better understandability of the technical specifications, there should also be meaningful examples. Cookbooks, blueprints or even public client libraries and code templates help developers consume APIs more efficiently.

### Define the language
{: .no_toc }

In a complex business domain, it is difficult to describe an API without providing the necessary context and explaining the terminology. For this reason, you **must** provide a glossary with the explanations of the different resources.

### Example
{: .no_toc }

A good example for comprehensive documentation is the [b2p API](https://developer.sbb.ch/apis/b2p).

### Rational
{: .no_toc }

- Comprehensive documentation leads to lower costs through higher reuse and better collaboration.
- Increased understandability also improves development speed and thus reduced [Cost of Delay](https://en.wikipedia.org/wiki/Cost_of_delay).
- Documentation in English enables global reuse of our APIs.

## `MUST` Define plans driven by the API's business context

APIs must provide subscription plans. Plans are usually used for distinct pricing and/or access management. These plans offered in the API Repository must be designed to meet the consumer needs. They must be driven by the API's business context. Appropriate plans are well documented and clarify the usage of the API.


### Use limited subscription plans only
{: .no_toc }

We highly recommend to use limited plans only for all APIs and all subscription plans. Plan limits clarify what amount of requests the API backend expects and can handle and therefore significantly improve documentation and understandability of an API. It also improves stability of the API and all it's consumers.

If it is not technically feasible to enforce a plan in API Repository, the message rates must be described in the documentation and discussed with the consumer.

### Example
{: .no_toc }

A good example for business context driven plans is the [b2p API](https://developer.sbb.ch/apis/b2p).

### Rational
{: .no_toc }

- Well documented and designed API plans make quality requirements explicit and make it easier for a provider to stay available for all consumers.
- API plans are vital for consumer management and also for lifecycle management.
