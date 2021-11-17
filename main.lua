local voxel = require("lib.voxel")
local voxworld = require("lib.voxworld")

local world
local north, east, south, west, floor
function love.load()
    world = voxworld.new("assets/model")

    world:add("north", {file = "kitchen-1-north.vox", y=-48, z=8, hide={min=90, max=270}})
    world:add("east", {file = "kitchen-0-east.vox", x=48, z=8, hide={min=0, max=180}})
    world:add("south", {file = "kitchen-2-south.vox", y=48, z=8, hide={min=270, max=90}})
    world:add("west", {file = "kitchen-3-west.vox", x=-48, z=8, hide={min=180, max=0}})
    world:add("floor", {file = "kitchen-4-floor.vox"})
    world:add("counter_left", {file = "kitchen-5-counter_left.vox", z=8})
    world:add("oven", {file = "kitchen-6-oven.vox", z=8})
    world:add("counter_right", {file = "kitchen-7-counter_right.vox", z=8})
    world:add("chair", {file = "kitchen-8-chair.vox", z=8})
    world:add("table", {file = "kitchen-9-table.vox", z=8})
    world:add("table", {file = "kitchen-10-compass.vox", z=50})
end

function love.update(dt)
    if love.mouse.isDown(2) then
    end
    world:rotate(math.pi/4,world.rot + dt/2)
    local item = "counter_left"
    if love.keyboard.isDown("w") then
        local vox = world:getItem(item)
        world:moveItem(item, vox.x+1, vox.y, vox.z)
    end
    if love.keyboard.isDown("s") then
        local vox = world:getItem(item)
        world:moveItem(item, vox.x-1, vox.y, vox.z)
    end
    if love.keyboard.isDown("a") then
        local vox = world:getItem(item)
        world:moveItem(item, vox.x, vox.y+1, vox.z)
    end
    if love.keyboard.isDown("d") then
        local vox = world:getItem(item)
        world:moveItem(item, vox.x, vox.y-1, vox.z)
    end
end

function love.draw()
    local w,h = select(3,love.window.getSafeArea())
    love.graphics.translate(w/2,h/2+100)
    love.graphics.print(world:getItem("east"):getRotation()*180/math.pi, -w/2, -h/2)
    love.graphics.scale(3)
    world:draw()
end
