require_relative 'version'

module IPS
  class Metadata < Inferno::TestKit
    id :ips_test_kit
    title 'International Patient Summary Test Kit'
    description <<~DESCRIPTION
      The International Patient Summary Test Kit provides an executable set of
      tests for IPS server implementers to validate their implementations
      against the [International Patient Summary (IPS) Implementation Guide
      v1.1.0](https://hl7.org/fhir/uv/ips/STU1.1/).
      <!-- break -->

      This test kit validates server implementations of the International
      Patient Summary (IPS) specification. It tests both the structural
      requirements of IPS documents and the operational capabilities required by
      IPS servers.

      The tests are organized into three main approaches:
      - **IPS Resource Validation Tests**: For validating standalone IPS bundles without requiring a server API
      - **IPS Operation Tests**: For testing server support of the $summary operation and document reference capabilities  
      - **IPS Read Tests**: For validating individual resource profile conformance via FHIR read operations

      Key capabilities tested include:
      - IPS Bundle structure and composition validation
      - Profile conformance for IPS resource profiles
      - Support for the $summary operation
      - Document reference and retrieval workflows
      - Terminology validation and value set bindings

      ## Status

      This test kit has **Low** maturity. It provides comprehensive coverage of
      IPS profile validation and core operational requirements. The test kit
      currently validates resource profiles defined in the IPS
      Implementation Guide v1.1.0, including all required profiles for Patient,
      AllergyIntolerance, Condition, Medication resources, and comprehensive
      coverage of observation profiles for laboratory, pathology, and radiology
      results.

      Two preset configurations are available to facilitate testing: one using
      example IPS bundles from the specification, and another configured for
      testing against reference server implementations.

      Future versions may expand operational workflow testing and add
      comprehensive edge case coverage.

      ## Repository

      This test kit is [open
      source](https://github.com/inferno-framework/ips-test-kit#license) and
      freely available for use or adoption by the health IT community including
      EHR vendors, health app developers, and testing labs. It is built using
      the [Inferno
      Framework](https://inferno-framework.github.io/).

      The IPS Test Kit GitHub repository can be [found
      here](https://github.com/inferno-framework/ips-test-kit).

      ## Providing Feedback

      We welcome feedback on the tests, including but not limited to the following areas:

      - Validation logic, such as potential bugs, lax checks, and unexpected failures
      - Requirements coverage, such as requirements that have been missed, tests that necessitate features that the IG does not require, or other issues with the interpretation of the IG's requirements  
      - User experience, such as confusing or missing information in the test UI

      Please report any issues with this set of tests in the [issues section](https://github.com/inferno-framework/ips-test-kit/issues) of the repository.
    DESCRIPTION
    suite_ids [:ips]
    tags ['IPS']
    last_updated LAST_UPDATED
    version VERSION
    maturity 'Low'
    authors ['MITRE Inferno Team']
    repo 'https://github.com/inferno-framework/ips-test-kit'
  end
end
