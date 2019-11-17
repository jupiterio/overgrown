local voxworld = {}
local cd = (...):match("(.-)[^%.]+$")

local voxel = require(cd .. "voxel")

function voxworld.new(mfolder)
    local world = {}

    world._folder = mfolder
    world._items = {}
    world._zordered = {}
    world.rot = 0

    return setmetatable(world, {__index = voxworld})
end

function voxworld:transformPoint(x, y, z)
    local rot = love.math.newTransform(0,0,self.rot)
    x, y = rot:transformPoint(x, y)
    return x, (y-z*1.5)*0.577
end

function voxworld:add(id, options)
    options = options or {}
    if type(options.file) ~= "string" then error("options.file is required") end

    local vox = voxel.new(self._folder .. "/" .. options.file)

    vox.x = options.x or 0
    vox.y = options.y or 0
    vox.z = options.z or 0

    if options.hide and (not options.hide.min or not options.hide.max) then error("min and max properties are required in options.hide") end
    vox.hide = options.hide

    vox:origin(0.5, 0.5)

    self._items[id] = vox
    table.insert(self._zordered, vox)

    self:zorder()
    return vox
end

function voxworld:moveItem(id, x, y, z)
    local item = self:getItem(id)
    item.x = x
    item.y = y
    item.z = z

    self:zorder()
end

function voxworld:getItem(id)
    return self._items[id] or error(id .. " does not exist")
end

function voxworld:rotate(r)
    self.rot = r

    for _,vox in ipairs(self._zordered) do
        vox:rotate(self.rot)
    end

    self:zorder()
end

function voxworld:zorder()
    table.sort(self._zordered, function(a,b)
        if a.z == b.z then
            local arx, ary = self:transformPoint(a.x, a.y, a.z)
            local brx, bry = self:transformPoint(b.x, b.y, b.z)
            return ary < bry
        else
            return a.z < b.z
        end
    end)
end

function voxworld:draw()
    for _,vox in ipairs(self._zordered) do
        local draw = true
        if vox.hide then
            local rot = (self.rot*180/math.pi) % 360 -- we want degrees, and we want them between 0 and 360 (exclusive)
            if vox.hide.min > vox.hide.max then
                draw = not (rot > vox.hide.min or rot < vox.hide.max)
            else
                draw = not (rot > vox.hide.min and rot < vox.hide.max)
            end
        end
        if draw then vox:draw(self:transformPoint(vox.x, vox.y, vox.z)) end
    end
end

return voxworld
