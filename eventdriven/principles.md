---
layout: default
title: Principles
parent: Event-Driven APIs
nav_order: 1
---

Principles for Event-Driven APIs
===========================
{: .no_toc }

This chapter describes a set of guidelines that must be applied when writing and publishing event-driven APIs. These APIs are usually published via topics or queues.

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Compatibility

### `MUST` We do not Break Backward Compatibility

APIs are contracts between service providers and service consumers that cannot be broken via unilateral decisions. For this reason APIs may only be changed if backward compatibility is guaranteed. If this cannot be guaranteed, a new API major version must be provided and the old one has to be supported in parallel. For deprecation, follow the principles described in the chapter about [deprecation](/api-principles/organization/#must-deprecation).

API designers should apply the following rules to evolve APIs for services in a backward-compatible way:

- Add only optional, never mandatory fields.
- Never change the semantic of fields (e.g. changing the semantic from customer-number to customer-id, as both are different unique customer keys)
- Input fields may have (complex) constraints being validated via server-side business logic. Never change the validation logic to be more restrictive and make sure that all constraints are clearly defined in description.
- Enum ranges can be reduced when used as input parameters, only if the server is ready to accept and handle old range values too. Enum range can be reduced when used as output parameters.
- Enum ranges cannot be extended when used for output parameters — clients may not be prepared to handle it. However, enum ranges can be extended when used for input parameters.
- Use x-extensible-enum, if range is used for output parameters and likely to be extended with growing functionality. It defines an open list of explicit values and clients must be agnostic to new values.

On the other hand, API consumers must follow the tolerant reader rules (see below).

### `MUST` Clients must be Tolerant Readers

Clients of an API **must** follow the rules described in the chapter about [tolerant dependencies](/api-principles/architecture/#must-we-build-tolerant-dependencies).


## Security

### `MUST` Secure Endpoints
Every API endpoint (topic/queue) needs to be secured by an appropriate authentication mechanism supported by the platform you'd like to use. 


## Monitoring

### `MUST` Support OpenTelemetry

Distributed Tracing over multiple applications, teams and even across large solutions is very important in root cause analysis and helps detect how latencies are stacked up and where incidents are located and thus can significantly shorten _mean time to repair_ (MTTR).

To identify a specific request through the entire chain and beyond team boundaries every team (and API) `MUST` use [OpenTelemetry](https://opentelemetry.io/) as its way to trace calls and business transactions. Teams `MUST` use standard [W3C Trace Context](https://www.w3.org/TR/trace-context/) Headers, as they are the common standard for distributed tracing and are supported by most of the cloud platforms and monitoring tools. We explicitly use W3C standards for eventing too and do not differ between synchronous and asynchronous requests, as we want to be able to see traces across the boundaries of these two architectural patterns.

##### Traceparent
{: .no_toc }
`traceparent`: ${version}-${trace-id}-${parent-id}-${trace-flags}

The traceparent header field identifies the incoming request in a tracing system. The _trace-id_ defines the trace through the whole forest of synchronous and asynchronous requests. The _parent-id_ defines a specific span within a trace.

##### Tracestate
{: .no_toc }
`tracestate`: key1=value1,key2=value2,...

The tracestate header field specifies application and/or APM Tool specific key/value pairs.

## Implementation & Documentation

### `MUST` Provide API Specification using AsyncAPI

We use the [AsyncAPI specification](https://www.asyncapi.com/) as standard to define event-driven API specification 
files. 

The API specification files should be subject to version control using a source code management system - best 
together with the implementing sources.

You `MUST` publish the component API specification with the deployment of the implementing service and make it 
discoverable, following our [publication](/api-principles/api-principles/publication) principles. As a starting 
point, use our ESTA Blueprints ([internal Link](http://esta.sbb.ch/Esta+Blueprints)).

### `SHOULD` use either Apache AVRO or JSON as data format
The preferred data format for asynchronous apis in the SBB are either [JSON](https://www.json.org/json-en.html) or [Apache AVRO](https://avro.apache.org/docs/current/spec.html)
If you have to decide which one, choose the data format based on what your customer / consumers are comfortable with. Additionally, please check out the [confluent blog](https://www.confluent.io/blog/avro-kafka-data/) 
about differences of the two formats. 

You `SHOULD NOT` use legacy data formats such as [Xml](https://en.wikipedia.org/wiki/XML) and [Java Object Serialization Stream Protocol](https://docs.oracle.com/javase/6/docs/platform/serialization/spec/protocol.html). 
It's almost impossible to  fulfill the principles laid out in this document because of numerous issues around versioning, compatibility and security considerations. 

### `SHOULD` use either Apache AVRO schema or JSON schema
Both are supported by the Kafka schema registry and as a linkable resource from the [developer portal](https://developer.sbb.ch). 

### `MUST` Comply with the Naming Conventions for Topics and Queues
Infrastructure artifacts like topics and queues must be named according to the following naming conventions: 

`{application-abbreviation}.{application-specific}`

- {application-abbreviation}:\
[a-z0-9-]+ (Sequence of:lower case,numbers, dashes). **Important:** For internal applications, use one of the documented names or aliases according to the EADB. 
- {application-specific}:\
[a-z0-9-.] (Sequence of:lower case, numbers, dashes, periods)


### `MUST` Use Semantic Versioning
Versions in the specification must follow the principles described by [SemVer](https://semver.org/). 
Versions in queue/topic names are always major versions. Or in a more generic way: we avoid introducing minors or 
patches anywhere where it could break consumers compatibility. We explicitly avoid resource based versioning, 
because this is a complexity which an API should not reflect to its consumers.

Good example for a topic/queue name:

`{application-abbreviation}/.../v1/orders/...`

Bad Example for a topic/queue name:

`{application-abbreviation}/.../orders/v1/...`

