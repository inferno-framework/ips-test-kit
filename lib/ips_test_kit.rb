Dir.glob(File.join(__dir__, 'ips', '*.rb')).each { |path| require_relative path.delete_prefix("#{__dir__}/") }
require_relative 'ips/version'

module IPS
  class Suite < Inferno::TestSuite
    title 'International Patient Summary (IPS) v1.1.0'
    short_title 'IPS v1.1.0'
    description %(
      This test suite evaluates the ability of a system to provide patient
      summary data expressed using HL7® FHIR® in accordance with the
      [International Patient Summary Implementation Guide (IPS
      IG) v1.1.0](https://www.hl7.org/fhir/uv/ips/STU1.1).  

      Because IPS bundles can be generated and transmitted in many different
      ways beyond a traditional FHIR RESTful server, this test suite allows you
      to optionally evaluate a single bundle that is not being provided by a server in the
      'IPS Resource Validation Tests'.

      For systems that support a standard API for generating and communicating
      these bundles in accordance with the guidance provided in the IG, use the
      'IPS Operation Tests'.

      For systems that also provide a FHIR API access to the components resources
      of the IPS bundle, use the 'IPS Read Tests'.

      This suite provides two presets:
      * HL7.org IPS Server: Hosted reference IPS Server.  This is suitable for running
        the 'Operation' and 'Read' tests.  Resource IDs may not remain valid as this is an
        open server.
      * IPS Example Summary Bundle: Populates the 'IPS Resource Validation Test' with an
        example provided in the IG. 
    )

    id 'ips'
    version IPS::VERSION

    validator do
      url ENV.fetch('VALIDATOR_URL', 'http://validator_service:4567')
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
