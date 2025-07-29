# Description Authoring Guide

Guidance in this file can be used by developers and LLMs to support authoring
descriptions for new tests, or improving descriptions of existing tests. This
guidance is based on broad Inferno conventions, as well as specific practices
used in existing tests in the IPS test kit. Please note that all updates should
be manually reviewed for accuracy, as LLMs may not always produce perfect
results.

This guide focuses specifically on writing effective descriptions at each level
of the test hierarchy: test kit, suite, group, and individual test levels.

## Why Descriptions Matter

Descriptions serve as the primary interface between test implementations and
users, providing essential information about what is being tested and why. While
the technical details of test validation logic are available in the source code,
natural language descriptions that appear in the user interface are critical for
helping implementers understand test purpose, scope, and requirements without
needing to parse complex code. These descriptions enable users to quickly assess
whether tests are relevant to their implementation, understand what capabilities
are being validated, and interpret test results in the context of specification
requirements. Maintaining accurate, up-to-date descriptions that stay in sync
with the underlying test logic is essential for the usability and effectiveness
of test kits, as they directly impact how implementers interact with and benefit
from the testing framework.

## Table of Contents

1. [Code Analysis Before Writing](#code-analysis-before-writing)
2. [Test Kit Level Descriptions](#test-kit-level-descriptions)
3. [Suite Level Descriptions](#suite-level-descriptions)
4. [Group Level Descriptions](#group-level-descriptions)
5. [Test Level Descriptions](#test-level-descriptions)
6. [Best Practices](#best-practices)

---

## Code Analysis Before Writing

**CRITICAL: Always analyze the actual test implementation before writing or updating descriptions.**

### Why Code Analysis is Essential

Descriptions must accurately reflect what tests actually do, not what they might do based on titles or assumptions. Writing descriptions without examining the implementation leads to:

- Inaccurate descriptions that mislead users
- Claims about validation that don't match the actual test logic
- Descriptions that become outdated when code changes
- Loss of user trust when descriptions don't match test behavior

### Required Analysis Steps

Before writing any description, you must:

1. **Read the test implementation code** - Examine the `run do` block to understand exactly what the test does
2. **Identify all assertions and validations** - Note every `assert`, `assert_valid_resource`, `assert_response_status`, etc.
3. **Understand test inputs and dependencies** - Check what inputs are required and what previous tests are referenced
4. **Note skip conditions** - Identify when tests will skip and why
5. **Check helper methods** - If tests call helper methods, examine those implementations too
6. **Verify specification claims** - Use web_fetch or other available tools (playwright MCP tool is particularly good if available) to access the relevant implementation guide or specification to verify any claims about requirements, optional vs required elements, or specification compliance rather than making assumptions

### Code Analysis Examples

**Example 1: Simple Validation Test**
```ruby
run do
  skip_if bundle_content.blank?, 'No IPS Bundle provided'
  resource_instance = FHIR.from_contents(bundle_content)
  assert_resource_type(:bundle, resource: resource_instance)
  assert_valid_resource(resource: resource_instance, profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/Bundle-uv-ips')
end
```

**Analysis Results:**
- Test skips if no bundle content provided
- Parses bundle content using FHIR.from_contents
- Verifies resource is Bundle type
- Validates against IPS Bundle profile
- Does NOT validate individual resources within the bundle
- Does NOT check bundle entry order or specific content

**Example 2: Operation Test**
```ruby
run do
  fhir_operation("Patient/#{patient_id}/$summary", name: :summary_operation, operation_method: :get)
  assert_response_status(200)
  assert_resource_type(:bundle)
  assert_valid_resource(profile_url: self.class.profile_url)
end
```

**Analysis Results:**
- Executes GET operation on Patient/[id]/$summary endpoint
- Requires patient_id input
- Expects 200 response status
- Validates returned resource is Bundle type
- Validates Bundle against IPS Bundle profile
- Uses GET method only (not POST)
- Stores request for use by other tests

### What to Document Based on Code Analysis

**For Each Test, Document:**
- Exact validation steps performed
- Required inputs and their usage
- Skip conditions and when they apply
- Specific assertions made
- Profile URLs used for validation
- HTTP methods and endpoints called
- Dependencies on other tests or requests

**Do NOT Document:**
- Assumptions about what the test "should" do
- Validation steps not actually performed
- General implementation guidance
- Features not actually tested

### Common Code Analysis Patterns

**Profile Validation Pattern:**
```ruby
assert_valid_resource(resource: resource_instance, profile_url: 'profile_url')
```
→ Documents: "Validates conformance to [profile name] profile"

**Resource Type Check:**
```ruby
assert_resource_type(:bundle, resource: resource_instance)
```
→ Documents: "Verifies the resource is of type Bundle"

**Response Status Check:**
```ruby
assert_response_status(200)
```
→ Documents: "Expects successful HTTP 200 response"

**Skip Conditions:**
```ruby
skip_if condition, 'message'
```
→ Documents: "Test skips if [condition explanation]"

**Resource Presence Check:**
```ruby
resources_present = resource.entry.any? { |r| r.resource.is_a?(FHIR::ResourceType) }
assert resources_present, 'error message'
```
→ Documents: "Verifies Bundle contains at least one [ResourceType] resource"

### Verification Process

After writing descriptions based on code analysis:

1. **Cross-check each claim** - Ensure every statement in the description corresponds to actual test code
2. **Verify assertion accuracy** - Confirm that described validations match the actual assertions
3. **Check completeness** - Ensure all significant test steps are documented
4. **Validate skip conditions** - Confirm skip condition descriptions match the code
5. **Review dependencies** - Verify that described dependencies are accurate

### Red Flags - When Descriptions May Be Inaccurate

- Descriptions that are too generic ("validates the resource")
- Claims about validation not supported by assertions in the code
- Missing mention of skip conditions that exist in the code
- Descriptions that don't match the complexity of the test implementation
- References to validation steps not present in the run block

### Updating Descriptions When Code Changes

When test code is modified:

1. **Re-analyze the updated implementation** - Don't assume the description is still accurate
2. **Update descriptions to match new behavior** - Ensure every change in logic is reflected
3. **Check for new skip conditions or assertions** - Add documentation for new validation steps
4. **Verify dependency changes** - Update references to other tests if relationships change

This rigorous approach to code analysis ensures that descriptions serve as accurate, trustworthy documentation of what tests actually validate.


## Test Kit Level Descriptions

### Location and Format
Test kit descriptions are defined in the `metadata.rb` file using a heredoc format:

```ruby
description <<~DESCRIPTION
  [Content here]
DESCRIPTION
```

### Structure
Test kit descriptions should follow this specific structure:

```ruby
description <<~DESCRIPTION
  [Brief overview paragraph - what the test kit does]
  <!-- break -->

  [Detailed explanation of purpose and scope]
  
  ## Status
  [Current implementation status and coverage]

  ## Repository
  [Repository information and links]

  ## Providing Feedback
  [How users can provide feedback]
DESCRIPTION
```

### Content Guidelines

**Overview Paragraph (before `<!-- break -->`)**
- Brief, high-level summary of what the test kit validates
- Target audience (implementers, vendors, etc.)
- Reference to the specification or implementation guide being tested
- Keep to 2-3 sentences maximum

**Detailed Explanation**
- Comprehensive description of the test kit's purpose
- Scope of testing (what is and isn't covered)
- Key capabilities being validated
- Any important context about the specification

**Status Section**
- Current maturity level and what that means
- Specific features/profiles being tested
- Known limitations or gaps
- Coverage information (e.g., "Tests 15 of 20 profiles")

**Repository Section**
- Link to source code
- Installation/usage instructions
- License information if relevant

**Feedback Section**
- How to report issues or bugs
- Types of feedback welcomed
- Contact information or preferred channels

### Example
```ruby
description <<~DESCRIPTION
  The International Patient Summary Test Kit provides an executable set of tests for the IPS Implementation Guide v1.1.0.
  <!-- break -->

  This test kit validates server implementations of the International Patient Summary (IPS) specification. It tests both the structural requirements of IPS documents and the operational capabilities required by IPS servers.

  The tests are organized into groups that validate:
  - IPS Bundle structure and composition
  - Required and optional resource profiles
  - Support for the $summary operation
  - Document reference capabilities

  ## Status
  This test kit has **Low** maturity. It currently tests core IPS Bundle validation and basic profile conformance. Advanced workflow testing and comprehensive edge case coverage are planned for future releases.

  ## Repository
  This test kit is open source and available at [GitHub Repository](https://github.com/inferno-framework/ips-test-kit). 

  ## Providing Feedback
  We welcome feedback including bug reports, feature requests, and suggestions for improving test coverage. Please submit issues through the GitHub repository or contact the Inferno team.
DESCRIPTION
```

---

## Suite Level Descriptions

### Location and Format
Suite descriptions are defined in the suite class using a multi-line string format:

```ruby
description %(
  [Content here]
)
```

### Content Guidelines

Suite descriptions should include:

**Purpose Statement**
- What specific aspect of the specification this suite tests
- How it fits into the broader test kit

**Key Capabilities**
- Bulleted list of main features being tested
- High-level test scenarios covered

**Usage Context**
- When/why someone would run this suite
- Prerequisites or setup requirements
- Available presets or configurations

**Scope Boundaries**
- What is explicitly tested
- What is not covered (if relevant)

### Example
```ruby
description %(
  This suite tests server support for the International Patient Summary (IPS) specification. 
  It validates both the structural requirements of IPS documents and the operational capabilities 
  required by IPS-compliant servers.

  Key capabilities tested:
  - IPS Bundle validation and composition structure
  - Required resource profile conformance (Patient, AllergyIntolerance, etc.)
  - Optional resource profile support
  - $summary operation implementation
  - Document reference and retrieval workflows

  This suite can be run against any FHIR R4 server claiming IPS support. Test scenarios 
  include both pre-loaded IPS documents and dynamic document generation via the $summary operation.

  Two preset configurations are available: one for testing with example IPS bundles, 
  and another for testing against reference server implementations.
)
```

---

## Group Level Descriptions

### Location and Format
Group descriptions are defined within group blocks:

```ruby
group do
  title 'Group Title'
  description %(
    [Content here]
  )
end
```

### Content Guidelines

Group descriptions should be concise and focused:

**Specific Purpose**
- What particular aspect or resource this group tests
- How it relates to the broader suite

**Testing Approach**
- Brief explanation of the testing methodology
- Key validation points

**Dependencies**
- Prerequisites from other groups
- Required inputs or setup

### Example
```ruby
group do
  title 'Patient Profile Validation'
  description %(
    This group tests server support for the IPS Patient profile. It validates that 
    Patient resources conform to the structural and terminology requirements defined 
    in the IPS specification.

    Tests verify required elements, cardinality constraints, and value set bindings 
    specific to the IPS Patient profile. The group assumes a valid Patient resource 
    ID is available from previous validation steps.
  )
end
```

---

## Test Level Descriptions

### Location and Format
Test descriptions are defined within individual test blocks:

```ruby
test do
  title 'Test Title'
  description %(
    [Content here]
  )
end
```

### Content Guidelines

Test descriptions should be precise and actionable:

**What is Being Tested**
- Specific requirement or capability being validated
- Reference to specification section if applicable

**Test Steps (if complex)**
- Brief outline of what the test does
- Key validation points

**Success Criteria**
- What constitutes a passing test
- Important edge cases handled

**Important Notes**
- Any assumptions or limitations
- Relationship to other tests

### Key Principles
- **Be Specific**: Describe exactly what is required and tested
- **Avoid General Guidance**: Don't include implementation advice
- **Note Discrepancies**: If the test differs from the specification requirement, explain why
- **Use Active Voice**: "This test verifies..." rather than "The server should..."

### Examples

**Simple Test**
```ruby
test do
  title 'Server returns Patient resource'
  description %(
    This test verifies that the server can return a Patient resource for the provided ID. 
    The test performs a FHIR read operation and validates that the response has a 200 status 
    and contains a Patient resource with the correct ID.
  )
end
```

**Complex Test**
```ruby
test do
  title 'Patient resource conforms to IPS Patient profile'
  description %(
    This test validates that the Patient resource conforms to the IPS Patient profile 
    (http://hl7.org/fhir/uv/ips/StructureDefinition/Patient-uv-ips). 

    The test verifies:
    - Required elements are present (identifier, name, gender)
    - Cardinality constraints are met
    - Value set bindings are correct for coded elements
    - Extensions are properly used according to the profile

    Note: This test uses the Patient resource retrieved in the previous test and will 
    skip if no valid Patient resource is available.
  )
end
```

**Test with Specification Discrepancy**
```ruby
test do
  title 'Bundle contains required Composition resource'
  description %(
    This test verifies that the IPS Bundle contains exactly one Composition resource 
    as required by the IPS specification section 2.3.1.

    The test searches for Composition resources within the Bundle entries and validates 
    that exactly one is present. While the specification requires the Composition to be 
    the first entry, this test does not enforce entry order due to common implementation 
    variations that do not affect clinical meaning.
  )
end
```

---

## Best Practices

### General Writing Guidelines

1. **Clarity Over Brevity**: Be clear and specific rather than concise
2. **Active Voice**: Use active voice ("This test verifies..." not "The server should...")
3. **Present Tense**: Describe what the test does, not what it will do
4. **Avoid Jargon**: Write for implementers who may not be familiar with all terminology
5. **Be Precise**: Specify exact requirements and validation points

### Maintaining Consistency Across Tests

**Terminology Consistency**
- Use consistent terminology throughout the test kit (e.g., always use "IPS Bundle" not "International Patient Summary Bundle" in some places and "IPS Bundle" in others)
- Maintain a glossary of key terms and their preferred usage
- Use the same phrasing for similar concepts across different tests

**Structural Consistency**
- Follow the same description structure for similar test types
- Use consistent formatting for specification references
- Apply the same level of detail for comparable tests

**Cross-Reference Management**
- When tests depend on each other, use consistent language to describe those dependencies
- Reference other tests by their exact titles when mentioning relationships
- Keep dependency descriptions up-to-date when test titles or structures change

### Handling Dynamic and Version-Specific Content

**Version References**
- Always specify the exact version of specifications being tested (e.g., "IPS Implementation Guide v1.1.0")
- Update version references consistently across all levels when upgrading
- Include links to specific versions rather than "current" or "latest" versions

**Dynamic Content Management**
- For test kits that support multiple versions, clearly indicate which version is being tested
- When test coverage changes, update the status sections to reflect current capabilities
- Use placeholder patterns for content that changes frequently (e.g., "Tests X of Y profiles" where X and Y are maintained programmatically)

**Configuration-Dependent Descriptions**
- When tests behave differently based on configuration, describe the variations
- For optional tests or groups, clearly explain when they should be run
- Document preset-specific behavior in relevant descriptions

### Description Evolution and Maintenance

**Keeping Descriptions Current**
- Review descriptions whenever test logic changes
- Update examples and validation points when test implementations evolve
- Ensure specification references remain valid and current

**Change Management**
- When modifying test behavior, update descriptions before or alongside code changes
- Consider the impact of description changes on user understanding
- Maintain backwards compatibility in description structure when possible

**Quality Assurance**
- Regularly audit descriptions against actual test behavior
- Verify that all specification links are functional
- Check that examples accurately reflect current implementation patterns

**Documentation Debt Prevention**
- Include description updates as part of the definition of done for test changes
- Use automated checks where possible to detect description-code mismatches
- Schedule periodic reviews of description accuracy and completeness

### Level-Specific Guidelines

**Test Kit Level**
- Write for decision-makers evaluating the test kit
- Include comprehensive scope and status information
- Provide clear next steps for users

**Suite Level**
- Write for implementers planning their testing approach
- Focus on practical usage scenarios
- Highlight key capabilities and prerequisites

**Group Level**
- Write for implementers working on specific resources/features
- Be concise but complete
- Clarify dependencies and relationships

**Test Level**
- Write for implementers debugging specific failures
- Be extremely specific about what is tested
- Include relevant specification references
- Note any test limitations or assumptions

### Common Mistakes to Avoid

1. **Vague Language**: Avoid "may", "should", "generally" - be specific
2. **Implementation Guidance**: Don't include how to implement, only what is tested
3. **Outdated References**: Ensure specification links and version numbers are current
4. **Assumption of Knowledge**: Don't assume readers know the full context
5. **Missing Context**: Always explain why a test exists and what it validates
6. **Format Support Claims**: Only mention supported formats (e.g., JSON-only, not XML)

### Markdown Formatting

- Use `**bold**` for emphasis on key points
- Use `- bullet points` for lists of capabilities or requirements
- Use `[link text](URL)` for specification references
- Use `code blocks` for technical terms or resource names
- Use `<!-- break -->` only in test kit descriptions to separate overview from details

### Specification References

- Always link to the specific version of the implementation guide
- Reference section numbers when applicable
- Explain any deviations from the specification
- Keep links current and verify they work

This focused approach ensures that descriptions serve their primary purpose: helping implementers understand exactly what each test validates and why it matters.
