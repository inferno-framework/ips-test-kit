module IPS
  class ObservationAlcoholUse < Inferno::TestGroup
    title 'Observation (SH: alcohol use) Tests'
    description %(
      Verify support for the server capabilities required by the Observation (SH: alcohol use) profile.
      These tests focus on validating the server's ability to handle Observation resources that
      represent alcohol use information according to the IPS Implementation Guide.
    )
    id :ips_observation_alcohol_use

    link 'Observation (SH: alcohol use) Profile',
         'http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Observation-alcoholuse-uv-ips'

    input :observation_alcohol_use_id,
          title: 'Alcohol Use Observation ID',
          description: 'ID of an existing Observation resource on the server that represents alcohol use information'

    test do
      title 'Server supports reading Alcohol Use Observation resources'
      description %(
        This test verifies that Observation resources containing alcohol use information can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches Observation
        3. The returned resource ID matches the requested ID
      )
      makes_request :observation_alcohol_use

      run do
        fhir_read(:observation, observation_alcohol_use_id, name: :observation_alcohol_use)

        assert_response_status(200)
        assert_resource_type(:observation)
        assert resource.id == observation_alcohol_use_id,
               "Requested resource with id #{observation_alcohol_use_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'Alcohol Use Observation resources conform to IPS profile'
      description %(
        This test validates that the Observation resource returned from the server
        conforms to the [Observation (SH: alcohol use) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Observation-alcoholuse-uv-ips).
        
        Profile-specific requirements verified by this test include:
        * Must have a status
        * Must have category coded as 'social-history'
        * Must have a code identifying this as an alcohol use observation
        * Must include a value or a data absent reason
        * Must reference a Patient as the subject
      )
      uses_request :observation_alcohol_use

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-alcoholuse-uv-ips')
      end
    end
  end
end
