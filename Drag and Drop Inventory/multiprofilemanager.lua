local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local ctg2ctg = {
	masks = 'mask',
	primaries = 'primary',
	secondaries = 'secondary',
}

function MultiProfileManager:ddi_update_other_profiles(category, old_data, new_data)
	local ctg = ctg2ctg[category]
	if not ctg then
		return
	end

	local indexed_new_data = {}
	for i, item in pairs(new_data) do
		indexed_new_data[item] = i
	end

	for i, profile in ipairs(self._global._profiles) do
		if i ~= self._current_profile then
			local previous_index = profile[ctg]
			local item = old_data[previous_index]
			local current_index = indexed_new_data[item]
			if current_index ~= previous_index then
				profile[ctg] = current_index
			end
		end
	end
end

function MultiProfileManager:ddi_swap_item(category, from_slot, to_slot)
	local ctg = ctg2ctg[category]
	if not ctg then
		return
	end

	for i, profile in ipairs(self._global._profiles) do
		if i ~= self._current_profile then
			if profile[ctg] == from_slot then
				profile[ctg] = to_slot
			elseif profile[ctg] == to_slot then
				profile[ctg] = from_slot
			end
		end
	end
end
