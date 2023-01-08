local class = require "com/class"

---@class UI2WidgetSpriteProgress
---@overload fun(parent, sprite, value, smooth):UI2WidgetSpriteProgress
local UI2WidgetSpriteProgress = class:derive("UI2WidgetSpriteProgress")



function UI2WidgetSpriteProgress:new(parent, sprite, align, value, smooth)
	self.type = "spriteProgress"

	self.parent = parent

	self.sprite = _Game.resourceManager:getSprite(sprite)
	self.size = self.sprite.img.size
	self.align = align
	self.value = 0
	self.valueData = value
	self.smooth = smooth
end

---Returns the current Widget's position.
---@return Vector2
function UI2WidgetSpriteProgress:getPos()
	return self.parent:getGlobalPos() - self:getSize() * self.align
end

---Returns the current Widget's size.
---@return Vector2
function UI2WidgetSpriteProgress:getSize()
	return self.size * self.parent:getGlobalScale()
end


function UI2WidgetSpriteProgress:update(dt)
	local value = _ParseNumber(self.valueData)
	if self.smooth then
		if self.value < value then
			self.value = math.min(self.value * 0.95 + value * 0.0501, value)
		elseif self.value > value then
			self.value = math.max(self.value * 0.95 + value * 0.0501, 0)
		end
	else
		self.value = value
	end
end

function UI2WidgetSpriteProgress:draw(variables)
	local pos = self:getPos()
	local pos2 = _PosOnScreen(pos)
	love.graphics.setScissor(pos2.x, pos2.y, self.size.x * _GetResolutionScale() * self.value, self.size.y * _GetResolutionScale())
	self.sprite:draw(pos, nil, nil, nil, nil, nil, self.parent:getGlobalAlpha())
	love.graphics.setScissor()
end

return UI2WidgetSpriteProgress
