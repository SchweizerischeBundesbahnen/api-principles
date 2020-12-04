---
layout: default
title: API Security
nav_order: 7
---

API Security
============
{: .no_toc }

Security on dependencies and interfaces is of course a very important topic. It becomes even more important when opening APIs to external usage, which is more and more the strategy we are heading to.

*Hint: APIs using the API Management infrastructure automatically fulfill the requirements described in this chapter.*

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## `MUST` APIs are secured

An API must always be secured by default - no matter of where it is accessible from. For increased security, APIs must be secured using [OAuth 2.0](https://oauth.net/2/) (usually following the [OIDC](https://openid.net/connect/) standard). APIs should not be secured with [basic auth](https://en.wikipedia.org/wiki/Basic_access_authentication) or access tokens that never expire (like static API Keys). Traffic must only be accepted via HTTPS.

APIs must be protected by security gateways (like the [APIM Gateway](https://code.sbb.ch/projects/KD_APIM/repos/apim-adapter/browse)\[internal link\]).

#### Exceptions
{: .no_toc }
If, and only if, you have one of the following use cases, API Key based access is allowed as well:
- When Standard Software, which cannot handle OAuth 2.0 Requests, needs to consume a managed API (e.g. when you can only set static headers). In that case we highly recommend to regularly rotate/regenerate the API Key for the sake of increased security.
- When an API exposes geographic maps, it `SHOULD` be generally secured using API Keys, because most of the ecosystem in this domain ist set-up to work with API Keys only. When exposing geographic Maps, you `MUST` make sure, the API does not expose protectable and or customer specific data. You `SHOULD` therefore split protectable Data from a geographic map data API into a separate API, secured by OAuth 2.0.

#### Rational
{: .no_toc }
By a standardization of security mechanisms by using templates and common good practices, we can enable the following benefits:
- Lower costs by easier access to security infrastructure and high automation
- Higher security

---

## `MUST` API consumers are well-known

Consumers of APIs must identify themselves. Every request must be mappable to one consumer. Identifiers can be mapped to a contact channel (like e-mail or chat) for operational issues.

#### Rational
{: .no_toc }
Consumer based API Security enables:
- New business models based on API usage and plans
- Better transparency in enterprise architecture
- Better operational stability through better transparency

---

## `SHOULD` APIs are protected by throttling mechanisms

API consumers should be throtteled, based on their individual request rates. Means the number of request done by one consumer should be individually tracked and throtteled on extensive use. This may be important for the stability on the API and reduces side effects between API consumers.

#### Rational
{: .no_toc }
- Throtteling of API consumer's requests improves the security and the operational stability of APIs.
- API providers usually have more confidence when making their APIs accessible for more consumers. Accessible APIs automatically lead to higher reuse coefficients.
