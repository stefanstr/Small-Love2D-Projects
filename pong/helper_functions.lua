function check_for_score () 
		local ball_pos = ball.body:getX()
		if ball_pos < 0 then
			ball_state = "left"
			right_score = right_score + 1
			ball.body:setLinearVelocity (0, 0)
			reset_pads()
		elseif ball_pos > win_x then
			ball_state = "right"
			left_score = left_score + 1
			ball.body:setLinearVelocity (0, 0)
			reset_pads()
		end
end

function check_for_serve ()
	if ball_state == "left" then
		ball.body:setPosition (pad_distance + pad_x*2, win_y * 3/4)
	elseif ball_state == "right" then
		ball.body:setPosition (win_x - pad_distance -pad_x*2, win_y * 1/4)
	end
end

function check_for_exit ()
	if love.keyboard.isDown("escape") then
			ball_state = initial_ball_state
			ball.body:setLinearVelocity (0, 0)
			menu()
	end
end

function serve (dx, dy)
	ball_state = "moving"
	local dlen = (dx^2 + dy^2) ^ 0.5
	local multiplier = ball_speed / dlen
	ball.body:applyTorque(0.3 * dlen) -- add some rotation to the ball
	ball.body:setLinearVelocity (multiplier * dx, multiplier * dy)
end

function manage_left_player (dt, ai)
	if ai then
		if whatAI == "simple" then simpleAI(dt, left_pad, right_pad) end
	else
		local ly = left_pad.body:getY()
		if love.keyboard.isDown("w") and ly > pad_y/2 then
				left_pad.body:setY (ly - dt * vel_unit)
		elseif love.keyboard.isDown("s") and ly < win_y - pad_y/2 then
			left_pad.body:setY (ly + dt * vel_unit)
		elseif love.keyboard.isDown("d") and ball_state == "left" then
			-- making sure that the ball starts always with the same velocity
			-- angle calculated by relative position of the pad
			local dx = ball.body:getX() - left_pad.body:getX()
			local dy = ball.body:getY() - left_pad.body:getY()
			if math.abs(dy) < pad_y/3 then
				serve(dx, dy)
			end
		end
	end
end


function manage_right_player (dt, ai)
	if ai then
		if whatAI == "simple" then simpleAI(dt, right_pad, left_pad) end
	else
		local ry = right_pad.body:getY()
		-- Get movement for the right pad:
		if love.keyboard.isDown("up") and ry > pad_y/2 then
				right_pad.body:setY (ry - dt * vel_unit)
		elseif love.keyboard.isDown("down") and ry < win_y - pad_y/2 then
			right_pad.body:setY (ry + dt * vel_unit)
		elseif love.keyboard.isDown("left") and ball_state == "right" then
			-- making sure that the ball starts always with the same velocity
			-- angle calculated by relative position of the pad
			local dx = ball.body:getX() - right_pad.body:getX()
			local dy = ball.body:getY() - right_pad.body:getY()
			if math.abs(dy) < pad_y/3 then
				serve(dx, dy)
			end
		end
	end
end

function reset_pads()
	left_pad.body:setPosition (pad_distance + pad_x/2, (win_y)/2)
	right_pad.body:setPosition (win_x - pad_x/2 - pad_distance, (win_y)/2)
end

function simpleAI(dt, pad, otherpad)
	local py = pad.body:getY()
	local by = ball.body:getY()
	local dy = nil
	local dx = ball.body:getX() - pad.body:getX()
	local other_relative_y = 0.5 - (otherpad.body:getY()/win_y)
	if ball_state == "moving" then
		dy = by - py
	elseif math.abs(dx) < win_x/2 then -- Checking if I am serving:
		-- try to serve the ball away from the player
		local target_y = by + pad_y/3 * other_relative_y
		dy = target_y - py
	else -- the other guy is serving, try intelligent placement
		if dx < 0 then
			dy = win_y *  (1.2 - (otherpad.body:getY()/win_y)) - py
		else
			dy = win_y *  (0.8 - (otherpad.body:getY()/win_y)) - py
		end
	end
	if dy < -pos_tolerance and py > pad_y/2 then
		pad.body:setY (py - dt * vel_unit)
	elseif dy > pos_tolerance and py < win_y - pad_y/2 then
		pad.body:setY (py + dt * vel_unit)
	elseif math.abs(dy) < pos_tolerance and ball_state ~= "moving" then
		-- Checking if ball is on the same side, i.e., if I am serving:
		if math.abs(dx) < win_x/2 then
			serve(dx, dy)
		end
	end
end

-- the below is used for menus

setNormalText = function ()
	love.graphics.setColor(unpack(menu_normal))
end
	
setHighlightedText = function ()
	love.graphics.setColor(unpack(menu_highlight))
end

function get_config_text ()
	local tmp = {}
	tmp[1] = config_options[1]
	tmp[2] = config_options[2] .. AI
	tmp[3] = config_options[3]
	return tmp
end


-- Draw the playing field.
function draw_playing_field()
	-- draw the pads
	love.graphics.setColor(unpack(pads_color))
	love.graphics.polygon("fill", left_pad.body:getWorldPoints(left_pad.shape:getPoints()))
	love.graphics.polygon("fill", right_pad.body:getWorldPoints(right_pad.shape:getPoints()))	

	-- draw the ball
	love.graphics.setColor(unpack(ball_color))
	love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())

	-- draw the walls
	love.graphics.polygon("fill", upper_wall.body:getWorldPoints(upper_wall.shape:getPoints()))	
	love.graphics.polygon("fill", lower_wall.body:getWorldPoints(lower_wall.shape:getPoints()))	

	-- draw the middle line
	love.graphics.line(win_x/2, 0, win_x/2, win_y)

	love.graphics.setColor(unpack(score_color))
	love.graphics.print(left_score, score_x, score_y)
	love.graphics.print(right_score, win_x - font_size, 20)
end

