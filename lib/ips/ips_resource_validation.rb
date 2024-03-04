module IPS
  class IPSResourceValidation < Inferno::TestGroup
    title 'IPS Resource Validation Tests'
    id :ips_resource_validation
    description %(
      This group performs content validation, which is useful for evaluating
      conformance of systems that produce IPS bundles but do not generate
      content using a FHIR interface as described in the [IPS
      Guidance](http://hl7.org/fhir/uv/ips/STU1.1/ipsGeneration.html).

      There is currently a single validation test for IPS bundles without any
      other context-specific constraints.  Therefore, this test measures a
      systems ability to produce a single, valid IPS bundle. Future enhancements
      to these tests should require systems to demonstrate more than just a
      single valid IPS bundle.
    )

    group do
      title 'IPS Bundle with no other constraints'

      test do
        title 'IPS Bundle meets constraints provided in the IPS Bundle profile'
        description %(
          This test will validate the content of an IPS bundle to ensure it is valid.
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
