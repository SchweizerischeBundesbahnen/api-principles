---
layout: default
title: Platform specific requirements
parent: Event-Driven APIs
nav_order: 3
---

Requirements for Event-Driven APIs on specific platforms
===========================
{: .no_toc }

This chapter describes a set of guidelines that must be applied when using specific platforms. 

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Kafka Platform

### `MUST` comply with the Naming Conventions for Topics
Infrastructure artifacts like topics and queues must be named according to the following naming conventions: 

`{application-abbreviation}.{application-specific}`

- {application-abbreviation}:\
[a-z0-9-]+ (Sequence of:lower case,numbers, dashes). **Important:** For internal applications, use one of the documented names or aliases according to the EADB. 
- {application-specific}:\
[a-z0-9-.] (Sequence of:lower case, numbers, dashes, periods)