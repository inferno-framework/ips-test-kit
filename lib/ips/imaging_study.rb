module IPS
  class ImagingStudy < Inferno::TestGroup
    title 'Imaging Study (IPS) Tests'
    id :ips_imaging_study

    description %(
      Verify support for the server capabilities required by the Imaging Study (IPS) profile.
      These tests focus on validating the server's ability to handle ImagingStudy resources that
      represent imaging procedures according to the IPS Implementation Guide.

      For more information, see:
      * [Imaging Study (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/ImagingStudy-uv-ips)
    )

    test do
      title 'Server returns correct Imaging Study resource from the Study read interaction'
      description %(
        This test verifies that ImagingStudy resources can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches ImagingStudy
        3. The returned resource ID matches the requested ID
      )

      input :imaging_study_id,
            title: 'Imaging Study ID',
            description: 'ID of an existing ImagingStudy resource on the server that represents an imaging procedure'
      makes_request :imaging_study

      run do
        fhir_read(:imaging_study, imaging_study_id, name: :imaging_study)

        assert_response_status(200)
        assert_resource_type(:imaging_study)
        assert resource.id == imaging_study_id,
               "Requested resource with id #{imaging_study_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'Imaging Study resources conform to IPS profile'
      description %(
        This test validates that the ImagingStudy resource returned from the server
        conforms to the [Imaging Study (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/ImagingStudy-uv-ips).

        Profile-specific requirements verified by this test include:
        * Must have a status
        * Must reference a Patient as the subject
      )
      uses_request :imaging_study

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/ImagingStudy-uv-ips')
      end
    end
  end
end
