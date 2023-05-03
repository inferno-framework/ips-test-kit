module IPS
  class MedicationRequest < Inferno::TestGroup
    title 'MedicationRequest (IPS) Tests'
    description 'Verify support for the server capabilities required by the MedicationRequest (IPS) profile.'
    id :ips_medication_request

    test do
      title 'Server returns correct MedicationRequest resource from the MedicationRequest read interaction'
      description %(
        This test will verify that MedicationRequest resources can be read from the server.
      )
      # link 'http://hl7.org/fhir/uv/ips/StructureDefinition/MedicationRequest-uv-ips'

      input :medication_request_id
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
      title 'Server returns MedicationRequest resource that matches the MedicationRequest (IPS) profile'
      description %(
        This test will validate that the MedicationRequest resource returned from the server matches the MedicationRequest (IPS) profile.
      )
      # link 'http://hl7.org/fhir/uv/ips/StructureDefinition/MedicationRequest-uv-ips'
      uses_request :medication_request

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/MedicationRequest-uv-ips')
      end
    end
  end
end
