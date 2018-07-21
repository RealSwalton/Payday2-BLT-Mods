WeaponFactoryManager._spawn_and_link_unit_original = WeaponFactoryManager._spawn_and_link_unit

local temp_custom_attachment_points = {}

function WeaponFactoryManager:_spawn_and_link_unit( u_name, a_obj, third_person, link_to_unit )
	if link_to_unit and link_to_unit:base() and link_to_unit:base().weapon_tweak_data then
		local weapon_tweakdata = link_to_unit:base():weapon_tweak_data()

		if weapon_tweakdata then
			temp_custom_attachment_points = weapon_tweakdata.attachment_points
		end
	end

	if temp_custom_attachment_points then
		for index, attach_point in pairs( temp_custom_attachment_points ) do
			if Idstring( attach_point.name ) == a_obj then
				local unit = World:spawn_unit(u_name, Vector3(), Rotation())

				local base_a_obj = Idstring(attach_point.base_a_obj) or Idstring("a_body")
				if base_a_obj then
					local attachment_object = link_to_unit:get_object(base_a_obj)
					if attachment_object then
						local base_attachment_position = attachment_object:position() or Vector3(0,0,0)
						local base_attachment_rotation = attachment_object:rotation() or Rotation(0,0,0)

						local position_offset = attach_point.position or Vector3(0,0,0)
						local rotation_offset = attach_point.rotation or Rotation(0,0,0)

						local res = link_to_unit:link(base_a_obj, unit, unit:orientation_object():name())

						local new_position = ( base_attachment_position + position_offset ) or Vector3(0,0,0)
						local new_rotation = Rotation(
							base_attachment_rotation:yaw() + rotation_offset:yaw(),
							base_attachment_rotation:pitch() + rotation_offset:pitch(),
							base_attachment_rotation:roll() + rotation_offset:roll()
						) or Rotation(0,0,0)

						unit:set_position( new_position )
						unit:set_rotation( new_rotation )

						if managers.occlusion and not third_person then
							managers.occlusion:remove_occlusion(unit)
						end
					else
						log("Custom Attachment Points Error: Base Not Found - " .. attach_point.name )
					end
				else
					log("Custom Attachment Points Error: Base Not Found - " .. attach_point.name )
				end

				return unit
			end
		end
	end

	return self:_spawn_and_link_unit_original( u_name, a_obj, third_person, link_to_unit )
end