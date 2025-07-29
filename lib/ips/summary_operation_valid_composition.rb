# frozen_string_literal: true

module IPS
  class SummaryOperationValidComposition < Inferno::Test
    title 'Bundle contains valid IPS Composition as first entry'
    description %(
      This test verifies that the Bundle returned by the $summary operation contains 
      a valid IPS Composition resource as the first entry, as required by the IPS 
      specification.

      The test validates:
      - Bundle contains at least one entry
      - First entry in the Bundle is a Composition resource
      - Composition conforms to the IPS Composition profile (http://hl7.org/fhir/uv/ips/StructureDefinition/Composition-uv-ips)

      The test skips if no Bundle was returned from the $summary operation. This test 
      uses the Bundle resource from the previous summary_operation request.
    )
    id :ips_summary_operation_valid_composition
    uses_request :summary_operation

    class << self
      def profile_url
        @profile_url ||= config.options[:ips_composition_profile_url] || 'http://hl7.org/fhir/uv/ips/StructureDefinition/Composition-uv-ips'
      end
    end

    run do
      skip_if !resource.is_a?(FHIR::Bundle), 'No Bundle returned from document operation'
      assert resource.entry.length.positive?, 'Bundle has no entries'

      first_resource = resource.entry.first.resource

      assert first_resource.is_a?(FHIR::Composition), 'The first entry in the Bundle is not a Composition'
      assert_valid_resource(resource: first_resource, profile_url: self.class.profile_url)
    end
  end
end
