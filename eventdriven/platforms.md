---
layout: default
title: Platform specific documentation
parent: Event-Driven APIs
nav_order: 3
---

Event-Driven APIs on specific platforms
===========================
{: .no_toc }

This chapter adds requirements and best practices for specific SBB platforms

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Requirements Kafka Platform

### `MUST` comply with the Naming Conventions for Topics
Infrastructure artifacts like topics and queues must be named according to the following naming conventions: 

`{application-abbreviation}.{application-specific}`

- {application-abbreviation}:\
[a-z0-9-]+ (Sequence of:lower case,numbers, dashes). **Important:** For internal applications, use one of the documented names or aliases according to the EA Repository. 
- {application-specific}:\
[a-z0-9-.] (Sequence of:lower case, numbers, dashes, periods)

## Best practices Kafka Platform 

### Initialload / state restore

When building an AsyncAPI on the Kafka platform, you should ask yourself how a prospective customer can restore its state, 
using only the Kafka topics as a source. After all, the feature of sending *and storing messages in a longterm fashion* is the unique
selling point of this technology. Consider the following hints
* Are you sending self-containing snapshots or events (which require some kind of a baseline)?
* Are there additional topics where your customer may obtain a baseline in a periodic fashion?
* Are the retention time on the topic appropriate for this use case?

If possible, refrain from building a backchannel to request a baseline. There is also always the possibility to build a baseline topic with Kafka Streams