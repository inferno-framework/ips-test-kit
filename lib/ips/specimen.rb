module IPS
  class Specimen < Inferno::TestGroup
    title 'Specimen (IPS) Tests'
    id :ips_specimen

    description %(
      Verify support for the server capabilities required by the Specimen (IPS) profile.
      These tests focus on validating the server's ability to handle Specimen resources that
      represent clinical specimens according to the IPS Implementation Guide.

      For more information, see:
      * [Specimen (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Specimen-uv-ips)

    )

    test do
      title 'Server supports reading Specimen resources'
      description %(
        This test verifies that Specimen resources can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches Specimen
        3. The returned resource ID matches the requested ID
      )

      input :specimen_id,
            title: 'Specimen ID',
            description: 'ID of an existing Specimen resource on the server that represents a clinical specimen'
      makes_request :specimen

      run do
        fhir_read(:specimen, specimen_id, name: :specimen)

        assert_response_status(200)
        assert_resource_type(:specimen)
        assert resource.id == specimen_id,
               "Requested resource with id #{specimen_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'Specimen resources conform to IPS profile'
      description %(
        This test validates that the Specimen resource returned from the server
        conforms to the [Specimen (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Specimen-uv-ips).

        Profile-specific requirements verified by this test include:
        * Must have a type
      )
      uses_request :specimen

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Specimen-uv-ips')
      end
    end
  end
end
