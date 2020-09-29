require "config"

require "__DragonIndustries__.biomecolor"

CHUNK_SIZE = 32

BASE_SPAWN_FACTOR = 0.125
DISTANCE_ZERO = 100
DISTANCE_FULL = 500

local TILE_COLOR_MAP = {}
local EXTRA_MAP = {}

local function addExtraValidColors(tile, name, list)
	local extras = EXTRA_MAP[name]
	if extras then
		for _,c in pairs(extras) do
			table.insert(list, c)
		end
	end
end

function getMiasmaColorsForTile(tile)
	local base,water = getColorsForTile(tile)
	if water then return nil end
	local n = tile.name
	if not TILE_COLOR_MAP[n] then
		TILE_COLOR_MAP[n] = base
		addExtraValidColors(tile, n, base)
	end
	return util.table.deepcopy(TILE_COLOR_MAP[n])
end

function initModifiers(isInit)

end

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