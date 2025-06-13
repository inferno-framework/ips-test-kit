module IPS
  class Practitioner < Inferno::TestGroup
    title 'Practitioner (IPS) Tests'
    id :ips_practitioner

    description %(
      Verify support for the server capabilities required by the Practitioner (IPS) profile.
      These tests focus on validating the server's ability to handle Practitioner resources that
      represent healthcare providers according to the IPS Implementation Guide.

      For more information, see:
      * [Practitioner (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Practitioner-uv-ips)

    )

    test do
      title 'Server supports reading Practitioner resources'
      description %(
        This test verifies that Practitioner resources can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches Practitioner
        3. The returned resource ID matches the requested ID
      )

      input :practitioner_id,
            title: 'Practitioner ID',
            description: 'ID of an existing Practitioner resource on the server that represents a healthcare provider'
      makes_request :practitioner

      run do
        fhir_read(:practitioner, practitioner_id, name: :practitioner)

        assert_response_status(200)
        assert_resource_type(:practitioner)
        assert resource.id == practitioner_id,
               "Requested resource with id #{practitioner_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'Practitioner resources conform to IPS profile'
      description %(
        This test validates that the Practitioner resource returned from the server
        conforms to the [Practitioner (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Practitioner-uv-ips).

        Profile-specific requirements verified by this test include:
        * Must have a name
      )
      uses_request :practitioner

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Practitioner-uv-ips')
      end
    end
  end
end
