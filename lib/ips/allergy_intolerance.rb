module IPS
  class AllergyIntolerance < Inferno::TestGroup
    title 'Allergy Intolerance (IPS) Tests'
    description %(
      Verify support for the server capabilities required by the Allergy Intolerance (IPS) profile.
      These tests focus on validating the server's ability to handle AllergyIntolerance resources
      according to the International Patient Summary Implementation Guide requirements.
    )
    id :ips_allergy_intolerance
    
    link 'AllergyIntolerance (IPS) Profile',
         'http://hl7.org/fhir/uv/ips/StructureDefinition/AllergyIntolerance-uv-ips'

    test do
      title 'Server supports reading AllergyIntolerance resources'
      description %(
        This test verifies that AllergyIntolerance resources can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches AllergyIntolerance
        3. The returned resource ID matches the requested ID
        
        [IPS Server CapabilityStatement](http://hl7.org/fhir/uv/ips/CapabilityStatement/ips-server)
        requires servers to support the read interaction for AllergyIntolerance resources.
      )
      
      input :allergy_intolerance_id,
            title: 'AllergyIntolerance ID',
            description: 'ID of an existing AllergyIntolerance resource on the server'
      
      makes_request :allergy_intolerance

      run do
        fhir_read(:allergy_intolerance, allergy_intolerance_id, name: :allergy_intolerance)

        assert_response_status(200)
        assert_resource_type(:allergy_intolerance)
        assert resource.id == allergy_intolerance_id,
               "Requested resource with id #{allergy_intolerance_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'AllergyIntolerance resources conform to IPS profile'
      description %(
        This test validates that the AllergyIntolerance resource returned from the server
        conforms to the [AllergyIntolerance (IPS) profile](http://hl7.org/fhir/uv/ips/StructureDefinition/AllergyIntolerance-uv-ips).
        
        Profile requirements include:
        * Must support required elements defined in the profile
        * Must use required value sets and coding systems
        * Must conform to profile constraints on data types and cardinalities
        
        For detailed requirements, refer to the [AllergyIntolerance (IPS) profile](http://hl7.org/fhir/uv/ips/StructureDefinition/AllergyIntolerance-uv-ips).
      )
      
      uses_request :allergy_intolerance

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/AllergyIntolerance-uv-ips')
      end
    end
  end
end
