require "config"
require "constants"

require "__DragonIndustries__.arrays"

function canPlaceAt(surface, x, y)
	return surface.can_place_entity{name = "miasma-effect", position = {x, y}}
end

function isInChunk(x, y, chunk)
	local minx = math.min(chunk.left_top.x, chunk.right_bottom.x)
	local miny = math.min(chunk.left_top.y, chunk.right_bottom.y)
	local maxx = math.max(chunk.left_top.x, chunk.right_bottom.x)
	local maxy = math.max(chunk.left_top.y, chunk.right_bottom.y)
	return x >= minx and x <= maxx and y >= miny and y <= maxy
end

function cantorCombine(a, b)
	--a = (a+1024)%16384
	--b = b%16384
	local k1 = a*2
	local k2 = b*2
	if a < 0 then
		k1 = a*-2-1
	end
	if b < 0 then
		k2 = b*-2-1
	end
	return 0.5*(k1 + k2)*(k1 + k2 + 1) + k2
end

function createSeed(surface, x, y) --Used by Minecraft MapGen
	local seed = surface.map_gen_settings.seed
	if Config.seedMixin ~= 0 then
		seed = bit32.band(cantorCombine(seed, Config.seedMixin), 2147483647)
	end
	return bit32.band(cantorCombine(seed, cantorCombine(x, y)), 2147483647)
end

function generateMiasma(surface, x, y, rand)
	if canPlaceAt(surface, x, y) then
		if surface.create_entity{name = "miasma-effect", position = {x, y}, force = game.forces.enemy} ~= nil then
			local n = 3 --how many to choose from
			local spawns = {}
			local nspawns = rand(1, n)
			while #spawns < nspawns do
				local i = rand(1, n)
				while listHasValue(spawns, i) do
					i = rand(1, n)
				end
				table.insert(spawns, i)
			end
			--game.print(serpent.block(spawns))
			for _,i in pairs(spawns) do
				local dx = rand(x-2, x+2)
				local dy = rand(y-2, y+2)
				if not surface.create_entity{name = "miasma-visual-" .. i, position = {dx, dy}, force = game.forces.enemy} then
					game.print("Failed to create effect " .. i)
				end
			end
		end
	end
end