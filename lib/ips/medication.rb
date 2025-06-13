module IPS
  class Medication < Inferno::TestGroup
    title 'Medication (IPS) Tests'
    id :ips_medication

    description %(
      Verify support for the server capabilities required by the Medication (IPS) profile.
      These tests focus on validating the server's ability to handle Medication resources that
      represent medications according to the IPS Implementation Guide.

      For more information, see:
      * [Medication (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Medication-uv-ips)
    )

    test do
      title 'Server supports reading Medication resources'
      description %(
        This test verifies that Medication resources can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches Medication
        3. The returned resource ID matches the requested ID
      )

      input :medication_id,
            title: 'Medication ID',
            description: 'ID of an existing Medication resource on the server that represents a medication'
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
      title 'Medication resources conform to IPS profile'
      description %(
        This test validates that the Medication resource returned from the server
        conforms to the [Medication (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Medication-uv-ips).

        Profile-specific requirements verified by this test include:
        * Must have a code identifying the medication
      )
      uses_request :medication

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Medication-uv-ips')
      end
    end
  end
end
