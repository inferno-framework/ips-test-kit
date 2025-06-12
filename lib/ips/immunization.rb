module IPS
  class Immunization < Inferno::TestGroup
    title 'Immunization (IPS) Tests'
    description %(
      Verify support for the server capabilities required by the Immunization (IPS) profile.
      These tests focus on validating the server's ability to handle Immunization resources that
      represent vaccinations according to the IPS Implementation Guide.
    )
    id :ips_immunization

    link 'Immunization (IPS) Profile',
         'http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Immunization-uv-ips'

    test do
      title 'Server supports reading Immunization resources'
      description %(
        This test verifies that Immunization resources can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches Immunization
        3. The returned resource ID matches the requested ID
      )

      input :immunization_id,
            title: 'Immunization ID',
            description: 'ID of an existing Immunization resource on the server that represents a vaccination'
      makes_request :immunization

      run do
        fhir_read(:immunization, immunization_id, name: :immunization)

        assert_response_status(200)
        assert_resource_type(:immunization)
        assert resource.id == immunization_id,
               "Requested resource with id #{immunization_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'Immunization resources conform to IPS profile'
      description %(
        This test validates that the Immunization resource returned from the server
        conforms to the [Immunization (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Immunization-uv-ips).

        Profile-specific requirements verified by this test include:
        * Must have a status
        * Must have a vaccine code
        * Must have an occurrence time
        * Must reference a Patient as the subject
      )
      uses_request :immunization

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Immunization-uv-ips')
      end
    end
  end
end
