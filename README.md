# International Patient Summary Test Kit

This is a collection of tests for the [International Patient Summary
Implementation Guide](http://build.fhir.org/ig/HL7/fhir-ips/) using the [Inferno
FHIR testing tool](https://github.com/inferno-community/inferno-core).

**NOTE:** These tests are implemented against the `1.0.0` build of the IG.

It is highly recommended that you use [Docker](https://www.docker.com/) to run
these tests so that you don't have to configure ruby locally.

## Instructions

- Clone this repo.
- Run `docker-compose build` in this repo.
- Run `docker-compose pull` in this repo.
- Run `docker-compose up` in this repo.
- Navigate to `http://localhost:4567`. The IPS test suite will be available.
