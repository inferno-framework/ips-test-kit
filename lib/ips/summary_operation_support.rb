# frozen_string_literal: true

module IPS
  class SummaryOperationSupport < Inferno::Test
    title 'IPS Server declares support for $summary operation in CapabilityStatement'
    description %(
      This test verifies that the server properly declares support for the $summary operation
      in its CapabilityStatement as required by the [IPS Implementation Guide](http://hl7.org/fhir/uv/ips/STU1.1/ipsGeneration.html).

      It validates that:
      1. The server's CapabilityStatement is accessible
      2. The CapabilityStatement includes the $summary operation for Patient resources
      3. The operation is defined using either:
         * The standard IPS operation definition URL
         * The operation name 'summary' or 'patient-summary'
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
