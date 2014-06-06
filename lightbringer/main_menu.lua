main_menu = function ()
	local menu_selected = 1
	
	love.update = nil

	function love.draw ()
		-- draw the title --
		draw_the_title()
		-- draw the menus --
		draw_the_menus(settings.menus, menu_selected)
	end

	function love.keypressed (key, isrepeat)
		if key == "up" and menu_selected > 1 then
			menu_selected = menu_selected - 1
		elseif key == "down" and menu_selected < settings.menus_len then
			menu_selected = menu_selected + 1
		elseif key == " " or key == "return" then
			if menu_selected == 1 then
				--new game
				game()
			elseif menu_selected == 2 then
				--resume active game
			elseif menu_selected == 3 then
				--game settings
				display_settings()
			elseif menu_selected == 4 then
				--instructions
			elseif menu_selected == 5 then
				--highscores
			elseif menu_selected == 6 then
				--game credits
			elseif menu_selected == 7 then
				--exit game
				love.event.quit()
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