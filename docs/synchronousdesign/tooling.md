---
layout: default
title: Tooling
parent: API Design
nav_order: 21
---

This is not a part of the actual guidelines, but might be helpful for following them. Using a tool mentioned here doesn’t automatically ensure you follow the guidelines.

API First Integrations
======================

The following frameworks were specifically designed to support the API First workflow with OpenAPI YAML files (sorted alphabetically):

-   **[Connexion](https://github.com/zalando/connexion):** OpenAPI First framework for Python on top of Flask

-   **[Friboo](https://github.com/zalando-stups/friboo):** utility library to write microservices in Clojure with support for Swagger and OAuth

-   **[Api-First-Hand](https://github.com/zalando/api-first-hand):** API-First Play Bootstrapping Tool for Swagger/OpenAPI specs

-   **[Swagger Codegen](https://github.com/swagger-api/swagger-codegen):** template-driven engine to generate client code in different languages by parsing Swagger Resource Declaration

-   **[Swagger Codegen Tooling](https://github.com/zalando-stups/swagger-codegen-tooling):** plugin for Maven that generates pieces of code from OpenAPI specification

-   **[Swagger Plugin for IntelliJ IDEA](https://github.com/zalando/intellij-swagger):** plugin to help you easily edit Swagger specification files inside IntelliJ IDEA

The Swagger/OpenAPI homepage lists more [Community-Driven Language Integrations](http://swagger.io/open-source-integrations/), but most of them do not fit our API First approach.

Support Libraries
=================

These utility libraries support you in implementing various parts of our RESTful API guidelines (sorted alphabetically):

-   **[Problem](https://github.com/zalando/problem):** Java library that implements application/problem+json

-   **[Problems for Spring Web MVC](https://github.com/zalando/problem-spring-web):** library for handling Problems in Spring Web MVC

-   **[Jackson Datatype Money](https://github.com/zalando/jackson-datatype-money):** extension module to properly support datatypes of javax.money

-   **[Tracer](https://github.com/zalando/tracer):** call tracing and log correlation in distributed systems

-   **[TWINTIP Spring Integration](https://github.com/zalando/twintip-spring-web):** API discovery endpoint for Spring Web MVC
