local class = require "com/class"

---@class BootScreen
---@overload fun():BootScreen
local BootScreen = class:derive("BootScreen")

local Vec2 = require("src/Essentials/Vector2")
local Button = require("src/Kernel/UI/Button")

local VersionManager = require("src/Kernel/VersionManager")

local BootMain = require("src/Kernel/Scene/BootMain")
local BootSettings = require("src/Kernel/Scene/BootSettings")



function BootScreen:new()
	self.versionManager = VersionManager()

	self.games = nil

	self.scene = nil
	self.sceneConstructors = {
		main = BootMain,
		settings = BootSettings
	}
end



function BootScreen:init()
	-- window title and size
	love.window.setTitle("OpenSMCE [" .. _VERSION .. "] - Boot Menu")

	-- game list
	self.games = self:getGames()

	-- init the main screen
	self:setScene("main")

	-- discord rpc connection
	_DiscordRPC:setStatus(string.format("Boot Screen - Version: %s (Build %s)", _VERSION_NAME, _BUILD_NUMBER), nil, true)
end



function BootScreen:setScene(name)
	self.scene = self.sceneConstructors[name](self)
	if self.scene.init then self.scene:init() end
end



function BootScreen:update(dt)
	self.scene:update(dt)
end



function BootScreen:draw()
	self.scene:draw()
end



function BootScreen:getGames()
	-- A given folder in the "games" folder is considered a valid game when it contains a "config.json" file with valid JSON structure.

	local games = {}

	for i, name in ipairs(_GetDirListing("games", "dir")) do
		_Log:printt("BootScreen", "Checking folder \"" .. name .. "\"...")
		local success, result = pcall(function() return _LoadJson("games/" .. name .. "/config.json") end)
		if success then
			table.insert(games, {name = name, config = result})
			_Log:printt("BootScreen", "SUCCESS!")
		else
			_Log:printt("BootScreen", "FAIL!")
		end
	end

	return games
end



function BootScreen:mousepressed(x, y, button)
	-- STUB
end

function BootScreen:mousereleased(x, y, button)
	self.scene:mousereleased(x, y, button)
end

function BootScreen:keypressed(key)
	-- STUB
end

function BootScreen:keyreleased(key)
	-- STUB
end

function BootScreen:textinput(t)
	-- STUB
end

return BootScreen
