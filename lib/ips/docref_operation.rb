module IPS
  class DocRefOperation < Inferno::TestGroup
    title 'DocRef Operation Tests'

    description %(
      This group tests server support for the DocumentReference/$docref operation 
      as referenced in the IPS Implementation Guide v1.1.0. The tests validate 
      both the operational capability declaration and basic operation functionality.

      Key capabilities tested:
      - CapabilityStatement declares $docref operation support
      - $docref operation responds successfully to requests

      Note: These tests currently validate basic operation functionality but do not 
      specifically request IPS bundles or validate IPS-specific content. Future 
      versions may include more comprehensive IPS-specific validation.
    )
    id :ips_docref_operation
    run_as_group
    optional

    test do
      title 'Server declares support for $docref operation in CapabilityStatement'
      description %(
        This test verifies that the server declares support for the DocumentReference/$docref 
        operation in its CapabilityStatement. The test retrieves the server's CapabilityStatement 
        and searches for the $docref operation definition in the DocumentReference resource operations.

        The test validates:
        - HTTP 200 response when retrieving CapabilityStatement
        - CapabilityStatement is a valid CapabilityStatement resource
        - DocumentReference resource declares $docref operation support

        The test checks for either:
        - An operation with the definition URL http://hl7.org/fhir/uv/ipa/OperationDefinition/docref
        - An operation with the name "docref" (case-insensitive)
      )
      # link 'http://build.fhir.org/composition-operation-document.html'

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
      title 'Server responds successfully to $docref operation request'
      description %(
        This test verifies that the server responds successfully to a DocumentReference/$docref 
        operation request. The test constructs a FHIR Parameters resource with a patient 
        parameter and sends it to the $docref operation endpoint.

        The test validates:
        - HTTP 200 response status from the $docref operation

        The test requires a valid patient_id input and creates a docref_operation request 
        that can be referenced by subsequent tests.

        Note: This test currently validates basic operation functionality but does not 
        specifically request IPS bundles or validate IPS-specific content in the response.
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
