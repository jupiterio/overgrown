local voxworld = {}
local cd = (...):match("(.-)[^%.]+$")

local voxel = require(cd .. "voxel")

function voxworld.new(mfolder)
    local world = {}

    world._folder = mfolder
    world._items = {}
    world._zorder = {}

    return setmetatable(world, {__index = voxworld})
end

function voxworld:transformPoint(x, y, z)
    return x, (y-z*1.5)*0.577
end

function voxworld:add(id, options)
    options = options or {}
    if type(options.file) ~= "string" then error("options.file is required") end

    local vox = voxel.new(self._folder .. "/" .. options.file)

    vox.x = options.x or 0
    vox.y = options.y or 0
    vox.z = options.z or 0
    vox:rotate(options.r or 0)
    vox:origin(options.ox or 0, options.oy or 0)

    self._items[id] = vox
    table.insert(self._zorder, vox)

    return vox
end

function voxworld:move(id, x, y, z)
    local item = self:getItem(id)
    item.x = x
    item.y = y
    item.z = z
end

function voxworld:getItem(id)
    return self._items[id] or error(id .. " does not exist")
end

function voxworld:draw()
    for k,v in pairs(self._items) do
        v:draw(voxworld.transformPoint(v.x, v.y, v.z))
    end
end

return voxworld
