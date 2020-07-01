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

### `MUST` Secure Endpoints with Certificate or OAuth 2.0
Every API endpoint (topic/queue) needs to be secured by a certificate or OAuth 2.0. A certificate or OAuth 
client secret is valid for exactly one endpoint and stage and differs between read and write accesses.

In case of certificates, Client Certificate Authentication must be used. Consider also to use two-way SSL 
for the machine-to-machine communication. 


### `MUST` Distinguish between Infrastructure and Real Users
Use certificates or infrastructure users for the connection between machines (e.g. to establish a topic connection) and 
forward the real users token (OAuth token) in the message header. The OAuth token is only required for internal communication
where the consuming system has to check the real users permissions / roles.

## Implementation & Documentation

### `MUST` Provide API Specification using AsyncAPI

We use the [AsyncAPI specification](https://www.asyncapi.com/) as standard to define event-driven API specification 
files. API designers are required to provide the API specification using a single **self-contained YAML** file to 
improve readability. We encourage to use **OpenAPI 3.0** version, but still support **OpenAPI 2.0**.

The API specification files should be subject to version control using a source code management system - best 
together with the implementing sources.

You **must** publish the component API specification with the deployment of the implementing service and make it 
discoverable, following our [publication](/api-principles/api-principles/publication) principles. As a starting 
point, use our ESTA Blueprints ([internal Link](http://esta.sbb.ch/Esta+Blueprints)).

**Hint:** A good way to explore **OpenAPI 3.0/2.0** is to navigate through the [OpenAPI specification mind map](https://openapi-map.apihandyman.io/).


### `MUST` Comply with the Naming Conventions for Topics and Queues
Infrastructure artifacts like topics and queues must be named according to the following naming conventions: 

`{application-abbreviation}.{application-specific}`

- {application-abbreviation}:\
[a-z0-9-]+ (Sequence of:lower case,numbers, dashes). **Important:** Use the MEGA-ID for SBB internal applications 
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


### `MUST` Support Distributed Tracing
In distributed systems, it is absolutely necessary to track messages across all components to be able to investigate the message flow in case of problems. 
The API provider must support the distributed tracing mechanism as defined by [OpenTracing](https://opentracing.io/). It standardizes

- The transmission of the context information between processes
- The format used to transmit the trace information  
