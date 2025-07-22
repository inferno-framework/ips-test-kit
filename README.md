# Inferno IPS Test Kit

The Inferno International Patient Summary Test Kit provides an
executable set of tests for the [International Patient Summary (IPS)
Implementation Guide](https://build.fhir.org/ig/HL7/fhir-ips/).  This test kit
is designed and maintained by the Inferno team to support the development of the
IPS IG and improve the core Inferno Framework.

This test kit includes a web interface to run a configured local [HL7® FHIR®
validator](https://confluence.hl7.org/display/FHIR/Using+the+FHIR+Validator)
service to validate instances of FHIR resources to the IPS profiles, as well as
a preliminary test suite.

## Instructions

It is highly recommended that you use [Docker](https://www.docker.com/) to run
these tests.  This test kit requires at least 10 GB of memory are available to Docker.

- Clone this repo.
- Run `setup.sh` in this repo.
- Run `run.sh` in this repo.
- Navigate to `http://localhost`. The IPS Test suite will be available.

See the [Inferno Framework
Documentation](https://inferno-framework.github.io/docs/getting-started-users.html)
for more information on running Inferno.

Additional [guidance](docs) and a [test template](docs/resource_test_template.rb) are included to support standardized and readable test kit structure.

## License

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at
```
http://www.apache.org/licenses/LICENSE-2.0
```
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

## Trademark Notice

HL7, FHIR and the FHIR [FLAME DESIGN] are the registered trademarks of Health
Level Seven International and their use does not constitute endorsement by HL7.
