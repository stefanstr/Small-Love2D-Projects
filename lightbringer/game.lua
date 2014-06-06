function game()
	map = map or Map.newMap(settings.map_size, settings.break_even)
	map:addLightSources(30) 
	local offsetx = 1
	local offsety = 1
	ls = LightSource.newLightSource(5)
	print(ls:getStrength())
	function love.draw()
		map:displayMap(offsetx, offsety)
	end

	function love.update(dt)
	end

	function love.keypressed (key, isrepeat)
		if key == "up" and offsety > 1 then offsety = offsety -1 
		elseif key == "down" and offsety < settings.map_size - tiles_in_window + 1 then offsety = offsety + 1
		elseif key == "left" and offsetx > 1  then offsetx = offsetx -1
		elseif key == "right" and offsetx < settings.map_size - tiles_in_window + 1 then offsetx = offsetx + 1
		end
	end
end