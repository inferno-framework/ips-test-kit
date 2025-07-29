require_relative './summary_operation_return_bundle'
require_relative './summary_operation_support'
require_relative './summary_operation_valid_composition'
module IPS
  class SummaryOperation < Inferno::TestGroup
    title 'Summary Operation Tests'
    description %(
      This group tests server support for the Patient/$summary operation as defined in the 
      IPS Implementation Guide v1.1.0. The tests validate both the operational capability 
      declaration and the structure and content of returned IPS Bundle resources.

      Key capabilities tested:
      - CapabilityStatement declares $summary operation support
      - $summary operation returns valid IPS Bundle
      - Bundle contains required Composition as first entry
      - Bundle contains valid IPS resource profiles for core clinical data

      Tests use GET requests for the $summary operation and validate returned Bundle 
      entries against their respective IPS profiles.
    )
    id :ips_summary_operation
    run_as_group

    test from: :ips_summary_operation_support

    test from: :ips_summary_operation_return_bundle

    test from: :ips_summary_operation_valid_composition

    test do
      title 'Bundle contains valid IPS MedicationStatement resources'
      description %(
        This test verifies that the Bundle returned by the $summary operation contains 
        at least one MedicationStatement resource and that all MedicationStatement 
        resources conform to the IPS MedicationStatement profile.

        The test skips if no Bundle was returned from the $summary operation. It checks 
        for the presence of MedicationStatement resources within the Bundle entries and 
        validates each MedicationStatement against the IPS MedicationStatement profile 
        (http://hl7.org/fhir/uv/ips/StructureDefinition/MedicationStatement-uv-ips).
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
      title 'Bundle contains valid IPS AllergyIntolerance resources'
      description %(
        This test verifies that the Bundle returned by the $summary operation contains 
        at least one AllergyIntolerance resource and that all AllergyIntolerance 
        resources conform to the IPS AllergyIntolerance profile.

        The test skips if no Bundle was returned from the $summary operation. It checks 
        for the presence of AllergyIntolerance resources within the Bundle entries and 
        validates each AllergyIntolerance against the IPS AllergyIntolerance profile 
        (http://hl7.org/fhir/uv/ips/StructureDefinition/AllergyIntolerance-uv-ips).
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
      title 'Bundle contains valid IPS Condition resources'
      description %(
        This test verifies that the Bundle returned by the $summary operation contains 
        at least one Condition resource and that all Condition resources conform to 
        the IPS Condition profile.

        The test skips if no Bundle was returned from the $summary operation. It checks 
        for the presence of Condition resources within the Bundle entries and validates 
        each Condition against the IPS Condition profile 
        (http://hl7.org/fhir/uv/ips/StructureDefinition/Condition-uv-ips).
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
