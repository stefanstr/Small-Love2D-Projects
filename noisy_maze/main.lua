-- Testing generating a maze bazed on simplex noise --

function love.load()
		love.math.setRandomSeed( love.timer.getTime( ))
		love.window.setTitle("Noisy maze by gestaltist")
		win_x, win_y = love.window.getDimensions()
		
		w = 64
		h = 64
		break_even = 0.65
		tile_size = 36
		wall_color = {0, 0, 0}
		room_color = {255, 255, 255}
		player_color = {255,228,181}
		lighting_strength = 10

		maze = createMaze(w, h, break_even)
		last_mouse_x, last_mouse_y = love.mouse.getPosition()
		repeat
			player_x = love.math.random(w)
			player_y = love.math.random(h)
			if not maze[player_y][player_x] then OK = true end
		until OK
end

function love.draw()
	love.graphics.translate(dx, dy)
	for h=1, h do
		for w = 1, w do
			if getDistance(player_x, player_y, w, h) > lighting_strength then
			 	love.graphics.setColor(unpack(wall_color))
			elseif maze[h][w] then 
				love.graphics.setColor(unpack(wall_color))
			else 
				love.graphics.setColor(unpack(room_color))
			end
			love.graphics.rectangle("fill", (w-1) * tile_size, (h-1) * tile_size, tile_size, tile_size)
		end
	end
	-- draw player
	love.graphics.setColor(unpack(player_color))
	love.graphics.circle("fill", getPlayerX(player_x),getPlayerY(player_y), math.floor(tile_size/2), tile_size)
	-- add lighting
	drawLighting(getPlayerX(player_x),getPlayerY(player_y), lighting_strength * (tile_size + 1))
end

function love.update(dt)
	dx = win_x/2 - getPlayerX(player_x) 
	dy = win_y/2 - getPlayerY(player_y)
--	local new_mouse_x, new_mouse_y = love.mouse.getPosition()
--	if love.mouse.isDown("l") then
--		dx = dx + (new_mouse_x - last_mouse_x)
--		dy = dy + (new_mouse_y - last_mouse_y)
--	end
--	last_mouse_x, last_mouse_y = new_mouse_x, new_mouse_y
end

function love.keypressed(key, isrepeat)
	if key == "up" then
		target_w = player_x
		target_h = player_y - 1
	elseif key == "down" then
		target_w = player_x
		target_h = player_y + 1
	elseif key == "left" then
		target_w = player_x - 1 
		target_h = player_y
	elseif key == "right" then
		target_w = player_x + 1
		target_h = player_y
	else
		return
	end
	if not maze[target_h][target_w] then
		player_y = target_h
		player_x = target_w
	end
end

-- End of callbacks --


function createMaze(width, height, break_even) -- creates a maze bazed on the simplex noise
	local maze = {}
	for h=1, height do
		table.insert(maze, {})
		for w=1, width do
			if w==1 or w == width or h==1 or h == height then
				has_wall = true
			else
				local noise = love.math.noise (w, h)
				has_wall = (noise > break_even) and true or false
			end
			table.insert(maze[h], has_wall)
		end
	end
	return maze
end

function drawMaze (w, h) -- to display the whole maze - for debug
	for h=1, h do
		for w =1, w do
			if maze[h][w] then 
				love.graphics.setColor(unpack(wall_color))
			else 
				love.graphics.setColor(unpack(room_color))
			end
			love.graphics.rectangle("fill", (w-1) * tile_size, (h-1) * tile_size, tile_size, tile_size)
		end
	end
end

function drawLighting(w, h, radius)
	local ls = tile_size/9 -- number of pixels of a lighting square - setting this too low can decrease performance
	local x1 = w - radius
	local y1 = h - radius
	local r = math.ceil(radius/ls) 
	local alpha
	local lighting_array = makeLightingArray(x1, y1, radius, ls) --new
	for x=1, r * 2 do
		for y=1, r * 2 do 
				if lighting_array[y][x] then -- new
					alpha = 128 
				else
					dist = getDistance(x1 + x * ls, y1 + y * ls, w, h)
					alpha = 255/radius * dist
					alpha = (alpha <= 255) and alpha or 255
				end
				love.graphics.setColor(0, 0, 0, alpha)
				love.graphics.rectangle("fill", x1+(x-1)*ls, y1+(y-1)*ls, ls, ls)
		end
	end
end

function getDistance(x1, y1, x2, y2)
	return math.sqrt((x1-x2)^2 + (y1-y2)^2)
end

function getPlayerX(x)
	return (x - 1/2) * tile_size
end

function getPlayerY(y)
	return  (y - 1/2) * tile_size
end

function getMazeSquare(x, y)
	local w = math.floor(x/tile_size) + 1
	local h = math.floor(y/tile_size) + 1
	return maze[h][w]
end

function hasObstacle(tab, x1, y1, x2, y2) -- check in tab between 2 points
	
	return false
end


function makeLightingArray(x1, y1, radius, ls) -- x1, y1 are pixels
	local t = {}
	local r = math.ceil(radius/ls)
	local center = tile_size / ls -- how big is the ball?
	for y=y1, y1 + 2 * radius, ls do
		table.insert(t, {})
		for x=x1, x1+ 2 * radius, ls do
			if maze[math.ceil(y/tile_size)][math.ceil(x/tile_size)] then
				table.insert(t[#t], true) -- true means is dark
			else
				table.insert(t[#t], false) 
			end
		end
	end
	for r1=1, r-1 do -- propagating darkness
		for x=-r1, r1 do
			for y= -r1, r1 do
				print(radius, r, x, y)
				if (math.abs(x) == r1) or (math.abs(y) == r1) then
					print("yes", #t, #t[1])
					if t[y + r ][x + r ] == true then
						print("true", (y/math.abs(y) * y), (x/math.abs(x) * x))
						local new_x = (x==0) and x or (x/math.abs(x) * x)
						local new_y = (y==0) and y or (y/math.abs(y) * y)
						--if new_y > -r1 then
--							t[new_y + r-1][new_x + r-1] = true
--							t[new_y + r-1][new_x + r] = true
--						end
--						if new_x > -r1 then
--							t[new_y + r][new_x + r-1] = true
--						end
						t[new_y + r][new_x + r ] = true
					end
				end 
			end
		end
	end
	return t
end 

