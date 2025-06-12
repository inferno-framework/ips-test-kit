module IPS
  class Bundle < Inferno::TestGroup
    title 'Bundle (IPS) Tests'
    description %(
      Verify support for the server capabilities required by the Bundle (IPS) profile.
      These tests focus on validating the server's ability to handle Bundle resources
      that contain International Patient Summary documents according to the IPS Implementation Guide.
      
      The Bundle resource is fundamental to IPS as it serves as the container for
      the complete patient summary document, including the Composition and all referenced resources.
    )
    id :ips_bundle
    
    link 'Bundle (IPS) Profile',
         'http://hl7.org/fhir/uv/ips/StructureDefinition/Bundle-uv-ips'
    link 'IPS Implementation Guide - Bundle Requirements',
         'http://hl7.org/fhir/uv/ips/bundle.html'
    link 'IPS Server Capability Statement',
         'http://hl7.org/fhir/uv/ips/CapabilityStatement/ips-server'

    test do
      title 'Server supports reading Bundle resources'
      description %(
        This test verifies that Bundle resources can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches Bundle
        3. The returned resource ID matches the requested ID
        
        [IPS Server CapabilityStatement](http://hl7.org/fhir/uv/ips/CapabilityStatement/ips-server)
        requires servers to support the read interaction for Bundle resources, as they are
        essential for retrieving complete patient summary documents.
      )
      
      input :bundle_id,
            title: 'Bundle ID',
            description: 'ID of an existing Bundle resource on the server that contains an IPS document'
      
      makes_request :bundle

      run do
        fhir_read(:bundle, bundle_id, name: :bundle)

        assert_response_status(200)
        assert_resource_type(:bundle)
        assert resource.id == bundle_id,
               "Requested resource with id #{bundle_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'Bundle resources conform to IPS profile'
      description %(
        This test validates that the Bundle resource returned from the server
        conforms to the [Bundle (IPS) profile](http://hl7.org/fhir/uv/ips/StructureDefinition/Bundle-uv-ips).
        
        The IPS Bundle profile requirements include:
        * Must be a Document type Bundle
        * Must contain a Composition resource as the first entry
        * Must include all resources referenced in the Composition
        * Must use absolute references within the Bundle
        * Must include required sections as defined in the IPS Implementation Guide
        
        For detailed requirements, refer to the [IPS Implementation Guide - Bundle Requirements](http://hl7.org/fhir/uv/ips/bundle.html).
      )
      
      uses_request :bundle

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Bundle-uv-ips')
      end
    end
  end
end
