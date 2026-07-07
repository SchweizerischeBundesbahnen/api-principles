---
layout: default
title: Maturity
parent: Organizational Aspects
nav_order: 3
---

# Maturity
{: .no_toc }

We have defined a maturity model in order to be able to differentiate between good and bad interfaces. This is an important precondition for the movement to better interfaces by fostering a high demanding API culture.

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## SBB API Maturity Model

![SBB API Maturity Model](../../images/sbb-maturity-model.svg)

- Design Maturity: L1 < L2 < L3 = L4
- Service Maturity: L1 = L2 < L3 < L4

### Example for Increased Maturity

1. API publishes 'Actual Times' as a flat file, each records contains information about the train, location and a timestamp. Data is correct from a business point of view, but only supplies parts of the capability. It is hard to read an contains a lots of implicit redundancies.
2. API publishes a timetable, actual times and forecasts as separate endpoints, responses are structured (XML, JSON). Parameters to query the API and responses contain though coded information, which is poorly documented. API therefore is complete from a business point of view, but remains hard to consume.
3. API publishes train slots contextualized with different time categories, data is available for the past, actual and future (as forecast). Endpoints are well documented including endpoints to query reference data or clearly pointing to other APIs to query for additional information. Subscription to the API can be done within one work day, API definition files are available.
4. Complete self-service for API consumers. Extensively documented release history and established communicaton channels in both directions: towards the consumers to inform about outages and changes - towards the provider to ask for support or input feature requests.

## `MUST` Continuous improvement of API Maturity

APIs must invest a continuous effort in increasing the maturity of an API according to the *SBB API Maturity Model*.

|     |     |     |     |     |
| --- | --- | --- | --- | --- |  
|     | 1. API is exposed | 2. API is service-oriented | 3. API is managed | 4. API is consumer-centric |
| Mastery of | Technicals | Business domain | Development Experience  | Business agility |
| Matching principles | APIs ...<br><br>* are used to access data<br>* hide technical internals<br>* are secured<br>* have well-known consumers<br>* have tolerant readers<br>* are designed first | APIs ...<br><br>* define business capabilities<br>* align with the SBB domain<br>* are shared by teams<br>* support composition<br>* support reuse | APIs ..<br><br>* are findable and classified<br>* have a managed schema<br>* define SLO <br>* enforce rate limiting <br>* have an owner and support channels<br>* are versioned<br>* have a deprecation policy | APIs ...<br> <br>* define appropriate API plans  <br>* monitor their usage <br>* define ways to contribute changes<br>* provides interface tests<br>* have a pre-production stage |
| Public<br><br>(between SBB intern and extern applications) | MUST | MUST | MUST  | MUST |
| Intern<br><br>(between applications, but SBB intern) | MUST | MUST | MUST | SHOULD |
| Private<br><br>(within an application or application ecosystem) | MUST | SHOULD | SHOULD | SHOULD |


### Rational
{: .no_toc }

Higher maturities of interfaces lead to ...
- higher speed in the development of API consumers.
- higher reuse coefficient due to better understandability, quality and functional precision.
- higher financial and operational excellence
