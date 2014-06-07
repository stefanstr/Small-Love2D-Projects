Player = {}

-- GENERAL SUPERCLASS FOR GAMEOBJECTS --

GameObject = {}
GameObject.__index = GameObject
GameObject.type = "GameObject"

function GameObject.getStrength (self)
	return self.strength
end

function GameObject.getPosition (self)
	return self.w, self.h
end

-- LIGHTSOURCES --
LightSource = {}
LightSource.__index = LightSource
LightSource.type = "LightSource"
setmetatable(LightSource, GameObject)

function LightSource.draw (self, offset_w, offset_h)
	local w = self.w + offset_w
	local h = self.h + offset_h
	local shine = self:getStrength() / settings.max_lightsource_strength * 255
	local r, g, b = unpack(settings.colors.lightsource)
	love.graphics.setColor(r, g, b, shine)
	love.graphics.circle("fill", (w + 0.5) * settings.tile_size, (h + 0.5) * settings.tile_size, settings.tile_size/2)
end

function LightSource.newLightSource (w, h, strength)
	local ls = {}
	ls.strength = strength
	ls.w = w
	ls.h = h
	setmetatable(ls, LightSource)
	return ls
end

-- DARKLINGS --

Darkling = {}
Darkling.__index = Darkling
Darkling.type = "Darkling"
Darkling.list = {}
Darkling.offset_w = 0
Darkling.offset_h = 0
setmetatable(Darkling, GameObject)

function Darkling.updateDarklings(map, dt)
	for _, v in ipairs(Darkling.list) do
		if math.abs(v.offset_h) >= settings.tile_size then
			if v.offset_h > 0 then
				map[v.w][v.h + 1] = map[v.w][v.h]
				v.h = v.h + 1
				map[v.w][v.h] = false
			else
				map[v.w][v.h - 1] = map[v.w][v.h]
				v.h = v.h - 1
				map[v.w][v.h] = false
			end
			v.destination = nil
		elseif math.abs(v.offset_w) >= settings.tile_size then
			if v.offset_w > 0 then
				map[v.w + 1][v.h] = map[v.w][v.h]
				v.w = v.w + 1
				map[v.w][v.h] = false
			else
				map[v.w - 1][v.h] = map[v.w][v.h]
				v.w = v.w - 1
				map[v.w][v.h] = false
			end
			v.destination = nil
		elseif v.destination == "up" then
			v.offset_w = 0
			v.offset_h = v.offset_h - dt
		elseif v.destination == "down" then
			v.offset_w = 0
			v.offset_h = v.offset_h + dt		
		elseif v.destination == "left" then
			v.offset_w = v.offset_w - dt
			v.offset_h = 0
		elseif v.destination == "right" then
			v.offset_w = v.offset_w + dt
			v.offset_h = 0
		else
			v.offset_w = 0
			v.offset_h = 0
			v:makeDecision(map)
		end
		v.offset_w = v.offset_w * settings.game_speed
		v.offset_h = v.offset_h * settings.game_speed
	end
end

function Darkling.makeDecision (self, map)
	local d = math.random(1,7)
	if d == 1 then
		if not map:getObject(self.w, self.h - 1) then
			self.destination = "up"
		end
	elseif d == 2 then
		if not map:getObject(self.w, self.h + 1) then
			self.destination = "down"
		end
	elseif d == 3 then
		if not map:getObject(self.w - 1, self.h) then
			self.destination = "left"
		end
	elseif d == 4 then
		if not map:getObject(self.w, self.h + 1) then
			self.destination = "right"
		end
	end
end

function Darkling.draw (self, offset_w, offset_h)
	local w = self.w + offset_w + self.offset_w/settings.tile_size
	local h = self.h + offset_h + self.offset_h/settings.tile_size
	local shine = self:getStrength() / settings.max_lightsource_strength * 255
	local r, g, b = unpack(settings.colors.darkling)
	love.graphics.setColor(r, g, b, shine)
	love.graphics.polygon("fill", 
			(w + 0.5) * settings.tile_size, h * settings.tile_size,
			(w + 1) * settings.tile_size, (h + 0.5) * settings.tile_size,
			(w + 0.5) * settings.tile_size, (h + 1) * settings.tile_size,
			w * settings.tile_size, (h + 0.5) * settings.tile_size
			)
end

function Darkling.newDarkling (w, h, strength, movement)
	local dk = {}
	dk.strength = strength
	dk.movement = movement
	dk.w = w
	dk.h = h
	setmetatable(dk, Darkling)
	table.insert(Darkling.list, dk)
	return dk
end