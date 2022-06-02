pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
-- the last antbender 
-- by peanutsfly
-- jam version

-- due to the time pressure of the game jam,
-- code redundancies are high, especially in the entities.
-- individual problems were also solved by copying
-- the same code into other lists, which created even more redundancies
-- but with that i was able to solve the problems faster.
-- i will not improve this in this project as i am already
-- aiming for the next projects.
-- i will take positive things in the project with me in the next ones and
-- i hope this source code will help everyone who is interested.

t = 0
debug = false
game_state = 1

function _init()
	music(18,2400)
	l_mngr:load(1)
end

function _update60()
	t += 1
	debug_toggle()
	if game_state == 2 then
		i_mngr:upd()
		l_mngr:upd()
	elseif game_state == 1 then
		i_mngr:upd()
		if i.a then
			game_state = 2
		end
	end
end

function _draw()
	cls()
	if game_state == 2 then
		l_mngr:drw()
	elseif game_state == 1 then
		map(112,0)
		print("press z/c",24,76+flr(t/30)%2,13)
		print("to start",24,84+flr(t/30)%2,13)
		print("game by peanutsfly",24,96,1)
		print("music by @grubermusic",24,104,1)
	end
end
-->8
-- managers

-- levels
l = {
	{
		m_tile = {0,0},
		p_tile = {3,10},
		w_tiles = {
			{11,10}
		},
		w_tiles_special = {},
		j_tiles = {},
		btn_tiles = {
			{1,10}
		},
		btn_tiles_special = {},
		door_tile = {13,10}
	},{
		m_tile = {32,0},
		p_tile = {35,10},
		w_tiles = {
			{44,10}
		},
		w_tiles_special = {},
		j_tiles = {},
		btn_tiles = {
			{33,10},
			{46,10}
		},
		btn_tiles_special = {},
		door_tile = {45,10}
	},{
		m_tile = {16,0},
		p_tile = {19,10},
		w_tiles = {},
		w_tiles_special = {},
		j_tiles = {
			{27,10}
		},
		btn_tiles = {
			{17,7}
		},
		btn_tiles_special = {},
		door_tile = {29,10}
	},{
		m_tile = {48,0},
		p_tile = {51,10},
		w_tiles = {},
		w_tiles_special = {},
		j_tiles = {
			{59,11}
		},
		btn_tiles = {
			{49,8},
			{62,6},
		},
		btn_tiles_special = {},
		door_tile = {61,11}
	},{
		m_tile = {64,0},
		p_tile = {67,10},
		w_tiles = {
			{76,6}
		},
		w_tiles_special = {
			{66,6}
		},
		j_tiles = {},
		btn_tiles = {
			{78,6},
		},
		btn_tiles_special = {
			{65,6},
		},
		door_tile = {77,10}
	},{
		m_tile = {80,0},
		p_tile = {83,9},
		w_tiles = {},
		w_tiles_special = {
			{83,12}
		},
		j_tiles = {
			{93,9}
		},
		btn_tiles = {
			{93,6},
		},
		btn_tiles_special = {
			{82,12},
		},
		door_tile = {93,9}
	},{
		m_tile = {96,0},
		p_tile = {99,9},
		w_tiles = {
			{105,10}
		},
		w_tiles_special = {},
		j_tiles = {},
		btn_tiles = {},
		btn_tiles_special = {},
		door_tile = {-1,-1}
	}
}

-- level manager
l_mngr = {
	current = nil,
	door_open = false
}

