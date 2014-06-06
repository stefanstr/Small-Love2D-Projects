function love.load ()
	love.math.setRandomSeed( love.timer.getTime( ))
	love.window.setTitle("Lighting Doodle by gestaltist")
	--love.graphics.setBackgroundColor(255,255,255)
	win_x, win_y = love.window.getDimensions()
	square_size = 25
	radius = 10
	table_x = math.ceil(win_x/square_size)
	table_y = math.ceil(win_y/square_size)
	field = {}
	for x=1, table_x do
		table.insert(field, {})
		for y=1, table_y do
			table.insert(field[x], {getRandomColor()})
		end
	end
end

function love.draw ()
	mx, my = love.mouse.getPosition()
	mx = math.ceil(mx/square_size)
	my = math.ceil(my/square_size)
	for x=1, table_x do
		for y=1, table_y do
			color = field[x][y]
			--local dmouse = math.sqrt((mx - x)^2 + (my - y)^2)
--			dmouse = dmouse * square_size * radius
--			local alpha = dmouse <= 255 and dmouse or 255
			love.graphics.setColor(unpack(color))
			love.graphics.rectangle("fill", (x-1) * square_size, (y-1) * square_size, square_size, square_size)
			y = y + 1
		end
		x = x + 1
	end
	--add circles of light
	local mx, my = love.mouse.getPosition()
	local n_alpha = 255
	local size = square_size/3
	for x=1, radius do
		local r = x * size
		love.graphics.setColor(0, 0, 0, 255-n_alpha)
		love.graphics.setLineWidth(size)
		love.graphics.circle("line", mx, my, r)
		n_alpha = math.log(n_alpha)
		--alpha = alpha + alpha/radius * x
	end
end

function love.keypressed(key, isrepeat)
	if key == "r" then square_size = square_size + 1 end
	if key == "e" then 
	square_size = square_size > 1 and (square_size - 1) or 1 
	table_x = math.ceil(win_x/square_size)
	table_y = math.ceil(win_y/square_size)
	field = {}
	for x=1, table_x do
		table.insert(field, {})
		for y=1, table_y do
			table.insert(field[x], {getRandomColor()})
		end
	end
	end
	if key == "f" then radius = radius + 0.1 end
	if key == "d" then radius = radius > 0.1 and (radius - 0.1) or 0.1 end
end


function getRandomColor()
	return love.math.random(255), love.math.random(255), love.math.random(255)
end
	