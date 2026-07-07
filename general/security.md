---
layout: default
title: API Security
parent: General Principles
nav_order: 3
---

# API Security
{: .no_toc }

API security refers to the practices, protocols, and technologies used to protect APIs from unauthorized access, use, and exploitation. It is an integral part of designing and operating our APIs.

## Zero Trust
{: .no_toc }

In particular, API Security also includes the concept of *Zero Trust* which means that all API calls, regardless of their origin or source, are authenticated, authorized, and validated before being granted access to sensitive data or applications.

In a Zero Trust API security model, the following assumptions are made:

- No implicit trust: No user, device, or system is trusted by default, regardless of its location or affiliation.
- All traffic is inspected: All API traffic is inspected and verified, regardless of its source or destination.
- Access is granted based on policy: Access to APIs is granted based on a set of predefined policies, rather than on the basis of a user's or device's identity or location.

*Hint: APIs using the API Management infrastructure automatically fulfill the MUST requirements described in this chapter.*

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## `MUST` APIs are secured

An API must always be secured by default - no matter of where it is accessible from. Public APIs must be protected by Policy Enforcement Points (PEP) according to the currently applicable SBB security architecture.

### RESTful APIs

Every API endpoint must be secured using OAuth 2.0 or newer. Please refer to the [official OpenAPI spec](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md#security-definitions-object) on how to specify security definitions in your API specification.

*Hint: It makes little sense specifying the flow to retrieve OAuth tokens in the `securitySchemes` section, as API endpoints should not care, how OAuth tokens were created. Unfortunately the `flow` field is mandatory and cannot be omitted. API endpoints should always set `flow: clientCredentials` and ignore this information.*

APIs should *not* be secured with [basic auth](https://en.wikipedia.org/wiki/Basic_access_authentication) or access tokens that never expire (like static API Keys). Traffic must be encrypted (via HTTPS).

### Event-driven APIs

Every API endpoint (topic/queue) needs to be secured by an state of the art authentication and authorization mechanism supported by the platform you'd like to use.

### Exceptions
{: .no_toc }

If, and only if, you have one of the following use cases, API key based access is allowed as well:

- When Standard Software, which cannot handle OAuth 2.0 Requests, needs to consume a managed API (e.g. when you can only set static headers). In that case we highly recommend to regularly rotate/regenerate the API Key for the sake of increased security.
- When an API exposes GIS data, it `SHOULD` be generally secured using API Keys, because most of the ecosystem in this domain ist set-up to work with API Keys only. When exposing GIS data, you `MUST` make sure, the API does not expose protectable and or customer specific data. You `SHOULD` therefore split protectable data into a separate API, secured by OAuth 2.0 or newer.

### Rational
{: .no_toc }

By a standardization of security mechanisms by using templates and common good practices, we can enable the following benefits:

- Lower costs by easier access to security infrastructure and high automation
- Higher security

---

## `MUST` API consumers are well-known

Consumers of APIs must identify themselves. Every request must be mappable to one consumer. Identifiers can be mapped to a contact channel (like e-mail or chat) for operational issues.

### Rational
{: .no_toc }

Consumer based API Security enables:

- New business models based on API usage and plans
- Better transparency in enterprise architecture
- Better operational stability through better transparency

---

## `SHOULD` APIs are protected by throttling mechanisms

API consumers should be throtteled, based on their individual request rates. Means the number of request done by one consumer should be individually tracked and throtteled on extensive use. This may be important for the stability on the API and reduces side effects between API consumers.

### Rational
{: .no_toc }

- Throtteling of API consumer's requests improves the security and the operational stability of APIs.
- API providers usually have more confidence when making their APIs accessible for more consumers. Accessible APIs automatically lead to higher reuse coefficients.

---

## `SHOULD` Least privilege access

All API calls are denied by default, and access is only granted the minimum level of access necessary to perform their intended function.

### Rational
{: .no_toc }

- This principle reduces the risk of security breaches and limits the damage that can be caused by a compromised account or system.

---

## `SHOULD` Continuous verification and monitoring

All API calls should continuously be verified and validated, even after initial access has been granted.

### Rational
{: .no_toc }

- Continuous verification ensures that API access is granted and maintained only to authorized entities, and that any changes to the entity's permissions or behaviour are immediately detected and responded to.
