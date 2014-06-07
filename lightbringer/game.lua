function game()
	map = map or Map.newMap(settings.map_size, settings.break_even)
	map:addObjects(30, LightSource.newLightSource, settings.max_lightsource_strength) 
	map:addObjects(30, Darkling.newDarkling, settings.max_darkling_strength, 1)
	local offsetx = 1
	local offsety = 1
	
	function love.draw()
		map:displayMap(offsetx, offsety)
	end

	function love.update(dt)
		Darkling.updateDarklings(map, dt)
	end

	function love.keypressed (key, isrepeat)
		if key == "up" and offsety > 1 then offsety = offsety -1 
		elseif key == "down" and offsety < settings.map_size - tiles_in_window + 1 then offsety = offsety + 1
		elseif key == "left" and offsetx > 1  then offsetx = offsetx -1
		elseif key == "right" and offsetx < settings.map_size - tiles_in_window + 1 then offsetx = offsetx + 1
		end
	end
end