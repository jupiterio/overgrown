local voxel = require("lib.voxel")
local voxworld = require("lib.voxworld")

local world
local north, east, south, west, floor
function love.load()
    world = voxworld.new("assets/model")

    world:add("north", { file = "kitchen-1-north.vox", ox = 50, oy = 50 })
    world:add("east", { file = "kitchen-0-east.vox", r = math.pi/2, ox = 50, oy = 50 })
    world:add("south", { file = "kitchen-2-south.vox", r = math.pi , ox = 50, oy = 50 })
    world:add("west", { file = "kitchen-3-west.vox", r = 3*math.pi/2, ox = 50, oy = 50 })
    world:add("floor", { file = "kitchen-4-floor.vox", ox = 50, oy = 50 })
end

function love.update(dt)
end

function love.draw()
    love.graphics.scale(2)
    love.graphics.translate(200, 200)
    world:draw()
end
