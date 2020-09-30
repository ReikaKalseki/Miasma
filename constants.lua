require "config"

require "__DragonIndustries__.arrays"
require "__DragonIndustries__.biomecolor"

CHUNK_SIZE = 32

BASE_SPAWN_FACTOR = 0.125
MIN_DISTANCE = 100
DISTANCE_FULL = 500

local TILE_COLOR_MAP = {}
local COLOR_GROUPS = {}
--local EXTRA_MAP = {}

local function addExtraValidColors(tile, name, list)
	local extras = EXTRA_MAP[name]
	if extras then
		for _,c in pairs(extras) do
			if not listHasValue(list, c) then
				table.insert(list, c)
			end
		end
	end
end

function getMiasmaColorsForTile(tile)
	local base,water = getColorsForTile(tile)
	if water then return nil end
	local n = tile.name
	if not TILE_COLOR_MAP[n] then
		--TILE_COLOR_MAP[n] = base
		for name,group in pairs(COLOR_GROUPS) do
			if string.find(n, name, 1, true) then
				TILE_COLOR_MAP[n] = group
			end
		end
		--addExtraValidColors(tile, n, base)
	end
	return util.table.deepcopy(TILE_COLOR_MAP[n])
end

function initModifiers(isInit)

end

--[[
local function addExtraColor(tile, color)
	if not EXTRA_MAP[tile] then
		EXTRA_MAP[tile] = {}
	end
	table.insert(EXTRA_MAP[tile], color)
end

for i = 1,4 do
	local n = "grass-" .. i
	addExtraColor(n, "cyan")
	addExtraColor(n, "argon")
	addExtraColor(n, "blue")
	addExtraColor(n, "purple")
end

addExtraColor("sand-1", "red")
addExtraColor("sand-2", "red")
addExtraColor("sand-3", "red")
--]]

local function addColorGroup(colors, names)
	for _,n in pairs(names) do
		COLOR_GROUPS[n] = colors
	end
end

addColorGroup({"red", "orange", "yellow"}, {"red", "dustyrose", "orange", "brown", "desert", "sand", "dirt", "tan", "beige"})
addColorGroup({"white", "green", "yellow"}, {"yellow", "cream", "olive"})
addColorGroup({"argon", "green", "cyan"}, {"green", "grass"})
addColorGroup({"white", "cyan", "argon"}, {"snow", "white", "ice", "frozen", "black", "grey", "gray"})
addColorGroup({"argon", "blue", "purple"}, {"blue", "turqoise"})
addColorGroup({"blue", "purple", "magenta"}, {"purple", "violet", "mauve", "aubergine"})