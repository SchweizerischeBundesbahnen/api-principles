---
layout: default
title: Best Practices
parent: Event-Driven APIs
nav_order: 2
---

Best Practices
==============
{: .no_toc }

This chapter is not subject to IT Governance. It is more a collection of extractions from literature, experiences and patterns that 
we document as shared knowledge. Nevertheless engineers **should** read this section as it contains very valuable knowledge of how to
design and implement event-driven APIs.

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## General API Design Principles
Before a new API is created, it is necessary to check which integration type it corresponds to. Event-Driven APIs 
have many advantages with regard to decoupling systems at runtime. At the same time, an Event-Driven API also brings 
challenges that are less significant with e.g. a RESTful API. Accordingly, Event-Driven APIs are primarily 
suitable for interfaces where "fire and forget" is possible. Or, in other words, an Even-Driven approach makes only 
limited sense if your application directly depends on the response for a sent message.

Concerning documentation, versioning, schema management etc. the claims are however the same as for a RESTful API. 
We apply the Event-Driven API principles to all kind of application (micro-) service components, independently from 
whether they provide functionality via the internet or intranet.

-   We prefer APIs with JSON payloads

An important principle for API design and usage is Postel’s Law, aka 
[The Robustness Principle](http://en.wikipedia.org/wiki/Robustness_principle) (see also [RFC 1122](https://tools.ietf.org/html/rfc1122)):

-   Be liberal in what you accept, be conservative in what you send


### Follow API First Principle

You should follow the API First Principle, more specifically:

-   You should design APIs first, before coding its implementation.
-   You should design your APIs consistently with these guidelines.
-   You should call for early review feedback from peers and client developers. Also consider to apply for a lightweight review by the API Team.

See also the principle [Design API first](https://schweizerischebundesbahnen.github.io/api-principles/architecture/#must-design-api-first).

### Provide API User Manual

In addition to the API Specification, it is good practice to provide an API user manual to improve client developer 
experience, especially of engineers that are less experienced in using this API. A helpful API user manual typically 
describes the following API aspects:

-   Domain Knowledge and context, including API scope, purpose, and use cases
-   Concrete examples of API usage
-   Edge cases, error situation details, and repair hints
-   Architecture context and major dependencies - including figures and sequence flows


## Compatibility

### Use Schema Management Registry

If you are sharing data with clients outside the scope of your system, you will want to make sure that the schemas involved are 
actively managed. Doing so early in the pipeline will prevent your downstream clients from deserialization and processing issues 
at a later time (worstcase in production).

Schema Management involves publication, distribution and lifecycle control of message schemas published by asynchronous interfaces.
Use a centralized schema management registry (e.g. Confluent Schema Registry or Red Hat Service Registry) for

- creating, updating and deleting schemas
- sharing schemas, making them available to downstream clients
- implementing schema evolution rules to enforce compatible changes of the schema

### Provide Version Information
{: .no_toc }
In addition to the major version given by topic/queue name, the full version of the API should be written into the message header. 
Use the header field `x-api-version` and write the version in [SemVer](https://semver.org/) notation.

## Data Formats and schemas

### JSON

Please see the best practice [documentation](/api-principles/api-principles/restful/best-practices) 

### Apache AVRO

Please see the [confluent schema registry best practices](https://docs.confluent.io/platform/current/schema-registry/avro.html)


## Implementation

### Handle duplicate messages

Event consumers must be developed to deal with duplicate messages. Most Message Brokers implement an _at-least-once_
delivery strategy since _exactly-once_ is usually too expensive. 

When systems and networks behave correctly, messages are delivered only once. However, some circumstances might 
cause message duplication. For instance, a network glitch could avoid a message acknowledgment when 
a publisher sends a message. In that case, the publisher will resend the message, leading to a message duplication in
the Message Broker. The same can happen on the consumer side, when the message cannot be acknowledged after a successful 
processing.

Consumers can follow one of these strategies to overcome this:
- Keeping track of the messages and discarding duplicates
- Writing idempotent handling logic (although not always possible)

## Deprecation

### Monitor Usage of Deprecated APIs

Owners of APIs used in production must monitor usage of deprecated APIs until the API can be shut down in order to align 
deprecation and avoid uncontrolled breaking effects.

**Hint:** Use [API Management (internal link)](https://confluence.sbb.ch/display/AITG/API+Management) to keep track of the usage of your APIs

