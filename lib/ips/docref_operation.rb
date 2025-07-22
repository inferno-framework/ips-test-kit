module IPS
  class DocRefOperation < Inferno::TestGroup
    title 'DocRef Operation Tests'

    id :ips_docref_operation
    run_as_group
    optional

    description %(
      Verify support for the $docref operation as described in the [IPS
      Guidance](http://hl7.org/fhir/uv/ips/STU1.1/ipsGeneration.html).

      These tests validate that the server properly supports the DocumentReference/$docref
      operation for retrieving patient documents. Note that this currently does not
      request an IPS bundle specifically, therefore does not validate the content.
      
      For more information, see:
      * [DocumentReference $docref Operation](http://hl7.org/fhir/uv/ips/STU1.1/ipsGeneration.html#documentreferencedocref)
    )

    test do
      title 'IPS Server declares support for $docref operation in CapabilityStatement'
      description %(
        This test verifies that the server properly declares support for the $docref operation
        in its CapabilityStatement.

        It validates that:
        1. The server's CapabilityStatement is accessible
        2. The CapabilityStatement includes the $docref operation for DocumentReference resources
        3. The operation is defined using either:
           * The standard operation definition URL
           * The operation name 'docref'
      )

      run do
        fhir_get_capability_statement
        assert_response_status(200)
        assert_resource_type(:capability_statement)

        operations = resource.rest&.flat_map do |rest|
          rest.resource
            &.select { |r| r.type == 'DocumentReference' && r.respond_to?(:operation) }
            &.flat_map(&:operation)
        end&.compact

        operation_defined = operations.any? do |operation|
          operation.definition == 'http://hl7.org/fhir/uv/ipa/OperationDefinition/docref' || 'docref' == operation.name.downcase
        end

        assert operation_defined, 'Server CapabilityStatement did not declare support for $docref operation in DocumentReference resource.'
      end
    end

    test do
      title 'Server responds successfully to a $docref operation'
      description %(
        This test verifies that the server responds successfully to a $docref operation
        request for a specific patient.

        It validates that:
        1. The server accepts a POST request to DocumentReference/$docref
        2. The server processes the patient parameter correctly
        3. The server responds with a 200 OK status

        Note: This test currently does not request an IPS bundle specifically,
        therefore does not validate the content of the response.
      )

      input :patient_id
      makes_request :docref_operation

      run do

        # Perform a FHIR Operation
        parameters = FHIR::Parameters.new(
        parameter: [
          {
            name: 'patient',
            valueId: patient_id
          }
        ]
        )
        fhir_operation("/DocumentReference/$docref", body: parameters)

        assert_response_status(200)
      end

    end
  end
end
