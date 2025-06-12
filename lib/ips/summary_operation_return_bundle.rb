# frozen_string_literal: true

module IPS
  class SummaryOperationReturnBundle < Inferno::Test
    title 'IPS Server returns Bundle resource for Patient/[id]/$summary GET operation'
    description %(
      This test verifies that the server returns a valid IPS Bundle resource when executing
      the $summary operation on a Patient resource, as required by the [IPS Implementation Guide](http://hl7.org/fhir/uv/ips/STU1.1/ipsGeneration.html).

      It validates that:
      1. The server responds with a 200 OK status
      2. The response is a Bundle resource
      3. The Bundle conforms to the [IPS Bundle Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Bundle-uv-ips)

      Technical Note:
      This test currently only issues a GET request for the summary due to a
      limitation in Inferno in issuing POST requests that omit a Content-Type
      header when the body is empty. Inferno currently adds a `Content-Type:
      application/x-www-form-urlencoded` header when issuing a POST with no
      body, which causes issues in known reference implementations.

      A future update to this test suite should include a required POST
      request as well as an optional GET request for this content.
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
