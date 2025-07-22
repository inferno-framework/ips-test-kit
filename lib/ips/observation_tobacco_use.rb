module IPS
  class ObservationTobaccoUse < Inferno::TestGroup
    title 'Observation (SH: tobacco use) Tests'
    description %(
      Verify support for the server capabilities required by the Observation (SH: tobacco use) profile.
      These tests focus on validating the server's ability to handle Observation resources that
      represent tobacco use information according to the IPS Implementation Guide.

      For more information, see:
      * [Observation (SH: tobacco use) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Observation-tobaccouse-uv-ips)
    )
    id :ips_observation_tobacco_use

    input :observation_tobacco_use_id,
          title: 'Tobacco Use Observation ID',
          description: 'ID of an existing Observation resource on the server that represents tobacco use information'

    test do
      title 'Server returns correct Tobacco Use Observation resource from the Tobacco Use Observation read interaction'
      description %(
        This test verifies that Observation resources containing tobacco use information can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches Observation
        3. The returned resource ID matches the requested ID
      )
      makes_request :observation_tobacco_use

      run do
        fhir_read(:observation, observation_tobacco_use_id, name: :observation_tobacco_use)

        assert_response_status(200)
        assert_resource_type(:observation)
        assert resource.id == observation_tobacco_use_id,
               "Requested resource with id #{observation_tobacco_use_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'Tobacco Use Observation resources conform to IPS profile'
      description %(
        This test validates that the Observation resource returned from the server
        conforms to the [Observation (SH: tobacco use) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Observation-tobaccouse-uv-ips).
        
        Profile-specific requirements verified by this test include:
        * Must have a status
        * Must have a code identifying this as a tobacco use observation
        * Must have an effective[x] element with a date or period
        * Must reference a Patient as the subject
      )
      uses_request :observation_tobacco_use

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-tobaccouse-uv-ips')
      end
    end
  end
end
