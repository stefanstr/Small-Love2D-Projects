function calculate_game_dimensions()
	local system_width, system_height = love.window.getDesktopDimensions()
	local window_dimension = (system_width < system_height) and system_width or system_height
	window_dimension = math.floor(0.8 * window_dimension)
	local map_size = math.floor(window_dimension/settings.tile_size)
	window_dimension = window_dimension - (window_dimension % settings.tile_size)
	if not love.window.setMode(window_dimension, window_dimension) then
		error ("Cannot set window dimensions!")
	end
	return window_dimension, map_size
end

function draw_the_title()
	-- draw the title --
	love.graphics.setColor(unpack(settings.colors.menu_title))
	love.graphics.setNewFont(settings.font, settings.title_font_size)
	love.graphics.printf(settings.title[settings.locale], 0, window_dimension/6, window_dimension, "center")
end

function draw_the_menus(menus, selection)
	-- draw the menus --
	love.graphics.setNewFont(settings.font, settings.font_size)
	local start_y = window_dimension / 2
	for k,v  in pairs (menus) do
		if v.position == selection then
			love.graphics.setColor(unpack(settings.colors.menu_highlight))
		else
			love.graphics.setColor(unpack(settings.colors.menu_normal))
		end
		love.graphics.printf(v[settings.locale], 0, start_y + v.position * (settings.font_size * 1.5), window_dimension , "center")
	end
end


-- ----------------------------------------------------------
-- serializer
-- See "Programming In Lua" chapter 12.1.2.
-- Also see forum thread:
--   http://www.gammon.com.au/forum/bbshowpost.php?bbsubject_id=4960
-- ----------------------------------------------------------
function basicSerialize (o)
  if type(o) == "number" or type(o) == "boolean" then
    return tostring(o)
  else   -- assume it is a string
    return string.format("%q", o)
  end
end -- basicSerialize 

--
-- Lua keywords might look OK to not be quoted as keys but must be.
-- So, we make a list of them.
--

lua_reserved_words = {}

for _, v in pairs{
    "and", "break", "do", "else", "elseif", "end", "false", 
    "for", "function", "if", "in", "local", "nil", "not", "or", 
    "repeat", "return", "then", "true", "until", "while"
            } do lua_reserved_words [v] = true end

-- ----------------------------------------------------------
-- save one variable (calls itself recursively)
-- ----------------------------------------------------------
function save (name, value, out, indent, saved)
  saved = saved or {}       -- initial value
  indent = indent or 0      -- start indenting at zero cols
  local iname = string.rep (" ", indent) .. name -- indented name
  if type(value) == "number" or 
     type(value) == "string" or
     type(value) == "boolean" then
    table.insert (out, iname .. " = " .. basicSerialize(value))
  elseif type(value) == "table" then
    if saved[value] then    -- value already saved?
      table.insert (out, iname .. " = " .. saved[value])  -- use its previous name
    else
      saved[value] = name   -- save name for next time
      table.insert (out, iname .. " = {}")   -- create a new table
      for k,v in pairs(value) do      -- save its fields
        local fieldname 
        if type (k) == "string"
           and string.find (k, "^[_%a][_%a%d]*$") 
           and not lua_reserved_words [k] then
          fieldname = string.format("%s.%s", name, k)
        else
          fieldname  = string.format("%s[%s]", name,
                                        basicSerialize(k))  
        end
        save(fieldname, v, out, indent + 2, saved)
      end
    end
  else
    error("cannot save a " .. type(value))
  end
end  -- save 

-- ----------------------------------------------------------
-- Serialize a variable or nested set of tables:
-- ----------------------------------------------------------

--[[

  Example of use:

  SetVariable ("mobs", serialize ("mobs"))  --> serialize mobs table
  loadstring (GetVariable ("mobs")) ()  --> restore mobs table 

--]]

function serialize (what, v)
  v = v or _G [what]  -- default to "what" in global namespace

  assert (type (what) == "string", 
          "Argument to serialize should be the *name* of a variable")
  assert (v, "Variable '" .. what .. "' does not exist")

  local out = {}  -- output to this table
  save (what, v, out)   -- do serialization
  return table.concat (out, "\r\n")  -- turn into a string
end -- serialize