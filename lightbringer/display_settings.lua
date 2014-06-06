display_settings = function ()
	local menu_selected = 1
	
	love.update = nil

	function love.draw ()
		draw_the_title()
		draw_the_menus(settings.settings_menus, menu_selected)
	end

	function love.keypressed (key, isrepeat)
		if key == "up" and menu_selected > 1 then
			menu_selected = menu_selected - 1
		elseif key == "down" and menu_selected < settings.menus_len then
			menu_selected = menu_selected + 1
		elseif key == " " or key == "return" then
			if menu_selected == 1 then
				--change language
				if settings.locale == "EN" then
					settings.locale = "PL"
				else 
					settings.locale = "EN"
				end
			elseif menu_selected == 2 then
				--save settings
				local settings_text = serialize("settings")
				love.filesystem.write (settingsfilename, settings_text)
				main_menu()
			elseif menu_selected == 3 then
				--back to the menu
				main_menu()
			end
		end
	end
end

--default_settings.menus.newgame.EN = "Start a new game"
--default_settings.menus.resume.EN = "Resume"
--default_settings.menus.settings.EN = "Game settings"
--default_settings.menus.instructions.EN = "How to play"
--default_settings.menus.highscores.EN = "Highscores"
--default_settings.menus.credits.EN = "Game credits"
--default_settings.menus.exit.EN = "Quit to the OS"