module IPS
    class BundleCrossBorder < Inferno::TestGroup
      title 'Bundle - Cross Border (IPS) Tests'
      description 'Verify support for the server capabilities required by the Bundle - Cross Border (IPS) profile.'
      id :ips_bundle_cross_border
  
      test do
        title 'Server returns correct Bundle resource from the Bundle read interaction'
        description %(
          This test will verify that Bundle resources can be read from the server.
        )
        # link 'http://hl7.org/fhir/uv/ips/StructureDefinition/Bundle-uv-ips'
  
        input :bundle_id
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
        title 'Server returns Bundle resource that matches the Bundle - Cross Border (IPS) profile'
        description %(
          This test will validate that the Bundle resource returned from the server matches the Bundle - Cross Border (IPS) profile.
        )
        # link 'http://hl7.org/fhir/uv/ips/StructureDefinition/Bundle-uv-ips'
        uses_request :bundle
  
        run do
          assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Bundle-cross-border-uv-ips
            ')
        end
      end
    end
  end
  