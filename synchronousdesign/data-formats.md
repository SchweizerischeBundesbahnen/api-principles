---
layout: default
title: Data Formats
parent: Synchronous-API Design
nav_order: 7
---

{MUST} Use JSON to Encode Structured Data
=========================================

Use JSON-encoded body payload for transferring structured data. The JSON payload must follow {RFC-7159}\[RFC 7159\] by having (if possible) a serialized object as the top-level structure, since it would allow for future extension. This also applies for collection resources where one naturally would assume an array. See [???](#161) for an example.

{MAY} Use non JSON Media Types for Binary Data or Alternative Content Representations
=====================================================================================

Other media types may be used in following cases:

-   Transferring binary data or data whose structure is not relevant. This is the case if payload structure is not interpreted and consumed by clients as is. Example of such use case is downloading images in formats JPG, PNG, GIF.

-   In addition to JSON version alternative data representations (e.g. in formats PDF, DOC, XML) may be made available through content negotiation.

{SHOULD} Prefer standard Media type name `application/json`
===========================================================

Previously, this guideline allowed the use of custom media types like `application/x.zalando.article+json`. This usage is not recommended anymore and should be avoided, except where it is necessary for cases of [media type versioning](#114). Instead, just use the standard media type name `application/json` (or `application/problem+json` for [???](#176)).

Custom media types beginning with `x` bring no advantage compared to the standard media type for JSON, and make automated processing more difficult. They are also {RFC-6838}\#section-3.4\[discouraged by RFC 6838\].

{SHOULD} Use standardized property formats
==========================================

{https://json-schema.org/understanding-json-schema/reference/string.html\#format}\[JSON Schema\] and {https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.2.md\#data-types}\[OpenAPI\] define several universally useful property formats. The following table contains some additional formats that are particularly useful in an e-commerce environment.

Please notice that the list is not exhaustive and everyone is encouraged to propose additions.

<table><colgroup><col style="width: 10%" /><col style="width: 25%" /><col style="width: 25%" /><col style="width: 40%" /></colgroup><thead><tr class="header"><th><code>type</code></th><th><code>format</code></th><th>Specification</th><th>Example</th></tr></thead><tbody><tr class="odd"><td><p><code>integer</code></p></td><td><p><a href="#171"><code>int32</code></a></p></td><td></td><td><p><code>7721071004</code></p></td></tr><tr class="even"><td><p><code>integer</code></p></td><td><p><a href="#171"><code>int64</code></a></p></td><td></td><td><p><code>772107100456824</code></p></td></tr><tr class="odd"><td><p><code>integer</code></p></td><td><p><a href="#171"><code>bigint</code></a></p></td><td></td><td><p><code>77210710045682438959</code></p></td></tr><tr class="even"><td><p><code>number</code></p></td><td><p><a href="#171"><code>float</code></a></p></td><td><p>{IEEE-754-2008}[IEEE 754-2008]</p></td><td><p><code>3.1415927</code></p></td></tr><tr class="odd"><td><p><code>number</code></p></td><td><p><a href="#171"><code>double</code></a></p></td><td><p>{IEEE-754-2008}[IEEE 754-2008]</p></td><td><p><code>3.141592653589793</code></p></td></tr><tr class="even"><td><p><code>number</code></p></td><td><p><a href="#171"><code>decimal</code></a></p></td><td></td><td><p><code>3.141592653589793238462643383279</code></p></td></tr><tr class="odd"><td><p><code>string</code></p></td><td><p><a href="#170"><code>bcp47</code></a></p></td><td><p>{BCP47}[BCP 47]</p></td><td><p><code>"en-DE"</code></p></td></tr><tr class="even"><td><p><code>string</code></p></td><td><p><code>byte</code></p></td><td><p>{RFC-7493}[RFC 7493]</p></td><td><p><code>"dGVzdA=="</code></p></td></tr><tr class="odd"><td><p><code>string</code></p></td><td><p><a href="#126"><code>date</code></a></p></td><td><p>{RFC-3339}[RFC 3339]</p></td><td><p><code>"2019-07-30"</code></p></td></tr><tr class="even"><td><p><code>string</code></p></td><td><p><a href="#126"><code>date-time</code></a></p></td><td><p>{RFC-3339}[RFC 3339]</p></td><td><p><code>"2019-07-30T06:43:40.252Z"</code></p></td></tr><tr class="odd"><td><p><code>string</code></p></td><td><p><code>email</code></p></td><td><p>{RFC-5322}[RFC 5322]</p></td><td><p><code>"example@zalando.de"</code></p></td></tr><tr class="even"><td><p><code>string</code></p></td><td><p><code>gtin-13</code></p></td><td><p>{GTIN}[GTIN]</p></td><td><p><code>"5710798389878"</code></p></td></tr><tr class="odd"><td><p><code>string</code></p></td><td><p><code>hostname</code></p></td><td><p>{RFC-1034}[RFC 1034]</p></td><td><p><code>"www.zalando.de"</code></p></td></tr><tr class="even"><td><p><code>string</code></p></td><td><p><code>ipv4</code></p></td><td><p>{RFC-2673}[RFC 2673]</p></td><td><p><code>"104.75.173.179"</code></p></td></tr><tr class="odd"><td><p><code>string</code></p></td><td><p><code>ipv6</code></p></td><td><p>{RFC-2673}[RFC 2673]</p></td><td><p><code>"2600:1401:2::8a"</code></p></td></tr><tr class="even"><td><p><code>string</code></p></td><td><p><a href="#170"><code>iso-3166</code></a></p></td><td><p>{ISO-3166-1-a2}[ISO 3166-1 alpha-2]</p></td><td><p><code>"DE"</code></p></td></tr><tr class="odd"><td><p><code>string</code></p></td><td><p><a href="#173"><code>iso-4217</code></a></p></td><td><p>{ISO-4217}[ISO 4217]</p></td><td><p><code>"EUR"</code></p></td></tr><tr class="even"><td><p><code>string</code></p></td><td><p><a href="#170"><code>iso-639</code></a></p></td><td><p>{ISO-639-1}[ISO 639-1]</p></td><td><p><code>"de"</code></p></td></tr><tr class="odd"><td><p><code>string</code></p></td><td><p><code>json-pointer</code></p></td><td><p>{RFC-6901}[RFC 6901]</p></td><td><p><code>"/items/0/id"</code></p></td></tr><tr class="even"><td><p><code>string</code></p></td><td><p><code>password</code></p></td><td></td><td><p><code>"secret"</code></p></td></tr><tr class="odd"><td><p><code>string</code></p></td><td><p><code>regex</code></p></td><td><p>{ECMA-262}[ECMA 262]</p></td><td><p><code>"^[a-z0-9]+$"</code></p></td></tr><tr class="even"><td><p><code>string</code></p></td><td><p><a href="#126"><code>time</code></a></p></td><td><p>{RFC-3339}[RFC 3339]</p></td><td><p><code>"06:43:40.252Z"</code></p></td></tr><tr class="odd"><td><p><code>string</code></p></td><td><p><code>uri</code></p></td><td><p>{RFC-3986}[RFC 3986]</p></td><td><p><code>"https://www.zalando.de/"</code></p></td></tr><tr class="even"><td><p><code>string</code></p></td><td><p><code>uri-template</code></p></td><td><p>{RFC-6570}[RFC 6570]</p></td><td><p><code>"/users/{id}"</code></p></td></tr><tr class="odd"><td><p><code>string</code></p></td><td><p><a href="#144"><code>uuid</code></a></p></td><td><p>{RFC-4122}[RFC 4122]</p></td><td><p><code>"e2ab873e-b295-11e9-9c02-…​"</code></p></td></tr></tbody></table>

{MUST} Use Standard Date and Time Formats
=========================================

JSON Payload
------------

Read more about date and time format in [???](#126).

HTTP headers
------------

Http headers including the proprietary headers use the {RFC-7231}\#section-7.1.1.1\[HTTP date format defined in RFC 7231\].

{MAY} Use Standards for Country, Language and Currency Codes
============================================================

Use the following standard formats for country, language and currency codes:

-   {ISO-3166-1-a2}\[ISO 3166-1-alpha2 country codes\]

    -   (It is "GB", not "UK", even though "UK" has seen some use at Zalando)

-   {ISO-639-1}\[ISO 639-1 language code\]

    -   {BCP47}\[BCP 47\] (based on {ISO-639-1}\[ISO 639-1\]) for language variants

-   {ISO-4217}\[ISO 4217 currency codes\]

{MUST} Define Format for Type Number and Integer
================================================

Whenever an API defines a property of type `number` or `integer`, the precision must be defined by the format as follows to prevent clients from guessing the precision incorrectly, and thereby changing the value unintentionally:

<table><colgroup><col style="width: 15%" /><col style="width: 15%" /><col style="width: 70%" /></colgroup><thead><tr class="header"><th>type</th><th>format</th><th>specified value range</th></tr></thead><tbody><tr class="odd"><td><p>integer</p></td><td><p>int32</p></td><td><p>integer between -231 and 231-1</p></td></tr><tr class="even"><td><p>integer</p></td><td><p>int64</p></td><td><p>integer between -263 and 263-1</p></td></tr><tr class="odd"><td><p>integer</p></td><td><p>bigint</p></td><td><p>arbitrarily large signed integer number</p></td></tr><tr class="even"><td><p>number</p></td><td><p>float</p></td><td><p>{IEEE-754-2008}[IEEE 754-2008/ISO 60559:2011] binary32 decimal number</p></td></tr><tr class="odd"><td><p>number</p></td><td><p>double</p></td><td><p>{IEEE-754-2008}[IEEE 754-2008/ISO 60559:2011] binary64 decimal number</p></td></tr><tr class="even"><td><p>number</p></td><td><p>decimal</p></td><td><p>arbitrarily precise signed decimal number</p></td></tr></tbody></table>

The precision must be translated by clients and servers into the most specific language types. E.g. for the following definitions the most specific language types in Java will translate to `BigDecimal` for `Money.amount` and `int` or `Integer` for the `OrderList.page_size`:

    components:
      schemas:
        Money:
          type: object
          properties:
            amount:
              type: number
              description: Amount expressed as a decimal number of major currency units
              format: decimal
              example: 99.95
           ...

        OrderList:
          type: object
          properties:
            page_size:
              type: integer
              description: Number of orders in list
              format: int32
              example: 42
