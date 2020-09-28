--[[

require "__DragonIndustries__.cloning"

local cloud = copyObject("smoke-with-trigger", "poison-cloud", "miasma")

cloud.created_effect = nil

error(serpent.block(cloud))

data:extend({cloud})

--]]

local function createSmoke(name, color, damage)
	local size = damage and damage.radius/11 or 1
	local ret = 
  {
    type = "smoke-with-trigger",
    name = "miasma-" .. name,
    flags = {"not-on-map"},
    show_when_smoke_off = true,
    particle_count = 16,
    particle_spread = { size, size*0.707 },
    particle_distance_scale_factor = 0.5,
    particle_scale_factor = { 1, 0.707 },
    wave_speed = { 1/80, 1/60 },
    wave_distance = { 0.3, 0.2 },
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
      animation_speed = 0.2,
	  scale = size,
      filename = color and "__Miasma__/graphics/entity/visuals.png" or "__core__/graphics/empty.png", -- "__base__/graphics/entity/smoke/smoke.png"
	  blend_mode = "additive-soft"
      flags = { "smoke" }
    },
    action_cooldown = 30
  }
  
  if damage and damage.amount > 0 then
    ret.action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "nested-result",
          action =
          {
            type = "area",
            radius = damage.radius,
            entity_flags = {"breaths-air", "placeable-player"},
            action_delivery =
            {
              type = "instant",
              target_effects =
              {
                type = "damage",
                damage = { amount = damage.amount, type = "poison"}
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
  createSmoke("effect", nil, {radius = 12, amount = 8}),
  createSmoke("visual-1", {r = 0, g = 213/255, b = 186/255, a = 1}, nil),
  createSmoke("visual-2", {r = 0, g = 95/255, b = 240/255, a = 1}, nil),
  createSmoke("visual-3", {r = 182/255, g = 99/255, b = 250/255, a = 1}, nil),
})