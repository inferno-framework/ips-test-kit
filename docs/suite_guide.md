# Test Suite Structure Guide

This guide explains how to create and structure test suites following the patterns established in the IPS Test Kit.

## Basic Structure

A test suite file defines a class that inherits from `Inferno::TestSuite` and organizes tests into logical groups:

```ruby
module YourModule
  class Suite < Inferno::TestSuite
    title 'Your Suite Title'
    short_title 'Short Title'
    description %(
      [Suite description]
    )
    id 'unique_id'
  end
end
```

## Required Components

### Core Identification
- `title`: Full title of the test suite
- `short_title`: Abbreviated title for UI display
- `description`: Comprehensive description of the suite's purpose
- `id`: Unique identifier (simple, lowercase string)

### Suite Organization
- Groups of related tests
- Resource validation configurations
- Client configurations
- External links

## Description Structure

The description should follow this format:

```ruby
description %(
  [Overview of the test suite]

  [Key capabilities being tested]

  [Usage instructions/scenarios]

  [Additional context like presets or requirements]
)
```

## Best Practices

### 1. Group Organization

Structure groups logically:

```ruby
group do
  title 'Main Group Title'
  short_title 'Short Title'  # Optional
  description %(
    Group-specific description
  )

  # Subgroups for related functionality
  group from: :related_group
  
  # Or nested groups
  group do
    title 'Nested Group'
    # ...
  end
end
```

### 2. Input Configuration

Define required inputs clearly:

```ruby
input :url,
      title: 'Server URL',
      description: 'The base URL for the FHIR server'
```

### 3. Client Configuration

Set up FHIR clients within relevant groups:

```ruby
fhir_client do
  url :url  # References input defined above
end
```

### 4. Resource Validation

Configure validation rules:

```ruby
fhir_resource_validator do
  igs 'ig.name#version'
  
  exclude_message do |message|
    # Validation message filtering logic
  end
end
```

### 5. External Links

Provide relevant external resources:

```ruby
links [
  {
    label: 'Documentation',
    url: 'https://example.com/docs'
  },
  {
    label: 'Source Code',
    url: 'https://github.com/org/repo'
  }
]
```

## Common Patterns

### 1. Group Types

1. **Resource Validation Groups**
   ```ruby
   group from: :resource_validation
   ```

2. **Operation Groups**
   ```ruby
   group do
     title 'Operation Tests'
     description %(
       Tests for specific operations
     )
     
     input :parameter
     # Operation-specific tests
   end
   ```

3. **Profile Validation Groups**
   ```ruby
   group do
     title 'Profile Tests'
     
     group from: :profile_one
     group from: :profile_two
   end
   ```

### 2. Optional Groups

Mark non-essential groups:

```ruby
group do
  title 'Optional Tests'
  optional
  
  # Optional test implementations
end
```

### 3. Group Organization

Organize related resources:

```ruby
group do
  title 'Related Resources'
  
  group from: :resource_one
  group from: :resource_two
  
  group do
    title 'Nested Resources'
    # More specific resources
  end
end
```

## Implementation Tips

1. **Clear Structure**
   - Organize groups logically
   - Use descriptive titles
   - Provide clear descriptions

2. **Resource Management**
   - Group related resources together
   - Use consistent naming patterns
   - Consider dependencies

3. **Configuration**
   - Define inputs clearly
   - Configure clients appropriately
   - Set up proper validation

4. **Documentation**
   - Write clear descriptions
   - Include usage examples
   - Document prerequisites

5. **Maintenance**
   - Keep groups organized
   - Update descriptions
   - Maintain external links

## Example Implementation

```ruby
module YourModule
  class Suite < Inferno::TestSuite
    title 'Example Test Suite'
    short_title 'Example Suite'
    description %(
      This suite tests various capabilities.
      
      Key features:
      - Feature 1
      - Feature 2
      
      Usage scenarios:
      - Scenario 1
      - Scenario 2
    )
    
    id 'example_suite'
    
    # Resource validation
    fhir_resource_validator do
      igs 'example.ig#1.0.0'
    end
    
    # External links
    links [
      {
        label: 'Documentation',
        url: 'https://example.com/docs'
      }
    ]
    
    # Main test groups
    group from: :resource_validation
    
    group do
      title 'API Operations'
      description 'Tests for API operations'
      
      input :url
      
      fhir_client do
        url :url
      end
      
      group from: :operation_one
      group from: :operation_two
    end
    
    group do
      title 'Profile Validation'
      optional
      
      group from: :profile_tests
    end
  end
end
```

## File Organization

```
lib/
  └── your_module/
      ├── suite.rb              # Main suite file
      ├── resource_validation/  # Resource validation tests
      ├── operations/          # Operation tests
      └── profiles/           # Profile validation tests
