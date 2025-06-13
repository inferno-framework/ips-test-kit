module IPS
  class DeviceObserver < Inferno::TestGroup
    title 'Device (performer, observer) Tests'
    description %(
      Verify support for the server capabilities required by the Device (performer, observer) profile.
      These tests focus on validating the server's ability to handle Device resources that
      represent devices used to make observations according to the IPS Implementation Guide.
    )
    id :ips_device_observer

    description %(
      Verify support for the server capabilities required by the Device (performer, observer) profile.
      These tests focus on validating the server's ability to handle Device resources that
      represent devices used to make observations according to the IPS Implementation Guide.
      
      For more information, see:
      * [Device (performer, observer) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Device-observer-uv-ips)
    )

    test do
      title 'Server supports reading Device Observer resources'
      description %(
        This test verifies that Device resources can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches Device
        3. The returned resource ID matches the requested ID
      )

      input :device_id,
            title: 'Device Observer ID',
            description: 'ID of an existing Device resource on the server that represents a device used to make observations'
      makes_request :device_observer

      run do
        fhir_read(:device, device_id, name: :device_observer)

        assert_response_status(200)
        assert_resource_type(:device)
        assert resource.id == device_id,
               "Requested resource with id #{device_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'Device Observer resources conform to IPS profile'
      description %(
        This test validates that the Device resource returned from the server
        conforms to the [Device (performer, observer) Profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Device-observer-uv-ips).
      )
      uses_request :device_observer

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Device-observer-uv-ips')
      end
    end
  end
end
