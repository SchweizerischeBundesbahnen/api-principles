---
layout: default
title: Best Practices
parent: Synchronous-API Design
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

## General Principles

### Follow API First Principle

You should follow the API First Principle, more specifically:

-   You should design APIs first, before coding its implementation.
-   You should design your APIs consistently with these guidelines.
-   You should call for early review feedback from peers and client developers. Also consider to apply for a lightweight review by the API Team.

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

-   {Content-Location} indicates where the body can be found otherwise ([{MAY} Use Header](#179) for more details\]).

-   {Content-Range} is used in responses to range requests to indicate which part of the requested resource representation is delivered with the body.

-   {Content-Type} indicates the media type of the body content.

### Use Standardized Headers

Use [this list](http://en.wikipedia.org/wiki/List_of_HTTP_header_fields) and mention its support in your OpenAPI definition.

### Consider to Support `ETag` Together With `If-Match`/`If-None-Match` Header

When creating or updating resources it may be necessary to expose conflicts and to prevent the 'lost update' or 'initially created' problem. Following {RFC-7232}\[RFC 7232 "HTTP: Conditional Requests"\] this can be best accomplished by supporting the {ETag} header together with the {If-Match} or {If-None-Match} conditional header. The contents of an `ETag: <entity-tag>` header is either (a) a hash of the response body, (b) a hash of the last modified field of the entity, or (c) a version number or identifier of the entity version.

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

Please see [???](#optimistic-locking) for a detailed discussion and options.

### Consider to Support `Idempotency-Key` Header

When creating or updating resources it can be helpful or necessary to ensure a strong [???](#idempotent) behavior comprising same responses, to prevent duplicate execution in case of retries after timeout and network outages. Generally, this can be achieved by sending a client specific *unique request key* – that is not part of the resource – via {Idempotency-Key} header.

The *unique request key* is stored temporarily, e.g. for 24 hours, together with the response and the request hash (optionally) of the first request in a key cache, regardless of whether it succeeded or failed. The service can now look up the *unique request key* in the key cache and serve the response from the key cache, instead of re-executing the request, to ensure [???](#idempotent) behavior. Optionally, it can check the request hash for consistency before serving the response. If the key is not in the key store, the request is executed as usual and the response is stored in the key cache.

This allows clients to safely retry requests after timeouts, network outages, etc. while receive the same response multiple times. **Note:** The request retry in this context requires to send the exact same request, i.e. updates of the request that would change the result are off-limits. The request hash in the key cache can protection against this misbehavior. The service is recommended to reject such a request using status code {400}.

**Important:** To grant a reliable [???](#idempotent) execution semantic, the resource and the key cache have to be updated with hard transaction semantics – considering all potential pitfalls of failures, timeouts, and concurrent requests in a distributed systems. This makes a correct implementation exceeding the local context very hard.

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

**Note:** The {Idempotency-Key} header unlike other headers in this section is not standardized in an RFC. Our only reference are the usage in the [Stripe API](https://stripe.com/docs/api/idempotent_requests). However, as it fit not into our section about [???](#proprietary-headers), and we did not want to change the header name and semantic, we decided to treat it as any other common header.

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

During the deprecation timespan the responses of the deprected API SHOULD have a `Warning` header accoring to [RFC 7234](https://tools.ietf.org/html/rfc7234#section-5.5) with code 299 and text: "This API call is deprecated and will be removed. Refer release notes for details.

Alternatively we also use `X-API-Deprecation` Header with the upcoming deletion date as its value.

### Design APIs Conservatively

Designers of service provider APIs should be conservative and accurate in what they accept from clients:

-   Unknown input fields in payload or URL should not be ignored; servers should provide error feedback to clients via an HTTP 400 response code.

-   Be accurate in defining input data constraints (like formats, ranges, lengths etc.) — and check constraints and return dedicated error information in case of violations.

-   Prefer being more specific and restrictive (if compliant to functional requirements), e.g. by defining length range of strings. It may simplify implementation while providing freedom for further evolution as compatible extensions.

Not ignoring unknown input fields is a specific deviation from Postel’s Law (e.g. see also  
[The Robustness Principle Reconsidered](https://cacm.acm.org/magazines/2011/8/114933-the-robustness-principle-reconsidered/fulltext)) and a strong recommendation. Servers might want to take different approach but should be aware of the following problems and be explicit in what is supported:

-   Ignoring unknown input fields is actually not an option for {PUT}, since it becomes asymmetric with subsequent {GET} response and HTTP is clear about the {PUT} *replace* semantics and default roundtrip expectations (see {RFC-7231}\#section-4.3.4\[RFC 7231 Section 4.3.4\]). Note, accepting (i.e. not ignoring) unknown input fields and returning it in subsequent {GET} responses is a different situation and compliant to {PUT} semantics.

-   Certain client errors cannot be recognized by servers, e.g. attribute name typing errors will be ignored without server error feedback. The server cannot differentiate between the client intentionally providing an additional field versus the client sending a mistakenly named field, when the client’s actual intent was to provide an optional input field.

-   Future extensions of the input data structure might be in conflict with already ignored fields and, hence, will not be compatible, i.e. break clients that already use this field but with different type.

In specific situations, where a (known) input field is not needed anymore, it either can stay in the API definition with "not used anymore" description or can be removed from the API definition as long as the server ignores this specific parameter.

### Always Return JSON Objects As Top-Level Data Structures To Support Extensibility

In a response body, you must always return a JSON object (and not e.g. an array) as a top level data structure to support future extensibility. JSON objects support compatible extension by additional attributes. This allows you to easily extend your response and e.g. add pagination later, without breaking backwards compatibility.

Maps (see [???](#216)), even though technically objects, are also forbidden as top level data structures, since they don’t support compatible, future extensions.

### Treat Open API Definitions As Open For Extension By Default

The Open API 2.0 specification is not very specific on default extensibility of objects, and redefines JSON-Schema keywords related to extensibility, like `additionalProperties`. Following our overall compatibility guidelines, Open API object definitions are considered open for extension by default as per [Section 5.18 "additionalProperties"](http://json-schema.org/latest/json-schema-validation.html#rfc.section.5.18) of JSON-Schema.

When it comes to Open API 2.0, this means an `additionalProperties` declaration is not required to make an object definition extensible:

-   API clients consuming data must not assume that objects are closed for extension in the absence of an `additionalProperties` declaration and must ignore fields sent by the server they cannot process. This allows API servers to evolve their data formats.

-   For API servers receiving unexpected data, the situation is slightly different. Instead of ignoring fields, servers *may* reject requests whose entities contain undefined fields in order to signal to clients that those fields would not be stored on behalf of the client. API designers must document clearly how unexpected fields are handled for {PUT}, {POST}, and {PATCH} requests.

API formats must not declare `additionalProperties` to be false, as this prevents objects being extended in the future.

Note that this guideline concentrates on default extensibility and does not exclude the use of `additionalProperties` with a schema as a value, which might be appropriate in some circumstances, e.g. see [???](#216).

### Use Open-Ended List of Values (`x-extensible-enum`) Instead of Enumerations

Enumerations are per definition closed sets of values, that are assumed to be complete and not intended for extension. This closed principle of enumerations imposes compatibility issues when an enumeration must be extended. To avoid these issues, we strongly recommend to use an open-ended list of values instead of an enumeration unless:

1.  the API has full control of the enumeration values, i.e. the list of values does not depend on any external tool or interface, and

2.  the list of value is complete with respect to any thinkable and unthinkable future feature.

To specify an open-ended list of values use the marker {x-extensible-enum} as follows:

    deliver_methods:
      type: string
      x-extensible-enum:
        - parcel
        - letter
        - email

**Note:** {x-extensible-enum} is not JSON Schema conform but will be ignored by most tools.