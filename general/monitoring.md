---
layout: default
title: Monitoring
parent: General Principles
nav_order: 2
---

# Monitoring
{: .no_toc }

Monitoring the API serves three main purposes:

1. Make sure the API provides the declared service level
1. Understanding the usage of the API and its endpoints
1. Detect misuse - erroneous and fraudulent

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## `MUST` Applications Support OpenTelemetry

Distributed Tracing over multiple applications, teams and even across large solutions is very important in root cause analysis and helps detect how latencies are stacked up and where incidents are located and thus can significantly shorten _mean time to repair_ (MTTR).

To identify a specific request through the entire chain and beyond team boundaries every team (and API) `MUST` use [OpenTelemetry](https://opentelemetry.io/) as its way to trace calls and business transactions. Teams `MUST` use standard [W3C Trace Context](https://www.w3.org/TR/trace-context/) Headers, as they are the common standard for distributed tracing and are supported by most of the cloud platforms and monitoring tools. We explicitly use W3C standards for eventing too and do not differ between synchronous and asynchronous requests, as we want to be able to see traces across the boundaries of these two architectural patterns.

### Traceparent
{: .no_toc }

`traceparent`: ${version}-${trace-id}-${parent-id}-${trace-flags}

The traceparent HTTP header field identifies the incoming request in a tracing system. The _trace-id_ defines the trace through the whole forest of synchronous and asynchronous requests. The _parent-id_ defines a specific span within a trace.

### Tracestate
{: .no_toc }
`tracestate`: key1=value1,key2=value2,...

The tracestate HTTP header field specifies application and/or APM Tool specific key/value pairs.

---

## `MUST` Infrastructure Supports OpenTelemetry

Every component like the API Management gateway, web application firewalls or other reverse proxies have to support and log the tracing headers too.
