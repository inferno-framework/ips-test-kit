module IPS
  class DiagnosticReport < Inferno::TestGroup
    title 'DiagnosticReport (IPS) Tests'
    id :ips_diagnostic_report

    description %(
      Verify support for the server capabilities required by the DiagnosticReport (IPS) profile.
      These tests focus on validating the server's ability to handle DiagnosticReport resources that
      represent diagnostic test results and reports according to the IPS Implementation Guide.

      For more information, see:
      * [DiagnosticReport (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/DiagnosticReport-uv-ips)
    )

    test do
      title 'Server supports reading DiagnosticReport resources'
      description %(
        This test verifies that DiagnosticReport resources can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches DiagnosticReport
        3. The returned resource ID matches the requested ID
      )

      input :diagnostic_report_id,
            title: 'DiagnosticReport ID',
            description: 'ID of an existing DiagnosticReport resource on the server that represents diagnostic test results'
      makes_request :diagnostic_report

      run do
        fhir_read(:diagnostic_report, diagnostic_report_id, name: :diagnostic_report)

        assert_response_status(200)
        assert_resource_type(:diagnostic_report)
        assert resource.id == diagnostic_report_id,
               "Requested resource with id #{diagnostic_report_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'DiagnosticReport resources conform to IPS profile'
      description %(
        This test validates that the DiagnosticReport resource returned from the server
        conforms to the [DiagnosticReport (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/DiagnosticReport-uv-ips).

        Profile-specific requirements verified by this test include:
        * Must have a status
        * Must have a code identifying the type of diagnostic report
        * Must have a category
        * Must have an effective time
        * Must reference a Patient as the subject
      )
      uses_request :diagnostic_report

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/DiagnosticReport-uv-ips')
      end
    end
  end
end
