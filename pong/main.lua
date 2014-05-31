--------------------------------------------------
--    My first experiment with Lua and Love2D   --
--                  P  O  N  G                  --
--------------------------------------------------

require("defaults") -- default values
require("helper_functions") -- most functions moved there to avoid clutter


-- This function runs once at the start of the game.
function love.load()
	left_score = 0
	right_score = 0
	love.graphics.setBackgroundColor (unpack(background_color)) 
	
	-- Initiating the physics and creating physical objects:
	board = love.physics.newWorld (0, 0, false)
	win_x, win_y = love.window.getDimensions()
	
	upper_wall = {}
	upper_wall.body = love.physics.newBody (board, win_x/2, wall_width/2, "static")
	upper_wall.shape = love.physics.newRectangleShape (win_x, wall_width)
	upper_wall.fixture = love.physics.newFixture (upper_wall.body, upper_wall.shape)

	lower_wall = {}
	lower_wall.body = love.physics.newBody (board, win_x/2, win_y - wall_width/2, "static")
	lower_wall.shape = love.physics.newRectangleShape (win_x, wall_width)
	lower_wall.fixture = love.physics.newFixture (lower_wall.body, lower_wall.shape)		

	-- Pads need to be static. Otherwise, the ball would push them offscreen.
	left_pad = {}
	left_pad.body = love.physics.newBody (board, pad_distance + pad_x/2, (win_y)/2, 'static')
	left_pad.shape = love.physics.newRectangleShape (pad_x, pad_y)
	left_pad.fixture = love.physics.newFixture (left_pad.body, left_pad.shape)

	
	right_pad = {}
	right_pad.body = love.physics.newBody (board, win_x - pad_x/2 - pad_distance, (win_y)/2, 'static')
	right_pad.shape = love.physics.newRectangleShape (pad_x, pad_y)
	right_pad.fixture = love.physics.newFixture (right_pad.body, right_pad.shape)
	
	ball = {}
	ball.body = love.physics.newBody (board, win_x/2, win_y/2, 'dynamic')
	ball.shape = love.physics.newCircleShape (ball_r)
	ball.fixture = love.physics.newFixture (ball.body, ball.shape)
	ball.fixture:setRestitution(ball_bounciness)	
	ball.fixture:setFriction(0) -- Without this, the ball behaved weirdly.
	ball_state = initial_ball_state
	
	menu() -- Launch the menu.
	
	--[[ The whole program is divided into functions that represent menu options.
	They launch the appropriate versions of love callbacks. The important thing
	to remember is to also set the unneeded callbacks used by other functions
	to nil.
	]]--
end


-- Beginning of function play --
-- This function covers the gameplay without or with AI
play = function ()
	-- Deactivating callbacks from other functions:
	love.mousepressed = nil
	
	-- Setting the font for score display:
	love.graphics.setNewFont( font_size )
	left_score = 0
	right_score = 0
	
	check_for_serve()
	
	reset_pads()


	function love.draw()
		-- If someone won - go to the winning screen.
		if left_score == winning_score then
			winner(1, left_score, right_score)
		elseif right_score == winning_score then
			winner(2, left_score, right_score)
		else
			draw_playing_field()
		end
	end


	function love.update(dt)
		board:update(dt) -- update physics
		
		check_for_score()

		check_for_serve()
		
		check_for_exit ()
		
		
		-- Get movement for the pads:
		-- these functions take an optional second parameter - AI
		manage_left_player(dt, leftAI)
		manage_right_player(dt, rightAI)	
	end
end
-- End of function play --


