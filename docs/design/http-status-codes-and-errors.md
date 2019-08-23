---
layout: default
title: HTTP Status Codes and Errors
parent: API Design
nav_order: 12
---

{MUST} Specify Success and Error Responses
==========================================

APIs should define the functional, business view and abstract from implementation aspects. Success and error responses are a vital part to define how an API is used correctly.

Therefore, you must define **all** success and service specific error responses in your API specification. Both are part of the interface definition and provide important information for service clients to handle standard as well as exceptional situations.

**Hint:** In most cases it is not useful to document all technical errors, especially if they are not under control of the service provider. Thus unless a response code conveys application-specific functional semantics or is used in a none standard way that requires additional explanation, multiple error response specifications can be combined using the following pattern (see also [???](#234)):

    responses:
      ...
      default:
        description: error occurred - see status code and problem object for more information.
        content:
          "application/problem+json":
            schema:
              $ref: 'https://opensource.zalando.com/problem/schema.yaml#/Problem'

API designers should also think about a **troubleshooting board** as part of the associated online API documentation. It provides information and handling guidance on application-specific errors and is referenced via links from the API specification. This can reduce service support tasks and contribute to service client and provider performance.

{MUST} Use Standard HTTP Status Codes
=====================================

You must only use standardized HTTP status codes consistently with their intended semantics. You must not invent new HTTP status codes.

RFC standards define ~60 different HTTP status codes with specific semantics (mainly {RFC-7231}\#section-6\[RFC7231\] and {RFC-6585}\[RFC 6585\]) — and there are upcoming new ones, e.g. [draft legally-restricted-status](https://tools.ietf.org/html/draft-tbray-http-legally-restricted-status-05). See overview on all error codes on [Wikipedia](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) or via <https://httpstatuses.com/>) also inculding 'unofficial codes', e.g. used by popular web servers like Nginx.

Below we list the most commonly used and best understood HTTP status codes, consistent with their semantic in the RFCs. APIs should only use these to prevent misconceptions that arise from less commonly used HTTP status codes.

**Important:** As long as your HTTP status code usage is well covered by the semantic defined here, you should not describe it to avoid an overload with common sense information and the risk of inconsistent definitions. Only if the HTTP status code is not in the list below or its usage requires additional information aside the well defined semantic, the API specification must provide a clear description of the HTTP status code in the response.

Success Codes
-------------

<table><colgroup><col style="width: 10%" /><col style="width: 70%" /><col style="width: 20%" /></colgroup><thead><tr class="header"><th>Code</th><th>Meaning</th><th>Methods</th></tr></thead><tbody><tr class="odd"><td><p>{200}</p></td><td><p>OK - this is the standard success response</p></td><td><p>{ALL}</p></td></tr><tr class="even"><td><p>{201}</p></td><td><p>Created - Returned on successful entity creation. You are free to return either an empty response or the created resource in conjunction with the Location header. (More details found in the <a href="#common-headers">???</a>.) <em>Always</em> set the Location header.</p></td><td><p>{POST}, {PUT}</p></td></tr><tr class="odd"><td><p>{202}</p></td><td><p>Accepted - The request was successful and will be processed asynchronously.</p></td><td><p>{POST}, {PUT}, {PATCH}, {DELETE}</p></td></tr><tr class="even"><td><p>{204}</p></td><td><p>No content - There is no response body.</p></td><td><p>{PUT}, {PATCH}, {DELETE}</p></td></tr><tr class="odd"><td><p>{207}</p></td><td><p>Multi-Status - The response body contains multiple status informations for different parts of a batch/bulk request (see <a href="#152">{MUST} Use Code 207 for Batch or Bulk Requests</a>).</p></td><td><p>{POST}</p></td></tr></tbody></table>

Redirection Codes
-----------------

<table><colgroup><col style="width: 10%" /><col style="width: 70%" /><col style="width: 20%" /></colgroup><thead><tr class="header"><th>Code</th><th>Meaning</th><th>Methods</th></tr></thead><tbody><tr class="odd"><td><p>{301}</p></td><td><p>Moved Permanently - This and all future requests should be directed to the given URI.</p></td><td><p>{ALL}</p></td></tr><tr class="even"><td><p>{301}</p></td><td><p>See Other - The response to the request can be found under another URI using a {GET} method.</p></td><td><p>{POST}, {PUT}, {PATCH}, {DELETE}</p></td></tr><tr class="odd"><td><p>{304}</p></td><td><p>Not Modified - indicates that a conditional GET or HEAD request would have resulted in 200 response if it were not for the fact that the condition evaluated to false, i.e. resource has not been modified since the date or version passed via request headers If-Modified-Since or If-None-Match.</p></td><td><p>{GET}, {HEAD}</p></td></tr></tbody></table>

Client Side Error Codes
-----------------------

<table><colgroup><col style="width: 10%" /><col style="width: 70%" /><col style="width: 20%" /></colgroup><thead><tr class="header"><th>Code</th><th>Meaning</th><th>Methods</th></tr></thead><tbody><tr class="odd"><td><p>{400}</p></td><td><p>Bad request - generic / unknown error. Should also be delivered in case of input payload fails business logic validation.</p></td><td><p>{ALL}</p></td></tr><tr class="even"><td><p>{401}</p></td><td><p>Unauthorized - the users must log in (this often means "Unauthenticated").</p></td><td><p>{ALL}</p></td></tr><tr class="odd"><td><p>{403}</p></td><td><p>Forbidden - the user is not authorized to use this resource.</p></td><td><p>{ALL}</p></td></tr><tr class="even"><td><p>{404}</p></td><td><p>Not found - the resource is not found.</p></td><td><p>{ALL}</p></td></tr><tr class="odd"><td><p>{405}</p></td><td><p>Method Not Allowed - the method is not supported, see {OPTIONS}.</p></td><td><p>{ALL}</p></td></tr><tr class="even"><td><p>{405}</p></td><td><p>Not Acceptable - resource can only generate content not acceptable according to the Accept headers sent in the request.</p></td><td><p>{ALL}</p></td></tr><tr class="odd"><td><p>{408}</p></td><td><p>Request timeout - the server times out waiting for the resource.</p></td><td><p>{ALL}</p></td></tr><tr class="even"><td><p>{409}</p></td><td><p>Conflict - request cannot be completed due to conflict, e.g. when two clients try to create the same resource or if there are concurrent, conflicting updates.</p></td><td><p>{POST}, {PUT}, {PATCH}, {DELETE}</p></td></tr><tr class="odd"><td><p>{410}</p></td><td><p>Gone - resource does not exist any longer, e.g. when accessing a resource that has intentionally been deleted.</p></td><td><p>{ALL}</p></td></tr><tr class="even"><td><p>{412}</p></td><td><p>Precondition Failed - returned for conditional requests, e.g. {If-Match} if the condition failed. Used for optimistic locking.</p></td><td><p>{PUT}, {PATCH}, {DELETE}</p></td></tr><tr class="odd"><td><p>{415}</p></td><td><p>Unsupported Media Type - e.g. clients sends request body without content type.</p></td><td><p>{POST}, {PUT}, {PATCH}, {DELETE}</p></td></tr><tr class="even"><td><p>{423}</p></td><td><p>Locked - Pessimistic locking, e.g. processing states.</p></td><td><p>{PUT}, {PATCH}, {DELETE}</p></td></tr><tr class="odd"><td><p>{428}</p></td><td><p>Precondition Required - server requires the request to be conditional, e.g. to make sure that the "lost update problem" is avoided (see <a href="#181">???</a>).</p></td><td><p>{ALL}</p></td></tr><tr class="even"><td><p>{429}</p></td><td><p>Too many requests - the client does not consider rate limiting and sent too many requests (see <a href="#153">{MUST} Use Code 429 with Headers for Rate Limits</a>).</p></td><td><p>{ALL}</p></td></tr></tbody></table>

Server Side Error Codes:
------------------------

<table><colgroup><col style="width: 10%" /><col style="width: 70%" /><col style="width: 20%" /></colgroup><thead><tr class="header"><th>Code</th><th>Meaning</th><th>Methods</th></tr></thead><tbody><tr class="odd"><td><p>{500}</p></td><td><p>Internal Server Error - a generic error indication for an unexpected server execution problem (here, client retry may be sensible)</p></td><td><p>{ALL}</p></td></tr><tr class="even"><td><p>{501}</p></td><td><p>Not Implemented - server cannot fulfill the request (usually implies future availability, e.g. new feature).</p></td><td><p>{ALL}</p></td></tr><tr class="odd"><td><p>{503}</p></td><td><p>Service Unavailable - service is (temporarily) not available (e.g. if a required component or downstream service is not available) — client retry may be sensible. If possible, the service should indicate how long the client should wait by setting the {Retry-After} header.</p></td><td><p>{ALL}</p></td></tr></tbody></table>

{MUST} Use Most Specific HTTP Status Codes
==========================================

You must use the most specific HTTP status code when returning information about your request processing status or error situations.

{MUST} Use Code 207 for Batch or Bulk Requests
==============================================

Some APIs are required to provide either *batch* or *bulk* requests using {POST} for performance reasons, i.e. for communication and processing efficiency. In this case services may be in need to signal multiple response codes for each part of an batch or bulk request. As HTTP does not provide proper guidance for handling batch/bulk requests and responses, we herewith define the following approach:

-   A batch or bulk request **always** has to respond with HTTP status code {207}, unless it encounters a generic or unexpected failure before looking at individual parts.

-   A batch or bulk response with status code {207} **always** returns a multi-status object containing sufficient status and/or monitoring information for each part of the batch or bulk request.

-   A batch or bulk request may result in a status code {4xx}/{5xx}, only if the service encounters a failure before looking at individual parts or, if an unanticipated failure occurs.

The before rules apply *even in the case* that processing of all individual part *fail* or each part is executed *asynchronously*! They are intended to allow clients to act on batch and bulk responses by inspecting the individual results in a consistent way.

**Note**: while a *batch* defines a collection of requests triggering independent processes, a *bulk* defines a collection of independent resources created or updated together in one request. With respect to response processing this distinction normally does not matter.

{MUST} Use Code 429 with Headers for Rate Limits
================================================

APIs that wish to manage the request rate of clients must use the {429} (Too Many Requests) response code, if the client exceeded the request rate (see {RFC-6585}\[RFC 6585\]). Such responses must also contain header information providing further details to the client. There are two approaches a service can take for header information:

-   Return a {Retry-After} header indicating how long the client ought to wait before making a follow-up request. The Retry-After header can contain a HTTP date value to retry after or the number of seconds to delay. Either is acceptable but APIs should prefer to use a delay in seconds.

-   Return a trio of `X-RateLimit` headers. These headers (described below) allow a server to express a service level in the form of a number of allowing requests within a given window of time and when the window is reset.

The `X-RateLimit` headers are:

-   `X-RateLimit-Limit`: The maximum number of requests that the client is allowed to make in this window.

-   `X-RateLimit-Remaining`: The number of requests allowed in the current window.

-   `X-RateLimit-Reset`: The relative time in seconds when the rate limit window will be reset. **Beware** that this is different to Github and Twitter’s usage of a header with the same name which is using UTC epoch seconds instead.

The reason to allow both approaches is that APIs can have different needs. Retry-After is often sufficient for general load handling and request throttling scenarios and notably, does not strictly require the concept of a calling entity such as a tenant or named account. In turn this allows resource owners to minimise the amount of state they have to carry with respect to client requests. The 'X-RateLimit' headers are suitable for scenarios where clients are associated with pre-existing account or tenancy structures. 'X-RateLimit' headers are generally returned on every request and not just on a 429, which implies the service implementing the API is carrying sufficient state to track the number of requests made within a given window for each named entity.

{MUST} Use Problem JSON
=======================

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

**Hint** for backward compatibility: A previous version of this guideline (before the publication of {RFC-7807}\[RFC 7807\] and the registration of the media type) told to return custom variant of the media type `application/x.problem+json`. Servers for APIs defined before this change should pay attention to the `Accept` header sent by the client and set the `Content-Type` header of the problem response correspondingly. Clients of such APIs should accept both media types.

{MUST} Do not expose Stack Traces
=================================

Stack traces contain implementation details that are not part of an API, and on which clients should never rely. Moreover, stack traces can leak sensitive information that partners and third parties are not allowed to receive and may disclose insights about vulnerabilities to attackers.
