local class = require "com/class"

---@class UI2WidgetSprite
---@overload fun(parent, sprite):UI2WidgetSprite
local UI2WidgetSprite = class:derive("UI2WidgetSprite")


---Constructs a new Sprite Widget.
---@param parent UI2Node The Node this Sprite is bound to.
---@param align Vector2 This Sprite's alignment.
function UI2WidgetSprite:new(parent, sprite, align)
	self.type = "sprite"

	self.parent = parent

	self.align = align

	self.sprite = _Game.resourceManager:getSprite(sprite)
	self.size = self.sprite.size
end

---Returns the current Widget's position.
---@return Vector2
function UI2WidgetSprite:getPos()
	return self.parent:getGlobalPos() - self:getSize() * self.align
end

---Returns the current Widget's size.
---@return Vector2
function UI2WidgetSprite:getSize()
	return self.size * self.parent:getGlobalScale()
end

---Draws this Widget on the screen.
function UI2WidgetSprite:draw()
	self.sprite:draw(self:getPos(), nil, nil, nil, nil, nil, self.parent:getGlobalAlpha())
end

return UI2WidgetSprite
