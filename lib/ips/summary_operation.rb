require_relative './summary_operation_return_bundle'
require_relative './summary_operation_support'
require_relative './summary_operation_valid_composition'
module IPS
  class SummaryOperation < Inferno::TestGroup
    title 'Summary Operation Tests'
    description %(
        Verify support for the $summary operation as as described in the [IPS
        Guidance](http://hl7.org/fhir/uv/ips/STU1.1/ipsGeneration.html).
    )
    id :ips_summary_operation
    run_as_group

    test from: :ips_summary_operation_support

    test from: :ips_summary_operation_return_bundle

    test from: :ips_summary_operation_valid_composition

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
