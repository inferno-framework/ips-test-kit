module IPS
  class IPSResourceValidation < Inferno::TestGroup
    title 'IPS Resource Validation Tests'
    id :ips_resource_validation
    description %(
      This group validates pre-existing IPS bundles for conformance to the IPS Bundle profile 
      without requiring a live FHIR server. It is designed for testing static IPS documents 
      or validating bundle structure and profile conformance offline.

      The validation tests accept IPS bundle content in JSON format and verify 
      conformance to the IPS Bundle profile (http://hl7.org/fhir/uv/ips/StructureDefinition/Bundle-uv-ips) 
      as defined in the IPS Implementation Guide v1.1.0.

      This testing approach is ideal for:
      - Systems that generate IPS bundles through non-FHIR interfaces
      - Offline validation of existing IPS documents  
      - Initial conformance testing during development
      - Validating IPS bundles before deployment

      The group currently provides basic IPS Bundle profile validation. Additional context-specific 
      validation tests may be added to verify specific clinical scenarios or content requirements.
    )

    group do
      title 'Basic IPS Bundle Validation'

      test do
        title 'IPS Bundle meets constraints provided in the IPS Bundle profile'
        description %(
          This test validates that the provided bundle content is a valid FHIR Bundle resource 
          that conforms to the IPS Bundle profile (http://hl7.org/fhir/uv/ips/StructureDefinition/Bundle-uv-ips).

          The test performs the following validations:
          - Parses the provided bundle content (JSON format)
          - Verifies the resource is of type Bundle
          - Validates conformance to the IPS Bundle profile constraints

          The test will skip if no bundle content is provided. Profile validation includes 
          verification of required elements, cardinality constraints, terminology bindings, 
          and structural requirements as defined in the IPS Implementation Guide v1.1.0.
        )
        input :bundle_content, title: 'IPS Bundle', type: 'textarea', optional: true, description: 'Validate a single IPS bundle (optional)'
  
        run do

          skip_if bundle_content.blank?, 'No IPS Bundle provided'

          resource_instance = FHIR.from_contents(bundle_content)

          assert_resource_type(:bundle, resource: resource_instance)
          assert_valid_resource(resource: resource_instance, profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Bundle-uv-ips')
  
        end
      end
    end

    # You could have extra context-sensitive groups e.g. "show me a bundle
    # that has this, or that" That way you can have a list of all the
    # different kinds of variants you would like to see in order to say that a
    # system can fully support IPS (assuming that a single valid example isn't
    # good enough)

    # group do
      # title 'IPS Bundle that has at least XYZ'

    # end
  end
end
