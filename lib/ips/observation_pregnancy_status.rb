module IPS
  class ObservationPregnancyStatus < Inferno::TestGroup
    title 'Observation (Pregnancy: status) Tests'
    description %(
      Verify support for the server capabilities required by the Observation (Pregnancy: status) profile.
      These tests focus on validating the server's ability to handle Observation resources that
      represent pregnancy status information according to the IPS Implementation Guide.
    )
    id :ips_observation_pregnancy_status

    link 'Observation (Pregnancy: status) Profile',
         'http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Observation-pregnancy-status-uv-ips'

    input :observation_pregnancy_status_id,
          title: 'Pregnancy Status Observation ID',
          description: 'ID of an existing Observation resource on the server that represents pregnancy status information'

    test do
      title 'Server supports reading Pregnancy Status Observation resources'
      description %(
        This test verifies that Observation resources containing pregnancy status information can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches Observation
        3. The returned resource ID matches the requested ID
      )
      makes_request :observation_pregnancy_status

      run do
        fhir_read(:observation, observation_pregnancy_status_id, name: :observation_pregnancy_status)

        assert_response_status(200)
        assert_resource_type(:observation)
        assert resource.id == observation_pregnancy_status_id,
               "Requested resource with id #{observation_pregnancy_status_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'Pregnancy Status Observation resources conform to IPS profile'
      description %(
        This test validates that the Observation resource returned from the server
        conforms to the [Observation (Pregnancy: status) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Observation-pregnancy-status-uv-ips).
        
        Profile-specific requirements verified by this test include:
        * Must have a status
        * Must have a code identifying this as a pregnancy status observation
        * Must have an effective[x] element with a date or period
        * Must reference a Patient as the subject
      )
      uses_request :observation_pregnancy_status

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-pregnancy-status-uv-ips')
      end
    end
  end
end
