local voxel = require("lib.voxel")
local voxworld = require("lib.voxworld")

local world
local north, east, south, west, floor
function love.load()
    world = voxworld.new("assets/model")

    world:add("north", {file = "kitchen-1-north.vox", y=-48, z=8})
    world:add("east", {file = "kitchen-0-east.vox", x=48, z=8})
    --world:add("south", {file = "kitchen-2-south.vox", y=48, z=8})
    world:add("west", {file = "kitchen-3-west.vox", x=-48, z=8})
    world:add("floor", {file = "kitchen-4-floor.vox"})
end

function love.update(dt)
    world:rotate(world.rot + dt/2)
end

function love.draw()
    local w,h = select(3,love.window.getSafeArea())
    love.graphics.translate(w/2,h/2)
    love.graphics.scale(3)
    world:draw()
end
