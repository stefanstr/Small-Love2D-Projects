-- Load screen for the Light bringer game --
function love.draw()
love.graphics.print (settings.splash[settings.locale])
end

function love.keypressed( key, isrepeat )
	if key then
		main_menu()
	end
end

