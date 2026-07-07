---
layout: default
title: Best Practices
parent: General Principles
nav_order: 4
---

# Best Practices
{: .no_toc }

A few generally valid best practices for APIs.

---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Follow API First Principle

You should follow the API First Principle, more specifically:

- You should design APIs first, before coding its implementation.
- You should design your APIs consistently with these guidelines.
- You should call for early review feedback from peers and client developers. Also consider to apply for a lightweight review by the API Team.

See also the principle [Design API first](https://schweizerischebundesbahnen.github.io/api-principles/architecture/#must-design-api-first).

## Provide API User Manual

In addition to the API Specification, it is good practice to provide an API user manual to improve client developer experience, especially of engineers that are less experienced in using this API. A helpful API user manual typically describes the following API aspects:

- Domain Knowledge and context, including API scope, purpose, and use cases
- Concrete examples of API usage
- Edge cases, error situation details, and repair hints
- Architecture context and major dependencies - including figures and sequence flows
