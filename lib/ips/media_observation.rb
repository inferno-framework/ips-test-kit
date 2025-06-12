module IPS
  class MediaObservation < Inferno::TestGroup
    title 'Media observation (Results: laboratory, media) Tests'
    description %(
      Verify support for the server capabilities required by the Media observation (Results: laboratory, media) profile.
      These tests focus on validating the server's ability to handle Media resources that
      represent laboratory media observations according to the IPS Implementation Guide.
    )
    id :ips_media_observation

    link 'Media observation (Results: laboratory, media) Profile',
         'http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Media-observation-uv-ips'

    test do
      title 'Server supports reading Media resources'
      description %(
        This test verifies that Media resources can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches Media
        3. The returned resource ID matches the requested ID
      )

      input :media_id,
            title: 'Media ID',
            description: 'ID of an existing Media resource on the server that represents a laboratory media observation'
      makes_request :media

      run do
        fhir_read(:media, media_id, name: :media)

        assert_response_status(200)
        assert_resource_type(:media)
        assert resource.id == media_id,
               "Requested resource with id #{media_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'Media resources conform to IPS profile'
      description %(
        This test validates that the Media resource returned from the server
        conforms to the [Media observation (Results: laboratory, media) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Media-observation-uv-ips).

        Profile-specific requirements verified by this test include:
        * Must have a status
        * Must have a content attachment
        * Must reference a Patient as the subject
      )
      uses_request :media

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Media-observation-uv-ips')
      end
    end
  end
end
