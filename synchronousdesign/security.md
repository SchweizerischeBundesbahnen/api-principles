---
layout: default
title: Security
parent: Synchronous-API Design
nav_order: 20
---

{MUST} Secure public APIs with API Management & WAF
===================================================
Every public API must be published in the API Management and must be protected with a WAF. For applications, which are running internal or in a private cloud, the configuration of the WAF is already made with the initial deployment of the API to the API Management. If an API is published on a public cloud, you **must** protect your API with a CloudWAF ([internal CloudWAF documentation](https://confluence.sbb.ch/pages/viewpage.action?pageId=1206812770))

{SHOULD} Use "OWASP Secure Coding Practice"
===================================================

The WAF checks all known OWASP 10 security risks. To avoid false positives, all API Provider **should** use the [OWASP Secure Coding Practice Checklist](https://www.owasp.org/index.php/OWASP_Secure_Coding_Practices_Checklist)  <br/>
**Example**: <br/>
Do not use <> in the payloads:

    {
      "user": "<unknown>"
    }

will be blocked as an html injection. In this case you **should** use an empty or null value:

    {
      "user": ""
    }

Exceptions can be configured in the WAF and **must** be reported to the Network and Security Team.

{MUST} Secure Endpoints with OAuth 2.0
======================================

Every API endpoint needs to be secured using OAuth 2.0. Please refer to the [official OpenAPI spec](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md#security-definitions-object) on how to specify security definitions in your API specification or take a look at the following example.

    components:
      securitySchemes:
        oauth2:
          type: oauth2
          flows:
            clientCredentials:
              tokenUrl: https://identity.zalando.com/oauth2/token
              scopes:
                fulfillment-order-service.read: Access right needed to read from the fulfillment order service.
                fulfillment-order-service.write: Access right needed to write to the fulfillment order service.

The example defines OAuth2 with client credentials flow as security standard used for authentication when accessing endpoints. Additionally, there are two API access rights (permissions) defined via the scopes section for later endpoint authorization usage (see [next section](#105)).

It makes little sense specifying the flow to retrieve OAuth tokens in the `securitySchemes` section, as API endpoints should not care, how OAuth tokens were created. Unfortunately the `flow` field is mandatory and cannot be omitted. API endpoints should always set `flow: clientCredentials` and ignore this information.

{SHOULD} Define and Assign Permissions (Scopes)
=============================================

APIs must define permissions to protect their resources. Thus, at least one permission must be assigned to each endpoint. Permissions are defined as shown in the [previous section](#104).

The naming schema for permissions corresponds to the naming schema for [hostnames](#224) and [event type names](#213). Please refer to [{MUST} Follow Naming Convention for Permissions (Scopes)](#225) for designing permission names.

APIs should stick to component specific permissions without resource extension to avoid governance complexity of too many fine grained permissions. For the majority of use cases, restricting access to specific API endpoints using read and write is sufficient for controlling access for client types like merchant or retailer business partners, customers or operational staff. However, in some situations, where the API serves different types of resources for different owners, resource specific scopes may make sense.

Some examples for standard and resource-specific permissions:

<table><colgroup><col style="width: 25%" /><col style="width: 20%" /><col style="width: 15%" /><col style="width: 40%" /></colgroup><thead><tr class="header"><th>Application ID</th><th>Resource ID</th><th>Access Type</th><th>Example</th></tr></thead><tbody><tr class="odd"><td><p><code>order-management</code></p></td><td><p><code>sales_order</code></p></td><td><p><code>read</code></p></td><td><p><code>order-management.sales_order.read</code></p></td></tr><tr class="even"><td><p><code>order-management</code></p></td><td><p><code>shipment_order</code></p></td><td><p><code>read</code></p></td><td><p><code>order-management.shipment_order.read</code></p></td></tr><tr class="odd"><td><p><code>fulfillment-order</code></p></td><td></td><td><p><code>write</code></p></td><td><p><code>fulfillment-order.write</code></p></td></tr><tr class="even"><td><p><code>business-partner-service</code></p></td><td></td><td><p><code>read</code></p></td><td><p><code>business-partner-service.read</code></p></td></tr></tbody></table>

After permission names are defined and the permission is declared in the security definition at the top of an API specification, it should be assigned to each API operation by specifying a [security requirement](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md#securityRequirementObject) like this:

    paths:
     /business-partners/{partner-id}:
        get:
          summary: Retrieves information about a business partner
          security:
            - oauth2:
              - business-partner.read


Hint: you need not explicitly define the "Authorization" header; it is a standard header so to say implicitly defined via the security section.

{SHOULD} Follow Naming Convention for Permissions (Scopes)
========================================================

As long as the [functional naming](#223) is not supported for permissions, permission names in APIs must conform to the following naming pattern:

    <permission> ::= <standard-permission> |  -- should be sufficient for majority of use cases
                     <resource-permission> |  -- for special security access differentiation use cases

    <standard-permission> ::= <application-id>.<access-mode>
    <resource-permission> ::= <application-id>.<resource-name>.<access-mode>

    <application-id>      ::= [a-z][a-z0-9-]*  -- application identifier
    <resource-name>       ::= [a-z][a-z0-9-]*  -- free resource identifier
    <access-mode>         ::= read | write    -- might be extended in future

