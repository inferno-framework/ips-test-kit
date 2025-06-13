module IPS
  class Condition < Inferno::TestGroup
    title 'Condition (IPS) Tests'
    description %(
      Verify support for the server capabilities required by the Condition (IPS) profile.
      These tests focus on validating the server's ability to handle Condition resources that
      represent problems and diagnoses according to the IPS Implementation Guide.
    )
    id :ips_condition

    description %(
      Verify support for the server capabilities required by the Condition (IPS) profile.
      These tests focus on validating the server's ability to handle Condition resources that
      represent problems and diagnoses according to the IPS Implementation Guide.
      
      For more information, see:
      * [Condition (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Condition-uv-ips)
    )

    test do
      title 'Server supports reading Condition resources'
      description %(
        This test verifies that Condition resources can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches Condition
        3. The returned resource ID matches the requested ID
      )

      input :condition_id,
            title: 'Condition ID',
            description: 'ID of an existing Condition resource on the server that represents a problem or diagnosis'
      makes_request :condition

      run do
        fhir_read(:condition, condition_id, name: :condition)

        assert_response_status(200)
        assert_resource_type(:condition)
        assert resource.id == condition_id,
               "Requested resource with id #{condition_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'Condition resources conform to IPS profile'
      description %(
        This test validates that the Condition resource returned from the server
        conforms to the [Condition (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Condition-uv-ips).

        Profile-specific requirements verified by this test include:
        * Must have a code identifying the condition
        * Must include a clinical status
        * Must reference a Patient as the subject
      )
      uses_request :condition

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Condition-uv-ips')
      end
    end
  end
end
