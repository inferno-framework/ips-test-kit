module IPS
  class DeviceUseStatement < Inferno::TestGroup
    title 'Device Use Statement (IPS) Tests'
    id :ips_device_use_statement

    description %(
      Verify support for the server capabilities required by the Device Use Statement (IPS) profile.
      These tests focus on validating the server's ability to handle DeviceUseStatement resources that
      represent a patient's use of a medical device according to the IPS Implementation Guide.

      For more information, see:
      * [Device Use Statement (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/DeviceUseStatement-uv-ips)
    )

    test do
      title 'Server supports reading Device Use Statement resources'
      description %(
        This test verifies that DeviceUseStatement resources can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches DeviceUseStatement
        3. The returned resource ID matches the requested ID
      )

      input :device_use_statement_id,
            title: 'Device Use Statement ID',
            description: 'ID of an existing DeviceUseStatement resource on the server that represents a patient\'s use of a medical device'
      makes_request :device_use_statement

      run do
        fhir_read(:device_use_statement, device_use_statement_id, name: :device_use_statement)

        assert_response_status(200)
        assert_resource_type(:device_use_statement)
        assert resource.id == device_use_statement_id,
               "Requested resource with id #{device_use_statement_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'Device Use Statement resources conform to IPS profile'
      description %(
        This test validates that the DeviceUseStatement resource returned from the server
        conforms to the [Device Use Statement (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/DeviceUseStatement-uv-ips).

        Profile-specific requirements verified by this test include:
        * Must reference a Device
        * Must include timing (device usage)
        * Must reference a Patient as the subject
      )
      uses_request :device_use_statement

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/DeviceUseStatement-uv-ips')
      end
    end
  end
end
