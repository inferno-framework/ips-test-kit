module IPS
  class Procedure < Inferno::TestGroup
    title 'Procedure (IPS) Tests'
    id :ips_procedure

    description %(
      Verify support for the server capabilities required by the Procedure (IPS) profile.
      These tests focus on validating the server's ability to handle Procedure resources that
      represent medical procedures according to the IPS Implementation Guide.

      For more information, see:
      * [Procedure (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Procedure-uv-ips)

    )

    test do
      title 'Server supports reading Procedure resources'
      description %(
        This test verifies that Procedure resources can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches Procedure
        3. The returned resource ID matches the requested ID
      )

      input :procedure_id,
            title: 'Procedure ID',
            description: 'ID of an existing Procedure resource on the server that represents a medical procedure'
      makes_request :procedure

      run do
        fhir_read(:procedure, procedure_id, name: :procedure)

        assert_response_status(200)
        assert_resource_type(:procedure)
        assert resource.id == procedure_id,
               "Requested resource with id #{procedure_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'Procedure resources conform to IPS profile'
      description %(
        This test validates that the Procedure resource returned from the server
        conforms to the [Procedure (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Procedure-uv-ips).

        Profile-specific requirements verified by this test include:
        * Must have a status
        * Must have a code identifying the procedure
        * Must reference a Patient as the subject
        * Must have a performed time
      )
      uses_request :procedure

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Procedure-uv-ips')
      end
    end
  end
end
