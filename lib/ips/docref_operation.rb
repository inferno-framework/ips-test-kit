module IPS
  class DocRefOperation < Inferno::TestGroup
    title 'DocRef Operation Tests'

    description %(
        Verify support for the $docref operation as as described in the [IPS
        Guidance](http://hl7.org/fhir/uv/ips/STU1.1/ipsGeneration.html).

        Note that this currently does not request an IPS bundle specifically
        therefore does not validate the content.
    )
    id :ips_docref_operation
    run_as_group
    optional

    test do
      title 'IPS Server declares support for $docref operation in CapabilityStatement'
      description %(
        The IPS Server declares support for DocumentReference/$docref operation in its server CapabilityStatement
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
      title 'Server responds successfully to a $docref operation'
      description %(
        This test creates a $docref operation request for a patient.  Note that this
        currently does not request an IPS bundle specifically therefore does not validate
        the content.
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
