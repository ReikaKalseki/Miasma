--[[

require "__DragonIndustries__.cloning"

local cloud = copyObject("smoke-with-trigger", "poison-cloud", "miasma")

cloud.created_effect = nil

error(serpent.block(cloud))

data:extend({cloud})

--]]

require "__DragonIndustries__.biomecolor"
require "__DragonIndustries__.color"

local function createSmoke(name, color, damage)
	local f = 2.0
	local size = 2.5*f*(damage and damage.radius/11 or 1)
	local ret = 
  {
    type = "smoke-with-trigger",
    name = "miasma-" .. name,
    flags = {"not-on-map"},
    show_when_smoke_off = true,
    particle_count = 48,
    particle_spread = { size*4, size*4*0.707 },
    particle_distance_scale_factor = 0.5,
    particle_scale_factor = { 1, 0.707 },
    wave_speed = { 1/60*(0.9+math.random()*0.2), 1/40*(0.9+math.random()*0.2) },
    wave_distance = { 0.5+math.random()*0.05, 0.5*0.707+math.random()*0.05 },
    spread_duration_variation = 20,
    render_layer = "air-object",

    affected_by_wind = false,
    cyclic = true,
    duration = 2^32-1,
    fade_away_duration = 1,
    spread_duration = 1,
    color = color and color or {r = 1, g = 1, b = 1, a = 0},

    animation =
    {
      width = color and 152 or 1,
      height = color and 120 or 1,
      line_length = color and 5 or nil,
      frame_count = color and 60 or 1,
      shift = {-0.53125, -0.4375},
      priority = "high",
      animation_speed = 0.15+math.random()*0.1,
	  scale = size,
      filename = color and "__Miasma__/graphics/entity/visuals.png" or "__core__/graphics/empty.png", -- "__base__/graphics/entity/smoke/smoke.png"
	  blend_mode = "additive-soft",
      flags = { "smoke" }
    },
    action_cooldown = 30
  }
  
  if damage and damage.amount > 0111 then
    ret.action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "nested-result",
          action = {
			  {
				type = "area",
				radius = damage.radius*f,
				entity_flags = {"breaths-air"},
				action_delivery =
				{
				  type = "instant",
				  target_effects =
				  {
					type = "damage",
					damage = { amount = damage.amount, type = "poison"}
				  }
				}
			  },
			  {
				type = "area",
				radius = damage.radius*f,
				entity_flags = {"placeable-enemy", "placeable-neutral"},
				action_delivery =
				{
				  type = "instant",
				  target_effects =
				  {
					type = "damage",
					damage = { amount = -damage.amount*2-1, type = "poison"}
				  }
				}
			  }
		  }
        }
      }
    }
  end
  
  return ret
end

data:extend({
	createSmoke("effect", nil, {radius = 12, amount = 2}),
	--createSmoke("visual-cyan", {r = 0, g = 213/255, b = 186/255, a = 1}, nil),
	--createSmoke("visual-blue", {r = 0, g = 95/255, b = 240/255, a = 1}, nil),
	--createSmoke("visual-purple", {r = 182/255, g = 99/255, b = 250/255, a = 1}, nil),
})

for _,color in pairs(ALL_COLORS) do
	local basecolor = convertColor(RENDER_COLORS[color], true)
	basecolor.r = math.min(1, basecolor.r*1.25+0.175)
	basecolor.g = math.min(1, basecolor.g*1.25+0.175)
	basecolor.b = math.min(1, basecolor.b*1.25+0.175)
	--log(serpent.block(convertColor(RENDER_COLORS[color], true)))
	--log("colorconvert to")
	--log(serpent.block(basecolor))
	data:extend({createSmoke("visual-" .. color, basecolor, nil)})
end