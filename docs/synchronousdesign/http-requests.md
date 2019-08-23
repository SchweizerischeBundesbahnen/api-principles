---
layout: default
title: HTTP Requests
parent: Synchronous-API Design
nav_order: 11
---

{MUST} Use HTTP Methods Correctly
=================================

Be compliant with the standardized HTTP method semantics summarized as follows:

GET
---

{GET} requests are used to **read** either a single or a collection resource.

-   {GET} requests for individual resources will usually generate a {404} if the resource does not exist

-   {GET} requests for collection resources may return either {200} (if the collection is empty) or {404} (if the collection is missing)

-   {GET} requests must NOT have a request body payload (see {GET-with-Body})

**Note:** {GET} requests on collection resources should provide sufficient [filter](#137) and [???](#pagination) mechanisms.

GET with Body
-------------

APIs sometimes face the problem, that they have to provide extensive structured request information with {GET}, that may conflict with the size limits of clients, load-balancers, and servers. As we require APIs to be standard conform (body in {GET} must be ignored on server side), API designers have to check the following two options:

1.  {GET} with URL encoded query parameters: when it is possible to encode the request information in query parameters, respecting the usual size limits of clients, gateways, and servers, this should be the first choice. The request information can either be provided via multiple query parameters or by a single structured URL encoded string.

2.  {POST} with body content: when a {GET} with URL encoded query parameters is not possible, a {POST} with body content must be used. In this case the endpoint must be documented with the hint {GET-with-Body} to transport the {GET} semantic of this call.

**Note:** It is no option to encode the lengthy structured request information using header parameters. From a conceptual point of view, the semantic of an operation should always be expressed by the resource names, as well as the involved path and query parameters. In other words by everything that goes into the URL. Request headers are reserved for general context information (see [???](#183)). In addition, size limits on query parameters and headers are not reliable and depend on clients, gateways, server, and actual settings. Thus, switching to headers does not solve the original problem.

**Hint:** As {GET-with-body} is used to transport extensive query parameters, the {cursor} cannot any longer be used to encode the query filters in case of [cursor-based pagination](#160). As a consequence, it is best practice to transport the query filters in the body, while using [pagination links](#161) containing the {cursor} that is only encoding the page position and direction. To protect the pagination sequence the {cursor} may contain a hash over all applied query filters (See also [???](#161)).

PUT
---

{PUT} requests are used to **update** (in rare cases to create) **entire** resources – single or collection resources. The semantic is best described as *"please put the enclosed representation at the resource mentioned by the URL, replacing any existing resource."*.

-   {PUT} requests are usually applied to single resources, and not to collection resources, as this would imply replacing the entire collection

-   {PUT} requests are usually robust against non-existence of resources by implicitly creating before updating

-   on successful {PUT} requests, the server will **replace the entire resource** addressed by the URL with the representation passed in the payload (subsequent reads will deliver the same payload)

-   successful {PUT} requests will usually generate {200} or {204} (if the resource was updated – with or without actual content returned), and {201} (if the resource was created)

**Important:** It is best practice to prefer {POST} over {PUT} for creation of (at least top-level) resources. This leaves the resource ID under control of the service and allows to concentrate on the update semantic using {PUT} as follows.

**Note:** In the rare cases where {PUT} is although used for resource creation, the resource IDs are maintained by the client and passed as a URL path segment. Putting the same resource twice is required to be [idempotent](#idempotent) and to result in the same single resource instance (see [{MUST} Fulfill Common Method Properties](#149)).

**Hint:** To prevent unnoticed concurrent updates and duplicate creations when using {PUT}, you [???](#182) to allow the server to react on stricter demands that expose conflicts and prevent lost updates. See also [???](#optimistic-locking) for details and options.

POST
----

{POST} requests are idiomatically used to **create** single resources on a collection resource endpoint, but other semantics on single resources endpoint are equally possible. The semantic for collection endpoints is best described as *"please add the enclosed representation to the collection resource identified by the URL"*.

-   on a successful {POST} request, the server will create one or multiple new resources and provide their URI/URLs in the response

-   successful {POST} requests will usually generate {200} (if resources have been updated), {201} (if resources have been created), {202} (if the request was accepted but has not been finished yet), and exceptionally {204} with {Location} header (if the actual resource is not returned).

The semantic for single resource endpoints is best described as *"please execute the given well specified request on the resource identified by the URL"*.

**Generally:** {POST} should be used for scenarios that cannot be covered by the other methods sufficiently. In such cases, make sure to document the fact that {POST} is used as a workaround (see {GET-with-Body}).

**Note:** Resource IDs with respect to {POST} requests are created and maintained by server and returned with response payload.

**Hint:** Posting the same resource twice is **not** required to be [idempotent](#idempotent) (check [{MUST} Fulfill Common Method Properties](#149)) and may result in multiple resources. However, you [{SHOULD} Consider To Design and Idempotent](#229) to prevent this.

PATCH
-----

{PATCH} requests are used to **update parts** of single resources, i.e. where only a specific subset of resource fields should be replaced. The semantic is best described as *"please change the resource identified by the URL according to my change request"*. The semantic of the change request is not defined in the HTTP standard and must be described in the API specification by using suitable media types.

-   {PATCH} requests are usually applied to single resources as patching entire collection is challenging

-   {PATCH} requests are usually not robust against non-existence of resource instances

-   on successful {PATCH} requests, the server will update parts of the resource addressed by the URL as defined by the change request in the payload

-   successful {PATCH} requests will usually generate {200} or {204} (if resources have been updated with or without updated content returned)

**Note:** since implementing {PATCH} correctly is a bit tricky, we strongly suggest to choose one and only one of the following patterns per endpoint, unless forced by a [backwards compatible change](#106). In preference order:

1.  use {PUT} with complete objects to update a resource as long as feasible (i.e. do not use {PATCH} at all).

2.  use {PATCH} with partial objects to only update parts of a resource, whenever possible. (This is basically {RFC-7396}\[JSON Merge Patch\], a specialized media type `application/merge-patch+json` that is a partial resource representation.)

3.  use {PATCH} with {RFC-6902}\[JSON Patch\], a specialized media type `application/json-patch+json` that includes instructions on how to change the resource.

4.  use {POST} (with a proper description of what is happening) instead of {PATCH}, if the request does not modify the resource in a way defined by the semantics of the media type.

In practice {RFC-7396}\[JSON Merge Patch\] quickly turns out to be too limited, especially when trying to update single objects in large collections (as part of the resource). In this cases {RFC-6902}\[JSON Patch\] can shown its full power while still showing readable patch requests (see also [JSON patch vs. merge](http://erosb.github.io/post/json-patch-vs-merge-patch)).

**Note:** Patching the same resource twice is **not** required to be [idempotent](#idempotent) (check [{MUST} Fulfill Common Method Properties](#149)) and may result in a changing result. However, you [{SHOULD} Consider To Design and Idempotent](#229) to prevent this.

**Hint:** To prevent unnoticed concurrent updates when using {PATCH} you [???](#182) to allow the server to react on stricter demands that expose conflicts and prevent lost updates. See [???](#optimistic-locking) and [{SHOULD} Consider To Design and Idempotent](#229) for details and options.

DELETE
------

{DELETE} requests are used to **delete** resources. The semantic is best described as *"please delete the resource identified by the URL"*.

-   {DELETE} requests are usually applied to single resources, not on collection resources, as this would imply deleting the entire collection

-   successful {DELETE} requests will usually generate {200} (if the deleted resource is returned) or {204} (if no content is returned)

-   failed {DELETE} requests will usually generate {404} (if the resource cannot be found) or {410} (if the resource was already deleted before)

**Important:** After deleting a resource with {DELETE}, a {GET} request on the resource is expected to either return {404} (not found) or {410} (gone) depending on how the resource is represented after deletion. Under no circumstances the resource must be accessible after this operation on its endpoint.

HEAD
----

{HEAD} requests are used to **retrieve** the header information of single resources and resource collections.

-   {HEAD} has exactly the same semantics as {GET}, but returns headers only, no body.

**Hint:** {HEAD} is particular useful to efficiently lookup whether large resources or collection resources have been updated in conjunction with the {ETag}-header.

OPTIONS
-------

{OPTIONS} requests are used to **inspect** the available operations (HTTP methods) of a given endpoint.

-   {OPTIONS} responses usually either return a comma separated list of methods in the `Allow` header or as a structured list of link templates

**Note:** {OPTIONS} is rarely implemented, though it could be used to self-describe the full functionality of a resource.

{MUST} Fulfill Common Method Properties
=======================================

Request methods in RESTful services can be…​

-   {RFC-safe} - the operation semantic is defined to be read-only, meaning it must not have *intended side effects*, i.e. changes, to the server state.

-   {RFC-idempotent} - the operation has the same *intended effect* on the server state, independently whether it is executed once or multiple times. **Note:** this does not require that the operation is returning the same response or status code.

-   {RFC-cacheable} - to indicate that responses are allowed to be stored for future reuse. In general, requests to safe methods are cachable, if it does not require a current or authoritative response from the server.

**Note:** The above definitions, of *intended (side) effect* allows the server to provide additional state changing behavior as logging, accounting, pre- fetching, etc. However, these actual effects and state changes, must not be intended by the operation so that it can be held accountable.

Method implementations must fulfill the following basic properties according to {RFC-7231}\[RFC 7231\]:

<table style="width:100%;"><colgroup><col style="width: 15%" /><col style="width: 15%" /><col style="width: 35%" /><col style="width: 35%" /></colgroup><thead><tr class="header"><th>Method</th><th>Safe</th><th>Idempotent</th><th>Cacheable</th></tr></thead><tbody><tr class="odd"><td><p>{GET}</p></td><td><p>{YES}</p></td><td><p>{YES}</p></td><td><p>{YES}</p></td></tr><tr class="even"><td><p>{HEAD}</p></td><td><p>{YES}</p></td><td><p>{YES}</p></td><td><p>{YES}</p></td></tr><tr class="odd"><td><p>{POST}</p></td><td><p>{NO}</p></td><td><p>{AT} No, but <a href="#229">{SHOULD} Consider To Design and Idempotent</a></p></td><td><p>{AT} May, but only if specific {POST} endpoint is <a href="#safe">safe</a>. <strong>Hint:</strong> not supported by most caches.</p></td></tr><tr class="even"><td><p>{PUT}</p></td><td><p>{NO}</p></td><td><p>{YES}</p></td><td><p>{NO}</p></td></tr><tr class="odd"><td><p>{PATCH}</p></td><td><p>{NO}</p></td><td><p>{AT} No, but <a href="#229">{SHOULD} Consider To Design and Idempotent</a></p></td><td><p>{NO}</p></td></tr><tr class="even"><td><p>{DELETE}</p></td><td><p>{NO}</p></td><td><p>{YES}</p></td><td><p>{NO}</p></td></tr><tr class="odd"><td><p>{OPTIONS}</p></td><td><p>{YES}</p></td><td><p>{YES}</p></td><td><p>{NO}</p></td></tr><tr class="even"><td><p>{TRACE}</p></td><td><p>{YES}</p></td><td><p>{YES}</p></td><td><p>{NO}</p></td></tr></tbody></table>

**Note:** [???](#227).

{SHOULD} Consider To Design `POST` and `PATCH` Idempotent
=========================================================

In many cases it is helpful or even necessary to design {POST} and {PATCH} [idempotent](#idempotent) for clients to expose conflicts and prevent resource duplicate (a.k.a. zombie resources) or lost updates, e.g. if same resources may be created or changed in parallel or multiple times. To design an [idempotent](#idempotent) API endpoint owners should consider to apply one of the following three patterns.

-   A resource specific **conditional key** provided via [`If-Match` header](#182) in the request. The key is in general a meta information of the resource, e.g. a *hash* or *version number*, often stored with it. It allows to detect concurrent creations and updates to ensure [idempotent](#idempotent) behavior (see [???](#182)).

-   A resource specific **secondary key** provided as resource property in the request body. The *secondary key* is stored permanently in the resource. It allows to ensure [idempotent](#idempotent) behavior by looking up the unique secondary key in case of multiple independent resource creations from different clients (see [{Should} Use Secondary Key for Idempotent Design](#231)).

-   A client specific **idempotency key** provided via {Idempotency-Key} header in the request. The key is not part of the resource but stored temporarily pointing to the original response to ensure [idempotent](#idempotent) behavior when retrying a request (see [???](#230)).

**Note:** While **conditional key** and **secondary key** are focused on handling concurrent requests, the **idempotency key** is focused on providing the exact same responses, which is even a *stronger* requirement than the [idempotency defined above](#idempotent). It can be combined with the two other patterns.

To decide, which pattern is suitable for your use case, please consult the following table showing the major properties of each pattern:

<table><colgroup><col style="width: 46%" /><col style="width: 18%" /><col style="width: 18%" /><col style="width: 18%" /></colgroup><thead><tr class="header"><th></th><th>Conditional Key</th><th>Secondary Key</th><th>Idempotency Key</th></tr></thead><tbody><tr class="odd"><td><p>Applicable with</p></td><td><p>{PATCH}</p></td><td><p>{POST}</p></td><td><p>{POST}/{PATCH}</p></td></tr><tr class="even"><td><p>HTTP Standard</p></td><td><p>{YES}</p></td><td><p>{NO}</p></td><td><p>{NO}</p></td></tr><tr class="odd"><td><p>Prevents duplicate (zombie) resources</p></td><td><p>{YES}</p></td><td><p>{YES}</p></td><td><p>{NO}</p></td></tr><tr class="even"><td><p>Prevents concurrent lost updates</p></td><td><p>{YES}</p></td><td><p>{NO}</p></td><td><p>{NO}</p></td></tr><tr class="odd"><td><p>Supports safe retries</p></td><td><p>{YES}</p></td><td><p>{YES}</p></td><td><p>{YES}</p></td></tr><tr class="even"><td><p>Supports exact same response</p></td><td><p>{NO}</p></td><td><p>{NO}</p></td><td><p>{YES}</p></td></tr><tr class="odd"><td><p>Can be inspected (by intermediaries)</p></td><td><p>{YES}</p></td><td><p>{NO}</p></td><td><p>{YES}</p></td></tr><tr class="even"><td><p>Usable without previous {GET}</p></td><td><p>{NO}</p></td><td><p>{YES}</p></td><td><p>{YES}</p></td></tr></tbody></table>

**Note:** The patterns applicable to {PATCH} can be applied in the same way to {PUT} and {DELETE} providing the same properties.

If you mainly aim to support safe retries, we suggest to apply [conditional key](#182) and [secondary key](#231) pattern before the [Idempotency Key](#230) pattern.

{Should} Use Secondary Key for Idempotent `POST` Design
=======================================================

The most important pattern to design {POST} [idempotent](#idempotent) for creation is to introduce a resource specific **secondary key** provided in the request body, to eliminate the problem of duplicate (a.k.a zombie) resources.

The secondary key is stored permanently in the resource as *alternate key* or *combined key* (if consisting of multiple properties) guarded by a uniqueness constraint enforced server-side, that is visible when reading the resource. The best and often naturally existing candidate is a *unique foreign key*, that points to another resource having *one-on-one* relationship with the newly created resource, e.g. a parent process identifier.

A good example here for a secondary key is the shopping cart ID in an order resource.

**Note:** When using the secondary key pattern without {Idempotency-Key} all subsequent retries should fail with status code {409} (conflict). We suggest to avoid {200} here unless you make sure, that the delivered resource is the original one implementing a well defined behavior. Using {204} without content would be a similar well defined option.

{MUST} Define Collection Format of Header and Query Parameters
==============================================================

Header and query parameters allow to provide a collection of values, either by providing a comma-separated list of values or by repeating the parameter multiple times with different values as follows:

<table><colgroup><col style="width: 14%" /><col style="width: 30%" /><col style="width: 39%" /><col style="width: 17%" /></colgroup><thead><tr class="header"><th>Parameter Type</th><th>Comma-separated Values</th><th>Multiple Parameters</th><th>Standard</th></tr></thead><tbody><tr class="odd"><td><p>Header</p></td><td><p><code>Header: value1,value2</code></p></td><td><p><code>Header: value1, Header: value2</code></p></td><td><p>{RFC-7230}#section-3.2.2[RFC 7230 Section 3.2.2]</p></td></tr><tr class="even"><td><p>Query</p></td><td><p><code>?param=value1,value2</code></p></td><td><p><code>?param=value1&amp;param=value2</code></p></td><td><p>{RFC-6570}#section-3.2.8[RFC 6570 Section 3.2.8]</p></td></tr></tbody></table>

As Open API does not support both schemas at once, an API specification must explicitly define the collection format to guide consumers as follows:

<table><colgroup><col style="width: 14%" /><col style="width: 40%" /><col style="width: 46%" /></colgroup><thead><tr class="header"><th>Parameter Type</th><th>Comma-separated Values</th><th>Multiple Parameters</th></tr></thead><tbody><tr class="odd"><td><p>Header</p></td><td><p><code>style: simple, explode: false</code></p></td><td><p>not allowed (see {RFC-7230}#section-3.2.2[RFC 7230 Section 3.2.2])</p></td></tr><tr class="even"><td><p>Query</p></td><td><p><code>style: form, explode: false</code></p></td><td><p><code>style: form, explode: true</code></p></td></tr></tbody></table>

When choosing the collection format, take into account the tool support, the escaping of special characters and the maximal URL length.

{MUST} Document Implicit Filtering
==================================

Sometimes certain collection resources or queries will not list all the possible elements they have, but only those for which the current client is authorized to access.

Implicit filtering could be done on:

-   the collection of resources being return on a parent {GET} request

-   the fields returned for the resource’s detail

In such cases, the implicit filtering must be in the API specification (in its description).

Consider [caching considerations](#227) when implicitely filtering.

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
