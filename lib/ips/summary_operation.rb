require_relative './summary_operation_return_bundle'
require_relative './summary_operation_support'
require_relative './summary_operation_valid_composition'
module IPS
  class SummaryOperation < Inferno::TestGroup
    title 'Summary Operation Tests'
    description %(
      Verify support for the $summary operation as described in the [IPS
      Guidance](http://hl7.org/fhir/uv/ips/STU1.1/ipsGeneration.html).
      
      These tests validate that the server can generate and return a complete
      International Patient Summary document bundle containing all required
      resources and sections according to the IPS Implementation Guide.
    )
    id :ips_summary_operation
    run_as_group

    test from: :ips_summary_operation_support

    test from: :ips_summary_operation_return_bundle

    test from: :ips_summary_operation_valid_composition

    test do
      title 'IPS Server returns Bundle resource containing valid IPS MedicationStatement entry'
      description %(
        This test verifies that the Bundle returned from the $summary operation contains
        valid MedicationStatement resources conforming to the IPS profile.

        It validates that:
        1. The Bundle contains at least one MedicationStatement resource
        2. Each MedicationStatement resource conforms to the [IPS MedicationStatement Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/MedicationStatement-uv-ips)
      )
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
        This test verifies that the Bundle returned from the $summary operation contains
        valid AllergyIntolerance resources conforming to the IPS profile.

        It validates that:
        1. The Bundle contains at least one AllergyIntolerance resource
        2. Each AllergyIntolerance resource conforms to the [IPS AllergyIntolerance Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/AllergyIntolerance-uv-ips)
      )
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
        This test verifies that the Bundle returned from the $summary operation contains
        valid Condition resources conforming to the IPS profile.

        It validates that:
        1. The Bundle contains at least one Condition resource
        2. Each Condition resource conforms to the [IPS Condition Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Condition-uv-ips)
      )
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
