if not BLTViewModGui then
	return
end

function BLTViewModGui:_setup_buttons( mod )
	local padding = 10

	local buttons_panel = self._panel:panel({
		x = padding,
		y = padding,
		w = self._panel:w() * 0.5 - padding * 2,
		h = self._panel:h() - padding * 2,
	})
	buttons_panel:set_top( self._info_panel:top() )
	buttons_panel:set_left( self._info_panel:right() + padding )

	local button_w = 280
	local button_h = 220
	local btn
	local next_row_height

	if not mod:IsUndisablable() then

		local icon, rect = tweak_data.hud_icons:get_icon_data( "csb_locks" )
		btn = BLTUIButton:new( buttons_panel, {
			x = 0,
			y = 0,
			w = button_w,
			h = button_h,
			title = managers.localization:text("blt_mod_state_enabled"),
			text = managers.localization:text("blt_mod_state_enabled_desc"),
			image = icon,
			image_size = 96,
			texture_rect = rect,
			callback = callback( self, self, "clbk_toggle_enable_state" )
		} )
		table.insert( self._buttons, btn )
		self._enabled_button = btn
		next_row_height = button_h + padding

	end

	if self._mod:HasUpdates() then

		local icon, rect = tweak_data.hud_icons:get_icon_data( "csb_pagers" )
		btn = BLTUIButton:new( buttons_panel, {
			x = 0,
			y = next_row_height or 0,
			w = button_w,
			h = button_h,
			title = managers.localization:text("blt_mod_updates_enabled"),
			text = managers.localization:text("blt_mod_updates_enabled_help"),
			image = icon,
			image_size = 96,
			texture_rect = rect,
			callback = callback( self, self, "clbk_toggle_updates_state" )
		} )
		table.insert( self._buttons, btn )
		self._updates_button = btn

		local icon, rect = tweak_data.hud_icons:get_icon_data( "csb_stamina" )
		btn = BLTUIButton:new( buttons_panel, {
			x = button_w + padding,
			y = next_row_height or 0,
			w = button_w,
			h = button_h,
			title = managers.localization:text("blt_mod_check_for_updates"),
			text = managers.localization:text("blt_mod_check_for_updates_desc"),
			image = icon,
			image_size = 96,
			texture_rect = rect,
			callback = callback( self, self, "clbk_check_for_updates" )
		} )
		table.insert( self._buttons, btn )
		self._check_update_button = btn

		next_row_height = (next_row_height or 0) + button_h + padding

	end

	btn = BLTUIButton:new( buttons_panel, {
		x = 0,
		y = (next_row_height or 0),
		w = button_w,
		h = button_h * 0.5,
		title = managers.localization:text("blt_mod_toggle_dev"),
		text = managers.localization:text("blt_mod_toggle_dev_desc"),
		callback = callback( self, self, "clbk_toggle_dev_info" )
	} )
	table.insert( self._buttons, btn )

	if mod.GetBLTVersion and mod:GetBLTVersion() ~= 2 then
		next_row_height = (next_row_height or 0) + button_h + padding
		btn = BLTUIButton:new( buttons_panel, {
			x = 0,
			y = (next_row_height or 0),
			w = button_w,
			h = button_h * 0.5,
			title = "Forced This Mod.txt to BLT 2.0",
			text = " ",
			callback = callback( self, self, "forced_this_mod_to_blt2", {mod = mod})
		} )
		table.insert( self._buttons, btn )
	end
end

function BLTViewModGui:forced_this_mod_to_blt2( data )
	if not data or not data.mod or not data.mod.json_data or not data.mod.path then
		return
	end
	data.mod.json_data.blt_version = data.mod.json_data.blt_version or 2
	local _file = io.open(data.mod.path .. "mod.txt", "w+")
	if _file then
		_file:write(tostring(json.encode(data.mod.json_data)))
		_file:close()
		QuickMenu:new(
			"'".. tostring(data.mod.name) .."' is updated successfully",
			" ",
			{
			},
			true
		)
	end
end