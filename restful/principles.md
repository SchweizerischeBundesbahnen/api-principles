---
layout: default
title: Principles
parent: RESTful APIs
nav_order: 1
---

Principles for RESTful APIs
===========================
{: .no_toc }

This chapter describes a set of guidelines that **must** be applied when writing and publishing RESTful APIs.

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Compatibility

### `MUST` We do not Break Backward Compatibility

APIs are contracts between service providers and service consumers that cannot be broken via unilateral decisions. For this reason APIs may only be changed if backward compatibility is guaranteed. If this cannot be guaranteed, a new API major version must be provided and the old one has to be supported in parallel. For deprecation, follow the principles described in the chapter about [deprecation](/api-principles/organization/#must-deprecation).

API designers should apply the following rules to evolve RESTful APIs for services in a backward-compatible way:

- Add only optional, never mandatory fields.
- Never change the semantic of fields (e.g. changing the semantic from customer-number to customer-id, as both are different unique customer keys)
- Input fields may have (complex) constraints being validated via server-side business logic. Never change the validation logic to be more restrictive and make sure that all constraints are clearly defined in description.
- Enum ranges can be reduced when used as input parameters, only if the server is ready to accept and handle old range values too. Enum range can be reduced when used as output parameters.
- Enum ranges cannot be extended when used for output parameters — clients may not be prepared to handle it. However, enum ranges can be extended when used for input parameters.
- Use x-extensible-enum, if range is used for output parameters and likely to be extended with growing functionality. It defines an open list of explicit values and clients must be agnostic to new values.
- Support redirection in case an URL has to change 301 (Moved Permanently).

On the other hand, API consumers must follow the tolerant reader rules (see below).


### `MUST` Clients must be Tolerant Readers

Clients of an API **must** follow the rules described in the chapter about [tolerant dependencies](/api-principles/architecture/#must-we-build-tolerant-dependencies).

## Security

### `MUST` Secure public APIs with API Management & WAF

Every public API must be published in the API Management and must be protected with a web application firewall (WAF). For applications, which are running internally or in a private cloud, the configuration of the WAF is already made during the initial deployment of the API to the API Management. If an API is published on a public cloud, you **must** protect your API with the so called CloudWAF ([internal CloudWAF documentation](https://confluence.sbb.ch/x/YoDuRw)).

### `MUST` Secure Endpoints with OAuth 2.0

Every API endpoint needs to be secured using OAuth 2.0. Please refer to the [official OpenAPI spec](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md#security-definitions-object) on how to specify security definitions in your API specification.

It makes little sense specifying the flow to retrieve OAuth tokens in the `securitySchemes` section, as API endpoints should not care, how OAuth tokens were created. Unfortunately the `flow` field is mandatory and cannot be omitted. API endpoints should always set `flow: clientCredentials` and ignore this information.

## Monitoring

### `MUST` Applications Support OpenTelemetry

Distributed Tracing over multiple applications, teams and even across large solutions is very important in root cause analysis and helps detect how latencies are stacked up and where incidents are located and thus can significantly shorten _mean time to repair_ (MTTR).

To identify a specific request through the entire chain and beyond team boundaries every team (and API) `MUST` use [OpenTelemetry](https://opentelemetry.io/) as its way to trace calls and business transactions. Teams `MUST` use standard [W3C Trace Context](https://www.w3.org/TR/trace-context/) Headers, as they are the common standard for distributed tracing and are supported by most of the cloud platforms and monitoring tools. We explicitly use W3C standards for eventing too and do not differ between synchronous and asynchronous requests, as we want to be able to see traces across the boundaries of these two architectural patterns.

##### Traceparent
{: .no_toc }
`traceparent`: ${version}-${trace-id}-${parent-id}-${trace-flags}

The traceparent HTTP header field identifies the incoming request in a tracing system. The _trace-id_ defines the trace through the whole forest of synchronous and asynchronous requests. The _parent-id_ defines a specific span within a trace.

##### Tracestate
{: .no_toc }
`tracestate`: key1=value1,key2=value2,...

The tracestate HTTP header field specifies application and/or APM Tool specific key/value pairs.

### `MUST` Infrastructure Supports OpenTelemetry

Every component like the API Management gateway, web application firewalls or other reverse proxies have to support and log the tracing headers too.

## Documentation

### `MUST` Provide API Specification using OpenAPI

>API Linting by Zally SBB Ruleset: [UseOpenApiRule](https://github.com/SchweizerischeBundesbahnen/zally/blob/main/server/zally-ruleset-sbb/src/main/kotlin/org/zalando/zally/ruleset/sbb/UseOpenApiRule.kt)

We use the [OpenAPI specification](http://swagger.io/specification/) as standard to define RESTful API specification files. API designers are required to provide the API specification using a single **self-contained YAML** file to improve readability. We encourage to use **OpenAPI 3.0** version, but still support **OpenAPI 2.0** (a.k.a. Swagger 2).

The API specification files should be subject to version control using a source code management system - best together with the implementing sources.

You **must** publish the component API specification with the deployment of the implementing service and make it discoverable, following our [publication](/api-principles/api-principles/publication) principles. As a starting point, use our ESTA Blueprints ([internal Link](http://esta.sbb.ch/Esta+Blueprints)).

**Hint:** A good way to explore **OpenAPI 3.0/2.0** is to navigate through the [OpenAPI specification mind map](https://openapi-map.apihandyman.io/).

### `MUST` Use HTTP Methods Correctly

Be compliant with the standardized HTTP method semantics summarized as follows:

#### GET
{: .no_toc }

{GET} requests are used to **read** either a single or a collection resource.

-   {GET} requests for individual resources will usually generate a {404} if the resource does not exist

-   {GET} requests for collection resources may return either {200} (if the collection is empty) or {404} (if the collection is missing)

-   {GET} requests must NOT have a request body payload (see {GET-with-Body})

**Note:** {GET} requests on collection resources should provide sufficient filter and pagination mechanisms.

#### GET with Body
{: .no_toc }

APIs sometimes face the problem, that they have to provide extensive structured request information with {GET}, that may conflict with the size limits of clients, load-balancers, and servers. As we require APIs to be standard conform (body in {GET} must be ignored on server side), API designers have to check the following two options:

1.  {GET} with URL encoded query parameters: when it is possible to encode the request information in query parameters, respecting the usual size limits of clients, gateways, and servers, this should be the first choice. The request information can either be provided via multiple query parameters or by a single structured URL encoded string.

2.  {POST} with body content: when a {GET} with URL encoded query parameters is not possible, a {POST} with body content must be used. In this case the endpoint must be documented with the hint {GET-with-Body} to transport the {GET} semantic of this call.

**Note:** It is no option to encode the lengthy structured request information using header parameters. From a conceptual point of view, the semantic of an operation should always be expressed by the resource names, as well as the involved path and query parameters. In other words by everything that goes into the URL. Request headers are reserved for general context information. In addition, size limits on query parameters and headers are not reliable and depend on clients, gateways, server, and actual settings. Thus, switching to headers does not solve the original problem.

**Hint:** As {GET-with-body} is used to transport extensive query parameters, the {cursor} cannot any longer be used to encode the query filters in case of cursor-based pagination. As a consequence, it is best practice to transport the query filters in the body, while using pagination links containing the {cursor} that is only encoding the page position and direction. To protect the pagination sequence the {cursor} may contain a hash over all applied query filters.

#### PUT
{: .no_toc }

{PUT} requests are used to **update** (in rare cases to create) **entire** resources – single or collection resources. The semantic is best described as *"please put the enclosed representation at the resource mentioned by the URL, replacing any existing resource."*.

-   {PUT} requests are usually applied to single resources, and not to collection resources, as this would imply replacing the entire collection

-   {PUT} requests are usually robust against non-existence of resources by implicitly creating before updating

-   on successful {PUT} requests, the server will **replace the entire resource** addressed by the URL with the representation passed in the payload (subsequent reads will deliver the same payload)

-   successful {PUT} requests will usually generate {200} or {204} (if the resource was updated – with or without actual content returned), and {201} (if the resource was created)

**Important:** It is best practice to prefer {POST} over {PUT} for creation of (at least top-level) resources. This leaves the resource ID under control of the service and allows to concentrate on the update semantic using {PUT} as follows.

**Note:** In the rare cases where {PUT} is although used for resource creation, the resource IDs are maintained by the client and passed as a URL path segment. Putting the same resource twice is required to be idempotent and to result in the same single resource instance.

#### POST
{: .no_toc }

{POST} requests are idiomatically used to **create** single resources on a collection resource endpoint, but other semantics on single resources endpoint are equally possible. The semantic for collection endpoints is best described as *"please add the enclosed representation to the collection resource identified by the URL"*.

-   on a successful {POST} request, the server will create one or multiple new resources and provide their URI/URLs in the response

-   successful {POST} requests will usually generate {200} (if resources have been updated), {201} (if resources have been created), {202} (if the request was accepted but has not been finished yet), and exceptionally {204} with {Location} header (if the actual resource is not returned).

The semantic for single resource endpoints is best described as *"please execute the given well specified request on the resource identified by the URL"*.

**Generally:** {POST} should be used for scenarios that cannot be covered by the other methods sufficiently. In such cases, make sure to document the fact that {POST} is used as a workaround (see {GET-with-Body}).

**Note:** Resource IDs with respect to {POST} requests are created and maintained by server and returned with response payload.

#### PATCH
{: .no_toc }

{PATCH} requests are used to **update parts** of single resources, i.e. where only a specific subset of resource fields should be replaced. The semantic is best described as *"please change the resource identified by the URL according to my change request"*. The semantic of the change request is not defined in the HTTP standard and must be described in the API specification by using suitable media types.

-   {PATCH} requests are usually applied to single resources as patching entire collection is challenging

-   {PATCH} requests are usually not robust against non-existence of resource instances

-   on successful {PATCH} requests, the server will update parts of the resource addressed by the URL as defined by the change request in the payload

-   successful {PATCH} requests will usually generate {200} or {204} (if resources have been updated with or without updated content returned)

**Note:** since implementing {PATCH} correctly is a bit tricky, we strongly suggest to choose one and only one of the following patterns per endpoint, unless forced by a backwards compatible change. In preference order:

1.  use {PUT} with complete objects to update a resource as long as feasible (i.e. do not use {PATCH} at all).

2.  use {PATCH} with partial objects to only update parts of a resource, whenever possible. (This is basically {RFC-7396}\[JSON Merge Patch\], a specialized media type `application/merge-patch+json` that is a partial resource representation.)

3.  use {PATCH} with {RFC-6902}\[JSON Patch\], a specialized media type `application/json-patch+json` that includes instructions on how to change the resource.

4.  use {POST} (with a proper description of what is happening) instead of {PATCH}, if the request does not modify the resource in a way defined by the semantics of the media type.

In practice {RFC-7396}\[JSON Merge Patch\] quickly turns out to be too limited, especially when trying to update single objects in large collections (as part of the resource). In this cases {RFC-6902}\[JSON Patch\] can shown its full power while still showing readable patch requests (see also [JSON patch vs. merge](http://erosb.github.io/post/json-patch-vs-merge-patch)).

**Note:** Patching the same resource twice is **not** required to be idempotent and may result in a changing result.

#### DELETE
{: .no_toc }

{DELETE} requests are used to **delete** resources. The semantic is best described as *"please delete the resource identified by the URL"*.

-   {DELETE} requests are usually applied to single resources, not on collection resources, as this would imply deleting the entire collection

-   successful {DELETE} requests will usually generate {200} (if the deleted resource is returned) or {204} (if no content is returned)

-   failed {DELETE} requests will usually generate {404} (if the resource cannot be found) or {410} (if the resource was already deleted before)

**Important:** After deleting a resource with {DELETE}, a {GET} request on the resource is expected to either return {404} (not found) or {410} (gone) depending on how the resource is represented after deletion. Under no circumstances the resource must be accessible after this operation on its endpoint.

#### HEAD
{: .no_toc }

{HEAD} requests are used to **retrieve** the header information of single resources and resource collections.

-   {HEAD} has exactly the same semantics as {GET}, but returns headers only, no body.

**Hint:** {HEAD} is particular useful to efficiently lookup whether large resources or collection resources have been updated in conjunction with the {ETag}-header.

#### OPTIONS
{: .no_toc }

{OPTIONS} requests are used to **inspect** the available operations (HTTP methods) of a given endpoint.

-   {OPTIONS} responses usually either return a comma separated list of methods in the `Allow` header or as a structured list of link templates

**Note:** {OPTIONS} is rarely implemented, though it could be used to self-describe the full functionality of a resource.

### `MUST` Use Standard HTTP Status Codes

> API Linting by Zally SBB Ruleset: [UseStandardHttpStatusCodesRule](https://github.com/SchweizerischeBundesbahnen/zally/blob/main/server/zally-ruleset-sbb/src/main/kotlin/org/zalando/zally/ruleset/sbb/UseStandardHttpStatusCodesRule.kt)

You must only use standardized HTTP status codes consistently with their intended semantics. You must not invent new HTTP status codes.

RFC standards define ~60 different HTTP status codes with specific semantics (mainly {RFC-7231}\#section-6\[RFC7231\] and {RFC-6585}\[RFC 6585\]) — and there are upcoming new ones, e.g. [draft legally-restricted-status](https://tools.ietf.org/html/draft-tbray-http-legally-restricted-status-05). See overview on all error codes on [Wikipedia](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) or via <https://httpstatuses.com/>) also inculding 'unofficial codes', e.g. used by popular web servers like Nginx.

Below we list the most commonly used and best understood HTTP status codes, consistent with their semantic in the RFCs. APIs should only use these to prevent misconceptions that arise from less commonly used HTTP status codes.

**Important:** As long as your HTTP status code usage is well covered by the semantic defined here, you should not describe it to avoid an overload with common sense information and the risk of inconsistent definitions. Only if the HTTP status code is not in the list below or its usage requires additional information aside the well defined semantic, the API specification must provide a clear description of the HTTP status code in the response.

#### Success Codes
{: .no_toc }

<table><colgroup><col style="width: 10%" /><col style="width: 70%" /><col style="width: 20%" /></colgroup><thead><tr class="header"><th>Code</th><th>Meaning</th><th>Methods</th></tr></thead><tbody><tr class="odd"><td><p>{200}</p></td><td><p>OK - this is the standard success response</p></td><td><p>{ALL}</p></td></tr><tr class="even"><td><p>{201}</p></td><td><p>Created - Returned on successful entity creation. You are free to return either an empty response or the created resource in conjunction with the Location header. <em>Always</em> set the Location header.</p></td><td><p>{POST}, {PUT}</p></td></tr><tr class="odd"><td><p>{202}</p></td><td><p>Accepted - The request was successful and will be processed asynchronously.</p></td><td><p>{POST}, {PUT}, {PATCH}, {DELETE}</p></td></tr><tr class="even"><td><p>{204}</p></td><td><p>No content - There is no response body.</p></td><td><p>{PUT}, {PATCH}, {DELETE}</p></td></tr><tr class="odd"><td><p>{207}</p></td><td><p>Multi-Status - The response body contains multiple status informations for different parts of a batch/bulk request.</p></td><td><p>{POST}</p></td></tr></tbody></table>

#### Redirection Codes
{: .no_toc }

<table><colgroup><col style="width: 10%" /><col style="width: 70%" /><col style="width: 20%" /></colgroup><thead><tr class="header"><th>Code</th><th>Meaning</th><th>Methods</th></tr></thead><tbody><tr class="odd"><td><p>{301}</p></td><td><p>Moved Permanently - This and all future requests should be directed to the given URI.</p></td><td><p>{ALL}</p></td></tr><tr class="even"><td><p>{301}</p></td><td><p>See Other - The response to the request can be found under another URI using a {GET} method.</p></td><td><p>{POST}, {PUT}, {PATCH}, {DELETE}</p></td></tr><tr class="odd"><td><p>{304}</p></td><td><p>Not Modified - indicates that a conditional GET or HEAD request would have resulted in 200 response if it were not for the fact that the condition evaluated to false, i.e. resource has not been modified since the date or version passed via request headers If-Modified-Since or If-None-Match.</p></td><td><p>{GET}, {HEAD}</p></td></tr></tbody></table>

#### Client Side Error Codes
{: .no_toc }

<table><colgroup><col style="width: 10%" /><col style="width: 70%" /><col style="width: 20%" /></colgroup><thead><tr class="header"><th>Code</th><th>Meaning</th><th>Methods</th></tr></thead><tbody><tr class="odd"><td><p>{400}</p></td><td><p>Bad request - generic / unknown error. Should also be delivered in case of input payload fails business logic validation.</p></td><td><p>{ALL}</p></td></tr><tr class="even"><td><p>{401}</p></td><td><p>Unauthorized - the users must log in (this often means "Unauthenticated").</p></td><td><p>{ALL}</p></td></tr><tr class="odd"><td><p>{403}</p></td><td><p>Forbidden - the user is not authorized to use this resource.</p></td><td><p>{ALL}</p></td></tr><tr class="even"><td><p>{404}</p></td><td><p>Not found - the resource is not found.</p></td><td><p>{ALL}</p></td></tr><tr class="odd"><td><p>{405}</p></td><td><p>Method Not Allowed - the method is not supported, see {OPTIONS}.</p></td><td><p>{ALL}</p></td></tr><tr class="even"><td><p>{406}</p></td><td><p>Not Acceptable - resource can only generate content not acceptable according to the Accept headers sent in the request.</p></td><td><p>{ALL}</p></td></tr><tr class="odd"><td><p>{408}</p></td><td><p>Request timeout - the server times out waiting for the resource.</p></td><td><p>{ALL}</p></td></tr><tr class="even"><td><p>{409}</p></td><td><p>Conflict - request cannot be completed due to conflict, e.g. when two clients try to create the same resource or if there are concurrent, conflicting updates.</p></td><td><p>{POST}, {PUT}, {PATCH}, {DELETE}</p></td></tr><tr class="odd"><td><p>{410}</p></td><td><p>Gone - resource does not exist any longer, e.g. when accessing a resource that has intentionally been deleted.</p></td><td><p>{ALL}</p></td></tr><tr class="even"><td><p>{412}</p></td><td><p>Precondition Failed - returned for conditional requests, e.g. {If-Match} if the condition failed. Used for optimistic locking.</p></td><td><p>{PUT}, {PATCH}, {DELETE}</p></td></tr><tr class="odd"><td><p>{415}</p></td><td><p>Unsupported Media Type - e.g. clients sends request body without content type.</p></td><td><p>{POST}, {PUT}, {PATCH}, {DELETE}</p></td></tr><tr class="even"><td><p>{423}</p></td><td><p>Locked - Pessimistic locking, e.g. processing states.</p></td><td><p>{PUT}, {PATCH}, {DELETE}</p></td></tr><tr class="odd"><td><p>{428}</p></td><td><p>Precondition Required - server requires the request to be conditional, e.g. to make sure that the "lost update problem" is avoided.</p></td><td><p>{ALL}</p></td></tr><tr class="even"><td><p>{429}</p></td><td><p>Too many requests - the client does not consider rate limiting and sent too many requests.</p></td><td><p>{ALL}</p></td></tr></tbody></table>

#### Server Side Error Codes:
{: .no_toc }

<table><colgroup><col style="width: 10%" /><col style="width: 70%" /><col style="width: 20%" /></colgroup><thead><tr class="header"><th>Code</th><th>Meaning</th><th>Methods</th></tr></thead><tbody><tr class="odd"><td><p>{500}</p></td><td><p>Internal Server Error - a generic error indication for an unexpected server execution problem (here, client retry may be sensible)</p></td><td><p>{ALL}</p></td></tr><tr class="even"><td><p>{501}</p></td><td><p>Not Implemented - server cannot fulfill the request (usually implies future availability, e.g. new feature).</p></td><td><p>{ALL}</p></td></tr><tr class="odd"><td><p>{503}</p></td><td><p>Service Unavailable - service is (temporarily) not available (e.g. if a required component or downstream service is not available) — client retry may be sensible. If possible, the service should indicate how long the client should wait by setting the {Retry-After} header.</p></td><td><p>{ALL}</p></td></tr></tbody></table>
