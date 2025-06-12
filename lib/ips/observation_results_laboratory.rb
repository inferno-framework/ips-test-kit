module IPS
  class ObservationResultsLaboratory < Inferno::TestGroup
    title 'Observation Results: laboratory (IPS) Tests'
    description %(
      Verify support for the server capabilities required by the Observation Results: laboratory (IPS) profile.
      These tests focus on validating the server's ability to handle Observation resources that
      represent laboratory test results according to the IPS Implementation Guide.
    )
    id :ips_observation_results_laboratory

    link 'Observation Results: Laboratory (IPS) Profile',
         'http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Observation-results-laboratory-uv-ips'

    input :observation_results_laboratory_id,
          title: 'Laboratory Results ID',
          description: 'ID of an existing Observation resource on the server that represents laboratory test results'

    test do
      title 'Server supports reading Laboratory Results resources'
      description %(
        This test verifies that Observation resources containing laboratory results can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches Observation
        3. The returned resource ID matches the requested ID
      )
      makes_request :observation_lab

      run do
        fhir_read(:observation, observation_results_laboratory_id, name: :observation_lab)

        assert_response_status(200)
        assert_resource_type(:observation)
        assert resource.id == observation_results_laboratory_id,
               "Requested resource with id #{observation_results_laboratory_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'Laboratory Results resources conform to IPS profile'
      description %(
        This test validates that the Observation resource returned from the server
        conforms to the [Observation Results: Laboratory (IPS) profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Observation-results-laboratory-uv-ips).
        
        Profile-specific requirements verified by this test include:
        * Must have a status
        * Must have category coded as 'laboratory'
        * Must have a code identifying the type of laboratory test
        * Must include a value or a data absent reason
        * Must reference a Patient as the subject
        * Must use standard UCUM units for quantitative results
      )
      uses_request :observation_lab

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-results-laboratory-uv-ips')
      end
    end
  end
end
