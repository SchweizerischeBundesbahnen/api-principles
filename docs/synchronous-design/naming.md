---
layout: default
title: Naming
parent: API Design
nav_order: 16
---

{MUST-SHOULD} Use Functional Naming Schema
==========================================

Functional naming is a powerful, yet easy way to align global resources as *host*, *permission*, and *event names* within an the application landscape. It helps to preserve uniqueness of names while giving readers meaningful context information about the addressed component. Besides, the most important aspect is, that it allows to keep APIs stable in the case of technical and organizational changes (Zalando for example maintains an internal naming convention).

To make use of this advantages for APIs with a larger [audience](#219) we strongly recommended to follow the functional naming schema for [hostnames](#224), [permission names](#215), and [event names](#213) in APIs as follows:

<table><colgroup><col style="width: 25%" /><col style="width: 75%" /></colgroup><tbody><tr class="odd"><td><p><strong>Functional Naming</strong></p></td><td><p><strong>Audience</strong></p></td></tr><tr class="even"><td><p><strong>must</strong></p></td><td><p>external-public, external-partner</p></td></tr><tr class="odd"><td><p><strong>should</strong></p></td><td><p>company-internal, business-unit-internal</p></td></tr><tr class="even"><td><p><strong>may</strong></p></td><td><p>component-internal</p></td></tr></tbody></table>

To conduct the functional naming schema, a unique `functional-name` is assigned to each functional component. It is built of the domain name of the functional group the component is belonging to and a unique a short identifier for the functional component itself:

    <functional-name>       ::= <functional-domain>-<functional-component>
    <functional-domain>     ::= [a-z][a-z0-9]*  -- managed functional group of components
    <functional-component>  ::= [a-z][a-z0-9-]* -- name of owning functional component

**Internal Hint**: Use the simple [functional name registry (internal link)](https://github.bus.zalan.do/team-architecture/functional-component-registry) to register your functional name before using it. The registry is a centralized infrastructure service to ensure uniqueness of your functional names (and available domains) and to support hostname DNS resolution.

Please see the following rules for detailed functional naming patterns:

-   [{MUST} Follow Naming Convention for Hostnames](#224)

-   [???](#213)

{MUST} Follow Naming Convention for Hostnames
=============================================

Hostnames in APIs must, respectively should conform to the functional naming depending on the [audience](#219) as follows (see [{MUST-SHOULD} Use Functional Naming Schema](#223) for details and `<functional-name>` definition):

    <hostname>             ::= <functional-hostname> | <application-hostname>

    <functional-hostname>  ::= <functional-name>.zalandoapis.com

The following application specific legacy convention is **only** allowed for hostnames of [component-internal](#219) APIs:

    <application-hostname> ::= <application-id>.<organization-unit>.zalan.do
    <application-id>       ::= [a-z][a-z0-9-]*  -- application identifier
    <organization-id>      ::= [a-z][a-z0-9-]*  -- organization unit identifier, e.g. team identifier

{MUST} Use lowercase separate words with hyphens for Path Segments
==================================================================

Example:

    /shipment-orders/{shipment-order-id}

This applies to concrete path segments and not the names of path parameters. For example `{shipment_order_id}` would be ok as a path parameter.

{MUST} Use snake\_case (never camelCase) for Query Parameters
=============================================================

Examples:

    customer_number, order_id, billing_address

{SHOULD} Prefer Hyphenated-Pascal-Case for HTTP header Fields
=============================================================

This is for consistency in your documentation (most other headers follow this convention). Avoid camelCase (without hyphens). Exceptions are common abbreviations like "ID."

Examples:

    Accept-Encoding
    Apply-To-Redirect-Ref
    Disposition-Notification-Options
    Original-Message-ID

See also: {RFC-7230}\#page-22\[HTTP Headers are case-insensitive (RFC 7230)\].

See [???](#common-headers) and [???](#proprietary-headers) sections for more guidance on HTTP headers.

{MUST} Pluralize Resource Names
===============================

Usually, a collection of resource instances is provided (at least API should be ready here). The special case of a resource singleton is a collection with cardinality 1.

{SHOULD} Not Use /api as Base Path
==================================

In most cases, all resources provided by a service are part of the public API, and therefore should be made available under the root "/" base path.

If the service should also support non-public, internal APIs — for specific operational support functions, for example — we encourage you to maintain two different API specifications and provide [API audience](#219). For both APIs, you should not use `/api` as base path.

We see API’s base path as a part of deployment variant configuration. Therefore, this information has to be declared in the [server object](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.2.md#server-object).

{MUST} Avoid Trailing Slashes
=============================

The trailing slash must not have specific semantics. Resource paths must deliver the same results whether they have the trailing slash or not.

{MUST} Stick to Conventional Query Parameters
=============================================

If you provide query support for searching, sorting, filtering, and paginating, you must stick to the following naming conventions:

-   {q}: default query parameter, e.g. used by browser tab completion; should have an entity specific alias, e.g. sku.

-   {sort}: comma-separated list of fields (as defined by [???](#154)) to define the sort order. To indicate sorting direction, fields may be prefixed with `+` (ascending) or `-` (descending), e.g. /sales-orders?sort=+id.

-   {fields}: field name expression to retrieve only a subset of fields of a resource. See [???](#157) below.

-   {embed}: field name expression to expand or embedded sub-entities, e.g. inside of an article entity, expand silhouette code into the silhouette object. Implementing {embed} correctly is difficult, so do it with care. See [???](#158) below.

-   {offset}: numeric offset of the first element provided on a page representing a collection request. See [???](#pagination) section below.

-   {cursor}: an opaque pointer to a page, never to be inspected or constructed by clients. It usually (encrypted) encodes the page position, i.e. the identifier of the first or last page element, the pagination direction, and the applied query filters to recreate the collection. See [pagination](#160) section below.

-   {limit}: client suggested limit to restrict the number of entries on a page. See [???](#pagination) section below.
