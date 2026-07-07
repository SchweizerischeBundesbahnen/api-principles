---
layout: default
title: Principles
parent: RESTful APIs
nav_order: 1
---

# Principles for RESTful APIs
{: .no_toc }

This chapter describes a set of guidelines that **must** be applied when writing and publishing RESTful APIs.

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## `MUST` Provide API Specification using OpenAPI

We use the [OpenAPI specification](http://swagger.io/specification/) as standard to define RESTful API specification files. API designers are required to provide the API specification using a single **self-contained YAML** file to improve readability. We encourage to use **OpenAPI 3.0** version, but still support **OpenAPI 2.0** (a.k.a. Swagger 2).

The API specification files should be subject to version control using a source code management system - best together with the implementing sources.

You **must** publish the component API specification with the deployment of the implementing service and make it discoverable, following our [publication](/api-principles/api-principles/publication) principles. As a starting point, use our [ESTA Blueprints](https://confluence.sbb.ch/x/7ICRRg) _\[internal link\]_.

**Hint:** A good way to explore **OpenAPI 3.0/2.0** is to navigate through the [OpenAPI specification mind map](https://openapi-map.apihandyman.io/).

---

## `MUST` Use HTTP Methods Correctly

Be compliant with the standardized HTTP method semantics summarized as follows:

### GET
{: .no_toc }

{GET} requests are used to **read** either a single or a collection resource.

- {GET} requests for individual resources will usually generate a {404} if the resource does not exist
- {GET} requests for collection resources may return either {200} (if the collection is empty) or {404} (if the collection is missing)
- {GET} requests must NOT have a request body payload (see {GET-with-Body})

**Note:** {GET} requests on collection resources should provide sufficient filter and pagination mechanisms.

### GET with Body
{: .no_toc }

APIs sometimes face the problem, that they have to provide extensive structured request information with {GET}, that may conflict with the size limits of clients, load-balancers, and servers. As we require APIs to be standard conform (body in {GET} must be ignored on server side), API designers have to check the following two options:

1. {GET} with URL encoded query parameters: when it is possible to encode the request information in query parameters, respecting the usual size limits of clients, gateways, and servers, this should be the first choice. The request information can either be provided via multiple query parameters or by a single structured URL encoded string.
1. {POST} with body content: when a {GET} with URL encoded query parameters is not possible, a {POST} with body content must be used. In this case the endpoint must be documented with the hint {GET-with-Body} to transport the {GET} semantic of this call.

**Note:** It is no option to encode the lengthy structured request information using header parameters. From a conceptual point of view, the semantic of an operation should always be expressed by the resource names, as well as the involved path and query parameters. In other words by everything that goes into the URL. Request headers are reserved for general context information. In addition, size limits on query parameters and headers are not reliable and depend on clients, gateways, server, and actual settings. Thus, switching to headers does not solve the original problem.

**Hint:** As {GET-with-body} is used to transport extensive query parameters, the {cursor} cannot any longer be used to encode the query filters in case of cursor-based pagination. As a consequence, it is best practice to transport the query filters in the body, while using pagination links containing the {cursor} that is only encoding the page position and direction. To protect the pagination sequence the {cursor} may contain a hash over all applied query filters.

### PUT
{: .no_toc }

{PUT} requests are used to **update** (in rare cases to create) **entire** resources – single or collection resources. The semantic is best described as _"please put the enclosed representation at the resource mentioned by the URL, replacing any existing resource."_.

- {PUT} requests are usually applied to single resources, and not to collection resources, as this would imply replacing the entire collection
- {PUT} requests are usually robust against non-existence of resources by implicitly creating before updating
- on successful {PUT} requests, the server will **replace the entire resource** addressed by the URL with the representation passed in the payload (subsequent reads will deliver the same payload)
- successful {PUT} requests will usually generate {200} or {204} (if the resource was updated – with or without actual content returned), and {201} (if the resource was created)

**Important:** It is best practice to prefer {POST} over {PUT} for creation of (at least top-level) resources. This leaves the resource ID under control of the service and allows to concentrate on the update semantic using {PUT} as follows.

**Note:** In the rare cases where {PUT} is although used for resource creation, the resource IDs are maintained by the client and passed as a URL path segment. Putting the same resource twice is required to be idempotent and to result in the same single resource instance.

### POST
{: .no_toc }

{POST} requests are idiomatically used to **create** single resources on a collection resource endpoint, but other semantics on single resources endpoint are equally possible. The semantic for collection endpoints is best described as _"please add the enclosed representation to the collection resource identified by the URL"_.

- on a successful {POST} request, the server will create one or multiple new resources and provide their URI/URLs in the response
- successful {POST} requests will usually generate {200} (if resources have been updated), {201} (if resources have been created), {202} (if the request was accepted but has not been finished yet), and exceptionally {204} with {Location} header (if the actual resource is not returned).

The semantic for single resource endpoints is best described as _"please execute the given well specified request on the resource identified by the URL"_.

**Generally:** {POST} should be used for scenarios that cannot be covered by the other methods sufficiently. In such cases, make sure to document the fact that {POST} is used as a workaround (see {GET-with-Body}).

**Note:** Resource IDs with respect to {POST} requests are created and maintained by server and returned with response payload.

### PATCH
{: .no_toc }

{PATCH} requests are used to **update parts** of single resources, i.e. where only a specific subset of resource fields should be replaced. The semantic is best described as _"please change the resource identified by the URL according to my change request"_. The semantic of the change request is not defined in the HTTP standard and must be described in the API specification by using suitable media types.

- {PATCH} requests are usually applied to single resources as patching entire collection is challenging
- {PATCH} requests are usually not robust against non-existence of resource instances
- on successful {PATCH} requests, the server will update parts of the resource addressed by the URL as defined by the change request in the payload
- successful {PATCH} requests will usually generate {200} or {204} (if resources have been updated with or without updated content returned)

**Note:** since implementing {PATCH} correctly is a bit tricky, we strongly suggest to choose one and only one of the following patterns per endpoint, unless forced by a backwards compatible change. In preference order:

1. use {PUT} with complete objects to update a resource as long as feasible (i.e. do not use {PATCH} at all).
1. use {PATCH} with partial objects to only update parts of a resource, whenever possible. (This is basically {RFC-7396}\[JSON Merge Patch\], a specialized media type `application/merge-patch+json` that is a partial resource representation.)
1. use {PATCH} with {RFC-6902}\[JSON Patch\], a specialized media type `application/json-patch+json` that includes instructions on how to change the resource.
1. use {POST} (with a proper description of what is happening) instead of {PATCH}, if the request does not modify the resource in a way defined by the semantics of the media type.

In practice {RFC-7396}\[JSON Merge Patch\] quickly turns out to be too limited, especially when trying to update single objects in large collections (as part of the resource). In this cases {RFC-6902}\[JSON Patch\] can shown its full power while still showing readable patch requests (see also [JSON patch vs. merge](http://erosb.github.io/post/json-patch-vs-merge-patch)).

**Note:** Patching the same resource twice is **not** required to be idempotent and may result in a changing result.

### DELETE
{: .no_toc }

{DELETE} requests are used to **delete** resources. The semantic is best described as _"please delete the resource identified by the URL"_.

- {DELETE} requests are usually applied to single resources, not on collection resources, as this would imply deleting the entire collection
- successful {DELETE} requests will usually generate {200} (if the deleted resource is returned) or {204} (if no content is returned)
- failed {DELETE} requests will usually generate {404} (if the resource cannot be found) or {410} (if the resource was already deleted before)

**Important:** After deleting a resource with {DELETE}, a {GET} request on the resource is expected to either return {404} (not found) or {410} (gone) depending on how the resource is represented after deletion. Under no circumstances the resource must be accessible after this operation on its endpoint.

### HEAD
{: .no_toc }

{HEAD} requests are used to **retrieve** the header information of single resources and resource collections.

- {HEAD} has exactly the same semantics as {GET}, but returns headers only, no body.

**Hint:** {HEAD} is particular useful to efficiently lookup whether large resources or collection resources have been updated in conjunction with the {ETag}-header.

### OPTIONS
{: .no_toc }

{OPTIONS} requests are used to **inspect** the available operations (HTTP methods) of a given endpoint.

- {OPTIONS} responses usually either return a comma separated list of methods in the `Allow` header or as a structured list of link templates

**Note:** {OPTIONS} is rarely implemented, though it could be used to self-describe the full functionality of a resource.

---

## `MUST` Use Standard HTTP Status Codes

You must only use standardized HTTP status codes consistently with their intended semantics. You must not invent new HTTP status codes.

RFC standards define ~60 different HTTP status codes with specific semantics (mainly {RFC-7231}\#section-6\[RFC7231\] and {RFC-6585}\[RFC 6585\]) — and there are upcoming new ones, e.g. [draft legally-restricted-status](https://tools.ietf.org/html/draft-tbray-http-legally-restricted-status-05). See overview on all error codes on [Wikipedia](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) or via <https://httpstatuses.com/>) also inculding 'unofficial codes', e.g. used by popular web servers like Nginx.

Below we list the most commonly used and best understood HTTP status codes, consistent with their semantic in the RFCs. APIs should only use these to prevent misconceptions that arise from less commonly used HTTP status codes.

**Important:** As long as your HTTP status code usage is well covered by the semantic defined here, you should not describe it to avoid an overload with common sense information and the risk of inconsistent definitions. Only if the HTTP status code is not in the list below or its usage requires additional information aside the well defined semantic, the API specification must provide a clear description of the HTTP status code in the response.

### Success Codes
{: .no_toc }

| Code | Meaning | Methods |
|:------|:-----------------------------------------------------------|:------------|
| {200} | OK - this is the standard success response | {ALL} |
| {201} | Created - Returned on successful entity creation. You are free to return either an empty response or the created resource in conjunction with the Location header. **Always** set the Location header. | {POST}, {PUT} |
| {202} | Accepted - The request was successful and will be processed asynchronously. | {POST}, {PUT}, {PATCH}, {DELETE} |
| {204} | No content - There is no response body. | {PUT}, {PATCH}, {DELETE} |
| {207} | Multi-Status - The response body contains multiple status informations for different parts of a batch/bulk request. | {POST} |

### Redirection Codes
{: .no_toc }

| Code | Meaning | Methods |
|:------|:-----------------------------------------------------------|:------------|
| {301} | Moved Permanently - This and all future requests should be directed to the given URI. | {ALL} |
| {301} | See Other - The response to the request can be found under another URI using a {GET} method. | {POST}, {PUT}, {PATCH}, {DELETE} |
| {304} | Not Modified - indicates that a conditional GET or HEAD request would have resulted in 200 response if it were not for the fact that the condition evaluated to false, i.e. resource has not been modified since the date or version passed via request headers If-Modified-Since or If-None-Match. | {GET}, {HEAD} |

### Client Side Error Codes
{: .no_toc }

| Code | Meaning | Methods |
|:------|:-----------------------------------------------------------|:------------|
| {400} | Bad request - generic / unknown error. Should also be delivered in case of input payload fails business logic validation. | {ALL} |
| {401} | Unauthorized - the users must log in (this often means "Unauthenticated"). | {ALL} |
| {403} | Forbidden - the user is not authorized to use this resource. | {ALL} |
| {404} | Not found - the resource is not found. | {ALL} |
| {405} | Method Not Allowed - the method is not supported, see {OPTIONS}. | {ALL} |
| {406} | Not Acceptable - resource can only generate content not acceptable according to the Accept headers sent in the request. | {ALL} |
| {408} | Request timeout - the server times out waiting for the resource. | {ALL} |
| {409} | Conflict - request cannot be completed due to conflict, e.g. when two clients try to create the same resource or if there are concurrent, conflicting updates. | {POST}, {PUT}, {PATCH}, {DELETE} |
| {410} | Gone - resource does not exist any longer, e.g. when accessing a resource that has intentionally been deleted. | {ALL} |
| {412} | Precondition Failed - returned for conditional requests, e.g. {If-Match} if the condition failed. Used for optimistic locking. | {PUT}, {PATCH}, {DELETE} |
| {415} | Unsupported Media Type - e.g. clients sends request body without content type. | {POST}, {PUT}, {PATCH}, {DELETE} |
| {423} | Locked - Pessimistic locking, e.g. processing states. | {PUT}, {PATCH}, {DELETE} |
| {428} | Precondition Required - server requires the request to be conditional, e.g. to make sure that the "lost update problem" is avoided. | {ALL} |
| {429} | Too many requests - the client does not consider rate limiting and sent too many requests. | {ALL} |

### Server Side Error Codes
{: .no_toc }

| Code | Meaning | Methods |
|:------|:-----------------------------------------------------------|:------------|
| {500} | Internal Server Error - a generic error indication for an unexpected server execution problem (here, client retry may be sensible) | {ALL} |
| {501} | Not Implemented - server cannot fulfill the request (usually implies future availability, e.g. new feature). | {ALL} |
| {503} | Service Unavailable - service is (temporarily) not available (e.g. if a required component or downstream service is not available) — client retry may be sensible. If possible, the service should indicate how long the client should wait by setting the {Retry-After} header. | {ALL} |
