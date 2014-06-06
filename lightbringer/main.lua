-----------------------------------------------
-- LIGHTBRINGER - a tale of hope and despair --
-- by gestaltist aka Stefan Stryjecki        --
-- v. pre-alpha                              --
-----------------------------------------------

--[[ game outline
1) start screen
2) choose your [language] PL/EN
3) main menu
	a. play -> 9
	b. options -> 8
	c. instructions -> 7
	d. credits -> 6
	e. highscores -> 5
	f. exit -> 4
4) exit
	- game quits 
		- save highscores
		- somewhere down the line maybe save progress?
5) highscores
	- for every [gamemode]
	- sorted according to the gamemode (by time for survival, by points for adventure
6) credits
	- nothing special, my name, yada yada
7) instructions
	- how to play: move with [arrows]
	- the stronger your light, the farther you see
	- if you lose all light, you die
	- in survival, you just have to stay alive (maybe gamemodes could be
		created as objects with a description that would be polled here)
	- in adventure you have to go through as many levels as you can
	- have fun
8) options
	- change the language
	(-set difficulty level)
	(-some graphical stuff??)
9) **play**
-----------
I. [generate the map] (via noise or maze generation - maybe also to be chosen
from the options or a part of gamemodes? - a different maze should probably have
separate highscores)
II. [initialize map] with enemies and lightsources
III. place [player] and [exit] (in adventure mode)
IV. play
	0. draw area - [lighting], [field view]
	1. if player presses arrow, move (if there is no obstacle)
	2. if player enters on light source, add to his [light radius]
	3. if player touches enemy, remove from his light radius
	4. if light radius == 0, display [end screen], update highscores
	5. if player reaches [exit] - display [level screen], generate a new one
	6. in survival [periodically] add new light sources and enemies with
		increasing difficulty
	7. if player hits escape or otherwise [quits], display a screen to [confirm]
		that he wants to exit and that he will lose his progress
	
	
[gamemode]
	__survival__ (stay on the same level for as long as you can; if your [light]
extinguishes, you die. [enemies] steal your light if they touch you. 
[light sources] can replenish your light. The amount of [light sources] gets
lower with [time], whereas the amount of [enemies] - higher. (Maybe survival
should have [safe zones] like shelter where the player doesn't lose energy.
The difficulty rises all the same so safe zones shouldn't be abused.)
	__adventure__ you have to find the exit from the [level] - you are then 
	placed in a tougher level - to be determined - does it go on indefinitely,
	or is there a "[final boss]"? (The rest of the rule as in survival) - In any
	case you get [points] for every light source taken and for every level. You
	loose points for being hit by enemy.
	- other game modes to come?: __restorer__ - you can light other light sources
	and have to bring light to the whole level
	
	
[other concepts / optional]
	- shooting at enemies at the expense of your own light
]]--

require("loaddata") -- responsible for loading settings
require("functions") -- loads general-purpose functions
require("display_settings") -- the function to display the game settings
require("main_menu") -- the function to display the game menu
require("game_objects") -- classes of game object
require("map_tools") -- tools to generate the map
require("game") -- plays a new game

function love.load ()
	love.keyboard.setKeyRepeat( true )
	-- makes the window square
	window_dimension, tiles_in_window = calculate_game_dimensions()
	print("Setting window dimensions to ", window_dimension)
	print("Setting map size to ", tiles_in_window)
	love.graphics.setNewFont(settings.font, settings.font_size)
	love.graphics.setBackgroundColor(unpack(settings.colors.background))
	dofile("splashscreen.lua")
end

