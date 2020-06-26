---
layout: default
title: Best Practices
parent: RESTful APIs
nav_order: 99
---

Best Practices
==============
{: .no_toc }

This chapter is not subject to IT Governance. It is more a collection of extractions from literature, experiences and patterns that we document as shared knowledge. We also included some ideas from other API Principles (e.g. Zalando's and Paypal's). Nevertheless engineers **should** read this section as it contains very valuable knowledge of how to design and implement RESTful APIs.

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## General API Design Principles

Comparing SOA web service interfacing style of SOAP vs. REST, the former tend to be centered around operations that are usually use-case specific and specialized. In contrast, REST is centered around business (data) entities exposed as resources that are identified via URIs and can be manipulated via standardized CRUD-like methods using different representations, and hypermedia. RESTful APIs tend to be less use-case specific and comes with less rigid client / server coupling and are more suitable for an ecosystem of (core) services providing a platform of APIs to build diverse new business services. We apply the RESTful web service principles to all kind of application (micro-) service components, independently from whether they provide functionality via the internet or intranet.

-   We prefer REST-based APIs with JSON payloads

-   We prefer systems to be truly RESTful (level 2)

An important principle for API design and usage is Postel’s Law, aka [The Robustness Principle](http://en.wikipedia.org/wiki/Robustness_principle) (see also [RFC 1122](https://tools.ietf.org/html/rfc1122)):

-   Be liberal in what you accept, be conservative in what you send

*Readings:* Some interesting reads on the RESTful API design style and service architecture:

-   Book: [Irresistable APIs: Designing web APIs that developers will love](https://www.amazon.de/Irresistible-APIs-Designing-that-developers/dp/1617292559)

-   Book: [REST in Practice: Hypermedia and Systems Architecture](http://www.amazon.de/REST-Practice-Hypermedia-Systems-Architecture/dp/0596805829)

-   Book: [Build APIs You Won’t Hate](https://leanpub.com/build-apis-you-wont-hate)

-   InfoQ eBook: [Web APIs: From Start to Finish](http://www.infoq.com/minibooks/emag-web-api)

-   Lessons-learned blog: [Thoughts on RESTful API Design](http://restful-api-design.readthedocs.org/en/latest/)

-   Fielding Dissertation: [Architectural Styles and the Design of Network-Based Software Architectures](http://www.ics.uci.edu/~fielding/pubs/dissertation/top.htm)

### Follow API First Principle

You should follow the API First Principle, more specifically:

-   You should design APIs first, before coding its implementation.
-   You should design your APIs consistently with these guidelines.
-   You should call for early review feedback from peers and client developers. Also consider to apply for a lightweight review by the API Team.

See also the principle [Design API first](https://schweizerischebundesbahnen.github.io/api-principles/architecture/#must-design-api-first).

### Provide API User Manual

In addition to the API Specification, it is good practice to provide an API user manual to improve client developer experience, especially of engineers that are less experienced in using this API. A helpful API user manual typically describes the following API aspects:

-   Domain Knowledge and context, including API scope, purpose, and use cases
-   Concrete examples of API usage
-   Edge cases, error situation details, and repair hints
-   Architecture context and major dependencies - including figures and sequence flows

## Common Headers

This section describes a handful of headers which are useful in particular circumstances but not widely known.

### Use `Content-*` Headers Correctly

Content or entity headers are headers with a `Content-` prefix. They describe the content of the body of the message and they can be used in both, HTTP requests and responses. Commonly used content headers include but are not limited to:

-   {Content-Disposition} can indicate that the representation is supposed to be saved as a file, and the proposed file name.

-   {Content-Encoding} indicates compression or encryption algorithms applied to the content.

-   {Content-Length} indicates the length of the content (in bytes).

-   {Content-Language} indicates that the body is meant for people literate in some human language(s).

-   {Content-Location} indicates where the body can be found otherwise.

-   {Content-Range} is used in responses to range requests to indicate which part of the requested resource representation is delivered with the body.

-   {Content-Type} indicates the media type of the body content.

### Use Standardized Headers

Use [this list](http://en.wikipedia.org/wiki/List_of_HTTP_header_fields) and mention its support in your OpenAPI definition.

#### Use Standardized request identifiers
To identify a specific request throug the entire chain, support the X-Correlation-Id and X-Process-Id header. 
The X-Correlation-Id header identifes one single request from the client to the prvider. Every component like the API Management gateway or the WAF has to log this header. This information is very important in root cause analysis over several systems and helps detect how total latencies are stacked up.
The X-Process-Id identifies a group of multiple synchronous and asynchronous requests (with different X-Correlation-Id headers) which all belong to one business transaction. 

### Consider to Support `ETag` Together With `If-Match`/`If-None-Match` Header

When creating or updating resources it may be necessary to expose conflicts and to prevent the 'lost update' or 'initially created' problem. Following [RFC-7232 HTTP: Conditional Requests](https://tools.ietf.org/html/rfc7232) this can be best accomplished by supporting the {ETag} header together with the {If-Match} or {If-None-Match} conditional header. The contents of an `ETag: <entity-tag>` header is either (a) a hash of the response body, (b) a hash of the last modified field of the entity, or (c) a version number or identifier of the entity version.

To expose conflicts between concurrent update operations via {PUT}, {POST}, or {PATCH}, the `If-Match: <entity-tag>` header can be used to force the server to check whether the version of the updated entity is conforming to the requested {entity-tag}. If no matching entity is found, the operation is supposed a to respond with status code {412} - precondition failed.

Beside other use cases, `If-None-Match: *` can be used in a similar way to expose conflicts in resource creation. If any matching entity is found, the operation is supposed a to respond with status code {412} - precondition failed.

The {ETag}, {If-Match}, and {If-None-Match} headers can be defined as follows in the API definition:

    components:
      headers:
      - ETag:
          description: |
            The RFC 7232 ETag header field in a response provides the entity-tag of
            a selected resource. The entity-tag is an opaque identifier for versions
            and representations of the same resource over time, regardless whether
            multiple versions are valid at the same time. An entity-tag consists of
            an opaque quoted string, possibly prefixed by a weakness indicator (see
            [RFC 7232 Section 2.3](https://tools.ietf.org/html/rfc7232#section-2.3).

          type: string
          required: false
          example: W/"xy", "5", "5db68c06-1a68-11e9-8341-68f728c1ba70"

      - If-Match:
          description: |
            The RFC7232 If-Match header field in a request requires the server to
            only operate on the resource that matches at least one of the provided
            entity-tags. This allows clients express a precondition that prevent
            the method from being applied if there have been any changes to the
            resource (see [RFC 7232 Section
            3.1](https://tools.ietf.org/html/rfc7232#section-3.1).

          type: string
          required: false
          example: "5", "7da7a728-f910-11e6-942a-68f728c1ba70"

      - If-None-Match:
          description: |
            The RFC7232 If-None-Match header field in a request requires the server
            to only operate on the resource if it does not match any of the provided
            entity-tags. If the provided entity-tag is `*`, it is required that the
            resource does not exist at all (see [RFC 7232 Section
            3.2](https://tools.ietf.org/html/rfc7232#section-3.2).

          type: string
          required: false
          example: "7da7a728-f910-11e6-942a-68f728c1ba70", *

### Consider to Support `Idempotency-Key` Header

When creating or updating resources it can be helpful or necessary to ensure a strong idempotent behavior comprising same responses, to prevent duplicate execution in case of retries after timeout and network outages. Generally, this can be achieved by sending a client specific *unique request key* – that is not part of the resource – via {Idempotency-Key} header.

The *unique request key* is stored temporarily, e.g. for 24 hours, together with the response and the request hash (optionally) of the first request in a key cache, regardless of whether it succeeded or failed. The service can now look up the *unique request key* in the key cache and serve the response from the key cache, instead of re-executing the request, to ensure idempotent behavior. Optionally, it can check the request hash for consistency before serving the response. If the key is not in the key store, the request is executed as usual and the response is stored in the key cache.

This allows clients to safely retry requests after timeouts, network outages, etc. while receive the same response multiple times. **Note:** The request retry in this context requires to send the exact same request, i.e. updates of the request that would change the result are off-limits. The request hash in the key cache can protection against this misbehavior. The service is recommended to reject such a request using status code {400}.

**Important:** To grant a reliable idempotent execution semantic, the resource and the key cache have to be updated with hard transaction semantics – considering all potential pitfalls of failures, timeouts, and concurrent requests in a distributed systems. This makes a correct implementation exceeding the local context very hard.

The {Idempotency-Key} header should be defined as follows, but you are free to choose your expiration time:

    components:
      headers:
      - Idempotency-Key:
          description: |
            The idempotency key is a free identifier created by the client to
            identify a request. It is used by the service to identify subsequent
            retries of the same request and ensure idempotent behavior by sending
            the same response without executing the request a second time.

            Clients should be careful as any subsequent requests with the same key
            may return the same response without further check. Therefore, it is
            recommended to use an UUID version 4 (random) or any other random
            string with enough entropy to avoid collisions.

            Idempotency keys expire after 24 hours. Clients are responsible to stay
            within this limits, if they require idempotent behavior.

          type: string
          format: uuid
          required: false
          example: "7da7a728-f910-11e6-942a-68f728c1ba70"

**Hint:** The key cache is not intended as request log, and therefore should have a limited lifetime, else it could easily exceed the data resource in size.

**Note:** The {Idempotency-Key} header unlike other headers in this section is not standardized in an RFC. Our only reference are the usage in the [Stripe API](https://stripe.com/docs/api/idempotent_requests). However, as it fit not into our section about proprietary-headers, and we did not want to change the header name and semantic, we decided to treat it as any other common header.

## Compatibility

### Follow Versioning best practices

#### URL based Versioning
{: .no_toc }

When API versioning is unavoidable, you should design your multi-version RESTful APIs carefully using URI type versioning. It is well known that versions in URIs also do have their negative consequences (like content negotiation issues). We still prefer URI Versioning because it is better supported by tools and infrastructure like API Management and Proxies use URL Mappings as an important property for routing and applying policies for the sake of performance (like e.g. different API subscription plans for different versions).

We explicitly avoid Resource based versioning, because this is a complexity which an API should not reflect to its consumers. 

*Good Example*
```
http://api.example.com/v1/myresource/...
```

*Bad Example*
```
http://api.example.com/myresource/v1/...
```

#### Semantic Versioning
{: .no_toc }

Versions in the Specification should follow the principles described by [SemVer](https://semver.org/). Versions in URIs are always major versions. Or in a more generic way: we avoid introducing minors or patches anywhere where it could break consumers compatibility.

#### Reflect deprecation in documentation
{: .no_toc }

Every element on the API that is being deprecated should also be marked in its documentation, using the [OpenAPI](https://swagger.io/specification/) property "deprecated".

#### Add Warnings in HTTP Headers
{: .no_toc }

During the deprecation timespan the responses of the deprected API SHOULD have a `Warning` header accoring to [RFC 7234](https://tools.ietf.org/html/rfc7234#section-5.5) with warn code 299 and text: "This API call is deprecated and will be removed. Refer release notes for details.

*Listed below, the table of warn codes described in RFC 7234:*

| Warn Code | Short Description                | Reference     |
|-----------|----------------------------------|---------------|
| 110       | Response is Stale                | Section 5.5.1 |
| 111       | Revalidation Failed              | Section 5.5.2 |
| 112       | Disconnected Operation           | Section 5.5.3 |
| 113       | Heuristic Expiration             | Section 5.5.4 |
| 199       | Miscellaneous Warning            | Section 5.5.5 |
| 214       | Transformation Applied           | Section 5.5.6 |
| 299       | Miscellaneous Persistent Warning | Section 5.5.7 |


### Design APIs Conservatively

Designers of service provider APIs should be conservative and accurate in what they accept from clients:

-   Unknown input fields in payload or URL should not be ignored; servers should provide error feedback to clients via an HTTP 400 response code.

-   Be accurate in defining input data constraints (like formats, ranges, lengths etc.) — and check constraints and return dedicated error information in case of violations.

-   Prefer being more specific and restrictive (if compliant to functional requirements), e.g. by defining length range of strings. It may simplify implementation while providing freedom for further evolution as compatible extensions.

Not ignoring unknown input fields is a specific deviation from Postel’s Law (e.g. see also  
[The Robustness Principle Reconsidered](https://cacm.acm.org/magazines/2011/8/114933-the-robustness-principle-reconsidered/fulltext)) and a strong recommendation. Servers might want to take different approach but should be aware of the following problems and be explicit in what is supported:

-   Ignoring unknown input fields is actually not an option for {PUT}, since it becomes asymmetric with subsequent {GET} response and HTTP is clear about the {PUT} *replace* semantics and default roundtrip expectations (see [RFC-7231#section-4.3.4](https://tools.ietf.org/html/rfc7231#section-4.3.4)). Note, accepting (i.e. not ignoring) unknown input fields and returning it in subsequent {GET} responses is a different situation and compliant to {PUT} semantics.

-   Certain client errors cannot be recognized by servers, e.g. attribute name typing errors will be ignored without server error feedback. The server cannot differentiate between the client intentionally providing an additional field versus the client sending a mistakenly named field, when the client’s actual intent was to provide an optional input field.

-   Future extensions of the input data structure might be in conflict with already ignored fields and, hence, will not be compatible, i.e. break clients that already use this field but with different type.

In specific situations, where a (known) input field is not needed anymore, it either can stay in the API definition with "not used anymore" description or can be removed from the API definition as long as the server ignores this specific parameter.

### Always Return JSON Objects As Top-Level Data Structures To Support Extensibility

In a response body, you must always return a JSON object (and not e.g. an array) as a top level data structure to support future extensibility. JSON objects support compatible extension by additional attributes. This allows you to easily extend your response and e.g. add pagination later, without breaking backwards compatibility.

Maps, even though technically objects, are also forbidden as top level data structures, since they don’t support compatible, future extensions.

### Treat Open API Definitions As Open For Extension By Default

The Open API 2.0 specification is not very specific on default extensibility of objects, and redefines JSON-Schema keywords related to extensibility, like `additionalProperties`. Following our overall compatibility guidelines, Open API object definitions are considered open for extension by default as per [Section 5.18 "additionalProperties"](http://json-schema.org/latest/json-schema-validation.html#rfc.section.5.18) of JSON-Schema.

When it comes to Open API 2.0, this means an `additionalProperties` declaration is not required to make an object definition extensible:

-   API clients consuming data must not assume that objects are closed for extension in the absence of an `additionalProperties` declaration and must ignore fields sent by the server they cannot process. This allows API servers to evolve their [data formats](#data-formats).

-   For API servers receiving unexpected data, the situation is slightly different. Instead of ignoring fields, servers *may* reject requests whose entities contain undefined fields in order to signal to clients that those fields would not be stored on behalf of the client. API designers must document clearly how unexpected fields are handled for {PUT}, {POST}, and {PATCH} requests.

API formats must not declare `additionalProperties` to be false, as this prevents objects being extended in the future.

Note that this guideline concentrates on default extensibility and does not exclude the use of `additionalProperties` with a schema as a value, which might be appropriate in some circumstances.

### Use Open-Ended List of Values (`x-extensible-enum`) Instead of Enumerations

Enumerations are per definition closed sets of values, that are assumed to be complete and not intended for extension. This closed principle of enumerations imposes compatibility issues when an enumeration must be extended. To avoid these issues, we strongly recommend to use an open-ended list of values instead of an enumeration unless:

1.  the API has full control of the enumeration values, i.e. the list of values does not depend on any external tool or interface, and

2.  the list of value is complete with respect to any thinkable and unthinkable future feature.

To specify an open-ended list of values use the marker {x-extensible-enum} as follows:

    deliverMethods:
      type: string
      x-extensible-enum:
        - parcel
        - letter
        - email

**Note:** {x-extensible-enum} is not JSON Schema conform but will be ignored by most tools.


## Data Formats

### Use JSON to Encode Structured Data

Use JSON-encoded body payload for transferring structured data. The JSON payload must follow [RFC-7159](https://tools.ietf.org/html/rfc7159) by having (if possible) a serialized object as the top-level structure, since it would allow for future extension. This also applies for collection resources where one naturally would assume an array.

### Use Standard Date and Time Formats

#### JSON Payload
{: .no_toc }

Read more about date and time format in //TODO date format definieren.

#### HTTP headers
{: .no_toc }

Http headers including the proprietary headers use the HTTP date format defined in [RFC-7231#section-7.1.1.1](https://tools.ietf.org/html/rfc7231#section-7.1.1.1).

### Use Standards for Country, Language and Currency Codes

Use the following standard formats for country, language and currency codes:

-   {ISO-3166-1-a2}\[ISO 3166-1-alpha2 country codes\]

    -   (It is "GB", not "UK")

-   {ISO-639-1}\[ISO 639-1 language code\]

    -   {BCP47}\[BCP 47\] (based on {ISO-639-1}\[ISO 639-1\]) for language variants

-   {ISO-4217}\[ISO 4217 currency codes\]

### Define format for number and integer types

Whenever an API defines a property of type `number` or `integer`, the
precision should be defined by the format as follows to prevent clients
from guessing the precision incorrectly, and thereby changing the value
unintentionally:

| Type      | Format   | Specified Value Range                                                 |
|-----------|----------|-----------------------------------------------------------------------|
| integer   | int32    | integer between pass:[-2<sup>31</sup>] and pass:[2<sup>31</sup>]-1    |
| integer   | int64i   | integer between pass:[-2<sup>63</sup>] and pass:[2<sup>63</sup>]-1    |
| integer   | bigint   | arbitrarily large signed integer number                               |
| number    | float    | {IEEE-754-2008}[IEEE 754-2008/ISO 60559:2011] binary32 decimal number |
| number    | doublel  | {IEEE-754-2008}[IEEE 754-2008/ISO 60559:2011] binary64 decimal number |
| number    | decimal  | arbitrarily precise signed decimal number                             |

The precision should be translated by clients and servers into the most
specific language types. E.g. for the following definitions the most
specific language types in Java will translate to `BigDecimal` for
`Money.amount` and `int` or `Integer` for the `OrderList.page_size`:

[source,yaml]
----
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
----

## Deprication

### Monitor Usage of Deprecated APIs

Owners of APIs used in production must monitor usage of deprecated APIs until the API can be shut down in order to align deprecation and avoid uncontrolled breaking effects.

**Hint:** Use [API Management (internal link)](https://confluence.sbb.ch/display/AITG/API+Management) to keep track of the usage of your APIs

### Add a Warning Header to Responses

During deprecation phase, the producer should add a `Warning` header (see [RFC 7234 - Warning header](https://tools.ietf.org/html/rfc7234)) field. When adding the `Warning` header, the `warn-code` must be `299` and the `warn-text` should be in form of

    The path/operation/parameter/... {name} is deprecated and will be removed by {date}.
    Please see {link} for details.

with a link to a documentation describing why the API is no longer supported in the current form and what clients should do about it. Adding the `Warning` header is not sufficient to gain client consent to shut down an API.

### Add Monitoring for Warning Header

Clients should monitor the `Warning` header in HTTP responses to see if an API will be deprecated in future.

## Hypermedia (REST level 3)

### Use REST Maturity Level 2

We strive for a good implementation of [REST Maturity Level 2](http://martinfowler.com/articles/richardsonMaturityModel.html#level2) as it enables us to build resource-oriented APIs that make full use of HTTP verbs and status codes. Although this is not HATEOAS, it should not prevent you from designing proper link relationships in your APIs as stated in some best practices, listed below.

### Use REST Maturity Level 3 - HATEOAS

We do not generally recommend to implement [REST Maturity Level 3](http://martinfowler.com/articles/richardsonMaturityModel.html#level3). HATEOAS comes with additional API complexity without real value in our SOA context where client and server interact via REST APIs and provide complex business functions as part of our e-commerce SaaS platform.

Our major concerns regarding the promised advantages of HATEOAS (see also [RESTistential Crisis over Hypermedia APIs](https://www.infoq.com/news/2014/03/rest-at-odds-with-web-apis), [Why I Hate HATEOAS](https://jeffknupp.com/blog/2014/06/03/why-i-hate-hateoas/) and others for a detailed discussion):

-   We follow the API First principle with APIs explicitly defined outside the code with standard specification language. HATEOAS does not really add value for SOA client engineers in terms of API self-descriptiveness: a client engineer finds necessary links and usage description (depending on resource state) in the API reference definition anyway.

-   Generic HATEOAS clients which need no prior knowledge about APIs and explore API capabilities based on hypermedia information provided, is a theoretical concept that we haven’t seen working in practice and does not fit to our SOA set-up. The OpenAPI description format (and tooling based on OpenAPI) doesn’t provide sufficient support for HATEOAS either.

-   In practice relevant HATEOAS approximations (e.g. following specifications like HAL or JSON API) support API navigation by abstracting from URL endpoint and HTTP method aspects via link types. So, Hypermedia does not prevent clients from required manual changes when domain model changes over time.

-   Hypermedia make sense for humans, less for SOA machine clients. We would expect use cases where it may provide value more likely in the frontend and human facing service domain.

-   Hypermedia does not prevent API clients to implement shortcuts and directly target resources without 'discovering' them.

However, we do not forbid HATEOAS; you could use it, if you checked its limitations and still see clear value for your usage scenario that justifies its additional complexity.

### Use full, absolute URI

Links to other resource must always use full, absolute URI.

**Motivation**: Exposing any form of relative URI (no matter if the relative URI uses an absolute or relative path) introduces avoidable client side complexity. It also requires clarity on the base URI, which might not be given when using features like embedding subresources. The primary advantage of non-absolute URI is reduction of the payload size, which is better achievable by following the recommendation to use gzip compression.

### Use Common Hypertext Controls

When embedding links to other resources into representations you must use the common hypertext control object. It contains at least one attribute:

-   {href}: The URI of the resource the hypertext control is linking to. All our API are using HTTP(s) as URI scheme.

In API that contain any hypertext controls, the attribute name {href} is reserved for usage within hypertext controls.

The schema for hypertext controls can be derived from this model:

    HttpLink:
      description: A base type of objects representing links to resources.
      type: object
      properties:
        href:
          description: Any URI that is using http or https protocol
          type: string
          format: uri
      required:
        - href

The name of an attribute holding such a `HttpLink` object specifies the relation between the object that contains the link and the linked resource. Implementations should use names from the {link-relations}\[IANA Link Relation Registry\] whenever appropriate. As IANA link relation names use hyphen-case notation, while this guide enforces camelCase notation for attribute names, hyphens in IANA names have to be replaced (e.g. the IANA link relation type `version-history` would become the attribute `versionHistory`)

Specific link objects may extend the basic link type with additional attributes, to give additional information related to the linked resource or the relationship between the source resource and the linked one.

E.g. a service providing "Person" resources could model a person who is married with some other person with a hypertext control that contains attributes which describe the other person (`id`, `name`) but also the relationship "spouse" between the two persons (`since`):

    {
      "id": "446f9876-e89b-12d3-a456-426655440000",
      "name": "Peter Mustermann",
      "spouse": {
        "href": "https://...",
        "since": "1996-12-19",
        "id": "123e4567-e89b-12d3-a456-426655440000",
        "name": "Linda Mustermann"
      }
    }

Hypertext controls are allowed anywhere within a JSON model. While this specification would allow [HAL](http://stateless.co/hal_specification.html), we actually don’t recommend/enforce the usage of HAL anymore as the structural separation of meta-data and data creates more harm than value to the understandability and usability of an API.

### Use Simple Hypertext Controls for Pagination and Self-References

For pagination and self-references a simplified form of the extensible common hypertext controls should be used to reduce the specification and cognitive overhead. It consists of a simple URI value in combination with the corresponding {link-relations}\[link relations\], e.g. {next}, {prev}, {first}, {last}, or {self}.

### Do not Use Link Headers with JSON Entities

For flexibility and precision, we prefer links to be directly embedded in the JSON payload instead of being attached using the uncommon link header syntax. As a result, the use of the [`Link` Header defined by RFC 8288](https://tools.ietf.org/html/rfc8288#section-3) in conjunction with JSON media types is forbidden.

## JSON Best Practices

This is a set of best practices for using JSON as a HTTP body format. JSON here refers to [RFC 7159](https://tools.ietf.org/html/rfc7159) (which updates [RFC 4627](https://tools.ietf.org/html/rfc4627)), the "application/json" media type and custom JSON media types defined for APIs. This section only cover some specific cases of JSON design decisions. The first some of the following guidelines are about property names, the later ones about values.

### Property names must be camelCase

Property names are restricted to ASCII strings in lower case camelCase, matching the following format: `[a-z]+[A-Z0-9][a-z0-9]+[A-Za-z0-9]*$`. The only exception are keywords like `_links`.

Rationale: It’s essential to establish a consistent look and feel such that JSON looks as if it came from the same hand, independent of the system that provides the API. It is also very important to stick to names that do generate valid source code when generating code from specs like [OpenAPI](https://swagger.io/specification/).

### Define Maps Using `additionalProperties`

A "map" here is a mapping from string keys to some other type. In JSON this is represented as an object, the key-value pairs being represented by property names and property values. In OpenAPI schema (as well as in JSON schema) they should be represented using additionalProperties with a schema defining the value type. Such an object should normally have no other defined properties.

The map keys don’t count as property names, and can follow whatever format is natural for their domain. Please document this in the description of the map object’s schema.

Here is an example for such a map definition (the `translations` property):

    components:
      schemas:
        Message:
          description:
            A message together with translations in several languages.
          type: object
          properties:
            messageKey:
              type: string
              description: The message key.
            translations:
              description:
                The translations of this message into several languages.
                The keys are [IETF BCP-47 language tags](https://tools.ietf.org/html/bcp47).
              type: object
              additionalProperties:
                type: string
                description:
                  the translation of this message into the language identified by the key.

An actual JSON object described by this might then look like this:

    { "messageKey": "color",
      "translations": {
        "de": "Farbe",
        "en-US": "color",
        "en-GB": "colour",
        "eo": "koloro",
        "nl": "kleur"
      }
    }

### Array names should be pluralized

To indicate they contain multiple values prefer to pluralize array names. This implies that object names should in turn be singular.

### Boolean property values must not be null

Schema based JSON properties that are by design booleans must not be presented as nulls. A boolean is essentially a closed enumeration of two values, true and false. If the content has a meaningful null value, strongly prefer to replace the boolean with enumeration of named values or statuses - for example *acceptedTermsAndConditions* with true or false can be replaced with *termsAndConditions* with values `yes`, `no` and `unknown`.

###  Use same semantics for `null` and absent properties

Open API 3.x allows to mark properties as `required` and as `nullable` to specify whether properties may be absent (`{}`) or `null` (`{"example":null}`). If a property is defined to be not `required` and `nullable` (see 2nd row in Table below), this rule demands that both cases must be handled in the exact same manner by specification.

The following table shows all combinations and whether the examples are valid:

<table><colgroup><col style="width: 25%" /><col style="width: 25%" /><col style="width: 25%" /><col style="width: 25%" /></colgroup><thead><tr class="header"><th>{CODE-START}required{CODE-END}</th><th>{CODE-START}nullable{CODE-END}</th><th>{CODE-START}{}{CODE-END}</th><th>{CODE-START}{"example":null}{CODE-END}</th></tr></thead><tbody><tr class="odd"><td><p><code>true</code></p></td><td><p><code>true</code></p></td><td><p>{NO}</p></td><td><p>{YES}</p></td></tr><tr class="even"><td><p><code>false</code></p></td><td><p><code>true</code></p></td><td><p>{YES}</p></td><td><p>{YES}</p></td></tr><tr class="odd"><td><p><code>true</code></p></td><td><p><code>false</code></p></td><td><p>{NO}</p></td><td><p>{NO}</p></td></tr><tr class="even"><td><p><code>false</code></p></td><td><p><code>false</code></p></td><td><p>{YES}</p></td><td><p>{NO}</p></td></tr></tbody></table>

While API designers and implementers may be tempted to assign different semantics to both cases, we explicitly decide **against** that option, because we think that any gain in expressiveness is far outweighed by the risk of clients not understanding and implementing the subtle differences incorrectly.

As an example, an API that provides the ability for different users to coordinate on a time schedule, e.g. a meeting, may have a resource for options in which every user has to make a `choice`. The difference between *undecided* and *decided against any of the options* could be modeled as *absent* and `null` respectively. It would be safer to express the `null` case with a dedicated [Null object](https://en.wikipedia.org/wiki/Null_object_pattern), e.g. `{}` compared to `{"id":"42"}`.

Moreover, many major libraries have somewhere between little to no support for a `null`/absent pattern (see [Gson](https://stackoverflow.com/questions/48465005/gson-distinguish-null-value-field-and-missing-field), [Moshi](https://github.com/square/moshi#borrows-from-gson), [Jackson](https://github.com/FasterXML/jackson-databind/issues/578), [JSON-B](https://developer.ibm.com/articles/j-javaee8-json-binding-3/)). Especially strongly-typed languages suffer from this since a new composite type is required to express the third state. Nullable `Option`/`Optional`/`Maybe` types could be used but having nullable references of these types completely contradicts their purpose.

The only exception to this rule is JSON Merge Patch [RFC 7396](https://tools.ietf.org/html/rfc7396)) which uses `null` to explicitly indicate property deletion while absent properties are ignored, i.e. not modified.

### Empty array values should not be null

Empty array values can unambiguously be represented as the empty list, `[]`.

### Enumerations should be represented as Strings

Strings are a reasonable target for values that are by design enumerations.

### Name date/time properties using the `At` suffix

Dates and date-time properties should end with `At` to distinguish them from boolean properties which otherwise would have very similar or even identical names:

-   `createdAt` rather than `created`
-   `modifiedAt` rather than `modified`
-   `occurredAt` rather than `occurred`
-   `returnedAt` rather than `returned`

### Date property values should conform to RFC 3339

Use the date and time formats defined by [RFC 3339](https://tools.ietf.org/html/rfc3339#section-5.6):

-   for "date" use strings matching `date-fullyear "-" date-month "-" date-mday`, for example: `2015-05-28`
-   for "date-time" use strings matching `full-date "T" full-time`, for example `2015-05-28T14:07:17Z`

Note that the [OpenAPI format](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md#data-types) "date-time" corresponds to "date-time" in the RFC) and `2015-05-28` for a date (note that the OpenAPI format "date" corresponds to "full-date" in the RFC). Both are specific profiles, a subset of the international standard ISO 8601.

A zone offset may be used (both, in request and responses) — this is simply defined by the standards. However, we encourage restricting dates to UTC and without offsets. For example `2015-05-28T14:07:17Z` rather than `2015-05-28T14:07:17+00:00`. From experience we have learned that zone offsets are not easy to understand and often not correctly handled. Note also that zone offsets are different from local times that might be including daylight saving time. Localization of dates should be done by the services that provide user interfaces, if required.

When it comes to storage, all dates should be consistently stored in UTC without a zone offset. Localization should be done locally by the services that provide user interfaces, if required.

Sometimes it can seem data is naturally represented using numerical timestamps, but this can introduce interpretation issues with precision - for example whether to represent a timestamp as 1460062925, 1460062925000 or 1460062925.000. Date strings, though more verbose and requiring more effort to parse, avoid this ambiguity.

###  Time durations and intervals could conform to ISO 8601

Schema based JSON properties that are by design durations and intervals could be strings formatted as recommended by ISO 8601 ([Appendix A of RFC 3339 contains a grammar](https://tools.ietf.org/html/rfc3339#appendix-A) for durations).

## Pagination

Consider to introduce pagination as soon as you provide search functionality on your API with more than some few dozens of possible records.

### Support Pagination

Access to lists of data items must support pagination to protect the service against overload as well as for best client side iteration and batch processing experience. This holds true for all lists that are (potentially) larger than just a few hundred entries.

There are two well known page iteration techniques:

-   [Offset/Limit-based pagination](https://developer.infoconnect.com/paging-results): numeric offset identifies the first page entry
-   [Cursor/Limit-based](https://dev.twitter.com/overview/api/cursoring) — aka key-based — pagination: a unique key element identifies the first page entry (see also [Facebook’s guide](https://developers.facebook.com/docs/graph-api/using-graph-api/v2.4#paging))

The technical conception of pagination should also consider user experience related issues. As mentioned in this [article](https://www.smashingmagazine.com/2016/03/pagination-infinite-scrolling-load-more-buttons/), jumping to a specific page is far less used than navigation via {next}/{prev} page links. This favours cursor-based over offset-based pagination.

### Prefer Cursor-Based Pagination, Avoid Offset-Based Pagination

Cursor-based pagination is usually better and more efficient when compared to offset-based pagination. Especially when it comes to high-data volumes and/or storage in NoSQL databases.

Before choosing cursor-based pagination, consider the following trade-offs:

-   Usability/framework support:
    -   Offset-based pagination is more widely known than cursor-based pagination, so it has more framework support and is easier to use for API clients
-   Use case - jump to a certain page:
    -   If jumping to a particular page in a range (e.g., 51 of 100) is really a required use case, cursor-based navigation is not feasible.
-   Data changes may lead to anomalies in result pages:
    -   Offset-based pagination may create duplicates or lead to missing entries if rows are inserted or deleted between two subsequent paging requests.
    -   If implemented incorrectly, cursor-based pagination may fail when the cursor entry has been deleted before fetching the pages.
-   Performance considerations - efficient server-side processing using offset-based pagination is hardly feasible for:
    -   Very big data sets, especially if they cannot reside in the main memory of the database.
    -   Sharded or NoSQL databases.
-   Cursor-based navigation may not work if you need the total count of results.

The {cursor} used for pagination is an opaque pointer to a page, that must never be **inspected** or **constructed** by clients. It usually encodes (encrypts) the page position, i.e. the identifier of the first or last page element, the pagination direction, and the applied query filters - or a hash over these - to safely recreate the collection. The {cursor} may be defined as follows:

    Cursor:
      type: object
      properties:
        position:
          description: >
            Object containing the identifier(s) pointing to the entity that is
            defining the collection resource page - normally the position is
            represented by the first or the last page element.
          type: object
          properties: ...

        direction:
          description: >
            The pagination direction that is defining which elements to choose
            from the collection resource starting from the page position.
          type: string
          enum: [ ASC, DESC ]

        query:
          description: >
            Object containing the query filters applied to create the collection
            resource that is represented by this cursor.
          type: object
          properties: ...

        queryHash:
          description: >
            Stable hash calculated over all query filters applied to create the
            collection resource that is represented by this cursor.
          type: string

      required:
        - position
        - direction

The page information for cursor-based pagination should consist of a {cursor} set, that besides {next} may provide support for {prev}, {first}, {last}, and {self} as follows:

    {
      "cursors": {
        "self": "...",
        "first": "...",
        "prev": "...",
        "next": "...",
        "last": "..."
      },
      "items": [... ]
    }

Further reading:

-   [Twitter](https://dev.twitter.com/rest/public/timelines)
-   [Use the Index, Luke](http://use-the-index-luke.com/no-offset)
-   [Paging in PostgreSQL](https://www.citusdata.com/blog/1872-joe-nelson/409-five-ways-paginate-postgres-basic-exotic)

### Use Pagination Links Where Applicable

To simplify client design, APIs should support simplified hypertext controls for pagination over collections whenever applicable. Beside {next} this may comprise the support for {prev}, {first}, {last}, and {self} as {link-relations}\[link relations\].

The page content is transported via {items}, while the {query} object may contain the query filters applied to the collection resource as follows:

    {
      "self": "http://..../resources?cursor=<self-position>",
      "first": "http://my-api.api.sbb.ch/resources?cursor=<first-position>",
      "prev": "http://my-api.api.sbb.ch/resources?cursor=<previous-position>",
      "next": "http://my-api.api.sbb.ch/resources?cursor=<next-position>",
      "last": "http://my-api.api.sbb.ch/resources?cursor=<last-position>",
      "query": {
        "query-param-<1>": ...,
        "query-param-<n>": ...
      },
      "items": [...]
    }

**Note:** In case of complex search requests, e.g. when {GET-with-body} is required, the {cursor} may not be able to encode all query filters. In this case, it is best practice to encode only page position and direction in the {cursor} and transport the query filter in the body - in the request as well as in the response. To protect the pagination sequence, in this case it is recommended, that the {cursor} contains a hash over all applied query filters for pagination request validation.

**Remark:** You should avoid providing a total count unless there is a clear need to do so. Very often, there are significant system and performance implications when supporting full counts. Especially, if the data set grows and requests become complex queries and filters drive full scans. While this is an implementation detail relative to the API, it is important to consider the ability to support serving counts over the life of a service.

## Performance

### Reduce Bandwidth Needs and Improve Responsiveness

APIs should support techniques for reducing bandwidth based on client needs. This holds for APIs that (might) have high payloads and/or are used in high-traffic scenarios like the public Internet and telecommunication networks. Typical examples are APIs used by mobile web app clients with (often) less bandwidth connectivity.

Common techniques include:

-   compression of request and response bodies (e.g. gZip)
-   querying field filters to retrieve a subset of resource attributes
-   {ETag} and {If-Match}/{If-None-Match} headers to avoid re-fetching of unchanged resources
-   {Prefer} header with `return=minimal` or `respond-async` to anticipate reduced processing requirements of clients
-   Pagination for incremental access of larger collections of data items
-   Caching of master data items, i.e. resources that change rarely or not at all after creation

Keep in mind that performance features must always well documented in the API documentation (e.g. if you use caching).

## Security

### Use "OWASP Secure Coding Practice"

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



### Define and Assign Permissions (Scopes)

APIs must define permissions to protect their resources. Thus, at least one permission must be assigned to each endpoint. Permissions are defined as shown in the previous section.

The naming schema for permissions corresponds to the naming schema for hostnames and event type names.

APIs should stick to component specific permissions without resource extension to avoid governance complexity of too many fine grained permissions. For the majority of use cases, restricting access to specific API endpoints using read and write is sufficient for controlling access for client types like merchant or retailer business partners, customers or operational staff. However, in some situations, where the API serves different types of resources for different owners, resource specific scopes may make sense.

After permission names are defined and the permission is declared in the security definition at the top of an API specification, it should be assigned to each API operation by specifying a [security requirement](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md#securityRequirementObject) like this:

    paths:
     /business-partners/{partner-id}:
        get:
          summary: Retrieves information about a business partner
          security:
            - oauth2:
              - business-partner.read


Hint: you need not explicitly define the "Authorization" header; it is a standard header so to say implicitly defined via the security section.

### Follow Naming Convention for Permissions (Scopes)

As long as the functional naming is not supported for permissions, permission names in APIs must conform to the following naming pattern:

    <permission> ::= <standard-permission> |  -- should be sufficient for majority of use cases
                     <resource-permission> |  -- for special security access differentiation use cases

    <standard-permission> ::= <application-id>.<access-mode>
    <resource-permission> ::= <application-id>.<resource-name>.<access-mode>

    <application-id>      ::= [a-z][a-z0-9-]*  -- application identifier
    <resource-name>       ::= [a-z][a-z0-9-]*  -- free resource identifier
    <access-mode>         ::= read | write    -- might be extended in future

## Resources

### Avoid Actions — Think About Resources

REST is all about your resources, so consider the domain entities that take part in web service interaction, and aim to model your API around these using the standard HTTP methods as operation indicators. For instance, if an application has to lock articles explicitly so that only one user may edit them, create an article lock with {PUT} or {POST} instead of using a lock action.

Request:

    PUT /article-locks/{article-id}

The added benefit is that you already have a service for browsing and filtering article locks.

### Model complete business processes

An API should contain the complete business processes containing all resources representing the process. This enables clients to understand the business process, foster a consistent design of the business process, allow for synergies from description and implementation perspective, and eliminates implicit invisible dependencies between APIs.

In addition, it prevents services from being designed as thin wrappers around databases, which normally tends to shift business logic to the clients.

### Define *useful* resources

As a rule of thumb resources should be defined to cover 90% of all its client’s use cases. A *useful* resource should contain as much information as necessary, but as little as possible. A great way to support the last 10% is to allow clients to specify their needs for more/less information by supporting filtering and embedding.

### Keep URLs Verb-Free

The API describes resources, so the only place where actions should appear is in the HTTP methods. In URLs, use only nouns. Instead of thinking of actions (verbs), it’s often helpful to think about putting a message in a letter box: e.g., instead of having the verb *cancel* in the url, think of sending a message to cancel an order to the *cancellations* letter box on the server side.

### Use Domain-Specific Resource Names

API resources represent elements of the application’s domain model. Using domain-specific nomenclature for resource names helps developers to understand the functionality and basic semantics of your resources. It also reduces the need for further documentation outside the API definition. For example, "sales-order-items" is superior to "order-items" in that it clearly indicates which business object it represents. Along these lines, "items" is too general.

### Identify resources and Sub-Resources via Path Segments

Some API resources may contain or reference sub-resources. Embedded sub-resources, which are not top-level resources, are parts of a higher-level resource and cannot be used outside of its scope. Sub-resources should be referenced by their name and identifier in the path segments.

Composite identifiers must not contain `/` as a separator. In order to improve the consumer experience, you should aim for intuitively understandable URLs, where each sub-path is a valid reference to a resource or a set of resources. For example, if `/customers/12ev123bv12v/addresses/DE_100100101` is a valid path of your API, then `/customers/12ev123bv12v/addresses`, `/customers/12ev123bv12v` and `/customers` must be valid as well in principle.

Basic URL structure:

    /{resources}/[resource-id]/{sub-resources}/[sub-resource-id]
    /{resources}/[partial-id-1][separator][partial-id-2]

Examples:

    /carts/1681e6b88ec1/items
    /carts/1681e6b88ec1/items/1
    /customers/12ev123bv12v/addresses/DE_100100101
    /content/images/9cacb4d8


### Consider Using (Non-) Nested URLs

If a sub-resource is only accessible via its parent resource and may not exists without parent resource, consider using a nested URL structure, for instance:

    /carts/1681e6b88ec1/cart-items/1

However, if the resource can be accessed directly via its unique id, then the API should expose it as a top-level resource. For example, customer has a collection for sales orders; however, sales orders have globally unique id and some services may choose to access the orders directly, for instance:

    /customers/1681e6b88ec1
    /sales-orders/5273gh3k525a

### Limit number of Resource types

To keep maintenance and service evolution manageable, we should follow "functional segmentation" and "separation of concern" design principles and do not mix different business functionalities in same API definition. In practice this means that the number of resource types exposed via an API should be limited. In this context a resource type is defined as a set of highly related resources such as a collection, its members and any direct sub-resources.

For example, the resources below would be counted as three resource types, one for customers, one for the addresses, and one for the customers' related addresses:

    /customers
    /customers/{id}
    /customers/{id}/preferences
    /customers/{id}/addresses
    /customers/{id}/addresses/{addr}
    /addresses
    /addresses/{addr}

Note that:

-   We consider `/customers/{id}/preferences` part of the `/customers` resource type because it has a one-to-one relation to the customer without an additional identifier.
-   We consider `/customers` and `/customers/{id}/addresses` as separate resource types because `/customers/{id}/addresses/{addr}` also exists with an additional identifier for the address.
-   We consider `/addresses` and `/customers/{id}/addresses` as separate resource types because there’s no reliable way to be sure they are the same.

Given this definition, our experience is that well defined APIs involve no more than 4 to 8 resource types. There may be exceptions with more complex business domains that require more resources, but you should first check if you can split them into separate subdomains with distinct APIs.

Nevertheless one API should hold all necessary resources to model complete business processes helping clients to understand these flows.

### Limit number of Sub-Resource Levels

There are main resources (with root url paths) and sub-resources (or *nested* resources with non-root urls paths). Use sub-resources if their life cycle is (loosely) coupled to the main resource, i.e. the main resource works as collection resource of the subresource entities. You should use <= 3 sub-resource (nesting) levels — more levels increase API complexity and url path length. (Remember, some popular web browsers do not support URLs of more than 2000 characters.)

## HTTP Requests

For the definition of how to use http methods, see the principle [Must use HTTP methods correctly](/api-principles/restful/principles#must-use-http-methods-correctly).

### Fulfill Common Method Properties

Request methods in RESTful services can be…​

-   {RFC-safe} - the operation semantic is defined to be read-only, meaning it must not have *intended side effects*, i.e. changes, to the server state.
-   {RFC-idempotent} - the operation has the same *intended effect* on the server state, independently whether it is executed once or multiple times. **Note:** this does not require that the operation is returning the same response or status code.
-   {RFC-cacheable} - to indicate that responses are allowed to be stored for future reuse. In general, requests to safe methods are cachable, if it does not require a current or authoritative response from the server.

**Note:** The above definitions, of *intended (side) effect* allows the server to provide additional state changing behavior as logging, accounting, pre- fetching, etc. However, these actual effects and state changes, must not be intended by the operation so that it can be held accountable.

Method implementations must fulfill the following basic properties according to [RFC 7231](https://tools.ietf.org/html/rfc7231):

<table style="width:100%;"><colgroup><col style="width: 15%" /><col style="width: 15%" /><col style="width: 35%" /><col style="width: 35%" /></colgroup><thead><tr class="header"><th>Method</th><th>Safe</th><th>Idempotent</th><th>Cacheable</th></tr></thead><tbody><tr class="odd"><td><p>{GET}</p></td><td><p>{YES}</p></td><td><p>{YES}</p></td><td><p>{YES}</p></td></tr><tr class="even"><td><p>{HEAD}</p></td><td><p>{YES}</p></td><td><p>{YES}</p></td><td><p>{YES}</p></td></tr><tr class="odd"><td><p>{POST}</p></td><td><p>{NO}</p></td><td><p>{AT} No, but consider idempotency</p></td><td><p>{AT} May, but only if specific {POST} endpoint is safe. <strong>Hint:</strong> not supported by most caches.</p></td></tr><tr class="even"><td><p>{PUT}</p></td><td><p>{NO}</p></td><td><p>{YES}</p></td><td><p>{NO}</p></td></tr><tr class="odd"><td><p>{PATCH}</p></td><td><p>{NO}</p></td><td><p>{AT} No, but consider idempontency</p></td><td><p>{NO}</p></td></tr><tr class="even"><td><p>{DELETE}</p></td><td><p>{NO}</p></td><td><p>{YES}</p></td><td><p>{NO}</p></td></tr><tr class="odd"><td><p>{OPTIONS}</p></td><td><p>{YES}</p></td><td><p>{YES}</p></td><td><p>{NO}</p></td></tr><tr class="even"><td><p>{TRACE}</p></td><td><p>{YES}</p></td><td><p>{YES}</p></td><td><p>{NO}</p></td></tr></tbody></table>

### Consider To Design `POST` and `PATCH` Idempotent

In many cases it is helpful or even necessary to design {POST} and {PATCH} idempotent for clients to expose conflicts and prevent resource duplicate (a.k.a. zombie resources) or lost updates, e.g. if same resources may be created or changed in parallel or multiple times. To design an idempotent API endpoint owners should consider to apply one of the following three patterns.

-   A resource specific **conditional key** provided via `If-Match` header in the request. The key is in general a meta information of the resource, e.g. a *hash* or *version number*, often stored with it. It allows to detect concurrent creations and updates to ensure idempotent behavior.
-   A resource specific **secondary key** provided as resource property in the request body. The *secondary key* is stored permanently in the resource. It allows to ensure idempotent behavior by looking up the unique secondary key in case of multiple independent resource creations from different clients (use Secondary Key for Idempotent Design).
-   A client specific **idempotency key** provided via {Idempotency-Key} header in the request. The key is not part of the resource but stored temporarily pointing to the original response to ensure idempotent behavior when retrying a request.

**Note:** While **conditional key** and **secondary key** are focused on handling concurrent requests, the **idempotency key** is focused on providing the exact same responses, which is even a *stronger* requirement than the idempotency defined above. It can be combined with the two other patterns.

To decide, which pattern is suitable for your use case, please consult the following table showing the major properties of each pattern:

<table><colgroup><col style="width: 46%" /><col style="width: 18%" /><col style="width: 18%" /><col style="width: 18%" /></colgroup><thead><tr class="header"><th></th><th>Conditional Key</th><th>Secondary Key</th><th>Idempotency Key</th></tr></thead><tbody><tr class="odd"><td><p>Applicable with</p></td><td><p>{PATCH}</p></td><td><p>{POST}</p></td><td><p>{POST}/{PATCH}</p></td></tr><tr class="even"><td><p>HTTP Standard</p></td><td><p>{YES}</p></td><td><p>{NO}</p></td><td><p>{NO}</p></td></tr><tr class="odd"><td><p>Prevents duplicate (zombie) resources</p></td><td><p>{YES}</p></td><td><p>{YES}</p></td><td><p>{NO}</p></td></tr><tr class="even"><td><p>Prevents concurrent lost updates</p></td><td><p>{YES}</p></td><td><p>{NO}</p></td><td><p>{NO}</p></td></tr><tr class="odd"><td><p>Supports safe retries</p></td><td><p>{YES}</p></td><td><p>{YES}</p></td><td><p>{YES}</p></td></tr><tr class="even"><td><p>Supports exact same response</p></td><td><p>{NO}</p></td><td><p>{NO}</p></td><td><p>{YES}</p></td></tr><tr class="odd"><td><p>Can be inspected (by intermediaries)</p></td><td><p>{YES}</p></td><td><p>{NO}</p></td><td><p>{YES}</p></td></tr><tr class="even"><td><p>Usable without previous {GET}</p></td><td><p>{NO}</p></td><td><p>{YES}</p></td><td><p>{YES}</p></td></tr></tbody></table>

**Note:** The patterns applicable to {PATCH} can be applied in the same way to {PUT} and {DELETE} providing the same properties.

If you mainly aim to support safe retries, we suggest to apply conditional key secondary key pattern before the Idempotency Key pattern.

### Use Secondary Key for Idempotent `POST` Design

The most important pattern to design {POST} idempotent for creation is to introduce a resource specific **secondary key** provided in the request body, to eliminate the problem of duplicate (a.k.a zombie) resources.

The secondary key is stored permanently in the resource as *alternate key* or *combined key* (if consisting of multiple properties) guarded by a uniqueness constraint enforced server-side, that is visible when reading the resource. The best and often naturally existing candidate is a *unique foreign key*, that points to another resource having *one-on-one* relationship with the newly created resource, e.g. a parent process identifier.

A good example here for a secondary key is the shopping cart ID in an order resource.

**Note:** When using the secondary key pattern without {Idempotency-Key} all subsequent retries should fail with status code {409} (conflict). We suggest to avoid {200} here unless you make sure, that the delivered resource is the original one implementing a well defined behavior. Using {204} without content would be a similar well defined option.

### Define Collection Format of Header and Query Parameters

Header and query parameters allow to provide a collection of values, either by providing a comma-separated list of values or by repeating the parameter multiple times with different values as follows:

<table><colgroup><col style="width: 14%" /><col style="width: 30%" /><col style="width: 39%" /><col style="width: 17%" /></colgroup><thead><tr class="header"><th>Parameter Type</th><th>Comma-separated Values</th><th>Multiple Parameters</th><th>Standard</th></tr></thead><tbody><tr class="odd"><td><p>Header</p></td><td><p><code>Header: value1,value2</code></p></td><td><p><code>Header: value1, Header: value2</code></p></td><td><p><a href="https://tools.ietf.org/html/rfc7230#section-3.2.2">RFC-7230#section-3.2.2</a></p></td></tr><tr class="even"><td><p>Query</p></td><td><p><code>?param=value1,value2</code></p></td><td><p><code>?param=value1&amp;param=value2</code></p></td><td><p><a href="https://tools.ietf.org/html/rfc6570#section-3.2.8">RFC-6570#section-3.2.8</a></p></td></tr></tbody></table>

As Open API does not support both schemas at once, an API specification must explicitly define the collection format to guide consumers as follows:

<table><colgroup><col style="width: 14%" /><col style="width: 40%" /><col style="width: 46%" /></colgroup><thead><tr class="header"><th>Parameter Type</th><th>Comma-separated Values</th><th>Multiple Parameters</th></tr></thead><tbody><tr class="odd"><td><p>Header</p></td><td><p><code>style: simple, explode: false</code></p></td><td><p>not allowed (see <a href="https://tools.ietf.org/html/rfc7230#section-3.2.2">RFC-7230#section-3.2.2</a>)</p></td></tr><tr class="even"><td><p>Query</p></td><td><p><code>style: form, explode: false</code></p></td><td><p><code>style: form, explode: true</code></p></td></tr></tbody></table>

When choosing the collection format, take into account the tool support, the escaping of special characters and the maximal URL length.

### Document Implicit Filtering

Sometimes certain collection resources or queries will not list all the possible elements they have, but only those for which the current client is authorized to access.

Implicit filtering could be done on:

-   the collection of resources being return on a parent {GET} request
-   the fields returned for the resource’s detail

In such cases, the implicit filtering must be in the API specification (in its description).

Consider caching considerations when implicitely filtering.

Example:

If an employee of the company *Foo* accesses one of our business-to-business service and performs a `{GET} /business-partners`, it must, for legal reasons, not display any other business partner that is not owned or contractually managed by her/his company. It should never see that we are doing business also with company *Bar*.

Response as seen from a consumer working at `FOO`:

    {
        "items": [
            { "name": "Foo Performance" },
            { "name": "Foo Sport" },
            { "name": "Foo Signature" }
        ]
    }

Response as seen from a consumer working at `BAR`:

    {
        "items": [
            { "name": "Bar Classics" },
            { "name": "Bar pour Elle" }
        ]
    }

The API Specification should then specify something like this:

    paths:
      /business-partner:
        get:
          description: >-
            Get the list of registered business partner.
            Only the business partners to which you have access to are returned.

## Error handling & status codes

### Specify Success and Error Responses

APIs should define the functional, business view and abstract from implementation aspects. Success and error responses are a vital part to define how an API is used correctly.

Therefore, you must define **all** success and service specific error responses in your API specification. Both are part of the interface definition and provide important information for service clients to handle standard as well as exceptional situations.

**Hint:** In most cases it is not useful to document all technical errors, especially if they are not under control of the service provider. Thus unless a response code conveys application-specific functional semantics or is used in a none standard way that requires additional explanation, multiple error response specifications can be combined using the following pattern:

    responses:
      ...
      default:
        description: error occurred - see status code and problem object for more information.

API designers should also think about a **troubleshooting board** as part of the associated online API documentation. It provides information and handling guidance on application-specific errors and is referenced via links from the API specification. This can reduce service support tasks and contribute to service client and provider performance.

### Use Most Specific HTTP Status Codes

You must use the most specific HTTP status code when returning information about your request processing status or error situations.

### Use Code 207 for Batch or Bulk Requests

Some APIs are required to provide either *batch* or *bulk* requests using {POST} for performance reasons, i.e. for communication and processing efficiency. In this case services may be in need to signal multiple response codes for each part of an batch or bulk request. As HTTP does not provide proper guidance for handling batch/bulk requests and responses, we herewith define the following approach:

-   A batch or bulk request **always** has to respond with HTTP status code {207}, unless it encounters a generic or unexpected failure before looking at individual parts.
-   A batch or bulk response with status code {207} **always** returns a multi-status object containing sufficient status and/or monitoring information for each part of the batch or bulk request.
-   A batch or bulk request may result in a status code {4xx}/{5xx}, only if the service encounters a failure before looking at individual parts or, if an unanticipated failure occurs.

The before rules apply *even in the case* that processing of all individual part *fail* or each part is executed *asynchronously*! They are intended to allow clients to act on batch and bulk responses by inspecting the individual results in a consistent way.

**Note**: while a *batch* defines a collection of requests triggering independent processes, a *bulk* defines a collection of independent resources created or updated together in one request. With respect to response processing this distinction normally does not matter.

### Use Code 429 with Headers for Rate Limits

APIs that wish to manage the request rate of clients must use the {429} (Too Many Requests) response code, if the client exceeded the request rate (see [RFC 6585](https://tools.ietf.org/html/rfc6585)). Such responses must also contain header information providing further details to the client. There are two approaches a service can take for header information:

-   Return a {Retry-After} header indicating how long the client ought to wait before making a follow-up request. The Retry-After header can contain a HTTP date value to retry after or the number of seconds to delay. Either is acceptable but APIs should prefer to use a delay in seconds.
-   Return a trio of `X-RateLimit` headers. These headers (described below) allow a server to express a service level in the form of a number of allowing requests within a given window of time and when the window is reset.

The `X-RateLimit` headers are:

-   `X-RateLimit-Limit`: The maximum number of requests that the client is allowed to make in this window.
-   `X-RateLimit-Remaining`: The number of requests allowed in the current window.
-   `X-RateLimit-Reset`: The relative time in seconds when the rate limit window will be reset. **Beware** that this is different to Github and Twitter’s usage of a header with the same name which is using UTC epoch seconds instead.

The reason to allow both approaches is that APIs can have different needs. Retry-After is often sufficient for general load handling and request throttling scenarios and notably, does not strictly require the concept of a calling entity such as a tenant or named account. In turn this allows resource owners to minimise the amount of state they have to carry with respect to client requests. The 'X-RateLimit' headers are suitable for scenarios where clients are associated with pre-existing account or tenancy structures. 'X-RateLimit' headers are generally returned on every request and not just on a 429, which implies the service implementing the API is carrying sufficient state to track the number of requests made within a given window for each named entity.

### Use Problem JSON

{RFC-7807}\[RFC 7807\] defines a Problem JSON object and the media type `application/problem+json`. Operations should return it (together with a suitable status code) when any problem occurred during processing and you can give more details than the status code itself can supply, whether it be caused by the client or the server (i.e. both for {4xx} or {5xx} error codes).

The Open API schema definition of the Problem JSON object can be found [on github](https://zalando.github.io/problem/schema.yaml). You can reference it by using:

    responses:
      503:
        description: Service Unavailable
        content:
          "application/problem+json":
            schema:
              $ref: 'https://opensource.zalando.com/problem/schema.yaml#/Problem'

You may define custom problem types as extension of the Problem JSON object if your API need to return specific additional error detail information.

**Hint** for backward compatibility: A previous version of this guideline (before the publication of [RFC-7807](https://tools.ietf.org/html/rfc7807) and the registration of the media type) told to return custom variant of the media type `application/x.problem+json`. Servers for APIs defined before this change should pay attention to the `Accept` header sent by the client and set the `Content-Type` header of the problem response correspondingly. Clients of such APIs should accept both media types.

### Do not expose Stack Traces

Stack traces contain implementation details that are not part of an API, and on which clients should never rely. Moreover, stack traces can leak sensitive information that partners and third parties are not allowed to receive and may disclose insights about vulnerabilities to attackers.
