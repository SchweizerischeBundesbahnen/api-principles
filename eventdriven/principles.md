---
layout: default
title: Principles
parent: Event-Driven APIs
nav_order: 1
---

# Principles for Event-Driven APIs
{: .no_toc }

This chapter describes a set of guidelines that must be applied when writing and publishing event-driven APIs. These APIs are usually published via topics or queues.

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Compatibility

### `MUST` Do not Break Backward Compatibility

APIs are contracts between service providers and service consumers that cannot be broken via unilateral decisions. For this reason APIs may only be changed if backward compatibility is guaranteed. If this cannot be guaranteed, a new API major version must be provided and the old one has to be supported in parallel. For deprecation, follow the principles described in the chapter about [deprecation](/api-principles/organization/#must-deprecation).

API designers should apply the following rules to evolve APIs for services in a backward-compatible way:

#### Adding Fields

- Add optional fields.
- Add mandatory fields only if they have a meaningful default value.

#### Deleting Fields

- Never delete mandatory fields.
- Optional fields may be deleted only after they have been deprecated for a reasonable time and confirmed to be unused by consumers.

#### Changing Existing Fields

- Never change the semantics of a field (for example, renaming field `customer-number` to `customer-id` alters its meaning, even though the data type remains the same).
- Do not change the field's data type (for example, from `string` to `integer`).
- Avoid making validation rules more restrictive. Event payloads might be tied to business constraints that must remain stable once published. These constraints should be documented in the schema, but tightening them (for example, narrowing allowed formats or ranges) may cause previously valid events to be rejected.

#### Working with Enums

- Producers **should not** introduce new enum values unless consumers are prepared.
- Producers may remove existing enum values. Consumers can already handle the remaining set.
- Consumer logic and schemas can be extended in advance to support new enum values that producers introduce later.
- Consumers should ignore unknown values rather than failing. This ensures robustness even if producers violate rules (see below: [Clients must be Tolerant Readers](/api-principles/eventdriven/principles/#must-clients-must-be-tolerant-readers)).

### `MUST` Clients must be Tolerant Readers

Clients of an API **must** follow the rules described in the chapter about [tolerant dependencies](/api-principles/architecture/#must-we-build-tolerant-dependencies).

## Message Design

### `MUST`  Follow Message Design Principles

The following principles apply to all parts of a message - identifiers (keys or equivalent),metadata (headers/properties), and body (payload).

### Message Types

We distinguish the following message types:

- **Notification**:

A notification is a message that informs consumers about an event that already happened. Notifications are immutable facts. Examples: `CustomerCreated`, `TicketSold`, `TrainDeparted`.

*Example payload*:

```json
{
  "eventType": "AccountCreated",
  "accountID": "8c0fd83f-ff3f-4e0e-af4b-2b7470334efa",
  "eventTimestamp": "2025-09-08T14:25:00Z"
}
```

*Notes:*

- Notifications are lightweight. They carry identifiers and minimal context.
- Notifications should always include a timestamp indicating when the event occurred.
- The full entity data are usually obtained by the consumer via:
  - a synchronous request to another service such as REST API, or
  - a join with a materialized view of a topic or queue holding the latest and complete state of the entity.

- **Event-Carried State** (aka "Documents"):

A state message provides a complete state of an entity at a specific point in time. It is used to synchronize data between systems.

*Notes:*

- There should be no distinction between **CREATE** and **UPDATE** messages.
- The **first** state message for a given entity identifier (key) is treated by the consumer as a **CREATE**. Any subsequent messages with the same identifier are handled as an **UPSERT**, updating the entity in the consumer system to reflect the latest state.
- Deletions are represented as **tombstone messages** (same identifier with an empty payload), instructing consumers that the entity should be removed.<br/><br/>

*Example use cases*:

- Customer address
- Customer account details
- Product catalog entry<br/><br/>

*Example payload*:

```json
{
  "entityType": "UserAccount",
  "id": "8c0fd83f-ff3f-4e0e-af4b-2b7470334efa",
  "name": "David Muster",
  "email": "david.muster@sbb.ch",
  "tel": {
    "type": "Mobile",
    "countryCode": "41",
    "number": "777777777"
  },
  "eventTimestamp": "2025-09-08T14:25:00Z"
}
```

**Including Previous and Current State**:

- In some scenarios, it is useful to include both the **PREVIOUS** and **CURRENT** state in the same message.
  - This pattern is common, for example, in change data capture (CDC) systems such as Debezium.
  - Providing before/after state enables consumers to understand what changed without having to compute diffs themselves.

- *Example payload* (CDC-style, Debezium):

```json
{
  "payload": {  
    "before": {
      "id": "8c0fd83f-ff3f-4e0e-af4b-2b7470334efa",
      "email": "old.email@sbb.ch"
    },
    "after": {
      "id": "8c0fd83f-ff3f-4e0e-af4b-2b7470334efa",
      "email": "new.email@sbb.ch"
    }
  },
  "op": "u",
  "ts_ms": 1694188730000
}
```

- **Command**:

Represents an instruction or request to perform an action in the future.

- Commands are addressed to specific services that are expected to act on it.
- Commands are named using the **imperative form of a verb**, for example: `CreateOrder`, `RegisterUser`, `ProcessPayment`.
- Processing a command usually results in follow-up events (for example: `DeliveryPrepared`, `PaymentAccepted`) that confirm the outcome and notify other systems to react.<br/><br/>

*Example payload*:

```json
{
  "commandType": "PurchaseTrainTicket",
  "orderId": "f1a4bcd2-55c3-4e5e-91f8-6c0e1d9f72e4",
  "customerId": "8c0fd83f-ff3f-4e0e-af4b-2b7470334efa",
  "journeys": [
    { "trainId": "IC1", "from": "Zurich HB", "to": "Geneva", 
    "time": "2025-09-20T08:30:00Z", "class": "2nd", "qty": 1 }
  ],
  "paymentMethod": "CreditCard",
  "eventTimestamp": "2025-09-08T14:25:00Z"
}
```

*Notes*:

- A command message `MUST` include a correlationId in its headers. The resulting event or reply message `MUST` use this same ID in its headers to link the follow-up event to the original command.
- A `reply-to` header `MAY` also be used to indicate where a response message should be sent (request-reply pattern). In event-driven architectures it is preferable to use correlation IDs and publish follow-up events to well-known channels instead of direct replies.
- Message payload `SHOULD` include an event timestamp indicating when the command was issued.
- Command handlers `MUST` be idempotent to safely handle message retries. This ensures a command sent multiple times (e.g., due to a network error) is only processed once. This `SHOULD` be achieved by checking the entity's current business state or `MAY` be done by tracking a unique Idempotency-Key sent as a message header by the command issuer (producer).
- Commands require knowledge of the consumer and should only be used when explicit coordination is needed.

- **Delta / Change Event**:

Contains only the changed attributes of an entity.

These messages are typically small and frequent, suitable for scenarios such as IoT signals, telemetry, or incremental updates or banking transactions.<br/><br/>

*Examples*:

- `TemperatureChanged`: `{ "sensorId": "sensor-123", "newTemperature": 22.5, "eventTimestamp": "2025-09-08T14:25:00Z" }`
- `StockLevelUpdated`: `{ "productId": "P-12345", "newStockLevel": 150, "eventTimestamp": "2025-09-08T14:25:00Z" }`<br/>

*Notes*:

- Payloads contain:
  - ID of the affected entity.
  - One or more changed values.
  - A timestamp of when the change occurred.

#### References:

- [Hope, David. "Async APIs ‒ Don’t Confuse Your Events, Commands and State." Scott Logic Blog, 22 Apr. 2024](https://blog.scottlogic.com/2024/04/22/message_types.html)
- [Amundsen, M., & Mitra, R. (2023). What are asynchronous APIs? O’Reilly Media, Inc. (ISBN 9781098147471)](https://www.oreilly.com/library/view/what-are-asynchronous/9781098147471/)
- [Debezium Documentation: Change Event Structure](https://debezium.io/documentation/reference/stable/transformations/event-changes.html#_change_event_structure)
- [Idempotent Command Handling](https://event-driven.io/en/idempotent_command_handling/)

### Entity Identifier

Every message `SHOULD` carry a stable identifier for the business entity it refers to.

This identifier is essential for:

- Preserving order of messages related to the same entity (where the platform supports ordering).
- Grouping related messages for coordinated processing.
- Enabling parallelism by distributing messages across partitions (Kafka) or message groups based on the identifier.

**Design Guidelines**:

- Use a domain identifier that uniquely represents the business entity (for example: `customerId`, `orderId`).
- For compound identifiers, prefer structured JSON or multiple properties instead of concatenated strings.
- If no natural identifier exists, a UUID may be used.

*Example Identifier*:

```json
{
   "sensorId": "sensor-123",
   "measurementType": "temperature"
}
```

**Platform specifics**:

- **Kafka / Cloud services (AWS Kinesis, Azure Event Hubs):**
  - Entity identifier is represented by the **message key**.
  - The key controls partitioning, ensuring all messages with the same key are delivered to in the same partition to **guarantee ordering**.
  - Avoid low-cardinality keys (keys with few distinct values) that may result in uneven partitioning for high volume streams. Such keys may lead to "hot" partitions where data and load are unevenly concentrated in certain partitions, impacting performance and scalability.
- **AMQP-Based Message Brokers (IBM MQ / RabbitMQ, etc.), Solace, ..:**
  - Entity identifier is usually expressed through **headers** or **message properties**.
  - Routing is primarily based on **routing keys** or **header values**.
  - The entity identifier may also be taken into account for routing decisions, for example via selectors, filters, or partitioned queues (Solace).

#### References:

- [Kafka Message Key: A Comprehensive Guide](https://www.confluent.io/learn/kafka-message-key)
- [CloudAMQP. RabbitMQ for beginners – Exchanges, routing keys and bindings (2024)](https://www.cloudamqp.com/blog/part4-rabbitmq-for-beginners-exchanges-routing-keys-bindings.html)

### Headers

Message headers are simple key-value pairs that carry metadata - information about the message rather than the business payload itself.

Headers are essential for:

- **Observability & tracing** across distributed systems (see [monitoring](#monitoring)).
- **Providing governance information** such as schema version or source system, data classification, api version, etc.
- **Interoperability**: Headers provide technical metadata such as content type, used message serializers, compression algorithm, delivery mode, message expiration time, etc.
- **Routing and filtering**: Headers influence routing and filtering in MQ-based systems (where supported).

#### Categories of headers:

- **Technical & Observability Headers**:
  - These headers are common across all message types and provide essential metadata for processing, governance, and observability.<br/>

*Examples*:

- `x-api-version`: Version of the API (e.g., `1.0.0`)
- `x-source-system`: Identifier of the system that produced the message
- Serialization format, encoding, content type, ..
- Tracing headers: many platforms automatically inject distributed tracing context. For instance, the **Instana agent** automatically adds headers that allow end-to-end correlation across asynchronous calls:
  - `X-INSTANA-T`: Trace ID
  - `X-INSTANA-S`: Span ID
  - `X-INSTANA-L`: Trace level

- **Business & Domain Headers**:
  - These are less common and are primarily used in MQ-based systems for routing or filtering.<br/> 
  
*Example*:

```json
{
  "headers": {
    "customerId": "cust-12345",
    "region": "eu-central",
    "priority": "high"
  },
  "payload": {
    "orderId": "ord-98765",
    "status": "shipped"
  }
}
```

- **Platform specifics**:

- **Kafka / Cloud services (AWS Kinesis, Azure Event Hubs):**
  - Headers are typically **technical metadata**.
  - They **do not** influence routing or partitioning, which is controlled by the **message key** instead.
- **AMQP-Based Message Brokers (IBM MQ / RabbitMQ, etc.), Solace, ..:**
  - Headers (or message properties), in addition to technical headers, may also carry **entity identifiers** or other values that brokers use for **routing, filtering, or grouping**.
  - Headers therefore serve both as **technical metadata** and as **routing hints** (for example: JMS message selectors, Solace partitioned queues, ..).

#### References

- [Kafka Headers - Use Cases, Best Practices, and Alternatives](https://www.redpanda.com/guides/kafka-cloud-kafka-headers)
- [RabbitMQ. Message properties](https://www.rabbitmq.com/docs/publishers#message-properties)

## `MUST` Avoid Large Messages

Avoid large messages (>1MB). Large messages lead to performance degradation, increased latency, and higher resource consumption on brokers and consumers.

For large payloads, use the **Claim Check pattern**: store the large data in an external system (like S3) and place only a reference in the message.

*Example*:

```json
{
  "eventType": "ProfileImageUpdated",
  "userId": "user_123456",
  "imageRef": "s3://user-profile-images/user_abc/profile.jpg"
}
```

*Notes*:

- Avoid message splitting unless absolutely necessary, as it adds complexity to both producers and consumers. On the consumer side, reassembling messages is error-prone and may lead to data loss if parts are missing or arrive out of order.
- Use compression (if supported by the platform) to reduce message size for payloads that are still relatively large where external storage would be unnecessary overhead.

## `MUST` Avoid CRUD Sourcing

CRUD sourcing is an anti-pattern where events simply mirror database operations, particularly **UPDATE** events that indicate a change occurred without specifying the nature of the change.

Such generic events (like `CustomerUpdated`, `OrderUpdated`) hide the business intent behind the change. They force consumers to manually compare the "before" and "after" state of the data to determine what actually changed.

### Use Domain-Specific Event Semantics

Model events as self-explanatory facts in the domain, not as technical log entries. A specific event should be published for each business action that can change an entity's state.

*Examples*:

| Avoid (CRUD style)   | Prefer (Domain style)                  |
|----------------------|----------------------------------------|
| `CustomerUpdated`    | `CustomerEmailChanged`                 |
| `OrderUpdated`       | `OrderCancelled`, `OrderShipped`       |
| `UserUpdated`        | `UserDeactivated`, `UserPasswordReset` |
| `UserCreated`        | `UserRegistered`                       |
| `ReservationDeleted` | `ReservationCancelled`                 |

Domain-specific events provide clear business meaning and provide a stable contract for consumers.

#### References

- [Event-Driven.io — Event Modelling Anti-Patterns](https://event-driven.io/en/anti-patterns/)

## Channels

## `SHOULD` Ensure One Schema per Channel

The recommended approach is to have a dedicated channel (topic or queue) for each distinct event type. The channel name should clearly indicate the single, specific event it carries.

Avoid publishing messages with different distinct schemas to the same channel.

*Example AsyncAPI specification*:

```yaml
channels:
  retail/v1/order:
  publish:  
    message:
      oneOf: # <-- This 'oneOf' is an anti-pattern
       - $ref: '#/components/messages/OrderCreated'
       - $ref: '#/components/messages/OrderShipped'
       - $ref: '#/components/messages/OrderCancelled'       
```

*Problems*:

- **Unclear Channel Purpose**: Channel name does not specify which event type it carries.
- **Payload Ambiguity**: The payload structure is ambiguous since it can represent multiple distinct event types. Consumers must inspect payloads to determine the type.
- **Schema Limitations**: Avro or Protobuf schemas do not support `oneOf`/`anyOf` clauses like JSON schema. Code generators typically cannot handle these clauses as well.
- **Schema Evolution**: Schemas for different events are coupled and cannot evolve independently.

### Recommended Approach: One Event Type per Channel

Use a dedicated channel for each event type. The channel name should clearly indicate the event type and map to a single schema.

*Kafka example*:

- "{app}.retail.v1.order.created" → topic carries only `OrderCreated` messages
- "{app}.retail.v1.order.shipped" → topic carries only `OrderShipped` messages

*Benefits*:

- **Clarity:** Channel name matches the business event.
- **Schema stability:** Each schema evolves independently.
- **Tooling support:** Fully compatible with schema registries and code generators.

## `SHOULD` Use a Single Entity Channel to Guarantee Event Order

The "One Event Type per Channel" pattern may lead to an unmanageable number of channels for a given use case.

Furthermore, that approach may not guarantee strict processing order for events related to a single business entity, which is critical for patterns like event sourcing or stateful stream processing.

To address this, we can group related events by domain (for example, `OrderEvents`, `CustomerEvents`) using a single envelope schema with an explicit discriminator field (such as `eventType`) to distinguish between specific events.

*Example*:

- An `OrderShipped` event must always be processed after the corresponding `OrderCreated` event.

### Schema:

- Define a single **envelope schema** with an explicit discriminator (`eventType`) to indicate the message type.
- Do not use `oneOf`/`anyOf` clauses to allow multiple distinct event types.

*Example Envelope Message*:

```json
{
  "eventType": "OrderCreated",
  "entityId": "CH-845B-291A",
  "timestamp": "2025-09-11T07:22:58Z",
  "data": {
    "customerId": "cust-7742",
    "items": [ { "sku": "SBB-01", "quantity": 1 } ]
  }
}
```

### Channel Name:

Name the channel after the entity stream, not individual events.

#### Kafka Example:

- {app}.retail.v1.order.events → carries `OrderCreated`, `OrderShipped`, and `OrderCancelled` messages.

*Benefits*:

- **Guaranteed Order:** All events for the same entity are published to the same partition, preserving chronological order.
- **Consistent Schema**: The envelope schema is consistent for all event types.
- **Explicit Typing**: discriminator field (eventType) makes the type clear for the consumers.

#### References

- [Confluent - Should You Put Several Event Types in the Same Kafka Topic?](https://www.confluent.io/blog/put-several-event-types-kafka-topic/)
- [Microsoft Learn — Event Sourcing pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing)
- [Confluent - Storing Data as Events](https://developer.confluent.io/courses/event-sourcing/storing-data-as-events/)

## `MUST` Use Semantic Versioning and Consistent Naming

Channel names must be clear, structured, and versioned for discoverability, and governance.

### Principles:

- **Clarity**: Names must clearly indicate the domain and purpose.
- **Structure**: Name should follow the order: {app / domain} → bounded context → entity → event → version.
- **Versioning**: Include the **major version** (v1, v2) in the name (see [SemVer](https://semver.org/)). Increase the major version whenever a breaking change is introduced. It is common not to include "v1" for the first version.
- **Avoid**: Do not include environment names or technical identifiers ("dev", "broker1", ..) in the name (unless necessary).

*Good examples*:

- `{app}.retail.order.created`
- `{app}.transport.train.departed.v2`
- `{app}.finance/payment/processed/v1`

*Bad examples*:

- `{app}.retail.order.v1.created` ← version in wrong position
- `{app}.transport.dev.train.departed.v1` ← environment in name

#### References

- [Kafka Topic Naming Conventions and Best Practices](https://www.confluent.io/learn/kafka-topic-naming-convention/)

## Security

### `MUST` Secure Endpoints with Strong Authentication

Every API endpoint (topic / queue) needs to be secured by an state of the art authentication mechanism supported by the platform you'd like to use.

Every client (producer or consumer) connecting to the message broker `MUST` be authenticated. Anonymous connections `MUST NOT` be allowed in production.

Use strong, standard mechanisms provided by the platform, such as:

- SASL (for example, SASL/SCRAM)
- Mutual TLS (mTLS), where clients present their own certificates.
- OAuth 2.0 / OIDC tokens (JWTs).

### `MUST` Enforce the Principle of Least Privilege (Authorization)

Authenticated clients `MUST` be granted access **only to the minimum set of actions and resources** required to perform their intended function.

**Producers:**

- `MUST` have **write permissions** only for the specific topics or queues they publish to.

**Consumers:**

- `MUST` have **read permissions** only for the specific topics or queues they consume from, and only for the consumer groups they belong to.

Technical user accounts `MUST NOT` be created manually for applications. Instead, a **centralized API management platform (APIM)** `MUST` be used to provision and manage application identities automatically - based on subscriptions to APIs published in the [Developer Portal (internal link)](https://developer.sbb.ch).

### `MUST` Encrypt Data in Transit

All data transmitted between clients and message brokers `MUST` be encrypted using strong encryption protocols such as TLS 1.2 or higher.

## Monitoring

### `MUST` Support OpenTelemetry

Distributed Tracing over multiple applications, teams and even across large solutions is very important in root cause analysis and helps detect how latencies are stacked up and where incidents are located and thus can significantly shorten _mean time to repair_ (MTTR).

To identify a specific request through the entire chain and beyond team boundaries every team (and API) `MUST` use [OpenTelemetry](https://opentelemetry.io/) as its way to trace calls and business transactions. Teams `MUST` use standard [W3C Trace Context](https://www.w3.org/TR/trace-context/) Headers, as they are the common standard for distributed tracing and are supported by most of the cloud platforms and monitoring tools. We explicitly use W3C standards for eventing too and do not differ between synchronous and asynchronous requests, as we want to be able to see traces across the boundaries of these two architectural patterns.

##### Traceparent
{: .no_toc }

```text
`traceparent`: ${version}-${trace-id}-${parent-id}-${trace-flags}
```

The traceparent header field identifies the incoming request in a tracing system. The _trace-id_ defines the trace through the whole forest of synchronous and asynchronous requests. The _parent-id_ defines a specific span within a trace.

##### Tracestate
{: .no_toc }

```text
`tracestate`: key1=value1,key2=value2,...
```

The tracestate header field specifies application and/or APM Tool specific key/value pairs.

## Implementation & Documentation

### `MUST` Provide API Specification using AsyncAPI

We use the [AsyncAPI specification](https://www.asyncapi.com/) as standard to define event-driven API specification
files.

The API specification files should be subject to version control using a source code management system - best
together with the implementing sources.

You `MUST` publish the application API specification with the deployment of the implementing service and make it
discoverable, following our [publication](/api-principles/api-principles/publication) principles. As a starting
point, use our [ESTA Blueprints (internal link)](https://code.sbb.ch/projects/KD_ESTA_BLUEPRINTS).

### `SHOULD` use either Apache AVRO or JSON as data format

The preferred data format for asynchronous APIs in the SBB are either [JSON](https://www.json.org/json-en.html) or [Apache AVRO](https://avro.apache.org/docs/current/spec.html)
If you have to decide which one, choose the data format based on what your customer / consumers are comfortable with. Additionally, please check out the [confluent blog](https://www.confluent.io/blog/avro-kafka-data/) about differences of the two formats.

You `SHOULD NOT` use legacy data formats such as [XML](https://en.wikipedia.org/wiki/XML) or [Java Object Serialization Stream Protocol](https://docs.oracle.com/javase/6/docs/platform/serialization/spec/protocol.html). It's almost impossible to  fulfill the principles laid out in this document because of numerous issues around versioning, compatibility and security considerations of these technologies.

### `SHOULD` use either Apache AVRO schema or JSON schema

Both are supported by the Kafka schema registry and as a linkable resource from the [developer portal](https://developer.sbb.ch).

### `MUST` Use Semantic Versioning

Versions in the specification must follow the principles described by [SemVer](https://semver.org/). Versions in queue/topic names are always major versions. Or in a more generic way: we avoid introducing minors or patches anywhere where it could break consumers compatibility. We explicitly avoid resource based versioning, because this is a complexity which an API should not reflect to its consumers.

*Good example* for a topic/queue name:

```text
`{application-abbreviation}/.../v1/orders/...`
```

*Bad Example* for a topic/queue name:

```text
`{application-abbreviation}/.../orders/v1/...`
```
