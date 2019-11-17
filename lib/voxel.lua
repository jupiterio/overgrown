local voxel = {}
local cd = (...):match("(.-)[^%.]+$")

local vox_model = require(cd .. "vox_model")
local vox_texture = require(cd .. "vox_texture")

function voxel.new(filename)
    local vox = {}

    local data, err = love.filesystem.read(filename)
    if data == nil then error(filename .. ": " .. err) end
    vox.model = vox_model.new(data) -- parses and gets info from file

    vox.tex = vox_texture.new(vox.model) -- slices the model and puts texture into canvas
    local image = love.graphics.newImage(vox.tex.canvas:newImageData())
    image:setFilter("nearest", "nearest")

    vox.batch = love.graphics.newSpriteBatch(image) 

    vox.quads = {}
    for i=1,vox.model.sizeZ do
        local quad = love.graphics.newQuad(vox.model.sizeX*(i-1), 0, vox.model.sizeX, vox.model.sizeY, image:getDimensions())
        table.insert(vox.quads, quad)
    end

    vox.canvas = love.graphics.newCanvas()

    vox._transform = {
        r=0,
        sx=1,
        sy=1,
        orx=1,
        ory=1
    }

    return setmetatable(vox, {__index=voxel})
end

function voxel:transform(r, sx, sy, orx, ory)
    self._transform.r = r or self._transform.r
    self._transform.sx = sx or self._transform.sx
    self._transform.sy = sy or self._transform.sy
    self._transform.orx = orx or self._transform.orx
    self._transform.ory = ory or self._transform.ory

    self.batch:clear()

    local orx, ory = self._transform.orx, self._transform.ory
    for i=1,#self.quads*4 do
        local quad = self.quads[math.ceil(i/4)]
        self.batch:add(quad, 0, -i/4*1.5, self._transform.r, 1, 1, self.model.sizeX*orx, self.model.sizeY*ory)
    end
end

function voxel:rotate(r)
    self:transform(r)
end

function voxel:scale(sx, sy)
    self:transform(nil, sx, sy)
end

function voxel:origin(ox, oy)
    self:transform(nil, nil, nil, ox, oy)
end

function voxel:getRotation()
    return self._transform.r
end

function voxel:getScale()
    return self._transform.sx, self._transform.sy
end

function voxel:getOrigin()
    return self._transform.ox, self._transform.oy
end

function voxel:draw(x, y)
    love.graphics.push()

    x = x or 0
    y = y or 0
    local sx = self._transform.sx
    local sy = self._transform.sy

    love.graphics.draw(self.batch, x, y, 0, sx, 0.577*sy)

    love.graphics.pop()
end

return voxel
