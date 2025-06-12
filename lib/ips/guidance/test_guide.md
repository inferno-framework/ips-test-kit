# Test Template Guide

This guide explains how to use the resource test template to create new test suites for FHIR resources.

## General Notes

- references to resource profiles or structure definitions should link to the pages within the correct version of the implementation guide

## Template Structure

The template follows a consistent structure:

1. **Test Group Definition**
   - Module namespace
   - Class name (inherits from Inferno::TestGroup)
   - Group-level metadata (title, description, id)

2. **Individual Tests**
   Each test case includes:
   - Title: Clear, action-oriented description
   - Description: Detailed explanation of what is being tested (do not include general guidance, only describe what is explicitly required and tested, noting any discrepancies between the two)
   - Implementation Guide/Profile references
   - Input/prerequisite definitions
   - Test execution logic

## Key Components

### Test Group Metadata

```ruby
title '[Resource Name] Tests'
description 'Verify support for the server capabilities required by the [Resource Name] profile.'
id :ips_resource_name
```

- `title`: Should clearly identify the resource being tested
- `description`: Should explain the overall purpose of the test group
- `id`: Should be lowercase, underscore-separated

### Test Case Structure

```ruby
test do
  title 'Descriptive test title'
  description %(
    Detailed test description
    [Additional context]
  )
  
  # Setup
  input :resource_id
  makes_request :resource_name
  
  # Execution
  run do
    # Test steps
  end
end
```

### Common Test Patterns

1. **Resource Read Test**
   - Verifies basic read capabilities
   - Checks response status
   - Validates resource type
   - Confirms resource ID matches

2. **Profile Validation Test**
   - Validates resource against profile requirements
   - Uses response from previous test
   - Performs additional profile-specific checks

## Usage Guidelines

1. Copy the template file for your new resource
2. Replace placeholder text (marked with [brackets])
3. Add resource-specific requirements and validations
4. Include relevant implementation guide links
5. Add additional test cases as needed

## Best Practices

1. **Clear Descriptions**
   - Use active voice
   - Clearly state what is being tested
   - Include context about why the test is important

2. **Modular Design**
   - Each test should verify one specific capability
   - Use makes_request/uses_request to share responses
   - Break complex validations into separate test cases

3. **Error Handling**
   - Include clear assertion messages
   - Verify both positive and negative cases
   - Handle edge cases appropriately

4. **Documentation**
   - Include relevant specification links
   - Document any assumptions
   - Explain complex validation logic

## Example Usage

```ruby
module IPS
  class PatientTests < Inferno::TestGroup
    title 'Patient Tests'
    description 'Verify support for the server capabilities required by the Patient profile.'
    id :ips_patient

    test do
      title 'Server returns correct Patient resource'
      description %(
        This test verifies that Patient resources can be read from the server.
      )
      input :patient_id
      makes_request :patient
      
      run do
        fhir_read(:patient, patient_id, name: :patient)
        assert_response_status(200)
        assert_resource_type(:patient)
      end
    end
  end
end
