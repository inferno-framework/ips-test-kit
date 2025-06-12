module IPS
  class ObservationPregnancyEDD < Inferno::TestGroup
    title 'Observation (Pregnancy: EDD) Tests'
    description %(
      Verify support for the server capabilities required by the Observation (Pregnancy: EDD) profile.
      These tests focus on validating the server's ability to handle Observation resources that
      represent estimated delivery dates according to the IPS Implementation Guide.
    )
    id :ips_observation_pregnancy_edd

    link 'Observation (Pregnancy: EDD) Profile',
         'http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Observation-pregnancy-edd-uv-ips'

    input :observation_pregnancy_edd_id,
          title: 'Pregnancy EDD Observation ID',
          description: 'ID of an existing Observation resource on the server that represents an estimated delivery date'

    test do
      title 'Server supports reading Pregnancy EDD Observation resources'
      description %(
        This test verifies that Observation resources containing estimated delivery dates can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches Observation
        3. The returned resource ID matches the requested ID
      )

      input :observation_pregnancy_edd_id
      makes_request :observation_pregnancy_edd

      run do
        fhir_read(:observation, observation_pregnancy_edd_id, name: :observation_pregnancy_edd)

        assert_response_status(200)
        assert_resource_type(:observation)
        assert resource.id == observation_pregnancy_edd_id,
               "Requested resource with id #{observation_pregnancy_edd_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'Pregnancy EDD Observation resources conform to IPS profile'
      description %(
        This test validates that the Observation resource returned from the server
        conforms to the [Observation (Pregnancy: EDD) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Observation-pregnancy-edd-uv-ips).
        
        Profile-specific requirements verified by this test include:
        * Must have a status
        * Must have a code identifying this as an EDD observation
        * Must include a dateTime value for the estimated delivery date
        * Must reference a Patient as the subject
      )
      uses_request :observation_pregnancy_edd

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-pregnancy-edd-uv-ips')
      end
    end
  end
end
