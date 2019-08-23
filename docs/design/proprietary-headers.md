---
layout: default
title: Proprietary Headers
parent: API Design
nav_order: 19
---

This section shares definitions of proprietary headers that should be named consistently because they address overarching service-related concerns. Whether services support these concerns or not is optional; therefore, the OpenAPI API specification is the right place to make this explicitly visible. Use the parameter definitions of the resource HTTP methods.

{MUST} Use Only the Specified Proprietary Zalando Headers
=========================================================

As a general rule, proprietary HTTP headers should be avoided. Still they can be useful in cases where context needs to be passed through multiple services in an end-to-end fashion. As such, a valid use-case for a proprietary header is providing context information, which is not a part of the actual API, but is needed by subsequent communication.

From a conceptual point of view, the semantics and intent of an operation should always be expressed by URLs path and query parameters, the method, and the content. Headers are more often used to implement functions close to the protocol considerations, such as flow control, content negotiation, and authentication. Thus, headers are reserved for general context information ({RFC-7231}\#section-5\[RFC 7231\]).

`X-` headers were initially reserved for unstandardized parameters, but the usage of `X-` headers is deprecated ({RFC-6648}\[RFC 6648\]). This complicates the contract definition between consumer and producer of an API following these guidelines, since there is no aligned way of using those headers. Because of this, the guidelines restrict which `X-` headers can be used and how they are used.

The Internet Engineering Task Force’s states in {RFC-6648}\[RFC 6648\] that company specific header' names should incorporate the organization’s name. We aim for backward compatibility, and therefore keep the `X-` prefix.

The following proprietary headers have been specified by this guideline for usage so far. Remember that HTTP header field names are not case-sensitive.

<table><colgroup><col style="width: 15%" /><col style="width: 10%" /><col style="width: 60%" /><col style="width: 15%" /></colgroup><thead><tr class="header"><th>Header field name</th><th>Type</th><th>Description</th><th>Header field value example</th></tr></thead><tbody><tr class="odd"><td><p>{X-Flow-ID}</p></td><td><p>String</p></td><td><p>For more information see <a href="#233">{MUST} Support </a>.</p></td><td><p>GKY7oDhpSiKY_gAAAABZ_A</p></td></tr><tr class="even"><td><p>{X-Tenant-ID}</p></td><td><p>String</p></td><td><p>Identifies the tenant initiated the request to the multi tenant Zalando Platform. The {X-Tenant-ID} must be set according to the Business Partner ID extracted from the OAuth token when a request from a Business Partner hits the Zalando Platform.</p></td><td><p>9f8b3ca3-4be5-436c-a847-9cd55460c495</p></td></tr><tr class="odd"><td><p>{X-Sales-Channel}</p></td><td><p>String</p></td><td><p>Sales channels are owned by retailers and represent a specific consumer segment being addressed with a specific product assortment that is offered via CFA retailer catalogs to consumers (see <a href="https://pages.github.bus.zalan.do/core-platform/docs/glossary/glossary.html">platform glossary (internal link)</a>)</p></td><td><p>52b96501-0f8d-43e7-82aa-8a96fab134d7</p></td></tr><tr class="even"><td><p>{X-Frontend-Type}</p></td><td><p>String</p></td><td><p>Consumer facing applications (CFAs) provide business experience to their customers via different frontend application types, for instance, mobile app or browser. Info should be passed-through as generic aspect — there are diverse concerns, e.g. pushing mobiles with specific coupons, that make use of it. Current range is mobile-app, browser, facebook-app, chat-app</p></td><td><p>mobile-app</p></td></tr><tr class="odd"><td><p>{X-Device-Type}</p></td><td><p>String</p></td><td><p>There are also use cases for steering customer experience (incl. features and content) depending on device type. Via this header info should be passed-through as generic aspect. Current range is smartphone, tablet, desktop, other.</p></td><td><p>tablet</p></td></tr><tr class="even"><td><p>{X-Device-OS}</p></td><td><p>String</p></td><td><p>On top of device type above, we even want to differ between device platform, e.g. smartphone Android vs. iOS. Via this header info should be passed-through as generic aspect. Current range is iOS, Android, Windows, Linux, MacOS.</p></td><td><p>Android</p></td></tr><tr class="odd"><td><p>{X-Mobile-Advertising-Id}</p></td><td><p>String</p></td><td><p>It is either the <a href="https://developer.apple.com/documentation/adsupport/asidentifiermanager">IDFA</a> (Apple Identifier for mobile Advertising) for iOS, or the <a href="https://support.google.com/googleplay/android-developer/answer/6048248">GAID</a> (Google mobile Advertising Identifier) for Android. It is a unique, customer-resettable identifier provided by mobile device’s operating system to faciliate personalized advertising, and usually passed by mobile apps via http header when calling backend services. Called services should be ready to pass this parameter through when calling other services. It is not sent if the customer disables it in the settings for respective mobile platform.</p></td><td><p>b89fadce-1f42-46aa-9c83-b7bc49e76e1f</p></td></tr></tbody></table>

**Exception:** The only exception to this guideline are the conventional hop-by-hop `X-RateLimit-` headers which can be used as defined in [???](#153).

{MUST} Propagate Proprietary Headers
====================================

All Zalando’s proprietary headers are end-to-end headers. [1]) defines two types of headers: end-to-end and hop-by-hop headers. End-to-end headers must be transmitted to the ultimate recipient of a request or response. Hop-by-hop headers, on the contrary, are meaningful for a single connection only.\]

