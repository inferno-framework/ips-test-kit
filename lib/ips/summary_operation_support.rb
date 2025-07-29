# frozen_string_literal: true

module IPS
  class SummaryOperationSupport < Inferno::Test
    title 'Server declares support for $summary operation in CapabilityStatement'
    description %(
      This test verifies that the server declares support for the Patient/$summary operation 
      in its CapabilityStatement. The test retrieves the server's CapabilityStatement and 
      searches for the $summary operation definition in the Patient resource operations.

      The test checks for either:
      - An operation with the definition URL http://hl7.org/fhir/uv/ips/OperationDefinition/summary
      - An operation with the name "summary" or "patient-summary" (case-insensitive)

      This test expects a successful HTTP 200 response when retrieving the CapabilityStatement.
    )
    id :ips_summary_operation_support

    class << self
      def ips_summary_operation_definition_url
        @ips_summary_operation_definition_url ||= config.options[:ips_summary_operation_definition_url] || 'http://hl7.org/fhir/uv/ips/OperationDefinition/summary'
      end
    end

    run do
      fhir_get_capability_statement
      assert_response_status(200)

      operations = resource.rest&.flat_map do |rest|
        rest.resource
            &.select { |r| r.type == 'Patient' && r.respond_to?(:operation) }
            &.flat_map(&:operation)
      end&.compact

      operation_defined = operations.any? do |operation|
        operation.definition == self.class.ips_summary_operation_definition_url ||
          %w[summary patient-summary].include?(operation.name.downcase)
      end

      assert operation_defined,
             'Server CapabilityStatement did not declare support for $summary operation in Patient resource.'
    end
  end
end
