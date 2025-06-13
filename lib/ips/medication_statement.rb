module IPS
  class MedicationStatement < Inferno::TestGroup
    title 'Medication Statement (IPS) Tests'
    id :ips_medication_statement

    description %(
      Verify support for the server capabilities required by the Medication Statement (IPS) profile.
      These tests focus on validating the server's ability to handle MedicationStatement resources that
      represent a patient's reported medication use according to the IPS Implementation Guide.

      For more information, see:
      * [Medication Statement (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/MedicationStatement-uv-ips)
    )

    input :medication_statement_id,
          title: 'MedicationStatement ID',
          description: 'ID of an existing MedicationStatement resource on the server that represents a patient\'s reported medication use'

    test do
      title 'Server supports reading MedicationStatement resources'
      description %(
        This test verifies that MedicationStatement resources can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches MedicationStatement
        3. The returned resource ID matches the requested ID
      )
      makes_request :medication_statement

      run do
        fhir_read(:medication_statement, medication_statement_id, name: :medication_statement)

        assert_response_status(200)
        assert_resource_type(:medication_statement)
        assert resource.id == medication_statement_id,
               "Requested resource with id #{medication_statement_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'MedicationStatement resources conform to IPS profile'
      description %(
        This test validates that the MedicationStatement resource returned from the server
        conforms to the [Medication Statement (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/MedicationStatement-uv-ips).

        Profile-specific requirements verified by this test include:
        * Must have a status
        * Must have a medication code or reference
        * Must have an effective time
        * Must reference a Patient as the subject
      )
      uses_request :medication_statement

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/MedicationStatement-uv-ips')
      end
    end
  end
end