All headers specified above must be propagated to the services down the call chain. The header names and values must remain unchanged.

For example, the values of the custom headers like `X-Device-Type` can affect the results of queries by using device type information to influence recommendation results. Besides, the values of the custom headers can influence the results of the queries (e.g. the device type information influences the recommendation results).

Sometimes the value of a proprietary header will be used as part of the entity in a subsequent request. In such cases, the proprietary headers must still be propagated as headers with the subsequent request, despite the duplication of information.

{MUST} Support `X-Flow-ID`
==========================

The *Flow-ID* is a generic parameter to be passed through service APIs and events and written into log files and traces. A consequent usage of the *Flow-ID* facilitates the tracking of call flows through our system and allows the correlation of service activities initiated by a specific call. This is extremely helpful for operational troubleshooting and log analysis. Main use case of *Flow-ID* is to track service calls of our SaaS fashion commerce platform and initiated internal processing flows (executed synchronously via APIs or asynchronously via published events).

**Data Definition**

The *Flow-ID* must be passed through:

-   RESTful API requests via {X-Flow-ID} proprietary header (see [{MUST} Propagate Proprietary Headers](#184))

-   Published events via `flow_id` event field (see [metadata](#event-metadata))

It must be an random unique string consisting of maximal 128 chars, restricted to the character set `[a-zA-Z0-9/+]` (Base64).

**Note:** If a legacy subsystem can only process *Flow-IDs* with a specific format or length, it must define this restrictions in its API specification, and be generous and remove invalid characters or cut the length to the supported limit.

**Hint:** In case distributed tracing is supported by {SRE-Tracing}\[OpenTracing (internal link)\] you should ensure that created *spans* are tagged using `flow_id` — see {SRE-Tracing}/blob/master/wg-semantic-conventions/best-practices/flowid.md\[How to Connect Log Output with OpenTracing Using Flow-IDs (internal link)\] or {SRE-Tracing}/blob/master/wg-semantic-conventions/best-practices.md\[Best practises (internal link)\].

**Service Guidance**

-   Services **must** support *Flow-ID* as generic input, i.e.

    -   RESTful API endpoints **must** support {X-Flow-ID} header in requests

    -   Event listeners **must** support the metadata `flow-id` from events.

    **Note:** API-Clients **must** provide *Flow-ID* when calling a service or producing events. If no *Flow-ID* is provided in a request or event, the service must create a new *Flow-ID*.

-   Services **must** propagate *Flow-ID*, i.e. use *Flow-ID* received with API-Calls or consumed events as…​

    -   input for all API called and events published during processing

    -   data field written for logging and tracing

**Hint:** This rule also applies to application internal interfaces and events not published via Nakadi (but e.g. via AWS SQS, Kinesis or service specific DB solutions).

[1] HTTP/1.1 standard ({RFC-7230}\#section-6.1\[RFC 7230
