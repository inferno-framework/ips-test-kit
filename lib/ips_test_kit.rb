Dir.glob(File.join(__dir__, 'ips', '*.rb')).each { |path| require_relative path.delete_prefix("#{__dir__}/") }
require_relative 'ips/metadata'

module IPS
  class Suite < Inferno::TestSuite
    title 'International Patient Summary (IPS) v1.1.0'
    short_title 'IPS v1.1.0'
    description %(
      This test suite evaluates the ability of systems to provide International Patient Summary (IPS) data
      using HL7® FHIR® in accordance with the [International Patient Summary Implementation Guide (IPS
      IG) v1.1.0](https://www.hl7.org/fhir/uv/ips/STU1.1).

      Key Capabilities:
      * Validation of IPS bundles against FHIR profiles and implementation guide requirements
      * Testing of standard FHIR APIs for generating and communicating IPS bundles
      * Verification of FHIR API access to individual IPS resources
      * Support for both server-based and standalone bundle validation workflows

      Usage Scenarios:
      1. Bundle Validation: Use 'IPS Resource Validation Tests' to evaluate standalone IPS bundles
         without requiring a server implementation
      2. API Operations: Use 'IPS Operation Tests' to verify systems that support standard APIs
         for generating and communicating IPS bundles
      3. Resource Access: Use 'IPS Read Tests' to validate systems that provide FHIR API access
         to individual IPS resources

      Available Presets:
      * HL7.org IPS Server: A hosted reference implementation suitable for Operation and Read tests
        (Note: Resource IDs may change as this is an open server)
      * IPS Example Summary Bundle: Pre-populated example from the IG for Resource Validation testing
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
        This group evaluates the ability of systems to provide a standard FHIR API for generating
        and communicating IPS Bundles as described in the [IPS Data Generation and Inclusion
        Guidance](http://hl7.org/fhir/uv/ips/STU1.1/ipsGeneration.html).

        Key Features:
        * Testing of $summary operation for generating IPS bundles
        * Validation of generated bundles against IPS profiles
        * Basic DocumentReference operation support
        * Verification of proper resource relationships and references

        Note: The DocumentReference operation tests are currently of limited scope but will be
        expanded in future versions.
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
        This group validates a system's ability to provide FHIR API access to individual IPS resources.
        Each resource must conform to the profiles specified in the IPS Implementation Guide.

        Key Features:
        * Individual resource retrieval via FHIR RESTful API
        * Profile validation for each resource type
        * Verification of required elements and extensions
        * Testing of resource references and relationships

        These tests are optional as not all IPS implementations are required to provide direct
        resource access. They are particularly relevant for systems that maintain IPS data and
        provide API access to individual resources.
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
      group do
        title 'Observation Profiles'
        description %(
          This group validates various observation resources that capture specific patient health data
          points as defined in the IPS Implementation Guide.

          Key Features:
          * Validation of lifestyle observations (alcohol and tobacco use)
          * Verification of pregnancy-related observations
          * Support for both coded and free-text entries
          * Proper use of required terminologies
        )

        group from: :ips_observation_alcohol_use
        group from: :ips_observation_pregnancy_edd
        group from: :ips_observation_pregnancy_outcome
        group from: :ips_observation_pregnancy_status
        group from: :ips_observation_tobacco_use
      end

      group do
        title 'Observation Result Profiles'
        description %(
          This group validates observation resources that represent clinical findings and measurements
          as specified in the IPS Implementation Guide.

          Key Features:
          * Support for laboratory, pathology, and radiology results
          * Validation of required measurement units and codes
          * Verification of proper result structure and formatting
          * Testing of optional components like reference ranges
        )

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
