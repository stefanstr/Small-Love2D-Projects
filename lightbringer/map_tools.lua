-- mapa musi zawierać listę pól, pozycję gracza, pozycję źródeł światła
-- pozycję wrogów
-- oprócz tego trzeba robić "wizualny" ruch, tzn. płynne przechodzenie z pola
-- na pole

Map = {}
Map.__newindex = function() error("You tried to create an invalid field!") end
Map.__index = Map

function Map.getWall (self, w, h)
	return self[w][h].wall
end

function Map.getObject (self, w, h)
	return self[w][h].object
end

function Map.setObject (self, w, h, object)
	self[w][h].object = object
end

function Map.displayMap (self, start_w, start_h)
	for w=0, tiles_in_window-1 do
		for h=0, tiles_in_window-1 do
			if self:getWall(w + start_w, h + start_h) then
				love.graphics.setColor(unpack(settings.colors.tile_wall))
			else
				love.graphics.setColor(unpack(settings.colors.tile_empty)) 			
			end
			--print("displaying coordinates ", w+start_w, h + start_h)
			love.graphics.rectangle("fill", w * settings.tile_size, h * settings.tile_size, settings.tile_size, settings.tile_size)
			if self:getObject(w + start_w, h + start_h) then
				if self:getObject(w + start_w, h + start_h).type == "LightSource" then
					local shine = self:getObject(w + start_w, h + start_h):getStrength() / settings.max_lightsource_strength * 255
					local r, g, b = unpack(settings.colors.lightsource)
					love.graphics.setColor(r, g, b, shine)
					love.graphics.circle("fill", (w + 0.5) * settings.tile_size, (h + 0.5) * settings.tile_size, settings.tile_size/2)
				end
			end
		end
	end
end

function Map.addLightSources (self, amount)
	local left = amount
	while left > 0 do
		for w=1, self.size do
			for h=1, self.size do
				if not self:getWall(w, h) and not self:getObject(w, h) and math.random(0, self.size^2) < amount then
					local strength = math.random (1, settings.max_lightsource_strength)
					self:setObject(w, h, LightSource.newLightSource (strength))
					left = left - 1
				end
			end
		end
	end
end

function Map.newMap (size, break_even)
	local maze = {}
	maze.size = size
	for w=1, size do
		table.insert(maze, {})
		for h=1, size do
			if w == 1 or w == size or h == 1 or h == size then
				has_wall = true
			else
				local noise = love.math.noise (w, h)
				has_wall = (noise > break_even) and true or false
			end
			table.insert(maze[w], {})
			maze[w][h].wall = has_wall
			maze[w][h].object = false
		end
	end
	
	--making maze an object of the Map class
	setmetatable (maze, Map)
	return maze
end
