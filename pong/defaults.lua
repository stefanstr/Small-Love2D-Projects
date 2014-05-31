winning_score = 5
background_color = {205, 225, 255} -- light blue
pads_color = {255, 255, 255}
ball_color = {255, 255, 255}
score_color = {15, 100, 200}
title_color = {255, 255, 255}
menu_normal = {100, 100, 100}
menu_highlight = {200, 0, 100}
winning_color = {255, 255, 255}
instructions_color = {0, 155, 100}

score_x, score_y = 10, 20 -- offset of the score displayed

-- You can change the text of the options but not their number.
-- The program will not know what to do with additional options.
menu_options = {"Play - 2 people", "Play with the computer", "Options", "Quit"}
title_text = "PONG"

font_size = 40 -- Program uses this value and its multiples for fonts.
pad_x, pad_y = 20, 100 -- size of pads
wall_width = 5 -- How wide should the side walls be?
pad_distance = 40 -- how far from the window border should the pads be
ball_r = 20	-- radius of the ball
ball_bounciness = 1 -- Don't change this unless you know what you are doing!
vel_unit = 270 -- pad speed
ball_speed = 600
initial_ball_state = "left" -- possible states are left, right, 
						-- (waiting to be served) and moving
-- AI data
whatAI = "simple"
AI = "right"
pos_tolerance = 15 -- makes movement smoother and is necessary for serving to work

config_options = {"Instructions", "Position of computer player: ", "Back to menu"}

instructions_txt = [[
Welcome to the perennial classic - the game of pong.

The rules are simple - you need to get the ball past 
your oponent to get a point. Whoever gets five points
first, wins.

Controls for the player on the left:
W - move up
S - move down
D - serve

Controls for the player on the right:
Arrow Up - move up
Arrow Down - move down
Arrow Left - serve

Escape - go back

Enjoy!
]]


