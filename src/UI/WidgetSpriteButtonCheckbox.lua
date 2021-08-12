local class = require "com/class"
local UIWidgetSpriteButtonCheckbox = class:derive("UIWidgetSpriteButtonCheckbox")

local Vec2 = require("src/Essentials/Vector2")
local UIWidgetSpriteButton = require("src/UI/WidgetSpriteButton")

function UIWidgetSpriteButtonCheckbox:new(parent, sprites)
	self.type = "spriteButtonCheckbox"

	self.parent = parent
	self.button = UIWidgetSpriteButton(parent, sprites[1])

	self.state = false

	self.sprites = {game.resourceManager:getSprite(sprites[1]), game.resourceManager:getSprite(sprites[2])}
end

function UIWidgetSpriteButtonCheckbox:click()
	self.button:click()
end

function UIWidgetSpriteButtonCheckbox:unclick()
	if not self.button.clicked then return end
	self.button:unclick()
	self:setState(not self.state)
end

function UIWidgetSpriteButtonCheckbox:keypressed(key)
	self.button:keypressed(key)
end

function UIWidgetSpriteButtonCheckbox:setEnabled(enabled)
	self.button:setEnabled(enabled)
end

function UIWidgetSpriteButtonCheckbox:setState(state)
	self.state = state
	self.button.sprite = self.sprites[state and 2 or 1]
end



function UIWidgetSpriteButtonCheckbox:draw()
	self.button:draw()
end

return UIWidgetSpriteButtonCheckbox
