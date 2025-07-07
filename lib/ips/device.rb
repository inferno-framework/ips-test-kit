module IPS
  class Device < Inferno::TestGroup
    title 'Device (IPS) Tests'
    id :ips_device

    description %(
      Verify support for the server capabilities required by the Device (IPS) profile.
      These tests focus on validating the server's ability to handle Device resources that
      represent medical devices according to the IPS Implementation Guide.

      For more information, see:
      * [Device (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Device-uv-ips)
    )

    test do
      title 'Server returns correct Device resource from the Device read interaction'
      description %(
        This test verifies that Device resources can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches Device
        3. The returned resource ID matches the requested ID
      )

      input :device_id,
            title: 'Device ID',
            description: 'ID of an existing Device resource on the server that represents a medical device'
      makes_request :device

      run do
        fhir_read(:device, device_id, name: :device)

        assert_response_status(200)
        assert_resource_type(:device)
        assert resource.id == device_id,
               "Requested resource with id #{device_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'Device resources conform to IPS profile'
      description %(
        This test validates that the Device resource returned from the server
        conforms to the [Device (IPS) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Device-uv-ips).

        Profile-specific requirements verified by this test include:
        * Must reference a Patient as the subject
      )
      uses_request :device

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Device-uv-ips')
      end
    end
  end
end
