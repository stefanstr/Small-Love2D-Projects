Player = {}

LightSource = {}
LightSource.__index = LightSource
LightSource.type = "LightSource"

function LightSource.getStrength (self)
	return self.strength
end

function LightSource.newLightSource (strength)
	local ls = {}
	ls.strength = strength
	setmetatable(ls, LightSource)
	return ls
end
