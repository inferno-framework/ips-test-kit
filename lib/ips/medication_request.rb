module IPS
  class MedicationRequest < Inferno::TestGroup
    title 'MedicationRequest (IPS) Tests'
    id :ips_medication_request

    description %(
      Verify support for the server capabilities required by the MedicationRequest (IPS) profile.
      These tests focus on validating the server's ability to handle MedicationRequest resources that
      represent medication prescriptions according to the IPS Implementation Guide.

      For more information, see:
      * [MedicationRequest (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/MedicationRequest-uv-ips)
    )

    test do
      title 'Server supports reading MedicationRequest resources'
      description %(
        This test verifies that MedicationRequest resources can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches MedicationRequest
        3. The returned resource ID matches the requested ID
      )

      input :medication_request_id,
            title: 'MedicationRequest ID',
            description: 'ID of an existing MedicationRequest resource on the server that represents a medication prescription'
      makes_request :medication_request

      run do
        fhir_read(:medication_request, medication_request_id, name: :medication_request)

        assert_response_status(200)
        assert_resource_type(:medication_request)
        assert resource.id == medication_request_id,
               "Requested resource with id #{medication_request_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'MedicationRequest resources conform to IPS profile'
      description %(
        This test validates that the MedicationRequest resource returned from the server
        conforms to the [MedicationRequest (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/MedicationRequest-uv-ips).

        Profile-specific requirements verified by this test include:
        * Must have a status
        * Must have an intent
        * Must have a medication code or reference
        * Must reference a Patient as the subject
      )
      uses_request :medication_request

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/MedicationRequest-uv-ips')
      end
    end
  end
end
