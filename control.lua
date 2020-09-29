require "config"
require "constants"
require "functions"

local ranTick = false

function initGlobal(markDirty)
	if not global.miasma then
		global.miasma = {}
	end
	local miasma = global.miasma
	if miasma.cache == nil then
		miasma.cache = {}
	end
	miasma.dirty = markDirty
end

script.on_configuration_changed(function()
	initGlobal(true)
end)

script.on_init(function()
	initGlobal(true)
end)

local function controlChunk(surface, area)
	local rand = game.create_random_generator()
	local x = (area.left_top.x+area.right_bottom.x)/2
	local y = (area.left_top.y+area.right_bottom.y)/2
	local dd = math.sqrt(x*x+y*y)
	if dd < MIN_DISTANCE then
		return
	end
	local df = math.min(1, (dd-MIN_DISTANCE)/(DISTANCE_FULL-MIN_DISTANCE))
	if df < 1 and math.random() > df then
		return
	end
	local seed = createSeed(surface, x, y)
	rand.re_seed(seed)
	local f = df*Config.spawnDensity*BASE_SPAWN_FACTOR
	local f1 = rand(0, 2147483647)/2147483647
	--game.print("Chunk at " .. x .. ", " .. y .. " with chance " .. f .. " / " .. f1)
	if f1 < f then
		--game.print("Genning Chunk at " .. x .. ", " .. y)
		x = x-16+rand(0, 32)
		y = y-16+rand(0, 32)
		generateMiasma(surface, x, y, rand)
	end
end

script.on_event(defines.events.on_chunk_generated, function(event)
	controlChunk(event.surface, event.area)
end)

script.on_event(defines.events.on_tick, function(event)	
	if not ranTick and Config.retrogenDistance >= 0 then
		local surface = game.surfaces["nauvis"]
		for chunk in surface.get_chunks() do
			local x = chunk.x
			local y = chunk.y
			if surface.is_chunk_generated({x, y}) then
				local area = {
					left_top = {
						x = x*CHUNK_SIZE,
						y = y*CHUNK_SIZE
					},
					right_bottom = {
						x = (x+1)*CHUNK_SIZE,
						y = (y+1)*CHUNK_SIZE
					}
				}
				local dx = x*CHUNK_SIZE+CHUNK_SIZE/2
				local dy = y*CHUNK_SIZE+CHUNK_SIZE/2
				local dist = math.sqrt(dx*dx+dy*dy)
				if dist >= Config.retrogenDistance then
					controlChunk(surface, area)
				end
			end
		end
		ranTick = true
		for name,force in pairs(game.forces) do
			force.rechart()
		end
		--game.print("Ran load code")
	end
	--[[
	if event.tick%30 == 0 then
		local miasma = global.miasma
		if miasma.cache then
			for unit,entry in pairs(miasma.cache) do
				if entry.entity.valid then
					tickHive(entry)
				else
					miasma.cache[unit] = nil
				end
			end
		end
	end
	--]]
end)

commands.add_command("spawnMiasma", {"cmd.spawn-miasma-help"}, function(event)
	local player = game.players[event.player_index]
	generateMiasma(player.surface, player.position.x, player.position.y, game.create_random_generator(math.random(0, 2387341)))
end)