module IPS
  class SummaryOperation < Inferno::TestGroup
    title 'Summary Operation Tests'
    description %(
        Verify support for the $summary operation as as described in the [IPS
        Guidance](http://hl7.org/fhir/uv/ips/STU1.1/ipsGeneration.html).
    )
    id :ips_summary_operation
    run_as_group

    test do
      title 'IPS Server declares support for $summary operation in CapabilityStatement'
      description %(
        The IPS Server declares support for Patient/[id]/$summary operation in its server CapabilityStatement
      )

      run do
        fhir_get_capability_statement
        assert_response_status(200)

        operations = resource.rest&.flat_map do |rest|
          rest.resource
            &.select { |r| r.type == 'Patient' && r.respond_to?(:operation) }
            &.flat_map(&:operation)
        end&.compact

        operation_defined = operations.any? do |operation|
          operation.definition == 'http://hl7.org/fhir/uv/ips/OperationDefinition/summary' ||
            ['summary', 'patient-summary'].include?(operation.name.downcase)
        end

        assert operation_defined, 'Server CapabilityStatement did not declare support for $summary operation in Patient resource.'
      end
    end

    test do
      title 'IPS Server returns Bundle resource for Patient/[id]/$summary GET operation'
      description %(
        IPS Server return valid IPS Bundle resource as successful result of
        $summary operation.

        This test currently only issues a GET request for the summary due to a
        limitation in Inferno in issuing POST requests that omit a Content-Type
        header when the body is empty. Inferno currently adds a `Content-Type:
        application/x-www-form-urlencoded` header when issuing a POST with no
        body, which causes issues in known reference implementations.

        A future update to this test suite should include a required POST
        request as well as an optional GET request for this content.

      )
      input :patient_id
      makes_request :summary_operation

      run do
        fhir_operation("Patient/#{patient_id}/$summary", name: :summary_operation, operation_method: :get)
        assert_response_status(200)
        assert_resource_type(:bundle)
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Bundle-uv-ips')
      end
    end

    test do
      title 'IPS Server returns Bundle resource containing valid IPS Composition entry'
      description %(
        IPS Server return valid IPS Composition resource in the Bundle as first entry
      )
      # link 'http://hl7.org/fhir/uv/ips/StructureDefinition-Composition-uv-ips.html'
      uses_request :summary_operation

      run do
        skip_if !resource.is_a?(FHIR::Bundle), 'No Bundle returned from document operation'

        assert resource.entry.length.positive?, 'Bundle has no entries'

        first_resource = resource.entry.first.resource

        assert first_resource.is_a?(FHIR::Composition), 'The first entry in the Bundle is not a Composition'
        assert_valid_resource(resource: first_resource, profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Composition-uv-ips')
      end
    end

    test do
      title 'IPS Server returns Bundle resource containing valid IPS MedicationStatement entry'
      description %(
        IPS Server return valid IPS MedicationStatement resource in the Bundle as first entry
      )
      # link 'http://hl7.org/fhir/uv/ips/StructureDefinition-MedicationStatement-uv-ips.html'
      uses_request :summary_operation

      run do
        skip_if !resource.is_a?(FHIR::Bundle), 'No Bundle returned from document operation'

        resources_present = resource.entry.any? { |r| r.resource.is_a?(FHIR::MedicationStatement) }

        assert resources_present, 'Bundle does not contain any MedicationStatement resources'

        assert_valid_bundle_entries(
          resource_types: {
            medication_statement: 'http://hl7.org/fhir/uv/ips/StructureDefinition/MedicationStatement-uv-ips'
          }
        )
      end
    end

    test do
      title 'IPS Server returns Bundle resource containing valid IPS AllergyIntolerance entry'
      description %(
        IPS Server return valid IPS AllergyIntolerance resource in the Bundle as first entry
      )
      # link 'http://hl7.org/fhir/uv/ips/StructureDefinition-AllergyIntolerance-uv-ips.html'
      uses_request :summary_operation

      run do
        skip_if !resource.is_a?(FHIR::Bundle), 'No Bundle returned from document operation'

        resources_present = resource.entry.any? { |r| r.resource.is_a?(FHIR::AllergyIntolerance) }

        assert resources_present, 'Bundle does not contain any AllergyIntolerance resources'

        assert_valid_bundle_entries(
          resource_types: {
            allergy_intolerance: 'http://hl7.org/fhir/uv/ips/StructureDefinition/AllergyIntolerance-uv-ips'
          }
        )
      end
    end

    test do
      title 'IPS Server returns Bundle resource containing valid IPS Condition entry'
      description %(
        IPS Server return valid IPS Condition resource in the Bundle as first entry
      )
      # link 'http://hl7.org/fhir/uv/ips/StructureDefinition-Condition-uv-ips.html'
      uses_request :summary_operation

      run do
        skip_if !resource.is_a?(FHIR::Bundle), 'No Bundle returned from document operation'

        resources_present = resource.entry.any? { |r| r.resource.is_a?(FHIR::Condition) }

        assert resources_present, 'Bundle does not contain any Condition resources'

        assert_valid_bundle_entries(
          resource_types: {
            condition: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Condition-uv-ips'
          }
        )
      end
    end
  end
end
