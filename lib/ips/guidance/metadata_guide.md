# Test Kit Metadata Guide

This guide explains how to create and structure metadata files for test kits, following the patterns established in the IPS Test Kit.

## Basic Structure

A metadata file defines a class that inherits from `Inferno::TestKit` and contains essential information about the test kit:

```ruby
require_relative 'version'

module YourModule
  class Metadata < Inferno::TestKit
    id :your_test_kit_id
    title 'Your Test Kit Title'
    description '...'
    # Additional metadata fields
  end
end
```

## Required Fields

### Core Identification
- `id`: Unique identifier in snake_case (e.g., `:ips_test_kit`)
- `title`: Human-readable name of the test kit
- `version`: Current version (imported from version.rb)
- `description`: Detailed description of the test kit

### Configuration
- `suite_ids`: Array of suite identifiers (e.g., `[:ips]`)
- `tags`: Categories/labels for the test kit (e.g., `['IPS']`)
- `last_updated`: Timestamp of last update
- `maturity`: Indication of test kit maturity ('Low', 'Medium', 'High')
- `authors`: List of authors/maintainers
- `repo`: Repository URL

## Description Structure

The description should be structured using this format:

```ruby
description <<~DESCRIPTION
  [Overview paragraph]
  <!-- break -->

  [Detailed description]
  
  ## Status
  [Current status and coverage]

  ## Repository
  [Repository information]

  ## Providing Feedback
  [Feedback guidelines]
DESCRIPTION
```

### Key Sections

1. **Overview**
   - Brief introduction
   - Purpose of the test kit
   - Link to relevant specifications

2. **Status**
   - Current implementation status
   - Features being tested
   - Known limitations

3. **Repository**
   - Link to source code
   - Installation/usage information

4. **Feedback**
   - How to report issues
   - Types of feedback welcomed
   - Contact information

## Best Practices

### 1. Version Management
- Keep version information in a separate `version.rb` file
- Use semantic versioning
- Update the `LAST_UPDATED` timestamp when making changes

Example `version.rb`:
```ruby
module YourModule
  VERSION = '1.0.0'
  LAST_UPDATED = '2025-06-10'
end
```

### 2. Description Writing
- Use clear, concise language
- Include markdown formatting for readability
- Separate sections with `<!-- break -->`
- Provide specific examples where helpful
- Link to relevant documentation

### 3. Identification
- Choose descriptive, unique IDs
- Use consistent tag naming
- Include relevant categorization

### 4. Documentation
- Keep descriptions up-to-date
- Document all major features
- Include examples of usage
- Link to additional resources

### 5. Maintenance
- Regular version updates
- Current author list
- Accurate status information
- Valid repository links

## Example Implementation

```ruby
require_relative 'version'

module IPS
  class Metadata < Inferno::TestKit
    id :ips_test_kit
    title 'International Patient Summary Test Kit'
    description <<~DESCRIPTION
      The International Patient Summary Test Kit provides an
      executable set of tests for the IPS Implementation Guide.
      <!-- break -->

      This test kit is open source and freely available for use.
      
      ## Status
      These tests validate:
      - IPS Bundle validation
      - Support for IPS operations
      - Profile Validation

      ## Repository
      [Repository information]

      ## Providing Feedback
      We welcome feedback on:
      - Validation logic
      - Requirements coverage
      - User experience
    DESCRIPTION
    
    suite_ids [:ips]
    tags ['IPS']
    last_updated LAST_UPDATED
    version VERSION
    maturity 'Low'
    authors ['Test Kit Team']
    repo 'https://github.com/org/repo'
  end
end
```

## Common Patterns

### 1. Description Formatting
```markdown
# Main Title
Brief overview

<!-- break -->

## Section 1
Content

## Section 2
- Bullet point 1
- Bullet point 2
```

### 2. Version Information
```ruby
version VERSION        # From version.rb
last_updated LAST_UPDATED
```

### 3. Suite Configuration
```ruby
suite_ids [:main_suite, :optional_suite]
tags ['Category1', 'Category2']
```

## Tips for Success

1. **Clarity**: Write clear, concise descriptions
2. **Completeness**: Include all required fields
3. **Consistency**: Follow established patterns
4. **Currency**: Keep information up-to-date
5. **Documentation**: Provide helpful examples
