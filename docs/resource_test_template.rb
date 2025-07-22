module IPS
  class ResourceNameTests < Inferno::TestGroup
    # Test Group Level Documentation
    title '[Resource Name] Tests'
    description 'Verify support for the server capabilities required by the [Resource Name] profile.'
    id :ips_resource_name  # Lowercase with underscores

    # Individual Test Case Template
    test do
      title 'Server returns correct [Resource Name] resource from the [Resource Name] read interaction'
      description %(
        This test will verify that [Resource Name] resources can be read from the server.
        
        [Additional context about what the test verifies]
      )

      # Test Prerequisites/Setup
      input :resource_id  # Define required inputs
      makes_request :resource_name  # Define requests this test makes

      # Test Execution
      run do
        # Step 1: Make the request
        fhir_read(:resource_name, resource_id, name: :resource_name)

        # Step 2: Verify response basics
        assert_response_status(200)
        assert_resource_type(:resource_name)
        
        # Step 3: Verify specific requirements
        assert resource.id == resource_id,
               "Requested resource with id #{resource_id}, received resource with id #{resource.id}"
        
        # [Additional verification steps as needed]
      end
    end

    # Profile Validation Test Template
    test do
      title 'Server returns [Resource Name] resource that matches the [Profile Name] profile'
      description %(
        This test will validate that the [Resource Name] resource returned from the server matches 
        the [Profile Name] profile requirements.

        [Additional context about profile requirements]
      )
      # Reference Profile
      # link '[Profile URL]'
      
      # Use request from previous test
      uses_request :resource_name

      run do
        # Validate against profile
        assert_valid_resource(profile_url: '[Profile URL]')
        
        # [Additional profile-specific validations]
      end
    end

    # [Additional test cases as needed...]
  end
end
