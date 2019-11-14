---
layout: default
title: Publication
nav_order: 2
---

Publication
===========
{: .no_toc }

For the purpose of higher reuse, more autonomous clients and «Self Service» of capabilities, it is crucial that APIs are well understandable, documented and easily accessible to other teams and external partners.

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## `MUST` APIs are findable

APIs must be published in the central API Repository, also known as the [SBB Developer Portal](https://developer.sbb.ch). APIs must be logically ordered and grouped by business capabilities or domains for better findability. APIs have a unique name and short description which describes the business capabilities in one or two sentences.

#### API Names
{: .no_toc }

The name of an API must represent the business capability that it provides, focusing on consumers and a wide understandability. Organizational names must not be used for API Names. API Names should be as unique as possible.

#### Rational
{: .no_toc }

- Better transparency and findability leads to a higher reuse which again leads to lower redundancy and costs.
- Better findability and documentation leads to a higher collaboration between API consumer and provider.
- We expect better stability and efficiency in development due to better documentation.

---

## `MUST` Business capabilities as a Service

For the sake of agility and more speed in development, it is very important that consumers can consume business capabilities over APIs without the need of human interaction. This is especially important for early prototyping, fast ramp-up, mode-2 projects and for creating new partnerships. Usually teams will nevertheless collaborate and talk together before production readyness.

APIs must provide subscription plans and there must be an automated sign-up process. Plans are usually used for distinct pricing and/or access management.

*Hint: Every API that is published via API Management (APIM) automatically fulfilles these requirements.*

#### Rational:
{: .no_toc }
- Managed APIs provide automated transparency of technical interfaces between teams.
- We expect a much higher speed and efficiency when implementing new interfaces, which leads to reduced [Cost of Delay](https://en.wikipedia.org/wiki/Cost_of_delay).

---

## `MUST` Centralized API documentation in english

An API must be documented in english by focusing on API consumers. For a better reuse quota it crucial that APIs are well documented. Good documentation fulfills the following properties:
- It describes the business capability in 1-3 sentences.
- It puts the API in a well understandable context.
- It provides all important information that a developer needs to consume the API (specification, security, access-codes, ...).
- It is understandable to internal and external developers.

For a better understandability of the technical specifications, there should also be meaningful examples and the possibility to *Try-It-Out* in a sandbox environment. Cookbooks, blueprints or even public client libraries and code templates help developers consume APIs more efficiently.

#### Define the language
{: .no_toc }

In a complex business domain, it's hard to translate everything in another languages without losing context. If you chose to define your resources in another language than English, you **must** provide a glossary with the explanations of the different resources.

#### Example
{: .no_toc }

A good example for comprehensive documentation is the [b2p API](https://developer.sbb.ch/api/16/b2p).

#### Rational
{: .no_toc }
- Comprehensive documentation leads to lower costs through higher reuse and better collaboration.
- Increased understandability also improves development speed and thus reduced [Cost of Delay](https://en.wikipedia.org/wiki/Cost_of_delay).
- Documentation in english enables new business models due to a global understandable repository of APIs.
