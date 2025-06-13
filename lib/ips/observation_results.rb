module IPS
  class ObservationResults < Inferno::TestGroup
    title 'Observation Results (IPS) Tests'
    description %(
      Verify support for the server capabilities required by the Observation Results (IPS) profile.
      These tests focus on validating the server's ability to handle Observation resources that
      represent clinical findings and measurements according to the IPS Implementation Guide.

      For more information, see:
      * [Observation Results (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Observation-results-uv-ips)
    )
    id :ips_observation_results

    input :observation_results_id,
          title: 'Observation Results ID',
          description: 'ID of an existing Observation resource on the server that represents clinical findings or measurements'

    test do
      title 'Server supports reading Observation Results resources'
      description %(
        This test verifies that Observation resources containing clinical results can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches Observation
        3. The returned resource ID matches the requested ID
      )
      makes_request :observation

      run do
        fhir_read(:observation, observation_results_id, name: :observation)

        assert_response_status(200)
        assert_resource_type(:observation)
        assert resource.id == observation_results_id,
               "Requested resource with id #{observation_results_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'Observation Results resources conform to IPS profile'
      description %(
        This test validates that the Observation resource returned from the server
        conforms to the [Observation Results (IPS) profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Observation-results-uv-ips).
        
        Profile-specific requirements verified by this test include:
        * Must have a status
        * Must have a category with required coding
        * Must have a code identifying the type of observation
        * Must include a value or a data absent reason
        * Must reference a Patient as the subject
      )
      uses_request :observation

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-results-uv-ips')
      end
    end
  end
end
