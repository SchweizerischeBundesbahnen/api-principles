---
layout: default
title: Best Practices
parent: Event-Driven APIs
nav_order: 2
---

# Best Practices
{: .no_toc }

This chapter serves as a supplemental knowledge base for designing event-driven APIs.  
It compiles best practices, patterns, and lessons learned from real-world experience.  
Engineers are encouraged to review this section for practical guidance on event-driven API design and implementation.

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## General API Design Principles

Before creating a new API, it is important to determine which integration type best fits the use case.  
Event-driven APIs offer significant advantages in decoupling systems at runtime.  
However, they also introduce challenges that are less prominent in request/response-based approaches such as RESTful APIs.

Event-driven asynchronous APIs are best used in scenarios where a **“fire-and-forget”** interaction model applies - in other words, when the producer does not require an immediate response from the consumer and eventual consistency is sufficient.

### Follow API First Principle

You should follow the API First Principle, more specifically:

- You should design APIs first, before coding its implementation.
- Ensure API design is consistent with the guidelines specified in the API Principles, taking into account the recommendations in these best practices.
- You should call for early review feedback from peers and client developers. Also consider to apply for a lightweight review by the API Team.

See also the principle [Design API first](https://schweizerischebundesbahnen.github.io/api-principles/architecture/#must-design-api-first).

### Provide API User Manual

In addition to the API Specification, it is good practice to provide an API user manual to improve API consumer experience.

API specification defines the technical contract (channels and schemas) but it rarely captures the full business process. This manual is essential for a consumer to understand the **behavior and context** of the events.

A helpful user manual for an event-driven API typically describes:

- Domain Knowledge and context, including API scope, purpose, and use cases.
- Business Process Flows: The expected *sequence* of events.
- Concrete examples of API usage (for example, event payloads for all major use cases, ..).
- Edge cases, error situation details, and repair hints.
- Architecture context and major dependencies - including figures and sequence flows.

## Compatibility

### Use Schema Management Registry

If you are sharing data with consumers outside the scope of your application, you will want to make sure that the schemas involved are actively managed. Doing so early in the pipeline will prevent your downstream consumers from deserialization and processing issues at a later time (in the worst case: in production).

Schema Management involves publication, distribution and lifecycle control of message schemas published by asynchronous APIs.
Use a centralized schema management registry (e.g. Confluent Schema Registry or Red Hat Service Registry) for:

- creating, updating and deleting schemas.
- sharing schemas, making them available to downstream consumers.
- implementing schema evolution rules to enforce compatible changes of the schema.
- validating messages against the schema at runtime.

#### References

- [Schema Registry - Key Concepts](https://developer.confluent.io/courses/schema-registry/key-concepts/)
- [Kafka Schema Registry Training (internal link)](https://confluence.sbb.ch/spaces/KAFKA/pages/1441337947/Schulungsangebot?preview=/1441337947/3211869326/sbb-kafka-schema-registry_EN.pdf)

### Provide Version Information
{: .no_toc }

In addition to the major version given by topic/queue name, the full version of the API should be written into the message header.
Use the header field `x-api-version` and write the version in [SemVer](https://semver.org/) notation.

---

## Data Formats and Schemas

In Event-driven APIs, **JSON** is the preferred data format for message payloads due to its wide adoption, broad interoperability and human readability.

### Schemas

Schemas define the structure and constraints of messages. They provide validation, tooling support, and controlled schema evolution - enabling changes to be introduced without breaking existing consumers.

Note that schemas are not just used for validation, but also for serialization and deserialization of messages. Schemas might additionally contain default values or metadata (for example: logical types) that influence how data is encoded on the wire.

There are two widely used schema formats used in event-driven systems:

- **Apache Avro**
- **JSON Schema**

### Apache Avro

Avro is the preferred schema format for strongly-typed, event-driven systems.

*Advantages*:

- Compact binary encoding, efficient for transport.
- Strong typing and closed content model → safe schema evolution (backward, forward, full).
- Rich tooling support (code generation, logical types, type-safe bindings).

*Disadvantages*:

- Typically, requires a code generation step to produce data transfer objects.
- Tooling and community support is strongest on the JVM; less mature in other ecosystems.

### JSON Schema

Use when interoperability between systems or tooling explicitly requires JSON Schema; otherwise prefer Avro Schema, and enforce strict validation.

*Advantages*:

- Native fit for JSON payloads, minimal translation overhead.
- Useful if external systems or historic JSON schemas exist.

*Disadvantages*:

- **Open vs. closed models:** JSON Schema supports closed, open, or partially-open content models:
  - **Open model:** `additionalProperties: true` → allows undeclared fields not defined in the schema.
  - **Closed model:** `additionalProperties: false` → restricts data to explicitly defined properties.
  - **Partially-open model:** allows some additional fields, while restricting others.
- The rules for **backward** and **forward** compatibility depend on which model is used. Unlike Avro, there is no single, predictable evolution contract.
- Limited tooling support for advanced clauses like: `oneOf`, `anyOf`, ..

#### References

- [Apache Avro](https://avro.apache.org/)
- [JSON Schema](https://json-schema.org/)
- [Evolving JSON Schemas](https://www.creekservice.org/articles/2024/01/08/json-schema-evolution-part-1.html)
- [Understanding JSON Schema Compatibility](https://yokota.blog/2021/03/29/understanding-json-schema-compatibility/)
- [Schema Evolution and Compatibility for Schema Registry on Confluent Platform](
   https://docs.confluent.io/platform/current/schema-registry/fundamentals/schema-evolution.html)
- [Kafka Schema Registry Training - Schema Evolution Principles (internal link)](https://confluence.sbb.ch/spaces/KAFKA/pages/1441337947/Schulungsangebot?preview=/1441337947/3211869326/sbb-kafka-schema-registry_EN.pdf)

## Implementation

### Handling of Duplicated Messages

Event consumers `SHOULD` be designed to handle duplicate messages. Most distributed messaging systems prioritize durability and therefore implement an at-least-once delivery guarantee. This means that under certain conditions, such as network issues or acknowledgment failures, a message can be delivered more than once to the consumer or written multiple times to the channel.

There are two primary strategies to handle duplicate messages:

1. **Idempotent Processing**: Ensure that consumer logic is **idempotent**, so handling the same message more than once does not cause unwanted side effects. A common approach is to use operations that can be safely repeated, such as **UPSERT**s instead of plain inserts.
1. **Deduplication Mechanism**: Implement a deduplication mechanism that tracks processed messages using unique identifiers (for example: message keys). This can be done using a database or in-memory store to keep track of which messages have already been processed, allowing the consumer to ignore duplicates.

### Platform Specifics: Apache Kafka

In the Kafka ecosystem, the **deduplication** pattern is commonly implemented using a **Kafka Streams** application using a state store to keep track of seen messages.

This application reads from a topic containing potential duplicates and uses a state store to track messages. It then writes only the unique messages to a new, clean output topic that non-idempotent consumers can safely use.

There are two main strategies for this:

- **Deduplication without Windowing**: The state store tracks all seen messages indefinitely. This is simpler but can lead to unbounded state growth.
- **Deduplication with Windowing**: The state store only tracks messages within a defined time window (for example, the last 5 minutes). This is recommended for high-volume topics as it keeps the state store's size manageable.

For concrete details on deduplication with Kafka Streams, see: [Message Deduplication with Kafka Streams (internal link)](https://confluence.sbb.ch/spaces/KAFKA/pages/3284444421/Message+Deduplication).

## Retention

The data retention strategy must balance resilience, cost, and business requirements.

We distinguish two main retention policies:

- **Time-based**: Discards messages after a specified time period (for example, 7 days).
- **Key-based**: Retains only the most recent event for each unique message key, effectively creating a snapshot of the latest state.

### Retention Strategies

#### Short-Term Retention (Default: 1-7 days)

Use this for **transactional and telemetry data** where the event log acts as a temporary buffer for decoupling services.

- **Use Cases**:
  - **Transactional Events**: `OrderPlaced`, `PaymentProcessed`. These are intended for immediate processing.
  -  **Telemetry/Metrics**: `SensorReading`, `UserClick`. High-volume data that is typically aggregated in real-time.
- **Principle**: The retention period **must** be longer than the recovery time objective (RTO) defined by the platform operations team.

#### Long-Term Retention

Longer retention is used when the data holds long-term value, such as for auditing, analytics, or to rebuild state (event sourcing).

- **Use Cases**:
  - **State / Master Data**: For channels representing entity state. This provides an infinitely retained, replayable log of the latest state for each entity. Use key-based compaction to retain only the most recent event per entity, reducing storage while keeping the latest state available.
  - **Event Sourcing / Audit Logs**: For a complete, immutable history, use **infinite time-based retention**.
- Consider privacy laws for retention time if you store personal sensitive data. Deletion of personal data can be requested by law by any person. It's not easily feasible to delete individual records in systems like Kafka.

### Summary

| Data Type | Retention Strategy | Cleanup Policy | Typical Retention Period | Architectural Pattern |
| :--- | :--- |:---------------| :--- | :--- |
| **Transactional Events** | Time-Based | `delete`       | 1-7 days | Durable Message Bus |
| **Telemetry & Metrics** | Time-Based | `delete`       | 1-7 days | Real-time Streaming |
| **State Changes / Master Data**| Key-Based (Compaction) | `compact`      | Infinite (for latest value) | Replayable State Log |
| **Audit & Compliance Logs**| Time-Based | `delete`       | Infinite / Years | System of Record |
| **Full Event History** | Time-Based | `delete`       | Infinite | Event Sourcing |

### References

- [Kafka Retention Policy: Concepts & Best Practices (2024)](https://www.automq.com/blog/kafka-retention-policy-concept-best-practices): A detailed guide on modern retention strategies, including tiered storage.
- [Limited Retention Event Stream Pattern (Confluent)](https://developer.confluent.io/patterns/event-storage/limited-retention-event-stream/): An architectural pattern guide for using Kafka as a temporary buffer.

## `SHOULD` Use Event Time for Business Logic

Messages `SHOULD` include a timestamp of when the event actually occurred in the business domain. This is required to ensure correctness for all time-sensitive logic such as sequencing, joins, and windowing.

Always distinguish between two concepts of time:

- **Event Time (Business Time)**: when the event actually occurred in the business domain.
- **Ingestion Time**: when the event was written to a topic or queue.

### Principles

- Business logic `MUST` always rely on the event time, never on ingestion time, as ingestion time as it can be affected by producer retries, network latency, or broker lag.
- The business event timestamp field `MUST` be formatted as an **ISO 8601** string (YYYY-MM-DDTHH:mm:ss.sssZ).

**Example**

```json
{
  "eventId": "a4d3a-2a2s-4d5f-b8s7-3a3d2f1l0a9s",
  "orderId": "ORD-12345",
  "status": "SHIPPED",
  "eventTimestamp": "2025-09-15T09:02:27.123Z"
}
```

### References:

- [Event Time vs. Ingestion Time in Stream Processing](https://developer.confluent.io/patterns/stream-processing/event-time-processing/)
- [Why Avro for Kafka Data (Confluent blog)](https://www.confluent.io/blog/avro-kafka-data/)

## Deprecation

### Monitor Usage of Deprecated APIs

Owners of APIs used in production should monitor usage of deprecated APIs until the API can be shut down in order to align deprecation and avoid uncontrolled breaking effects.

*Hint:*
Use [API Management (internal link)](https://confluence.sbb.ch/display/AITG/API+Management) to keep track of the usage of your APIs.
