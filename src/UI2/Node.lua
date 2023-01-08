local class = require "com/class"

---@class UI2Node
---@overload fun(config):UI2Node
local UI2Node = class:derive("UI2Node")

-- Place your imports here
local UI2WidgetRectangle = require("src/UI2/WidgetRectangle")
local UI2WidgetSprite = require("src/UI2/WidgetSprite")
--local UI2WidgetSpriteButton = require("src/UI2/WidgetSpriteButton")
--local UI2WidgetSpriteButtonCheckbox = require("src/UI2/WidgetSpriteButtonCheckbox")
--local UI2WidgetSpriteButtonSlider = require("src/UI2/WidgetSpriteButtonSlider")
local UI2WidgetSpriteProgress = require("src/UI2/WidgetSpriteProgress")

local Vec2 = require("src/Essentials/Vector2")



---Constructs a new UI2Node.
---@param config UI2NodeConfig The UI2 Node Config which describes this Node.
---@param name string Specifies the name of this Node. Should match with this Parent's child of this name, or "root" / "splash" if no parent specified.
---@param parent UI2Node? The UI2 Node which is a parent of this Node. If not specified, this will be a root node.
function UI2Node:new(config, name, parent)
    self.config = config
    self.name = name
    self.parent = parent

    -- Data
    self.pos = config.pos
    self.scale = config.scale
    self.alpha = config.alpha

    -- Children
    self.children = {}
    for childN, child in pairs(config.children) do
        local childConfig = child
        if type(childConfig) == "string" then
            -- Load from another file.
            childConfig = _Game.configManager:getUI2Layout(childConfig)
        end
        self.children[childN] = UI2Node(childConfig, childN, self)
    end

    -- Widget
    local w = config.widget
    if w then
        if w.type == "rectangle" then
            self.widget = UI2WidgetRectangle(self, w.align, w.size, w.color)
        elseif w.type == "sprite" then
            self.widget = UI2WidgetSprite(self, w.sprite, w.align)
        elseif w.type == "spriteProgress" then
            self.widget = UI2WidgetSpriteProgress(self, w.sprite, w.align, w.value, w.smooth)
        end
    end
end



---Returns the current effective position of this Node.
---@return Vector2
function UI2Node:getGlobalPos()
    if not self.parent then
        return self.pos
    end
    return self.parent:getGlobalPos() + self.pos
end



---Returns the current effective scale of this Node.
---@return Vector2
function UI2Node:getGlobalScale()
    if not self.parent then
        return self.scale
    end
    return self.parent:getGlobalScale() * self.scale
end



---Returns the current effective alpha value of this Node.
---@return number
function UI2Node:getGlobalAlpha()
    if not self.parent then
        return self.alpha
    end
    return self.parent:getGlobalAlpha() * self.alpha
end



---Draws this Node and its children.
function UI2Node:draw()
    if self.widget then
        self.widget:draw()
    end
    for childN, child in pairs(self.children) do
        child:draw()
    end
end



---Debug function. Prints this Widget's tree.
---@param depth number? Used in recursion.
function UI2Node:printTree(depth)
    depth = depth or 0
    local s = ""
    for i = 1, depth do
        s = s .. "    "
    end
    s = s .. self.name
    print(s)
    for childN, child in pairs(self.children) do
        child:printTree(depth + 1)
    end
end



return UI2Node