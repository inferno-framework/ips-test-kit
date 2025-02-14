require_relative 'version'

module IPS
  class Metadata < Inferno::TestKit
    id :ips_test_kit
    title 'International Patient Summary Test Kit'
    description <<~DESCRIPTION
      The International Patient Summary Test Kit provides an
      executable set of tests for the [International Patient Summary (IPS)
      Implementation Guide v1.1.0](https://hl7.org/fhir/uv/ips/STU1.1/). This test kit
      simulates requests performed by a realistic IPS Requestor and
      validating responses based on requirements specified within the IPS IG and the base FHIR specification.
      <!-- break -->

      This test kit is [open source](https://github.com/inferno-framework/ips-test-kit#license) and freely available for use or
      adoption by the health IT community including EHR vendors, health app
      developers, and testing labs. It is built using the [Inferno Framework](https://inferno-framework.github.io/inferno-core/). The Inferno Framework is
      designed for reuse and aims to make it easier to build test kits for any
      FHIR-based data exchange.

      ## Status

      These tests are intended to allow IPS server implementers to perform checks of their server against IPS requrirements. Future versions of these tests may validate other requirements and may change how these are tested.

      The test kit currently tests the following requirements:
      - IPS Bundle validation
      - Support for IPS operations
      - Profile Validation

      See the test descriptions within the test kit for detail on the specific validations performed as part of testing these requirements.

      ## Repository

      The IPS Test Kit GitHub repository can be [found here](https://github.com/inferno-framework/ips-test-kit).

      ## Providing Feedback and Reporting Issues

      We welcome feedback on the tests, including but not limited to the following areas:

      - Validation logic, such as potential bugs, lax checks, and unexpected failures.
      - Requirements coverage, such as requirements that have been missed, tests that necessitate features that the IG does not require, or other issues with the interpretation of the IG's requirements.
      - User experience, such as confusing or missing information in the test UI.

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
