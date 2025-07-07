require_relative 'version'

module IPS
  class Metadata < Inferno::TestKit
    id :ips_test_kit
    title 'International Patient Summary Test Kit'
    version VERSION
    last_updated LAST_UPDATED

    # Configuration
    suite_ids [:ips]
    tags ['IPS']
    maturity 'Low'
    authors ['MITRE Inferno Team']
    repo 'https://github.com/inferno-framework/ips-test-kit'

    description <<~DESCRIPTION
      # Overview
      The International Patient Summary Test Kit provides an executable set of tests for the 
      [International Patient Summary (IPS) Implementation Guide v1.1.0](https://hl7.org/fhir/uv/ips/STU1.1/). 
      This test kit simulates requests performed by a realistic IPS Requestor and validates responses 
      based on requirements specified within the IPS IG and the base FHIR specification.
      <!-- break -->

      # Purpose and Scope
      This test kit is [open source](https://github.com/inferno-framework/ips-test-kit#license) 
      and freely available for use or adoption by the health IT community including:
      - EHR vendors
      - Health app developers
      - Testing labs

      It is built using the [Inferno Framework](https://inferno-framework.github.io/inferno-core/), 
      which is designed for reuse and aims to make it easier to build test kits for any 
      FHIR-based data exchange.

      ## Status
      These tests are intended to allow IPS server implementers to perform checks of their server 
      against IPS requirements. Future versions of these tests may validate other requirements 
      and may change how these are tested.

      ### Current Test Coverage
      The test kit currently validates:
      - IPS Bundle validation
      - Support for IPS operations
      - Profile Validation

      See the test descriptions within the test kit for detail on the specific validations 
      performed as part of testing these requirements.

      ## Repository
      The IPS Test Kit GitHub repository can be [found here](https://github.com/inferno-framework/ips-test-kit).

      ## Feedback and Issue Reporting
      We welcome feedback on the tests, including but not limited to the following areas:

      ### Validation Logic
      - Potential bugs
      - Lax checks
      - Unexpected failures

      ### Requirements Coverage
      - Missed requirements
      - Tests requiring features not in the IG
      - Issues with IG requirement interpretation

      ### User Experience
      - Confusing information
      - Missing information
      - Test UI improvements

      Please report any issues with this set of tests in the 
      [issues section](https://github.com/inferno-framework/ips-test-kit/issues) of the repository.
    DESCRIPTION
  end
end
