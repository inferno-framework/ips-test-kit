module IPS
  class PractitionerRole < Inferno::TestGroup
    title 'PractitionerRole (IPS) Tests'
    description %(
      Verify support for the server capabilities required by the PractitionerRole (IPS) profile.
      These tests focus on validating the server's ability to handle PractitionerRole resources that
      represent healthcare provider roles and responsibilities according to the IPS Implementation Guide.
    )
    id :ips_practitioner_role

    description %(
      Verify support for the server capabilities required by the PractitionerRole (IPS) profile.
      These tests focus on validating the server's ability to handle PractitionerRole resources that
      represent healthcare provider roles and responsibilities according to the IPS Implementation Guide.
      
      For more information, see:
      * [PractitionerRole (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/PractitionerRole-uv-ips)

    )

    test do
      title 'Server supports reading PractitionerRole resources'
      description %(
        This test verifies that PractitionerRole resources can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches PractitionerRole
        3. The returned resource ID matches the requested ID
      )

      input :practitioner_role_id,
            title: 'PractitionerRole ID',
            description: 'ID of an existing PractitionerRole resource on the server that represents a healthcare provider role'
      makes_request :practitioner_role

      run do
        fhir_read(:practitioner_role, practitioner_role_id, name: :practitioner_role)

        assert_response_status(200)
        assert_resource_type(:practitioner_role)
        assert resource.id == practitioner_role_id,
               "Requested resource with id #{practitioner_role_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'PractitionerRole resources conform to IPS profile'
      description %(
        This test validates that the PractitionerRole resource returned from the server
        conforms to the [PractitionerRole (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/PractitionerRole-uv-ips).
      )
      uses_request :practitioner_role

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/PractitionerRole-uv-ips')
      end
    end
  end
end
