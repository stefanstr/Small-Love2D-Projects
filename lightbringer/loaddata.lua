-- deals with loading settings
local default_settings = {}
default_settings.locale = "EN"
default_settings.font = "resources/nymphont_aver/Aver.ttf"

default_settings.splash = {
	["EN"] =  [[
This is going to be the starting screen for the game
LIGHTBRINGER - a tale of hope and despair

Press any key to continue
]],
	["PL"] = [[
To będzie startowy ekran do gry
LIGTBRINGER - opowieść o nadziei i rozpaczy

Naciśnij dowolny klawisz, żeby kontynuować]]
}

default_settings.title = {
	["EN"] =  "LIGHTBRINGER - a tale of hope and despair",
	["PL"] = "LIGTBRINGER - opowieść o nadziei i rozpaczy"
	}

default_settings.menus ={}
default_settings.menus_len = 7

default_settings.menus.newgame = {}
default_settings.menus.resume = {}
default_settings.menus.settings = {}
default_settings.menus.instructions = {}
default_settings.menus.highscores = {}
default_settings.menus.credits = {}
default_settings.menus.exit = {}

default_settings.menus.newgame.position = 1
default_settings.menus.resume.position = 2
default_settings.menus.settings.position = 3
default_settings.menus.instructions.position = 4
default_settings.menus.highscores.position = 5
default_settings.menus.credits.position = 6
default_settings.menus.exit.position = 7


default_settings.menus.newgame.EN = "Start a new game"
default_settings.menus.resume.EN = "Resume"
default_settings.menus.settings.EN = "Game settings"
default_settings.menus.instructions.EN = "How to play"
default_settings.menus.highscores.EN = "Highscores"
default_settings.menus.credits.EN = "Game credits"
default_settings.menus.exit.EN = "Quit to the OS"

default_settings.menus.newgame.PL = "Rozpocznij nową grę"
default_settings.menus.resume.PL = "Wróć do gry"
default_settings.menus.settings.PL = "Ustawienia"
default_settings.menus.instructions.PL = "Instrukcje"
default_settings.menus.highscores.PL = "Najlepsze wyniki"
default_settings.menus.credits.PL = "O grze"
default_settings.menus.exit.PL = "Wyjdź do systemu"

default_settings.settings_menus ={}
default_settings.settings_menus_len = 3

default_settings.settings_menus.language = {}
default_settings.settings_menus.save = {}
default_settings.settings_menus.exit = {}

default_settings.settings_menus.language.position = 1
default_settings.settings_menus.save.position = 2
default_settings.settings_menus.exit.position = 3

default_settings.settings_menus.language.EN = "Choose language: English or Polish"
default_settings.settings_menus.save.EN = "Save settings and back to the menu"
default_settings.settings_menus.exit.EN = "Back to the menu"

default_settings.settings_menus.language.PL = "Wybierz język: angielski lub polski"
default_settings.settings_menus.save.PL = "Zapisz ustawienia i wróć do menu"
default_settings.settings_menus.exit.PL = "Wróć do menu"

default_settings.colors = {}
default_settings.colors.background = {255, 178, 102}
default_settings.colors.menu_highlight = {50, 50, 250}
default_settings.colors.menu_normal = {255, 255, 255}
default_settings.colors.menu_title = {255, 255, 255, 125}
default_settings.colors.tile_empty = {255, 255, 255}
default_settings.colors.tile_wall = {0, 0, 0}
default_settings.colors.lightsource = {255, 255, 0}

default_settings.font_size = 20
default_settings.title_font_size = 40
default_settings.break_even = 0.65 -- needed for map generation
default_settings.tile_size = 32
default_settings.map_size = 100
default_settings.max_lightsource_strength = 10

local mt = {}
mt.__index = default_settings

settingsfilename = "game_settings.lua"
if love.filesystem.exists (settingsfilename) then
	print ("Loading settings")
	settingsfile = love.filesystem.load (settingsfilename)
	settingsfile()
	--read settings
else
	--create default settings
	 settings = {}
	 print ("No settings - falling back on the defaults")
end
setmetatable(settings, mt)

