---
layout: default
title: Best Practices
parent: Event-Driven APIs
nav_order: 2
---

Best Practices
==============
{: .no_toc }

This chapter is not subject to IT Governance. It is more a collection of extractions from literature, experiences and patterns that 
we document as shared knowledge. Nevertheless engineers **should** read this section as it contains very valuable knowledge of how to
design and implement event-driven APIs.

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## General API Design Principles
Before a new API is created, it is necessary to check which integration type it corresponds to. Event-Driven APIs 
have many advantages with regard to decoupling systems at runtime. At the same time, an Event-Driven API also brings 
challenges that are less significant with e.g. a RESTful API. Accordingly, Event-Driven APIs are primarily 
suitable for interfaces where "fire and forget" is possible. Or, in other words, an Even-Driven approach makes only 
limited sense if your application directly depends on the response for a sent message.

Concerning documentation, versioning, schema management etc. the claims are however the same as for a RESTful API. 
We apply the Event-Driven API principles to all kind of application (micro-) service components, independently from 
whether they provide functionality via the internet or intranet.

-   We prefer APIs with JSON payloads

An important principle for API design and usage is Postel’s Law, aka 
[The Robustness Principle](http://en.wikipedia.org/wiki/Robustness_principle) (see also [RFC 1122](https://tools.ietf.org/html/rfc1122)):

-   Be liberal in what you accept, be conservative in what you send


### Follow API First Principle

You should follow the API First Principle, more specifically:

-   You should design APIs first, before coding its implementation.
-   You should design your APIs consistently with these guidelines.
-   You should call for early review feedback from peers and client developers. Also consider to apply for a lightweight review by the API Team.

See also the principle [Design API first](https://schweizerischebundesbahnen.github.io/api-principles/architecture/#must-design-api-first).

### Provide API User Manual

In addition to the API Specification, it is good practice to provide an API user manual to improve client developer 
experience, especially of engineers that are less experienced in using this API. A helpful API user manual typically 
describes the following API aspects:

-   Domain Knowledge and context, including API scope, purpose, and use cases
-   Concrete examples of API usage
-   Edge cases, error situation details, and repair hints
-   Architecture context and major dependencies - including figures and sequence flows


## Compatibility

### Use Schema Management Registry

If you are sharing data with clients outside the scope of your system, you will want to make sure that the schemas involved are 
actively managed. Doing so early in the pipeline will prevent your downstream clients from deserialization and processing issues 
at a later time (worstcase in production).

Schema Management involves publication, distribution and lifecycle control of message schemas published by asynchronous interfaces.
Use a centralized schema management registry (e.g. Confluent Schema Registry or Red Hat Service Registry) for

- creating, updating and deleting schemas
- sharing schemas, making them available to downstream clients
- implementing schema evolution rules to enforce compatible changes of the schema

### Provide Version Information
{: .no_toc }
In addition to the major version given by topic/queue name, the full version of the API should be written into the message header. 
Use the header field `x-api-version` and write the version in [SemVer](https://semver.org/) notation.


### Always Return JSON Objects As Top-Level Data Structures To Support Extensibility

In a response body, you must always return a JSON object (and not e.g. an array) as a top level data structure to 
support future extensibility. JSON objects support compatible extension by additional attributes. This allows 
you to easily extend your response and e.g. add pagination later, without breaking backwards compatibility.

Maps, even though technically objects, are also forbidden as top level data structures, since they don’t support 
compatible, future extensions.

### Treat Open API Definitions As Open For Extension By Default

The Open API 2.0 specification is not very specific on default extensibility of objects, and redefines JSON-Schema 
keywords related to extensibility, like `additionalProperties`. Following our overall compatibility guidelines, 
Open API object definitions are considered open for extension by default as 
per [Section 5.18 "additionalProperties"](http://json-schema.org/latest/json-schema-validation.html#rfc.section.5.18) of JSON-Schema.

When it comes to Open API 2.0, this means an `additionalProperties` declaration is not required to make an object definition extensible:

-   API clients consuming data must not assume that objects are closed for extension in the absence of an `additionalProperties` 
declaration and must ignore fields sent by the server they cannot process. This allows API servers to evolve their data formats.

API formats must not declare `additionalProperties` to be false, as this prevents objects being extended in the future.

Note that this guideline concentrates on default extensibility and does not exclude the use of `additionalProperties` with a schema as
 a value, which might be appropriate in some circumstances.

### Use Open-Ended List of Values (`x-extensible-enum`) Instead of Enumerations

Enumerations are per definition closed sets of values, that are assumed to be complete and not intended for extension. This closed 
principle of enumerations imposes compatibility issues when an enumeration must be extended. To avoid these issues, we strongly 
recommend to use an open-ended list of values instead of an enumeration unless:

1.  the API has full control of the enumeration values, i.e. the list of values does not depend on any external tool or interface, and
2.  the list of value is complete with respect to any thinkable and unthinkable future feature.

To specify an open-ended list of values use the marker {x-extensible-enum} as follows:

    deliverMethods:
      type: string
      x-extensible-enum:
        - parcel
        - letter
        - email

**Note:** {x-extensible-enum} is not JSON Schema conform but will be ignored by most tools.

## Data Formats

### Use JSON to Encode Structured Data

Use JSON-encoded body payload for transferring structured data. The JSON payload must follow [RFC-7159](https://tools.ietf.org/html/rfc7159) 
by having (if possible) a serialized object as the top-level structure, since it would allow for future extension. This also applies for 
collection resources where one naturally would assume an array.

### Use Standard Date and Time Formats

#### JSON Payload
{: .no_toc }

Read more about date and time format in [Date property values should conform to RFC 3339](https://schweizerischebundesbahnen.github.io/api-principles/eventdriven/best-practices/#date-property-values-should-conform-to-rfc-3339)

### Use Standards for Country, Language and Currency Codes

Use the following standard formats for country, language and currency codes:

-   {ISO-3166-1-a2}\[ISO 3166-1-alpha2 country codes\]
    -   (It is "GB", not "UK")
-   {ISO-639-1}\[ISO 639-1 language code\]
    -   {BCP47}\[BCP 47\] (based on {ISO-639-1}\[ISO 639-1\]) for language variants
-   {ISO-4217}\[ISO 4217 currency codes\]

## Implementation

### Handle duplicate messages

Event consumers must be developed to deal with duplicate messages. Most Message Brokers implement an _at-least-once_
delivery strategy since _exactly-once_ is usually too expensive. 

When systems and networks behave correctly, messages are delivered only once. However, some circumstances might 
cause message duplication. For instance, a network glitch could avoid a message acknowledgment when 
a publisher sends a message. In that case, the publisher will resend the message, leading to a message duplication in
the Message Broker. The same can happen on the consumer side, when the message cannot be acknowledged after a successful 
processing.

Consumers can follow one of these strategies to overcome this:
- Keeping track of the messages and discarding duplicates
- Writing idempotent handling logic (although not always possible)

## Deprecation

### Monitor Usage of Deprecated APIs

Owners of APIs used in production must monitor usage of deprecated APIs until the API can be shut down in order to align 
deprecation and avoid uncontrolled breaking effects.

**Hint:** Use [API Management (internal link)](https://confluence.sbb.ch/display/AITG/API+Management) to keep track of the usage of your APIs

## JSON Best Practices

This is a set of best practices for using JSON as a message body format. JSON here refers to [RFC 7159](https://tools.ietf.org/html/rfc7159) 
(which updates [RFC 4627](https://tools.ietf.org/html/rfc4627)), the "application/json" media type and custom JSON media types defined for APIs.
 This section only cover some specific cases of JSON design decisions. The first some of the following guidelines are about property names, the 
 later ones about values.

### Property names must be camelCase

Property names are restricted to ASCII strings in lower case camelCase, matching the following format: `[a-z]+[A-Z0-9][a-z0-9]+[A-Za-z0-9]*$`. The only exception are keywords like `_links`.

Rationale: It’s essential to establish a consistent look and feel such that JSON looks as if it came from the same hand, independent of the system that provides the API. It is also very important to stick to names that do generate valid source code when generating code from specs like [OpenAPI](https://swagger.io/specification/).

### Define Maps Using `additionalProperties`

A "map" here is a mapping from string keys to some other type. In JSON this is represented as an object, the key-value pairs being represented 
by property names and property values. In OpenAPI schema (as well as in JSON schema) they should be represented using additionalProperties 
with a schema defining the value type. Such an object should normally have no other defined properties.

The map keys don’t count as property names, and can follow whatever format is natural for their domain. Please document this in the description 
of the map object’s schema.

Here is an example for such a map definition (the `translations` property):

    components:
      schemas:
        Message:
          description:
            A message together with translations in several languages.
          type: object
          properties:
            messageKey:
              type: string
              description: The message key.
            translations:
              description:
                The translations of this message into several languages.
                The keys are [IETF BCP-47 language tags](https://tools.ietf.org/html/bcp47).
              type: object
              additionalProperties:
                type: string
                description:
                  the translation of this message into the language identified by the key.

An actual JSON object described by this might then look like this:

    { "messageKey": "color",
      "translations": {
        "de": "Farbe",
        "en-US": "color",
        "en-GB": "colour",
        "eo": "koloro",
        "nl": "kleur"
      }
    }

### Array names should be pluralized

To indicate they contain multiple values prefer to pluralize array names. This implies that object names should in turn be singular.

### Boolean property values must not be null

Schema based JSON properties that are by design booleans must not be presented as nulls. A boolean is essentially a closed enumeration of two values, true and false. If the content has a meaningful null value, strongly prefer to replace the boolean with enumeration of named values or statuses - for example *acceptedTermsAndConditions* with true or false can be replaced with *termsAndConditions* with values `yes`, `no` and `unknown`.

###  Use same semantics for `null` and absent properties

Open API 3.x allows to mark properties as `required` and as `nullable` to specify whether properties may be absent (`{}`) 
or `null` (`{"example":null}`). If a property is defined to be not `required` and `nullable` (see 2nd row in Table below), this rule 
demands that both cases must be handled in the exact same manner by specification.

The following table shows all combinations and whether the examples are valid:

|`required`|`nullable`|`{}`|`{"example":null}`| 
|---|---|---|---|
|true|true|{NO}|{YES}|
|false|true|{YES}|{YES}|
|true|false|{NO}|{NO}|
|false|false|{YES}|{NO}|

While API designers and implementers may be tempted to assign different semantics to both cases, we explicitly decide **against** 
that option, because we think that any gain in expressiveness is far outweighed by the risk of clients not understanding and 
implementing the subtle differences incorrectly.

As an example, an API that provides the ability for different users to coordinate on a time schedule, e.g. a meeting, may have a 
resource for options in which every user has to make a `choice`. The difference between *undecided* and *decided against any of 
the options* could be modeled as *absent* and `null` respectively. It would be safer to express the `null` case with a dedicated 
[Null object](https://en.wikipedia.org/wiki/Null_object_pattern), e.g. `{}` compared to `{"id":"42"}`.

Moreover, many major libraries have somewhere between little to no support for a `null`/absent pattern 
(see [Gson](https://stackoverflow.com/questions/48465005/gson-distinguish-null-value-field-and-missing-field), 
[Moshi](https://github.com/square/moshi#borrows-from-gson), [Jackson](https://github.com/FasterXML/jackson-databind/issues/578), 
[JSON-B](https://developer.ibm.com/articles/j-javaee8-json-binding-3/)). Especially strongly-typed languages suffer from this since 
a new composite type is required to express the third state. Nullable `Option`/`Optional`/`Maybe` types could be used but having 
nullable references of these types completely contradicts their purpose.

The only exception to this rule is JSON Merge Patch [RFC 7396](https://tools.ietf.org/html/rfc7396)) which uses `null` to explicitly 
indicate property deletion while absent properties are ignored, i.e. not modified.

### Empty array values should not be null

Empty array values can unambiguously be represented as the empty list, `[]`.

### Enumerations should be represented as Strings

Strings are a reasonable target for values that are by design enumerations.

### Name date/time properties using the `At` suffix

Dates and date-time properties should end with `At` to distinguish them from boolean properties which otherwise would have very similar or even identical names:

-   `createdAt` rather than `created`
-   `modifiedAt` rather than `modified`
-   `occurredAt` rather than `occurred`
-   `returnedAt` rather than `returned`

**Note:** {created} and {modified} were mentioned in an earlier version of the guideline and are therefore still accepted for APIs that predate this rule.


### Date property values should conform to RFC 3339

Use the date and time formats defined by [RFC 3339](https://tools.ietf.org/html/rfc3339#section-5.6):

-   for "date" use strings matching `date-fullyear "-" date-month "-" date-mday`, for example: `2015-05-28`
-   for "date-time" use strings matching `full-date "T" full-time`, for example `2015-05-28T14:07:17Z`

Note that the [OpenAPI format](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md#data-types) "date-time" 
corresponds to "date-time" in the RFC) and `2015-05-28` for a date (note that the OpenAPI format "date" corresponds to "full-date" 
in the RFC). Both are specific profiles, a subset of the international standard ISO 8601.

A zone offset may be used (both, in request and responses) — this is simply defined by the standards. However, we encourage 
restricting dates to UTC and without offsets. For example `2015-05-28T14:07:17Z` rather than `2015-05-28T14:07:17+00:00`. From 
experience we have learned that zone offsets are not easy to understand and often not correctly handled. Note also that zone 
offsets are different from local times that might be including daylight saving time. Localization of dates should be done by the 
services that provide user interfaces, if required.

When it comes to storage, all dates should be consistently stored in UTC without a zone offset. Localization should be done 
locally by the services that provide user interfaces, if required.

Sometimes it can seem data is naturally represented using numerical timestamps, but this can introduce interpretation issues with 
precision - for example whether to represent a timestamp as 1460062925, 1460062925000 or 1460062925.000. Date strings, though more 
verbose and requiring more effort to parse, avoid this ambiguity.

###  Time durations and intervals could conform to ISO 8601

Schema based JSON properties that are by design durations and intervals could be strings formatted as recommended by ISO 8601 
([Appendix A of RFC 3339 contains a grammar](https://tools.ietf.org/html/rfc3339#appendix-A) for durations).