-- Beginning of function menu --
-- This function covers the main menu
menu = function ()
	local mx, my = love.mouse.getPosition()
	local menu_selected = nil

	function love.draw ()
		local title_size = font_size * 3
		local txt_x = win_x/3
		local txt_y = font_size * 0.6
		
		-- draw the title --
		love.graphics.setColor(unpack(title_color))
		love.graphics.setNewFont(title_size)
		love.graphics.printf(title_text ,txt_x, font_size , txt_x ,"center")
		love.graphics.setNewFont(txt_y)
		
		-- draw the menu options, highlighting as needed --
		for i, txt in ipairs(menu_options) do
			if mx > txt_x/2 and mx < txt_x * 2.5 and my > (title_size * 2 + txt_y * i *2)
			   and my < (title_size * 2 + txt_y * (i+1) *2) then
			   	setHighlightedText()
			   	menu_selected = i
			else
				setNormalText()
			end
			love.graphics.printf(txt, txt_x/2, title_size * 2 + txt_y * i * 2, txt_x*2, "center")
		end
		
	end
	
	function love.update (dt)
		-- we only need to update the mouse position here
		-- as all the work is done by love.draw and love.mousepressed
		mx, my = love.mouse.getPosition()
		
		check_for_exit () -- go back to menu with escape
	end
	
	-- if any menu position has been selected - do that
	function love.mousepressed (mx, my, button)
		if menu_selected == 1 then
			leftAI = nil
			rightAI = nil
			play()
		elseif menu_selected == 2 then
			if AI == "left" then
				leftAI = whatAI
				rightAI = nil
			elseif
				AI == "right" then
				leftAI = nil
				rightAI = whatAI
			elseif AI == "both" then
				leftAI = whatAI
				rightAI = whatAI
			else error ("Invalid AI selection")
			end
			play()
		elseif menu_selected == 3 then
			options()
		elseif menu_selected == 4 then
			love.event.quit()
		end
	end
end
-- End of function menu --


-- Beginning of function options --
-- This function covers the various options
options = function ()
	local mx, my = love.mouse.getPosition()
	local option_selected = nil

	function love.draw ()
		local title_size = font_size * 3
		local txt_x = win_x/3
		local txt_y = font_size * 0.6
		
		-- draw the title --
		love.graphics.setColor(unpack(title_color))
		love.graphics.setNewFont(title_size)
		love.graphics.printf(title_text ,txt_x, font_size , txt_x ,"center")
		love.graphics.setNewFont(txt_y)
		
		-- draw the menu options, highlighting as needed --
		for i, txt in ipairs(get_config_text()) do
			if mx > txt_x/2 and mx < txt_x * 2.5 and my > (title_size * 2 + txt_y * i *2)
			   and my < (title_size * 2 + txt_y * (i+1) *2) then
			   	setHighlightedText()
			   	option_selected = i
			else
				setNormalText()
			end
			love.graphics.printf(txt, txt_x/2, title_size * 2 + txt_y * i * 2, txt_x*2, "center")
		end
		
	end
	
	function love.update (dt)
		-- we only need to update the mouse position here
		-- as all the work is done by love.draw and love.mousepressed
		mx, my = love.mouse.getPosition()
	end
	
	-- if any menu position has been selected - do that
	function love.mousepressed (mx, my, button)
		if option_selected == 1 then
			instructions()
		elseif option_selected == 2 then
			if AI == "left" then
				AI = "right"
			elseif AI == "right" then
				AI = "both"
			elseif AI == "both" then
				AI = "left"
			else error ("Invalid AI selection")
			end
		elseif option_selected == 3 then
			menu()
		end
	end
end

-- End of function options --


-- Beginning of function winner --
-- This function displays the winning message
winner = function (player, score1, score2)
	love.update = nil  -- no updates needed here

	function love.draw()
		love.graphics.setColor(unpack(winning_color))
		message = "Player " .. player .. " wins!"
		love.graphics.printf(message, win_x/6, win_y/3, win_x/6*4, "center")
		love.graphics.setColor(unpack(score_color))
		love.graphics.print(score1, score_x, score_y)
		love.graphics.print(score2, win_x - font_size, score_y)

	end
	
	function love.mousepressed (x, y, button)
		menu() -- go back to the menu on click
	end
		
end
-- End of function winner --


-- Beginning of function instructions --
-- This function displays the rules of the game
instructions = function()

		function love.draw()
			love.graphics.setColor(unpack(instructions_color))
			love.graphics.print(instructions_txt, win_x/20, win_y/20)
		end	
		
		function love.update (dt)
			check_for_exit () -- go back to menu with escape
		end
		
		function love.mousepressed (x, y, button)
			options() -- go back to the options on click
		end

end
-- End of function instructions --