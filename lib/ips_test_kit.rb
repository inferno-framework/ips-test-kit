Dir.glob(File.join(__dir__, 'ips', '*.rb')).each { |path| require_relative path.delete_prefix("#{__dir__}/") }
require_relative 'ips/metadata'

module IPS
  class Suite < Inferno::TestSuite
    title 'International Patient Summary (IPS) v1.1.0'
    short_title 'IPS v1.1.0'
    description %(
      This test suite evaluates the ability of systems to provide patient summary data 
      expressed using HL7® FHIR® R4 in accordance with the [International Patient Summary 
      Implementation Guide (IPS IG) v1.1.0](https://www.hl7.org/fhir/uv/ips/STU1.1).

      The suite provides three distinct testing approaches to accommodate different 
      implementation scenarios and system capabilities:

      **Testing Approaches:**

      - **IPS Resource Validation Tests**: For validating pre-existing IPS bundles without 
        requiring a live FHIR server. Use this approach when you have static IPS documents 
        to validate or when testing bundle structure and profile conformance offline.

      - **IPS Operation Tests**: For testing systems that implement the $summary operation 
        and document reference capabilities as defined in the IPS IG. Use this approach 
        when your system generates IPS bundles dynamically via FHIR operations.

      - **IPS Read Tests**: For validating individual IPS resource profiles via standard 
        FHIR read operations. Use this approach when your system provides RESTful access 
        to individual IPS resources and you want to test profile conformance at the 
        resource level.

      **Key Capabilities Tested:**

      *Structural Validation:*
      - IPS Bundle structure and composition requirements
      - Resource entry organization and references
      - Required vs. optional section validation

      *Profile Conformance:*
      - All required IPS profiles (Patient, AllergyIntolerance, Condition, Medication, etc.)
      - Optional IPS profiles for comprehensive coverage
      - Cardinality constraints and element requirements

      *Operational Capabilities:*
      - $summary operation implementation and response validation
      - Document reference creation and retrieval workflows
      - Bundle generation from patient data

      *Terminology Validation:*
      - Value set bindings for coded elements
      - Required terminology systems and codes
      - IPS-specific code system usage

      **Prerequisites:**
      - FHIR R4 server implementation (for Operation and Read tests)
      - Valid patient data conforming to IPS profiles
      - For Operation tests: Implementation of the $summary operation
      - For Read tests: RESTful FHIR API with read capabilities

      **Available Presets:**

      - **HL7.org IPS Server**: Pre-configured for testing against the hosted reference 
        IPS server. Suitable for Operation and Read tests. Note that resource IDs may 
        change as this is a shared testing environment.

      - **IPS Example Summary Bundle**: Pre-loads the Resource Validation tests with 
        example IPS bundles from the specification. Ideal for initial validation and 
        understanding IPS structure requirements.

      **Scope and Limitations:**
      This suite focuses on IPS document structure, profile conformance, and core operational 
      requirements. It does not test advanced workflow scenarios, security implementations, 
      or integration with external systems beyond the IPS specification scope.
    )

    id 'ips'

    VALIDATION_MESSAGE_FILTERS = [
      /\A\S+: \S+: URL value '.*' does not resolve/
    ].freeze

    fhir_resource_validator do
      igs 'hl7.fhir.uv.ips#1.1.0'

      exclude_message do |message|
        VALIDATION_MESSAGE_FILTERS.any? { |filter| filter.match? message.message }
      end
    end

    links [
      {
        label: 'Report Issue',
        url: 'https://github.com/inferno-framework/ips-test-kit/issues/'
      },
      {
        label: 'Open Source',
        url: 'https://github.com/inferno-framework/ips-test-kit/'
      },
      {
        label: 'Download',
        url: 'https://github.com/inferno-framework/ips-test-kit/releases'
      },
      {
        label: 'International Patient Summary IG v1.1.0',
        url: 'http://hl7.org/fhir/uv/ips/STU1.1/'
      }
    ]

    # Comment this out to remove
    group from: :ips_resource_validation

    group do
      title 'IPS Server Operations for Generating IPS Bundles Tests'
      short_title 'IPS Operation Tests'
      description %(
        This group evaluates the ability of systems to provide a standard FHIR
        API for generating and communicating an IPS Bundle as described in the
        [IPS Data Generation and Inclusion Guidance](http://hl7.org/fhir/uv/ips/STU1.1/ipsGeneration.html).

        Please note that the DocRef tests are currently of limited scope.
      )


      input :url, title: 'IPS FHIR Server Base URL'

      fhir_client do
        url :url
      end

      group from: :ips_summary_operation
      group from: :ips_docref_operation
    end

    group do
      title 'IPS Server Read and Validate Profiles Tests'
      short_title 'IPS Read Tests'
      description %(
        This group tests server support for individual IPS resource profiles via standard 
        FHIR read operations. It validates that servers can provide RESTful access to IPS 
        resources and that these resources conform to their respective IPS profile requirements.

        Each resource type test group performs two key validations:
        - **Read Operation Test**: Executes a FHIR read operation using the provided resource ID, 
          verifies successful HTTP 200 response, confirms correct resource type, and validates 
          that the returned resource has the expected ID
        - **Profile Conformance Test**: Validates that the retrieved resource conforms to its 
          specific IPS profile requirements including structural constraints, cardinality rules, 
          and terminology bindings

        This testing approach is suitable for servers that store IPS resources individually 
        and provide standard FHIR RESTful API access. It requires valid resource IDs for 
        each resource type being tested.

        **Prerequisites**: 
        - FHIR R4 server with RESTful read capabilities
        - Valid resource IDs for the IPS resources to be tested
        - Resources that conform to IPS profile requirements

        **Coverage**: Tests all IPS resource profiles including:
        - Core structural profiles (Bundle, Composition, Patient) - always required
        - Required section profiles (AllergyIntolerance, Condition, MedicationStatement/MedicationRequest/Medication)
        - Recommended section profiles (Immunization, Procedure, DiagnosticReport, Device profiles)
        - Optional section profiles (Observation variants for vital signs, pregnancy, social history, etc.)
      )
      optional

      input :url, title: 'IPS FHIR Server Base URL'

      fhir_client do
        url :url
      end

      group from: :ips_allergy_intolerance
      group from: :ips_bundle
      group from: :ips_composition
      group from: :ips_condition
      group from: :ips_diagnostic_report
      group from: :ips_device
      group from: :ips_device_observer
      group from: :ips_device_use_statement
      group from: :ips_imaging_study
      group from: :ips_immunization
      group from: :ips_media_observation
      group from: :ips_medication
      group from: :ips_medication_request
      group from: :ips_medication_statement
      group  do
        title 'Observation Profiles'

        group from: :ips_observation_alcohol_use
        group from: :ips_observation_pregnancy_edd
        group from: :ips_observation_pregnancy_outcome
        group from: :ips_observation_pregnancy_status
        group from: :ips_observation_tobacco_use
      end
      group do
        title 'Observation Result Profiles'

        group from: :ips_observation_results
        group from: :ips_observation_results_laboratory
        group from: :ips_observation_results_pathology
        group from: :ips_observation_results_radiology
      end
      group from: :ips_organization
      group from: :ips_patient
      group from: :ips_practitioner
      group from: :ips_practitioner_role
      group from: :ips_procedure
      group from: :ips_specimen

    end
  end
end
