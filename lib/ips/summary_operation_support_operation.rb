# frozen_string_literal: true

module IPS
  class SummaryOperationSupportOperation < Inferno::Test
    title 'IPS Server declares support for $summary operation in CapabilityStatement'
    description %(
      The IPS Server declares support for Patient/[id]/$summary operation in its server CapabilityStatement
    )
    id :ips_summary_operation_support_operation

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
          %w[summary patient-summary].include?(operation.name.downcase)
      end

      assert operation_defined,
             'Server CapabilityStatement did not declare support for $summary operation in Patient resource.'
    end
  end
end
