require("objects")
require("modes")

-- KEYMAP
rot_l = "j"
rot_r = "k"
inc_x = "d"
dec_x = "a"
inc_y = "w"
dec_y = "s"
key_see = "1"
key_move = "2"
key_attack = "3"

function love.load()
	win_w = 800	
	win_h = 600
	love.window.setMode(win_w, win_h, {resizable=false, vsync=true, highdpi=true})

	big_font = love.graphics.newFont("yf16font.ttf", 55)
	medium_font = love.graphics.newFont("yf16font.ttf", 15)
	small_font = love.graphics.newFont(15)
	small_font:setFilter( "nearest", "nearest" )
	medium_font:setFilter( "nearest", "nearest" )
	big_font:setFilter( "nearest", "nearest" )

	game_running = false
	hs_holder = "A. Nonymous"
	highscore = 0
	
	-- Note: mode1 in table is matched with string created in onKeyPressed/initial mode
	modes = {mode1 = mode_see, mode2 = mode_move, mode3 = mode_attack}
	rotation_speed = math.pi * 2  -- half a lap per second

	mode = "mode"..key_see -- initial mode

end

function love.keypressed(key)
	if game_running then
		if key == "escape" then
			close_game()
		end
		-- Modes
		if key == key_see or key == key_move or key == key_attack then
			mode = "mode"..key
		end

		-- Movement
		if key == rot_r then
			player.rotation_dir = player.rotation_dir + 1
		elseif key == rot_l then
			player.rotation_dir = player.rotation_dir - 1
		elseif key == inc_x then
			player.x_dir = player.x_dir + 1
		elseif key == dec_x then
			player.x_dir = player.x_dir - 1
		elseif key == dec_y then
			player.y_dir = player.y_dir + 1
		elseif key == inc_y then
			player.y_dir = player.y_dir - 1
		end

		if key == "space" then
			modes[mode].func_shoot()
		end

	else
		if key == "escape" then
			love.event.quit()
		elseif key == "space" or key == "return" then
			init_game()
		end
	end
end

function love.keyreleased(key)
	if game_running then
		if key == rot_r then
			player.rotation_dir = player.rotation_dir - 1
		elseif key == rot_l then
			player.rotation_dir = player.rotation_dir + 1
		elseif key == inc_x then
			player.x_dir = player.x_dir - 1
		elseif key == dec_x then
			player.x_dir = player.x_dir + 1
		elseif key == dec_y then
			player.y_dir = player.y_dir - 1
		elseif key == inc_y then
			player.y_dir = player.y_dir + 1
		end
	end
end

function love.update(dt)
	if game_running then
		modes[mode].func_update(dt)
	end
end

function love.draw()
	if game_running then
		modes[mode].func_draw()
		game_time = math.ceil(love.timer.getTime() - game_start_time)
	love.graphics.setFont(medium_font)
		love.graphics.print(game_time, 
							win_w - medium_font:getWidth(game_time) - 10, 5)
	love.graphics.setFont(small_font)
	else
		show_startscreen()
	end
end

function init_game()
	game_running = true
	init_objects()
	game_start_time = love.timer.getTime()
end

function close_game()
	game_running = false
	highscore = math.max(highscore, game_time) 
end

function show_startscreen()
	-- Setup
	local title = "Shape Shifter"
	local start_text = "Press <space> to start game!"
	local hs_text = "Current highscore is "..highscore.." seconds by "..hs_holder
	local w_title = big_font:getWidth(title)
	local w_text = medium_font:getWidth(start_text)
	local w_hs = medium_font:getWidth(hs_text)
	local w = 60
	local h = 40
	local x = (win_w - w) / 2
	local y = 1.7*win_h / 4
	local dist = 90	

	-- Print 
	love.graphics.setFont(big_font)
	love.graphics.print(title, (win_w - w_title) / 2, 0.7*win_h / 4)

	love.graphics.setFont(medium_font)
	love.graphics.print(hs_text, (win_w - w_hs) / 2, y + 2*h)
	
	love.graphics.rectangle("line", x - dist, y, w, h, w/2, h/2) 
	love.graphics.rectangle("line", x, y, w, h, 0, 0) 
	love.graphics.polygon("line", {x + dist, y, 
									x + dist, y + h, 
									x + w + dist, y + h/2}) 

	love.graphics.print(start_text, (win_w - w_text) / 2, 3.2*win_h / 4)
end
