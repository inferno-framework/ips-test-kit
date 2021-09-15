module IPS
	class AllergyIntolerance < Inferno::TestGroup
		title 'Allergy Intolerance - Cross Border (IPS) Tests'
		description 'Verify support for the server capabilities required by the Allergy Intolerance - Cross Border (IPS) profile.'
		id :ips_allergy_intolerance_cross_border

		test do
			title 'Server returns correct AllergyIntolerance resource from the AllergyIntolerance read interaction'
			description %(
				This test will verify that AllergyIntolerance resources can be read from the server.
			)
			# link 'http://hl7.org/fhir/uv/ips/StructureDefinition/AllergyIntolerance-cross-border-uv-ips'

			input :allergy_intolerance_id
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
			title 'Server returns AllergyIntoleranceCrossBorder resource that matches the Allergy Intolerance - Cross Border (IPS) profile'
			description %(
				This test will validate that the AllergyIntoleranceCrossBorder resource returned from the server matches the Allergy Intolerance - Cross Border (IPS) profile.
			)
			# link 'http://hl7.org/fhir/uv/ips/StructureDefinition/AllergyIntolerance-cross-border-uv-ips'
			uses_request :allergy_intolerance

			run do
				assert_valid_resource(profile_url: 'http://hl7.org/fhir/uv/ips/StructureDefinition/AllergyIntolerance-cross-border-uv-ips')
			end
		end
	end
end