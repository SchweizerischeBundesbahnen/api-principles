---
layout: default
title: Documentation
parent: Synchronous-API Design
nav_order: 1
---

The titles are marked with the corresponding labels: {MUST}, {SHOULD}, {MAY}.

## `MUST` Provide API Specification using OpenAPI

We use the [OpenAPI specification](http://swagger.io/specification/) as standard to define RESTful API specification files. API designers are required to provide the API specification using a single **self-contained YAML** file to improve readability. We encourage to use **OpenAPI 3.0** version, but still support **OpenAPI 2.0** (a.k.a. Swagger 2).

The API specification files should be subject to version control using a source code management system - best together with the implementing sources.

You **must** publish the component API specification with the deployment of the implementing service and make it discoverable, following our [publication](https://schweizerischebundesbahnen.github.io/api-principles/publication) principles. As a starting point, use our ESTA Blueprints ([internal Link](http://esta.sbb.ch/Esta+Blueprints)).

**Hint:** A good way to explore **OpenAPI 3.0/2.0** is to navigate through the [OpenAPI specification mind map](https://openapi-map.apihandyman.io/).
