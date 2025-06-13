module IPS
  class Organization < Inferno::TestGroup
    title 'Organization (IPS) Tests'
    id :ips_organization

    description %(
      Verify support for the server capabilities required by the Organization (IPS) profile.
      These tests focus on validating the server's ability to handle Organization resources that
      represent healthcare organizations according to the IPS Implementation Guide.

      For more information, see:
      * [Organization (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Organization-uv-ips)

    )

    test do
      title 'Server supports reading Organization resources'
      description %(
        This test verifies that Organization resources can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches Organization
        3. The returned resource ID matches the requested ID
      )

      input :organization_id,
            title: 'Organization ID',
            description: 'ID of an existing Organization resource on the server that represents a healthcare organization'
      makes_request :organization

      run do
        fhir_read(:organization, organization_id, name: :organization)

        assert_response_status(200)
        assert_resource_type(:organization)
        assert resource.id == organization_id,
               "Requested resource with id #{organization_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'Organization resources conform to IPS profile'
      description %(
        This test validates that the Organization resource returned from the server
        conforms to the [Organization (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Organization-uv-ips).

        Profile-specific requirements verified by this test include:
        * Must have a name
      )
      uses_request :organization

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Organization-uv-ips')
      end
    end
  end
end
