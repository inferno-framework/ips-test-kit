module IPS
  class Patient < Inferno::TestGroup
    title 'Patient (IPS) Tests'
    id :ips_patient

    description %(
      Verify support for the server capabilities required by the Patient (IPS) profile.
      These tests focus on validating the server's ability to handle Patient resources that
      represent the subject of care according to the IPS Implementation Guide.

      For more information, see:
      * [Patient (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Patient-uv-ips)

    )

    test do
      title 'Server returns correct Patient resource from the Patient read interaction'
      description %(
        This test verifies that Patient resources can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches Patient
        3. The returned resource ID matches the requested ID
      )

      input :patient_id,
            title: 'Patient ID',
            description: 'ID of an existing Patient resource on the server that represents the subject of care'
      makes_request :patient

      run do
        fhir_read(:patient, patient_id, name: :patient)

        assert_response_status(200)
        assert_resource_type(:patient)
        assert resource.id == patient_id,
               "Requested resource with id #{patient_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'Patient resources conform to IPS profile'
      description %(
        This test validates that the Patient resource returned from the server
        conforms to the [Patient (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Patient-uv-ips).

        Profile-specific requirements verified by this test include:
        * Must have a name
        * Must have a birth date
      )
      uses_request :patient

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Patient-uv-ips')
      end
    end
  end
end
