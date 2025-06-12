module IPS
  class IPSResourceValidation < Inferno::TestGroup
    title 'IPS Resource Validation Tests'
    id :ips_resource_validation
    description %(
      This group performs content validation for systems that produce IPS bundles without using
      a FHIR interface, as described in the [IPS Guidance](http://hl7.org/fhir/uv/ips/STU1.1/ipsGeneration.html).

      These tests validate that:
      1. Systems can produce valid IPS bundles that conform to the profile
      2. Generated bundles contain all required elements and sections
      3. Resources within the bundle follow IPS Implementation Guide requirements

      Note: Currently there is a single validation test for IPS bundles without context-specific
      constraints. Future enhancements may require systems to demonstrate additional capabilities
      beyond producing a single valid IPS bundle.
    )

    link 'Bundle (IPS) Profile',
         'http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Bundle-uv-ips'

    group do
      title 'IPS Bundle with no other constraints'

      test do
        title 'IPS Bundle conforms to profile requirements'
        description %(
          This test validates that a provided IPS bundle conforms to the [Bundle (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Bundle-uv-ips).

          It validates that:
          1. The resource is a Bundle
          2. The Bundle type is 'document'
          3. The Bundle contains all required sections
          4. All resources within the Bundle conform to their respective IPS profiles
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
