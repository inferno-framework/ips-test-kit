module IPS
  class MedicationCrossBorder < Inferno::TestGroup
    title 'Medication - Cross Border (IPS) Tests'
    description 'Verify support for the server capabilities required by the Medication - Cross Border (IPS) profile.'
    id :ips_medication_cross_border

    test do
      title 'Server returns correct Medication resource from the Medication read interaction'
      description %(
        This test will verify that Medication resources can be read from the server.
      )
      # link 'http://hl7.org/fhir/uv/ips/StructureDefinition/Medication-uv-ips'

      input :medication_id
      makes_request :medication

      run do
        fhir_read(:medication, medication_id, name: :medication)

        assert_response_status(200)
        assert_resource_type(:medication)
        assert resource.id == medication_id,
                "Requested resource with id #{medication_id}, received resource with id #{resource.id}"
      end
    end
  
    test do
      title 'Server returns Medication resource that matches the Medication - Cross Border (IPS) profile'
      description %(
        This test will validate that the Medication resource returned from the server matches the Medication - Cross Border (IPS) profile.
      )
      # link 'http://hl7.org/fhir/uv/ips/StructureDefinition/Medication-uv-ips'
      uses_request :medication

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Medication-cross-border-uv-ips
          ')
      end
    end
  end
end