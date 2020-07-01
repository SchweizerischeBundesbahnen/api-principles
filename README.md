![SBB's API Principles](images/API-Principles-Logo.jpg)

This is the repository for maintaining the SBB's API Principles, as part of the company wide *Integration Architecture* initiative. The principles are subject to constant improvements and are valid for all kind of software projects, independent of the chosen procurement model: reuse, buy, customize, make and also shoring.

*See it in action:* https://SchweizerischeBundesbahnen.github.io/api-principles/

## Repository Structure

#### Documentation
The [/docs](/docs) folder contains all the markdown files which are rendered with [jekyll](https://jekyllrb.com). The master branch is automatically being published using [GitHub Pages](https://pages.github.com). For styling, we use [Patrick Marceill](https://github.com/pmarsceill)'s awesome jekyll theme called *[Just-The-Docs](https://github.com/pmarsceill/just-the-docs)*.

#### Versioning
The applicable principles are the ones described in the version of the master branch. Minor changes and bugfixes will be merged, using the simple review process by the "Integration Team". We maintain Major changes and extensions in a Branch using the name of the next version following the rules of [semantic versioning](https://semver.org/). Releases of new major versions `MUST` be approved by the central IT architecture board and are afterwards merged into the master branch as the new applicable set of principles.

When Introducing a new Version, Changes must be updated in the [CHANGELOG.md](/CHANGELOG.md) file.

#### Styling
Custom styling is overwritten in the [_sass/custom](/_sass/custom) Folder. For further information on customization, read the documentation for [customization](https://pmarsceill.github.io/just-the-docs/docs/customization/).

#### Contributing
You are always welcome to [contribute](/CONTRIBUTING.md) to our API Principles by filing a Pull Request (PR).

#### Thank you
- To Zalando for the publication of their awesome set of RESTful API Guidelines, which is published under the [CC-BY](https://github.com/zalando/restful-api-guidelines/blob/master/LICENSE) (Creative commons Attribution 4.0) license. We’ve learned a lot while reading and adopting them to our needs.

#### License
[Apache License 2.0](/LICENSE)
