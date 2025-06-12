module IPS
  class Composition < Inferno::TestGroup
    title 'Composition (IPS) Tests'
    description %(
      Verify support for the server capabilities required by the Composition (IPS) profile.
      These tests focus on validating the server's ability to handle Composition resources
      that organize International Patient Summary documents according to the IPS Implementation Guide.
      
      The Composition resource is crucial to IPS as it defines the structure and organization
      of the patient summary, including required sections like allergies, medications, and problems.
      It serves as the clinical document wrapper within the IPS Bundle.
    )
    id :ips_composition
    
    link 'Composition (IPS) Profile',
         'http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Composition-uv-ips'
    link 'IPS Implementation Guide - Composition',
         'http://hl7.org/fhir/uv/ips/STU1.1/composition.html'

    test do
      title 'Server supports reading Composition resources'
      description %(
        This test verifies that Composition resources can be read from the server.
        
        It validates that:
        1. The server responds to a read request with a 200 OK status
        2. The resource type matches Composition
        3. The returned resource ID matches the requested ID
        
        [IPS Server CapabilityStatement](http://hl7.org/fhir/uv/ips/STU1.1/CapabilityStatement/ips-server)
        requires servers to support the read interaction for Composition resources, as they are
        essential for organizing the content of patient summary documents.
      )
      
      input :composition_id,
            title: 'Composition ID',
            description: 'ID of an existing Composition resource on the server that represents an IPS document'
      
      makes_request :composition

      run do
        fhir_read(:composition, composition_id, name: :composition)

        assert_response_status(200)
        assert_resource_type(:composition)
        assert resource.id == composition_id,
               "Requested resource with id #{composition_id}, received resource with id #{resource.id}"
      end
    end

    test do
      title 'Composition resources conform to IPS profile'
      description %(
        This test validates that the Composition resource returned from the server
        conforms to the [Composition (IPS) profile](http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Composition-uv-ips).
        
        The IPS Composition profile requirements include:
        * Must have type code indicating it is an IPS document
        * Must include mandatory sections (e.g., allergies, medications, problems)
        * Must use required section codes from the IPS document code system
        * Must reference a Patient as the subject
        * Must include author information
        * Must have a status and date
        
        For detailed requirements, refer to the [IPS Implementation Guide - Composition](http://hl7.org/fhir/uv/ips/STU1.1/composition.html).
        The Composition serves as the foundation of the IPS document, organizing all relevant
        clinical information into a structured format.
      )
      
      uses_request :composition

      run do
        assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/STU1.1/StructureDefinition/Composition-uv-ips')
      end
    end
  end
end