-- load level
function l_mngr:load(level)
	w.list = {}
	w.list_special = {}
	j.list = {}
	b.list = {}
	b.list_special = {}
	effects:reset()
	self.current = min(level,#l)
	local tile = l[self.current].p_tile
	p:init(tile[1]*8,tile[2]*8)
	for t in all(l[self.current].w_tiles) do
		w:spawn_walker(t[1]*8,t[2]*8,false)
	end
	for t in all(l[self.current].w_tiles_special) do
		w:spawn_walker(t[1]*8,t[2]*8,true)
	end
	for t in all(l[self.current].j_tiles) do
		j:spawn_jumper(t[1]*8,t[2]*8)
	end
	for t in all(l[self.current].btn_tiles) do
		b:create_btn(t[1]*8,t[2]*8,false)
	end
	for t in all(l[self.current].btn_tiles_special) do
		b:create_btn(t[1]*8,t[2]*8,true)
	end
	door_tile = l[self.current].door_tile
	door:set(door_tile[1],door_tile[2])
end

-- update level
function l_mngr:upd()
	p:upd()
	w:upd()
	j:upd()
	self:update_level_status()
	door:upd()
	effects:update()
end

-- draw level
function l_mngr:drw()
	local tile = l[self.current].m_tile
	map(0,0)
	camera(tile[1]*8,tile[2]*8)
	print("press x/v",46,47,2)
	print("to make the ant move",24,55,2)
	print("let everything shine",280,51,2)
	print("press z/c",190,47,2)
	print("to make the ant jump",158,55,2)
	print("well done! keep it up",406,40,2)
	print("thanks for playing!",796,51,2)
	print("die to restart",804,59,2)
	b:draw()
	p:draw()
	w:draw()
	j:draw()
	effects:draw()
end

function l_mngr:update_level_status()
	local finished = true
	for button in all(b.list) do
		if not button.pressed then
			finished = false
		end
	end
	for button in all(b.list_special) do
		if not button.pressed then
			finished = false
		end
	end
	self.door_open = finished
end

-- input
i = {
	x = 0,
	y = 0,
	a = false,
	b = false
}

-- input_manager
i_mngr = {}

-- update inputs
function i_mngr:upd()
	i.x = -int(btn(0))+int(btn(1))
	i.y = -int(btn(2))+int(btn(3))
	i.a = btn(4)
	i.b = btn(5)
end
-->8
-- objects

-- rectangle
rectangle = {}

function rectangle:new(x,y,w,h)
	local r = {
		x = x,
		y = y,
		w = w,
		h = h
	}
	setmetatable(r,self)
	self.__index = self

	return r
end

function rectangle:is_colliding(s)
	local x1,y1,w1,h1 = self.x,self.y,self.w,self.h
	local x2,y2,w2,h2 = s.x,s.y,s.w,s.h
	return x1<x2+w2 and x2<x1+w1 and y1<y2+h2 and y2<y1+h1
end

function rectangle:draw(c)
	if debug then
		rect2(self.x,self.y,self.w,self.h,c)
	end
end

-- timer
timer = {}
timer.started = false

function timer:new(t)
	local o = {}
	setmetatable(o,self)
	self.__index = self

	o.t = t

	return o
end

function timer:run()
	self.started = true
	self.counter = self.t
end

function timer:update()
	if self.started then
		self.counter -= 1
	end
end

function timer:is_finished()
	if self.counter <= 0 then
		self.started = false
		return true
	else
		return false
	end
end

-->8
-- entities

player = {
	state = 1,
	pos = {
		x = 0,
		y = 0
	},
	shape = nil,
	acc = 0.12,
	fri = 0.95,
	speed = 2,
	jump_pw = 1.8,
	jump_lock = false,
	bend_lock = false,
	landed = false,
	motion = {
		x=0,
		y=0
	},
	flp = false,
	sprite = 128,
	offset = {
		back = 3,
		front = 2,
		up = 1,
		down = 0
	},
	w = 3,
	h = 7,
	dead = false
}

-- player controller --

p = {}

function p:init(x,y)
	player.dead_counter = 90
	player.dead = false
	player.pos.x = x
	player.pos.y = y
	player.motion = {
		x=0,
		y=0
	}
	player.shape = rectangle:new(x+player.offset.back,y+player.offset.up,player.w,player.h)
end

function p:upd()
	if not player.dead then
		self:calc_motion()
		self:check_collision()
		self:check_door()
		self:move()
		self:bend()
		self:key_lock()
		self:update_flip()
		self:update_rectangle()
		self:update_state()
		self:animate()
	else
		player.dead_counter -= 1
		if player.dead_counter <= 0 then
			if l_mngr.current != #l then
				l_mngr:load(l_mngr.current)
			else
				l_mngr:load(1)
			end
		end
	end
end

function p:draw()
	if not player.dead then
		spr(player.sprite,player.pos.x,player.pos.y,1,1,player.flp)
		player.shape:draw(8)
	end
end

-- calculates motion
function p:calc_motion()
	local x_motion = player.motion.x+player.acc*i.x
	local y_motion = player.motion.y
	if x_motion < -0.08 then
		x_motion = max(-player.speed,x_motion)
	elseif x_motion > 0.08 then
		x_motion = min(player.speed,x_motion)
	else
		x_motion = 0
	end
	if i.y == -1 and player.landed and not player.jump_lock then
		player.motion.y = -player.jump_pw
		player.landed = false
		sfx(0)
	end
	y_motion = player.motion.y+gravity
	y_motion = min(player.speed,y_motion)
	player.motion.x = x_motion*player.fri
	player.motion.y = y_motion
end

-- locks key
function p:key_lock()
	player.jump_lock = i.y == -1
	player.bend_lock = i.a or i.b
end

-- checks for platforms
function p:check_collision()
	local shape = player.shape
	if player.motion.x < 0 then
		local x,y = shape.x-2,shape.y
		local tile = {flr(x/8),flr(y/8)}
		if fget(mget(tile[1],tile[2]),0) then
			player.motion.x = 0
			player.pos.x = (tile[1]+1)*8-player.offset.front
		end
	elseif player.motion.x > 0 then
		local x,y = shape.x+shape.w+1,shape.y
		local tile = {flr(x/8),flr(y/8)}
		if fget(mget(tile[1],tile[2]),0) then
			player.motion.x = 0
			player.pos.x = (tile[1]-1)*8+player.offset.front
		end
	end
	if player.motion.y < 0 then
		local x,y = shape.x,shape.y-2
		local tile = {flr(x/8),flr(y/8)}
		if fget(mget(tile[1],tile[2]),0) then
			player.motion.y = 0
			player.pos.y = (tile[2]+1)*8-player.offset.up
		end
	elseif player.motion.y > 0 then
		local x,y = shape.x,shape.y+shape.h+1
		local tile = {flr(x/8),flr(y/8)}
		if fget(mget(tile[1],tile[2]),0) then
			player.motion.y = 0
			player.pos.y = (tile[2]-1)*8+player.offset.down
			player.landed = true
		end
	end
end

function p:check_door()
	if l_mngr.door_open then
		if player.shape:is_colliding(door.shape) then
			l_mngr:load(l_mngr.current+1)
		end
	end
end

-- moving player
function p:move()
	player.pos.x+=player.motion.x
	player.pos.y+=player.motion.y
end

-- switch ants walking param
function p:bend()
	if i.a and not player.bend_lock then
		for o in all(j.list) do
			o.jump = true
		end
	end
	if i.b and not player.bend_lock then
		for o in all(w.list) do
			o.walk = not o.walk
		end
		for o in all(w.list_special) do
			o.walk = not o.walk
		end
		for o in all(j.list) do
			o.walk = not o.walk
		end
	end
end

-- update sprite flip
function p:update_flip()
	if player.motion.x != 0 then
		player.flp = player.motion.x < 0
	end
end

-- updates rectangle position
function p:update_rectangle()
	player.shape.y = player.pos.y+player.offset.up
	if player.flp then
		player.shape.x = player.pos.x+player.offset.front
	else
		player.shape.x = player.pos.x+player.offset.back
	end
end

-- update player state
function p:update_state()
	if player.motion.y == 0 and player.landed then
		-- idle
		if player.motion.x == 0 then
			player.state = 1
		-- walking
		else
			player.state = 2
		end
	else
		-- jump
		if player.motion.y < 0 then
			player.state = 3
		-- fall
		else
			player.state = 4
		end
	end
end

-- animating player
function p:animate()
	local state = player.state
	if state == 1 then
		player.sprite = 128+flr(t/16)%2
	elseif state == 2 then
		player.sprite = 130+flr(t/6)%8
	elseif state == 3 then
		player.sprite = 131
	elseif state == 4 then
		player.sprite = 132
	else
		player.sprite = 129
	end
end

function p:die()
	player.dead = true
	explode(player.shape.x, player.shape.y,90)
	sfx(2)
end

-- walker controller --

walker = {
	acc = 0.12,
	fri = 0.96,
	speed = 2,
	offset = {
		back = 3,
		front = 3,
		up = 3,
		down = 0
	},
	w = 11,
	h = 5
}

w = {}
w.list = {}
w.list_special = {}

function w:spawn_walker(x,y,special)
	local o = {}

	o.state = 1
	o.pos = {
		x = x,
		y = y
	}
	o.shape = rectangle:new(x+walker.offset.front,y+walker.offset.up,walker.w,walker.h)
	o.motion = {
		x = 0,
		y = 0
	}
	o.sprite = {144,145}

	if special then
		o.flp = true
		o.dir = 1
		o.walk = true
		add(self.list_special,o)
	else
		o.flp = false
		o.dir = -1
		o.walk = false
		add(self.list,o)
	end
end

function w:upd()
	self:calc_motion()
	self:check_collisions()
	self:attack_player()
	self:press_btn()
	self:move()
	self:update_flip()
	self:update_rectangles()
	self:update_states()
	self:animate()
end

function w:draw()
	for o in all(self.list) do
		local pos = o.pos
		local sprite = {}
		if o.flp then
			sprite[1] = o.sprite[2]
			sprite[2] = o.sprite[1]
		else
			sprite[1] = o.sprite[1]
			sprite[2] = o.sprite[2]
		end
		spr(sprite[1],pos.x,pos.y,1,1,o.flp)
		spr(sprite[2],pos.x+8,pos.y,1,1,o.flp)
		o.shape:draw(8)
	end
	for o in all(self.list_special) do
		pal(1,2)
		local pos = o.pos
		local sprite = {}
		if o.flp then
			sprite[1] = o.sprite[2]
			sprite[2] = o.sprite[1]
		else
			sprite[1] = o.sprite[1]
			sprite[2] = o.sprite[2]
		end
		spr(sprite[1],pos.x,pos.y,1,1,o.flp)
		spr(sprite[2],pos.x+8,pos.y,1,1,o.flp)
		pal()
		o.shape:draw(8)
	end
end

function w:calc_motion()
	for o in all(self.list) do
		if o.walk then
			local x_motion = o.motion.x+walker.acc*o.dir
			if x_motion < -0.08 then
				x_motion = max(-walker.speed,x_motion)
			elseif x_motion > 0.08 then
				x_motion = min(walker.speed,x_motion)
			else
				x_motion = 0
			end
			o.motion.x = x_motion*walker.fri
		else
			if o.motion.x > -0.08 and o.motion.x < 0.08 then
				o.motion.x = 0
			else
				o.motion.x *= walker.fri
			end
		end
		y_motion = o.motion.y+gravity
		y_motion = min(walker.speed,y_motion)
		o.motion.y = y_motion
	end
	for o in all(self.list_special) do
		if o.walk then
			local x_motion = o.motion.x+walker.acc*o.dir
			if x_motion < -0.08 then
				x_motion = max(-walker.speed,x_motion)
			elseif x_motion > 0.08 then
				x_motion = min(walker.speed,x_motion)
			else
				x_motion = 0
			end
			o.motion.x = x_motion*walker.fri
		else
			if o.motion.x > -0.08 and o.motion.x < 0.08 then
				o.motion.x = 0
			else
				o.motion.x *= walker.fri
			end
		end
		y_motion = o.motion.y+gravity
		y_motion = min(walker.speed,y_motion)
		o.motion.y = y_motion
	end
end

-- checks for platforms
function w:check_collisions()
	for o in all(self.list) do
		local shape = o.shape
		if o.motion.x < 0 then
			local x,y = shape.x-2,shape.y
			local tile = {flr(x/8),flr(y/8)}
			if fget(mget(tile[1],tile[2]),0) then
				o.motion.x = 0
				o.pos.x = (tile[1]+1)*8-walker.offset.front
				o.dir = 1
			end
		elseif o.motion.x > 0 then
			local x,y = shape.x+shape.w+1,shape.y
			local tile = {flr(x/8),flr(y/8)}
			if fget(mget(tile[1],tile[2]),0) then
				o.motion.x = 0
				o.pos.x = (tile[1]-1)*8+walker.offset.front-8
				o.dir = -1
			end
		end
		if o.motion.y > 0 then
			local x,y = shape.x,shape.y+shape.h+1
			local tile = {flr(x/8),flr(y/8)}
			if fget(mget(tile[1],tile[2]),0) then
				o.motion.y = 0
				o.pos.y = (tile[2]-1)*8+walker.offset.down
			end
		end
	end
	for o in all(self.list_special) do
		local shape = o.shape
		if o.motion.x < 0 then
			local x,y = shape.x-2,shape.y
			local tile = {flr(x/8),flr(y/8)}
			if fget(mget(tile[1],tile[2]),0) then
				o.motion.x = 0
				o.pos.x = (tile[1]+1)*8-walker.offset.front
				o.dir = 1
			end
		elseif o.motion.x > 0 then
			local x,y = shape.x+shape.w+1,shape.y
			local tile = {flr(x/8),flr(y/8)}
			if fget(mget(tile[1],tile[2]),0) then
				o.motion.x = 0
				o.pos.x = (tile[1]-1)*8+walker.offset.front-8
				o.dir = -1
			end
		end
		if o.motion.y > 0 then
			local x,y = shape.x,shape.y+shape.h+1
			local tile = {flr(x/8),flr(y/8)}
			if fget(mget(tile[1],tile[2]),0) then
				o.motion.y = 0
				o.pos.y = (tile[2]-1)*8+walker.offset.down
			end
		end
	end
end

function w:attack_player()
	for o in all(self.list) do
		if o.shape:is_colliding(player.shape) and not player.dead then
			p:die()
		end
	end
	for o in all(self.list_special) do
		if o.shape:is_colliding(player.shape) and not player.dead then
			p:die()
		end
	end
end

function w:press_btn()
	for o in all(self.list) do
		for button in all(b.list) do
			if o.shape:is_colliding(button.shape) then
				if not button.lock then
					button:press()
					button.lock = true
					sfx(3)
				end
			else
				button.lock = false
			end
		end
	end
	for o in all(self.list_special) do
		for button in all(b.list_special) do
			if o.shape:is_colliding(button.shape) then
				if not button.lock then
					button:press()
					button.lock = true
					sfx(3)
				end
			else
				button.lock = false
			end
		end
	end
end

function w:move()
	for o in all(self.list) do
		o.pos.x+=o.motion.x
		o.pos.y+=o.motion.y
	end
	for o in all(self.list_special) do
		o.pos.x+=o.motion.x
		o.pos.y+=o.motion.y
	end
end

function w:update_flip()
	for o in all(self.list) do
		if o.motion.x != 0 then
			o.flp = o.motion.x > 0
		end
	end
	for o in all(self.list_special) do
		if o.motion.x != 0 then
			o.flp = o.motion.x > 0
		end
	end
end

function w:update_rectangles()
	for o in all(self.list) do
		o.shape.y = o.pos.y+walker.offset.up
		if o.flp then
			o.shape.x = o.pos.x+walker.offset.front
		else
			o.shape.x = o.pos.x+walker.offset.back
		end
	end
	for o in all(self.list_special) do
		o.shape.y = o.pos.y+walker.offset.up
		if o.flp then
			o.shape.x = o.pos.x+walker.offset.front
		else
			o.shape.x = o.pos.x+walker.offset.back
		end
	end
end

function w:update_states()
	for o in all(self.list) do
		-- idle
		if o.motion.x == 0 then
			o.state = 1
		-- walking
		else
			o.state = 2
		end
	end
	for o in all(self.list_special) do
		-- idle
		if o.motion.x == 0 then
			o.state = 1
		-- walking
		else
			o.state = 2
		end
	end
end

function w:animate()
	for o in all (self.list) do
		local state = o.state
		if state == 1 then
			o.sprite[1] = 144+(flr(t/16)%2)*2
			o.sprite[2] = 145+(flr(t/16)%2)*2
		elseif state == 2 then
			o.sprite[1] = 148+(flr(t/6)%4)*2
			o.sprite[2] = 149+(flr(t/6)%4)*2
		end
	end
	for o in all (self.list_special) do
		local state = o.state
		if state == 1 then
			o.sprite[1] = 144+(flr(t/16)%2)*2
			o.sprite[2] = 145+(flr(t/16)%2)*2
		elseif state == 2 then
			o.sprite[1] = 148+(flr(t/6)%4)*2
			o.sprite[2] = 149+(flr(t/6)%4)*2
		end
	end
end

-- jumper controller --

jumper = {
	acc = 0.12,
	fri = 0.96,
	speed = 1.5,
	jump_pw = 2.3,
	offset = {
		back = 3,
		front = 3,
		up = 3,
		down = 0
	},
	w = 11,
	h = 5
}

j = {}
j.list = {}

function j:spawn_jumper(x,y)
	local o = {}

	o.state = 1
	o.pos = {
		x = x,
		y = y
	}
	o.shape = rectangle:new(x+jumper.offset.front,y+jumper.offset.up,jumper.w,jumper.h)
	o.motion = {
		x = 0,
		y = 0
	}
	o.sprite = {160,161}
	o.flp = false
	o.walk = false
	o.jump = false
	o.jump_lock = false
	o.dir = -1

	add(self.list,o)
end

function j:upd()
	self:calc_motion()
	self:check_collisions()
	self:attack_player()
	self:press_btn()
	self:move()
	self:update_flip()
	self:update_rectangles()
	self:update_states()
	self:animate()
end

function j:draw()
	for o in all(self.list) do
		local pos = o.pos
		local sprite = {}
		if o.flp then
			sprite[1] = o.sprite[2]
			sprite[2] = o.sprite[1]
		else
			sprite[1] = o.sprite[1]
			sprite[2] = o.sprite[2]
		end
		spr(sprite[1],pos.x,pos.y,1,1,o.flp)
		spr(sprite[2],pos.x+8,pos.y,1,1,o.flp)
		o.shape:draw(8)
	end
end

function j:calc_motion()
	for o in all(self.list) do
		if o.walk then
			local x_motion = o.motion.x+walker.acc*o.dir
			if x_motion < -0.08 then
				x_motion = max(-jumper.speed,x_motion)
			elseif x_motion > 0.08 then
				x_motion = min(jumper.speed,x_motion)
			else
				x_motion = 0
			end
			o.motion.x = x_motion*jumper.fri
		else
			if o.motion.x > -0.08 and o.motion.x < 0.08 then
				o.motion.x = 0
			else
				o.motion.x *= jumper.fri
			end
		end
		if o.jump and o.landed then
			o.jump = false
			o.landed = false
			o.motion.y = -jumper.jump_pw
			sfx(1)
		end
		y_motion = o.motion.y+gravity
		y_motion = min(jumper.speed,y_motion)
		o.motion.y = y_motion
	end
end

-- checks for platforms
function j:check_collisions()
	for o in all(self.list) do
		local shape = o.shape
		if o.motion.x < 0 then
			local x,y = shape.x-2,shape.y
			local tile = {flr(x/8),flr(y/8)}
			if fget(mget(tile[1],tile[2]),0) then
				o.motion.x = 0
				o.pos.x = (tile[1]+1)*8-walker.offset.front
				o.dir = 1
			end
		elseif o.motion.x > 0 then
			local x,y = shape.x+shape.w+1,shape.y
			local tile = {flr(x/8),flr(y/8)}
			if fget(mget(tile[1],tile[2]),0) then
				o.motion.x = 0
				o.pos.x = (tile[1]-1)*8+walker.offset.front-8
				o.dir = -1
			end
		end
		if o.motion.y < 0 then
			local x,y = shape.x,shape.y-2
			local tile = {flr(x/8),flr(y/8)}
			if fget(mget(tile[1],tile[2]),0) then
				o.motion.y = 0
				o.pos.y = (tile[2]+1)*8-jumper.offset.up
			end
		elseif o.motion.y > 0 then
			local x,y = shape.x,shape.y+shape.h+1
			local tile = {flr(x/8),flr(y/8)}
			if fget(mget(tile[1],tile[2]),0) then
				o.motion.y = 0
				o.pos.y = (tile[2]-1)*8+jumper.offset.down
				o.landed = true
			end
		end
	end
end

function j:attack_player()
	for o in all(self.list) do
		if o.shape:is_colliding(player.shape) and not player.dead then
			p:die()
		end
	end
end

function j:press_btn()
	for o in all(self.list) do
		for button in all(b.list) do
			if o.shape:is_colliding(button.shape) then
				if not button.lock then
					button:press()
					button.lock = true
					sfx(3)
				end
			else
				button.lock = false
			end
		end
	end
end

function j:move()
	for o in all(self.list) do
		o.pos.x+=o.motion.x
		o.pos.y+=o.motion.y
	end
end

function j:update_flip()
	for o in all(self.list) do
		if o.motion.x != 0 then
			o.flp = o.motion.x > 0
		end
	end
end

function j:update_rectangles()
	for o in all(self.list) do
		o.shape.y = o.pos.y+jumper.offset.up
		if o.flp then
			o.shape.x = o.pos.x+jumper.offset.front
		else
			o.shape.x = o.pos.x+jumper.offset.back
		end
	end
end

function j:update_states()
	for o in all(self.list) do
		if o.motion.y == 0 and o.landed then
			-- idle
			if o.motion.x == 0 then
				o.state = 1
			-- walking
			else
				o.state = 2
			end
		else
			-- jump
			if o.motion.y < 0 then
				o.state = 3
			-- fall
			else
				o.state = 4
			end
		end
	end
end

function j:animate()
	for o in all (self.list) do
		local state = o.state
		if state == 1 then
			o.sprite[1] = 160+(flr(t/16)%2)*2
			o.sprite[2] = 161+(flr(t/16)%2)*2
		elseif state == 2 then
			o.sprite[1] = 164+(flr(t/6)%4)*2
			o.sprite[2] = 165+(flr(t/6)%4)*2
		elseif state == 3 then
			o.sprite[1] = 166
			o.sprite[2]	= 167
		elseif state == 4 then
			o.sprite[1] = 168
			o.sprite[2] = 169
		end
	end
end

-- button controller --

button = {
	offset = {
		back = 2,
		front = 2,
		up = 4,
		down = 0
	},
	w = 4,
	h = 4
}

b = {}
b.list = {}
b.list_special = {}

function b:create_btn(x,y,special)
	local o = {}

	o.pos = {
		x = x,
		y = y
	}
	o.shape = rectangle:new(x+button.offset.back,y+button.offset.up,button.w,button.h)
	o.pressed = false
	o.press = function(self)
		self.pressed = not self.pressed
	end

	if special then
		add(self.list_special,o)
	else
		add(self.list,o)
	end
end

function b:draw()
	for o in all(self.list) do
		local sprite = 54
		if o.pressed then
			sprite = 56
		end
		spr(sprite,o.pos.x,o.pos.y)
		o.shape:draw(8)
	end
	for o in all(self.list_special) do
		local sprite = 55
		if o.pressed then
			sprite = 57
		end
		spr(sprite,o.pos.x,o.pos.y)
		o.shape:draw(8)
	end
end

-- door controller

door = {
	tile = {}
}

function door:set(tile_x,tile_y)
	self.tile = {tile_x,tile_y}
	self.shape = rectangle:new(tile_x*8,tile_y*8,8,8)
	mset(tile_x,tile_y,40)
	self.counter = timer:new(4)
end

function door:upd()
	self.counter:update()
	if l_mngr.door_open then
		self:open()
	else
		self:close()
	end
end

function door:open()
	local curr = mget(self.tile[1],self.tile[2])
	if curr != 39 then
		if not self.counter.started then
			self.counter:run()
		end
		if self.counter:is_finished() then
			local new = curr-16
			if new < 0 then
				new = 39
			end
			mset(self.tile[1],self.tile[2],new)
		end
	end
end

function door:close()
	local curr = mget(self.tile[1],self.tile[2])
	if curr != 40 then
		if not self.counter.started then
			self.counter:run()
		end
		if self.counter:is_finished() then
			local new = 0
			if curr == 39 then
				new = 8
			else
				new = curr+16
			end
			mset(self.tile[1],self.tile[2],new)
		end
	end
end

-->8
-- tools

effects = {}
effects.list = {}

function effects:update()
	for effect in all(self.list) do
		effect:update()
	end
end

function effects:draw()
	for effect in all(self.list) do
		effect:draw()
	end
end

function effects:reset()
	self.list = {}
end

function explode(x,y,t)
	local aa = rnd(1)
	for i=0,5 do
		local vector = {}
		vector.x = cos(aa+i/6)/4
		vector.y = sin(aa+i/6)/4
		particle(x,y,vector,t)
	end
end

function particle(x,y,vector,t)
	local particle = {}
	particle.pos = {
		x = x,
		y = y
	}
	particle.vector = vector
	particle.timer = t
	particle.sprites = {9,10,11,12}
	particle.speed = 2
	particle.update = function(self)
		self.timer -= 1
		self.pos.x += self.vector.x * self.speed
		self.pos.y += self.vector.y * self.speed
		if self.timer <= 0 then
			del(effects.list, self)
		end
	end
	particle.draw=function(self)
		local sprite = self.sprites[flr(t/15)%#self.sprites+1]
		spr(sprite,self.pos.x,self.pos.y,1,1)
	end
	add(effects.list,particle)
end

-- toggles debug mode
function debug_toggle()
	if btnp(2) and btnp(3) then
		debug = not debug
	end
end

-- translates bool to int
function int(bool)
	return bool and 1 or 0
end

-- returns center position for text
function center(x,txt)
	return x-#txt*2
end

-- rect with width and height
function rect2(x,y,w,h,c)
	rect(x,y,x+w-1,y+h-1,c)
end
-->8
-- global values

gravity = 0.1
__gfx__
000000006666666663333336633333333333333333333336101010101010101066aaaa6600000000000000000000000000077000000000000000000000000000
00000000666666663131331331113311113133311113111301010101010101016a9999a600000000000000000007700000000000000000000000000000000000
0070070066666666311111133311111111111111111111331010101010101010a999999a00000000000770000000000000000000000000000000000000000000
0007700066666666311111133311111111111111111111130101010101010101a999999a00077000007007000700007070000007000000000000000000000000
0007700066666666311111133111111111111111111111331010101110101010a000000a00077000007007000700007070000007000000000000000000000000
0070070066666666331111133311111111111111111111330101011111010101a000000a00000000000770000000000000000000000000000000000000000000
0000000066666666311131333111333111133111113311131010111111101010a000000a00000000000000000007700000000000000000000000000000000000
0000000066666666633333366333333333333333333333360101111111110101a000000a00000000000000000000000000077000000000000000000000000000
633333333333333333333336633333361111111111111010101011111111101066aaaa6600000000000000000000000000000000000000000000000000000000
31313311113133111131331331313313111111111111010101010111111101016a9999a600000000000000000000000000000000000000000000000000000000
3111111111111111111111133111111311111111111110101010101111101010a999999a00000000000000000000000000000000000000000000000000000000
3111111111111111111111133111111311111111111101010101010111010101a999999a00000000000000000000000000000000000000000000000000000000
3311101010101010101011333311113310101010111110101010101010101010a999999a00000000000000000000000000000000000000000000000000000000
3111010101010101010111333111113301010101111101010101010101010101a999999a00000000000000000000000000000000000000000000000000000000
3111101010101010101011133111111310101010111110101010101010101010a000000a00000000000000000000000000000000000000000000000000000000
3111010101010101010111133111111301010101111101010101010101010101a000000a00000000000000000000000000000000000000000000000000000000
3111101010101010101011133111111310101010101011116655556666aaaa6666aaaa6600000000000000000000000000000000000000000000000000000000
331101010101010101011113331111130101010101011111650000566a0000a66a9999a600000000000000000000000000000000000000000000000000000000
33111010101010101010111333111113101010101010111150000005a000000aa999999a00000000000000000000000000000000000000000000000000000000
33110101010101010101113333111133010101010101111150000005a000000aa999999a00000000000000000000000000000000000000000000000000000000
31111010101010101010113331111133111111111010111150000005a000000aa999999a00000000000000000000000000000000000000000000000000000000
33110101010101010101111333111113111111110101111150000005a000000aa999999a00000000000000000000000000000000000000000000000000000000
31111010101010101010111331111113111111111010111150000005a000000aa999999a00000000000000000000000000000000000000000000000000000000
31110101010101010101111331111113111111110101111150000005a000000aa999999a00000000000000000000000000000000000000000000000000000000
31111010101010101010111331111113666666666666663666666666666666666666666666666666000000000000000000000000000000000000000000000000
31110101010101010101113331111133666666666666636666666666666666666666666666666666000000000000000000000000000000000000000000000000
33111010101010101010113333111133666666666666636666666666666666666666666666666666000000000000000000000000000000000000000000000000
33110101010101010101113333111133666666666633636666666666666666666666666666666666000000000000000000000000000000000000000000000000
3111111111111111111111133111111366666666666336666661166666622666666cc666666ee666000000000000000000000000000000000000000000000000
311111111111111111111113311111136655556666663666661111666622226666cccc6666eeee66000000000000000000000000000000000000000000000000
313333131131333113311313313313136555555666663666661111666622226666cccc6666eeee66000000000000000000000000000000000000000000000000
63333333333333333333333663333336655555566666366664444446644444466444444664444446000000000000000000000000000000000000000000000000
000000000000000066666666dddddd66dd66dd66dddddd6666666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006666666d777777dd77dd77dd777777d666666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006666666d777777dd77dd77dd777777d666666666000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000066666666dd77dd6d77dd77dd77dddd6666666666000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000666666666d77d66d77dd77dd77dd666666666666000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000666666666d77d66d777777dd7777d66666666666000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000666666666d77d66d777777dd7777d66666666666000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000666666666d77d66d77dd77dd77dd666666666666000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000666666666d77d66d77dd77dd77dddd6666666666000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000666666666d77d66d77dd77dd777777d666666666000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000666666666d77d66d77dd77dd777777d666666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006666666666dd6666dd66dd66dddddd6666666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000666666dd666666dddddd6666dddd66dddddd6666000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000066666d77d6666d777777d66d7777dd777777d666000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000066666d77d6666d777777d6dd7777dd777777d666000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000066666d77d6666d77dd77dd77dddd66dd77dd6666000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000066666d77d6666d77dd77dd77dddd666d77d66666000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000066666d77d6666d777777dd777777d66d77d66666000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000066666d77d6666d777777dd777777d66d77d66666000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000066666d77d6666d77dd77d6dddd77d66d77d66666000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000066666d77dddd6d77dd77d6dddd77d66d77d66666000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000066666d777777dd77dd77dd7777dd666d77d66666000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000066666d777777dd77dd77dd7777d6666d77d66666000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000666666dddddd66dd66dd66dddd666666dd666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000044400000000000000000000000000000444000000000000000000000000000000000000000000000000000000000000000000
000444000000000000044400004fff00000444000000000000044400004fff000004440000000000000000000000000000000000000000000000000000000000
004fff0000044400004fff00004fff00004fff0000044400004fff00004fff00004fff0000044400000000000000000000000000000000000000000000000000
004fff00004fff00004fff0000422200004fff00004fff00004fff0000422200004fff00004fff00000000000000000000000000000000000000000000000000
00422200004fff00004222000002220100422200004fff00004222000002220000422200004fff00000000000000000000000000000000000000000000000000
00122210004222000002220101010110010222010042220001022200010111010102220100422200000000000000000000000000000000000000000000000000
00010100010222010101010000100000001101000102220100010101000010000001110001022201000000000000000000000000000000000000000000000000
00010100000101000001100000000000000000100010010000100100000000000001000000011000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000101000001110000010100000111000000000000000000000000000000000000000000000000000
00101000001110000000000000000000001010000011100000081111101110000008111110111000001010000011100000000000000000000000000000000000
0008111110111000001010000011100000081111101110000001111d111110000001111d11111000000811111011100000000000000000000000000000000000
0001111d1111100000081111101110000001111d111110000000dd0d0dd0000000000d0ddd0000000001111d1111100000000000000000000000000000000000
00000d0d0d0000000001111d1111100000000d0d0d00000000000000d00000000000d00000d0000000000d0d0d00000000000000000000000000000000000000
0000d00d00d00000000d000d000d0000000000dd00d000000000000000000000000000000000000000000d00dd00000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000101000001110000010100000111000000000000000000000000000000000000000000000000000
00101000001110000000000000000000001010000011100000081111101110000008111110111000001010000011100000000000000000000000000000000000
00081111101110000010100000111000000811111011100000011111111110000001111111111000000811111011100000000000000000000000000000000000
0001111111111000000811111011100000011111111110000000011d110000000000011d11000000000111111111100000000000000000000000000000000000
0000011d1100000000011111111110000000011d11000000000ddd0d0ddd000000000d0ddd0000000000011d1100000000000000000000000000000000000000
00000d0d0d0000000000011d1100000000000d0d0d00000000000000d00000000000d00000d0000000000d0d0d00000000000000000000000000000000000000
0000d00d00d000000000d00d00d00000000000dd00d0000000000000d00000000000d00000d0000000000d00dd00000000000000000000000000000000000000
0000d00d00d00000000d000d000d0000000000dd00d000000000000000000000000000000000000000000d00dd00000000000000000000000000000000000000
6dddddd66dddd6666dddddd66dddddd66dddddd66dddd6666dddd6666dddddd66dddddd600000000000000000000000000000000000000000000000000000000
d777777dd7777d66d777777dd777777dd777777dd7777d66d7777d66d777777dd777777d00000000000000000000000000000000000000000000000000000000
d777777dd7777dd6d777777dd777777dd777777dd7777dd6d7777dd6d777777dd777777d00000000000000000000000000000000000000000000000000000000
d77dd77dd77dd77d6dd77dd6d77dd77dd77dddd6d77dd77dd77dd77dd77dddd6d77dd77d00000000000000000000000000000000000000000000000000000000
d77dd77dd77dd77d66d77d66d77dd77dd77dd666d77dd77dd77dd77dd77dd666d77dd77d00000000000000000000000000000000000000000000000000000000
d777777dd77dd77d66d77d66d7777dd6d7777d66d77dd77dd77dd77dd7777d66d7777dd600000000000000000000000000000000000000000000000000000000
d777777dd77dd77d66d77d66d7777dd6d7777d66d77dd77dd77dd77dd7777d66d7777dd600000000000000000000000000000000000000000000000000000000
d77dd77dd77dd77d66d77d66d77dd77dd77dd666d77dd77dd77dd77dd77dd666d77dd77d00000000000000000000000000000000000000000000000000000000
d77dd77dd77dd77d66d77d66d77dd77dd77dddd6d77dd77dd77dd77dd77dddd6d77dd77d00000000000000000000000000000000000000000000000000000000
d77dd77dd77dd77d66d77d66d777777dd777777dd77dd77dd777777dd777777dd77dd77d00000000000000000000000000000000000000000000000000000000
d77dd77dd77dd77d66d77d66d777777dd777777dd77dd77dd777777dd777777dd77dd77d00000000000000000000000000000000000000000000000000000000
6dd66dd66dd66dd6666dd6666dddddd66dddddd66dd66dd66dddddd66dddddd66dd66dd600000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666666666666666666666666666666666666666666600000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666666666666666666666666666666666666666666600000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666666666666666666666666666666666666666666600000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666666666666666666666666666666666666666666600000000000000000000000000000000000000000000000000000000
__label__
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
10101011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110101010
01010111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111010101
10101111113133311131333111313331113133311131333111313331113133311131333111313331113133311131333111313331113133311131333111101010
01011111333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333311110101
10101113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631111010
01011113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666633110101
10101113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666633111010
01011133666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666633110101
10101133666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631111010
01011113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666633110101
10101113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631111010
01011113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631110101
10101113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631111010
01011113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666633110101
10101113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666633111010
01011133666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666633110101
10101133666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631111010
01011113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666633110101
10101113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631111010
01011113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631110101
101011136666666666666666666666666666666666666666dddddd66dd66dd66dddddd6666666666666666666666666666666666666666666666666631111010
01011113666666666666666666666666666666666666666d777777dd77dd77dd777777d666666666666666666666666666666666666666666666666633110101
10101113666666666666666666666666666666666666666d777777dd77dd77dd777777d666666666666666666666666666666666666666666666666633111010
010111336666666666666666666666666666666666666666dd77dd6d77dd77dd77dddd6666666666666666666666666666666666666666666666666633110101
1010113366666666666666666666666666666666666666666d77d66d77dd77dd77dd666666666666666666666666666666666666666666666666666631111010
0101111366666666666666666666666666666666666666666d77d66d777777dd7777d66666666666666666666666666666666666666666666666666633110101
1010111366666666666666666666666666666666666666666d77d66d777777dd7777d66666666666666666666666666666666666666666666666666631111010
0101111366666666666666666666666666666666666666666d77d66d77dd77dd77dd666666666666666666666666666666666666666666666666666631110101
1010111366aaaa66666666366666666666666666666666666d77d66d77dd77dd77dddd6666666666666666666666666666666666666666666666666631111010
010111136a0000a6666663666666666666666666666666666d77d66d77dd77dd777777d666666666666666666666666666666666666666666666666633110101
10101113a000000a666663666666666666666666666666666d77d66d77dd77dd777777d666666666666666666666666666666666666666666666666633111010
01011133a000000a6633636666666666666666666666666666dd6666dd66dd66dddddd6666666666666666666666666666666666666666666666666633110101
10101133a000000a6663366666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631111010
01011113a000000a6666366666555566666666666666666666666666666666666666666666666666666666666666666666666666666666666666666633110101
10101113a000000a6666366665555556666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631111010
01011113a000000a6666366665555556666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631110101
10101111333333333333333333333333333333366666666666666666666666dd666666dddddd6666dddd66dddddd666666666666666666666666666631111010
0101111111313331113133311131333111131113666666666666666666666d77d6666d777777d66d7777dd777777d66666666666666666666666666633110101
1010111111111111111111111111111111111133666666666666666666666d77d6666d777777d6dd7777dd777777d66666666666666666666666666633111010
0101111111111111111111111111111111111113666666666666666666666d77d6666d77dd77dd77dddd66dd77dd666666666666666666666666666633110101
1010111111111111111111111111111111111133666666666666666666666d77d6666d77dd77dd77dddd666d77d6666666666666666666666666666631111010
0101111111111111111111111111111111111133666666666666666666666d77d6666d777777dd777777d66d77d6666666666666666666666666666633110101
1010111111133111111331111113311111331113666666666666666666666d77d6666d777777dd777777d66d77d6666666666666666666666666666631111010
0101111133333333333333333333333333333336666666666666666666666d77d6666d77dd77d6dddd77d66d77d6666666666666666666666666666631110101
1010111366666666666666666666666666666666666666666666666666666d77dddd6d77dd77d6dddd77d66d77d6666666666666666666666666666631111010
0101111366666666666666666666666666666666666666666666666666666d777777dd77dd77dd7777dd666d77d6666666666666666666666666666633110101
1010111366666666666666666666666666666666666666666666666666666d777777dd77dd77dd7777d6666d77d6666666666666666666666666666633111010
01011133666666666666666666666666666666666666666666666666666666dddddd66dd66dd66dddd666666dd66666666666666666666666666666633110101
10101133666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631111010
01011113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666633110101
10101113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631111010
01011113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631110101
1010111366666666666666666dddddd66dddd6666dddddd66dddddd66dddddd66dddd6666dddd6666dddddd66dddddd666666666666666666666666631111010
010111136666666666666666d777777dd7777d66d777777dd777777dd777777dd7777d66d7777d66d777777dd777777d66666666666666666666666633110101
101011136666666666666666d777777dd7777dd6d777777dd777777dd777777dd7777dd6d7777dd6d777777dd777777d66666666666666666666666633111010
010111336666666666666666d77dd77dd77dd77d6dd77dd6d77dd77dd77dddd6d77dd77dd77dd77dd77dddd6d77dd77d66666666666666666666666633110101
101011336666666666666666d77dd77dd77dd77d66d77d66d77dd77dd77dd666d77dd77dd77dd77dd77dd666d77dd77d66666666666666666666666631111010
010111136666666666666666d777777dd77dd77d66d77d66d7777dd6d7777d66d77dd77dd77dd77dd7777d66d7777dd666666666666666666666666633110101
101011136666666666666666d777777dd77dd77d66d77d66d7777dd6d7777d66d77dd77dd77dd77dd7777d66d7777dd666666666666666666666666631111010
010111136666666666666666d77dd77dd77dd77d66d77d66d77dd77dd77dd666d77dd77dd77dd77dd77dd666d77dd77d66666666666666666666666631110101
101011136666666666666666d77dd77dd77dd77d66d77d66d77dd77dd77dddd6d77dd77dd77dd77dd77dddd6d77dd77d66666666666666666666666631111010
010111136666666666666666d77dd77dd77dd77d66d77d66d777777dd777777dd77dd77dd777777dd777777dd77dd77d66666666666666666666666633110101
101011136666666666666666d77dd77dd77dd77d66d77d66d777777dd777777dd77dd77dd777777dd777777dd77dd77d66666666666666666666666633111010
0101113366666666666666666dd66dd66dd66dd6666dd6666dddddd66dddddd66dd66dd66dddddd66dddddd66dd66dd666666666666666666666666633110101
10101133666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631111010
01011113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666633110101
10101113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631111010
01011113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631110101
10101113666666666666666666666666666666666666666666666666666666666666666666666666666666666666663666666666666666666666666631111010
01011113666666666666666666666666666666666666666666666666666666666666666666666666666666666666636666666666666666666666666633110101
10101113666666666666666666666666666666666666666666666666666666666666666666666666666666666666636666666666666666666666666633111010
01011133666666666666666666666666666666666666666666666666666666666666666666666666666666666633636666666666666666666666666633110101
10101133666666666666666666666666666666666666666666666666666666666666666666666666666666666663366666666666666666666662266631111010
010111136666666666666666ddd6ddd6ddd66dd66dd66666ddd666d66dd666666666666666666666666666666666366666666666666666666622226633110101
101011136666666666666666d6d6d6d6d666d666d666666666d66d66d66666666666666666666666666666666666366666666666666666666622226631111010
010111136666666666666666ddd6dd66dd66ddd6ddd666666d666d66d66666666666666666666666666666666666366666666666666666666444444631110101
101011136666666666666666d666d6d6d66666d666d66666d6666d66d66666666666666663333333333333333333333333333333333333333333333311111010
010111136666666666666666d666d6d6ddd6dd66dd666666ddd6d6666dd666666666666631113311113133311131333111313331113133311131333111110101
10101113666666666666666666666666666666666666666666666666666666666666666633111111111111111111111111111111111111111111111111111010
01011133666666666666666666666666666666666666666666666666666666666666666633111111111111111111111111111111111111111111111111110101
10101133666666666666666666666666666666666666666666666666666666666666666631111111111111111111111111111111111111111111111111111010
010111136666666666666666ddd66dd666666dd6ddd6ddd6ddd6ddd6666666666666666633111111111111111111111111111111111111111111111111110101
1010111366666666666666666d66d6d66666d6666d66d6d6d6d66d66666666666666666631113331111331111113311111133111111331111113311111111010
0101111366666666666666666d66d6d66666ddd66d66ddd6dd666d66666666666666666663333333333333333333333333333333333333333333333311110101
1010111366666666666666666d66d6d6666666d66d66d6d6d6d66d66666666666666666666666666666666666666666666666666666666666666666631111010
0101111366666666666666666d66dd666666dd666d66d6d6d6d66d66666666666666666666666666666666666666666666666666666666666666666633110101
10101113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666633111010
01011133666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666633110101
10101133666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631111010
01011113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666633110101
10101113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631111010
01011113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631110101
10101113666666666666666661161116111611166666111616166666111611161116116616161116611611161666161666666666666666666666666631111010
01011113666666666666666616661616111616666666161616166666161616661616161616166166166616661666161666666666666666666666666633110101
10101113666666666666666616661116161611666666116611166666111611661116161616166166111611661666111666666666666666666666666633111010
01011133666666666666666616161616161616666666161666166666166616661616161616166166661616661666661666666666666666666666666633110101
10101133666666666666666611161616161611166666111611166666166611161616161661166166116616661116111666666666666666666666666631111010
01011113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666633110101
10101113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631111010
01011113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631110101
10101113666666666666666611161616611611166116666611161616666661666116111616161116111611161116161661161116611666666666666631111010
01011113666666666666666611161616166661661666666616161616666616161666161616161616166616161116161616666166166666666666666633110101
10101113666666666666666616161616111661661666666611661116666616161666116616161166116611661616161611166166166666666666666633111010
01011133666666666666666616161616661661661666666616166616666616661616161616161616166616161616161666166166166666666666666633110101
10101133666666666666666616166116116611166116666611161116666661161116161661161116111616161616611611661116611666666666666631111010
01011113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666633110101
10101113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631111010
01011113666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666631110101
10101113666666666655556666666666666666666666663666666666666666366666666666666666666666666666666666666666666666666666666631111010
01011113666666666500005666666666666666666666636666666666666663666666666666666666666666666666666666666666666666666666666633110101
10101113666666665000000566666666666666666666636666666666666663666666666666666666666666666666666666666666666666666666666633111010
01011133666666665000000566666666666666666633636666666666663363666666666666666666666666666666666666666666666666666666666633110101
101011336666666650000005666666666666666666633666666666666663366666666666666666666666666666666666666cc666666666666666666631111010
01011113666666665000000566666666666666666666366666555566666636666666666666666666666666666666666666cccc66665555666666666633110101
10101113666666665000000566666666666666666666366665555556666636666666666666666666666666666666666666cccc66655555566666666631111010
01011113666666665000000566666666666666666666366665555556666636666666666666666666666666666666666664444446655555566666666631110101
10101111333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333311111010
01010111113133111131331111313311113133111131331111313311113133111131331111313311113133111131331111313311113133111131331111110101
10101011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111101010
01010101111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111010101
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101

__gff__
0000010101010101000000000000000001010101010101010000000000000000010101010101000800000000000000000101010100000204020400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212106313131313131313131313131313107
2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212122010101010101010101010101010120
2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212122010101010101010101010101010120
2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121210631313131313131313131313131310721212121212121212121212121212121063131313131313131313131313131072121212121212121212121212121212122010101014243444501460101010120
0631313131313131313131313131310706313131313131313131313131313107063131313131313131313131313131072201010101010101010101010101012006313131313131313131313131313107220101010101010101010101010101200631313131313131313131313131310722273534015253545501560101010120
2201010101010101010101010101012022010101010101010101010101010120220101010101010101010101010101202201010101010101010101010101012022010101010101010101010101010120220101010101010101010101010101202201010101010101010101010101012025040404050101626364656601010120
2201010101010101010101010101012022010101010101010101010101010120220101010101010101010101010101202201010101010101010101013501012022010135340135013534010101010120220101010101010101340101010101202201010101010101010101010101012022010101010101727374757601010120
22010101010101010101010101010120220135010101010101010101010101202201010101010101010101010101012022010101010101030405010103040415161111111111111111111111111111172201010101010103040404040405012022010101010101010101010101010120220101b0b1b2b3b4b5b6b7b801010120
22010101010101010101010101010120250404040501010101010101010101202201010101010101010101010101012022013501010101010101010101010120063131313131313131313131313131072201010101010101010101010101012022010101010101010101010101010120220101c0c1c2c3c4c5c6c7c801010120
2201010101010101010101010101012022010101010101010101010101010120220101010101010101010101010101202504040405010101010101010101012022010101010101010101010101010120220126013501010101010101012835202201010101010101010101010101012022010101010101010101013501013720
2201260135010101013435010128012022012601340101350134010101283520220126010135343501010101012801202201010101010101010101010101012022012601350101010101353401280120161111111112010101010101101111172201260135010101013435010101012022010101010101010103040404040415
1611111111111111111111111111111716111111111111111111111111111117161111111111111111111111111111172201260134010135013401010128352016111111111111111111111111111117210631313132010101010110172121211611111111111111111111111111111722010101010101010101010101010120
2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121211611111111111111111111111111111721212121212121212121212121212121212201010134350101011017212121212121212121212121212121212121212122010101010101010101010101010120
2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121211611111111111111111721212121212121212121212121212121212121212122010101010101010101010101010120
2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212122012601013534350101010138340120
2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212116111111111111111111111111111117
__sfx__
000100002305026050290502a0001c000190000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001b0501d0501f050300001e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000170500d0500c0500705005000020000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100003805000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000290000b0000b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001400000c0030250502505020050e6050250500005025050c0030250502505020050e60502505020050250500000000000000000000000000000000000000000000000000000000000000000000000000000000
000400000d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000000000000000000000000000002a0002b0002c0002c0002c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011400001051512515150151a5151051512515150151a5151051512515150151a5151051512515150151a5151051512515170151c5151051512515170151c5151051512515160151c5151051512515160151c515
011400000c0330253502525020450e6150252502045025250c0330253502525020450e6150252502045025250c0330252502045025350e6150204502535025250c0330253502525020450e615025250204502525
011400002c7252c0152c7152a0252a7152a0152a7152f0152c7252c0152c7152801525725250152a7252a0152072520715207151e7251e7151e7151e715217152072520715207151e7251e7151e7151e7151e715
011400000c0330653506525060450e6150652506045065250c0330653506525060450e6150652506045065250c0330952509045095350e6150904509535095250c0330953509525090450e615095250904509525
0114000020725200152071520015217252101521715210152c7252c0152c7152c0152a7252a0152a7152a015257252501525715250152672526015267153401532725310152d715280152672525015217151c015
__music__
00 00014344
00 00014344
01 00014344
00 00014344
00 02034344
02 02034344
00 04424344
00 04424344
00 04054344
00 04054344
01 04054344
00 04054344
00 06074344
02 08094344
01 0a0b4344
00 0c0d4344
00 0a0e4344
02 0c0e4344
00 10424344
01 100f4344
00 100f4344
00 10114344
00 12114344
02 12134344
01 14154344
00 14154344
00 16154344
00 16154344
00 18174344
02 16174344
00 19424344
01 191a4344
00 191a4344
00 1b1a4344
00 191c4344
02 1b1c4344
01 1d1e4344
00 1d1f4344
00 1d1e4344
00 1d1f4344
00 21204344
02 1d224344
00 27424344
01 24234344
00 24234344
02 26254344
01 28294344
03 2a2b4344
01 2d304344
00 2e304344
00 2d304344
00 2e304344
00 2d2c4344
00 2d2c4344
02 2e2f4344
01 31324344
00 31324344
00 33344344
02 35364344
01 3738433f
00 3738433f
00 393b433f
00 393c433f
02 3a3d433f

