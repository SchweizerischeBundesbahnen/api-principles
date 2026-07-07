---
layout: default
title: Compatibility
parent: General Principles
nav_order: 1
---

# Compatibility
{: .no_toc }

Compatibility is vital in API design to supply a stable and robust service. These guidelines are to be followed for ensuring backward compatibility and fostering client adaptability.

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## `MUST` We do not Break Backward Compatibility

APIs are contracts between service providers and service consumers that cannot be broken via unilateral decisions. For this reason APIs may only be changed if backward compatibility is guaranteed. If this cannot be guaranteed, a new API major version must be provided and the old one has to be supported in parallel. For deprecation, follow the principles described in the chapter about [deprecation](/api-principles/organization/#must-deprecation).

API designers should apply the following rules to evolve APIs for services in a backward-compatible way:

- Add only optional, never mandatory fields.
- Never change the semantic of fields (e.g. changing the semantic from customer-number to customer-id, as both are different unique customer keys)
- Input fields may have (complex) constraints being validated via server-side business logic. Never change the validation logic to be more restrictive and make sure that all constraints are clearly defined in description.
- Enum ranges can be reduced when used as input parameters, only if the server is ready to accept and handle old range values too. Enum range can be reduced when used as output parameters.
- Enum ranges cannot be extended when used for output parameters — clients may not be prepared to handle it. However, enum ranges can be extended when used for input parameters.
- Use x-extensible-enum, if range is used for output parameters and likely to be extended with growing functionality. It defines an open list of explicit values and clients must be agnostic to new values.
- Support redirection in case an URL has to change 301 (Moved Permanently).

On the other hand, API consumers must follow the tolerant reader rules (see below).

---

## `MUST` Clients must be Tolerant Readers

Clients of an API **must** follow the rules described in the chapter about [tolerant dependencies](/api-principles/architecture/#must-we-build-tolerant-dependencies).
