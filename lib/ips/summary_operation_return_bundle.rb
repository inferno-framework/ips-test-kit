# frozen_string_literal: true

module IPS
  class SummaryOperationReturnBundle < Inferno::Test
    title 'Server returns valid IPS Bundle for Patient/$summary operation'
    description %(
      This test verifies that the server returns a valid IPS Bundle resource when 
      the Patient/$summary operation is invoked. The test performs a GET request 
      to the Patient/[id]/$summary endpoint and validates the response.

      The test validates:
      - HTTP 200 response status
      - Response contains a Bundle resource
      - Bundle conforms to the IPS Bundle profile (http://hl7.org/fhir/uv/ips/StructureDefinition/Bundle-uv-ips)

      Note: This test currently uses only GET requests due to a limitation in Inferno 
      where POST requests with empty bodies include an unwanted Content-Type header 
      that causes issues with some reference implementations. Future versions may 
      include both GET and POST request testing.

      This test requires a valid patient_id input and creates a summary_operation 
      request that can be referenced by subsequent tests.
    )
    id :ips_summary_operation_return_bundle

    input :patient_id
    makes_request :summary_operation

    class << self
      def profile_url
        @profile_url ||= config.options[:ips_bundle_profile_url] || 'http://hl7.org/fhir/uv/ips/StructureDefinition/Bundle-uv-ips'
      end
    end

    run do
      fhir_operation("Patient/#{patient_id}/$summary", name: :summary_operation, operation_method: :get)
      assert_response_status(200)
      assert_resource_type(:bundle)
      assert_valid_resource(profile_url: self.class.profile_url)
    end
  end
end
