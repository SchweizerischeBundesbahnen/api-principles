---
layout: default
title: Proprietary Headers
parent: Synchronous-API Design
nav_order: 19
---

This section shares definitions of proprietary headers that should be named consistently because they address overarching service-related concerns. Whether services support these concerns or not is optional; therefore, the OpenAPI API specification is the right place to make this explicitly visible. Use the parameter definitions of the resource HTTP methods.

{SHOULD} Separation of concerns
=========================================================
From a conceptual point of view, the semantics and intent of an operation should always be expressed by URLs path and query parameters, the method, and the content. Headers are more often used to implement functions close to the protocol considerations, such as flow control, content negotiation, and authentication. Thus, headers are reserved for general context information ({RFC-7231}\#section-5\[RFC 7231\]).

So your request will be split in three parts.
- URI: identifies the object
- Body: contains the object information
- Headers: contains additional context information

**Exception:** The only exception of this principe is the version information in the URI. For more inofrmation visit {link zum versions zügs}



{SHOULD} Support `X-Correlation-ID`
==========================

The *X-Correlation-ID* is a generic parameter to be passed through service APIs and events and written into log files and traces. A consequent usage of the *X-Correlation-ID* facilitates the tracking of call flows through our system and allows the correlation of service activities initiated by a specific call. This is extremely helpful for operational troubleshooting and log analysis. 

It must be an random unique string consisting of maximal 128 chars, restricted to the character set `[a-zA-Z0-9/+]` (Base64).

**Note:** If a legacy subsystem can only process *X-Correlation-ID* with a specific format or length, it must define this restrictions in its API specification, and be generous and remove invalid characters or cut the length to the supported limit.


**Service Guidance**

-   Services **should** support *X-Correlation-ID* as generic input, i.e.

    -   RESTful API endpoints **should** support {X-Correlation-ID} header in requests
    
    **Note:** API-Clients **should** provide *X-Correlation-ID* when calling a service or producing events. If no *X-Correlation-ID* is provided in a request or event, the service must create a new *X-Correlation-ID*.

-   Services **should** propagate *X-Correlation-ID*, i.e. use *X-Correlation-ID* received with API-Calls or consumed events as…​

    -   input for all API called and events published during processing

    -   data field written for logging and tracing
