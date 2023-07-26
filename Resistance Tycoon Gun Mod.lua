-- This funny script can modify the starter "Five-Seven" gun. You can change whatever gun to the gun you own in the variable below
-- Made by XploitSDS team: https://www.youtube.com/@Xploitsds

local gun = "Five-Seven" -- Change this to any gun in your backpack

local player = game.Players.LocalPlayer
local gundata = require(game.Players.LocalPlayer.Backpack[gun].Setting) -- get gundata from module script inside backpack

local mods = {} -- list of available mods
for i,v in pairs(gundata) do
	if type(v) == "string" or type(v) == "number" or type(v) == "boolean" then -- too lazy to implement complex data types so this checks for strings, numbers and booleans
		table.insert(mods,i)
	end
end

local godgunmods = { -- preset for lazy people, feel free to modify or add stuff here
	-- mod critical damage because base damage does not seem to work
	CriticalDamageEnabled = true,
	CriticalDamageMultiplier = 100000000,
	CriticalBaseChance = 100,
	-- firerate
	Auto = true,
	FireRate = 0.01,
	-- ammo and reload
	AmmoPerMag = 100000000,
	ReloadTime = 0.01,
	ShotgunReload = false, -- shotgun does individual reload, do not enable this if you have a lot of ammo per mag
	-- explosion
	ExplosiveEnabled = true,
	ExplosionSoundEnabled = false, -- the default audio got deleted, so we have to disable this for explosion to work
	ExplosionRadius = 100,
}

local pipegunmods = { -- another example: Shoots pipes that are extremely loud
	CriticalDamageEnabled = true,
	CriticalDamageMultiplier = 100000000,
	CriticalBaseChance = 100,

	ExplosiveEnabled = true,
	ExplosionSoundIDs = {6729922069},
	ExplosionSoundVolume = 100,
	ExplosionRadius = 50,

	BulletTransparency = 0,
	BulletSize = Vector3.new(5,0.5,0.5),
	BulletShape = Enum.PartType.Cylinder,
	BulletColor = Color3.new(0.6,0.6,0.6),
	BulletMaterial = Enum.Material.Metal
}

local selectedmod = ""

-- Create GUI
local _, library = pcall(loadstring(game:HttpGet("https://raw.githubusercontent.com/Subject920/XploitHub/main/XPloitHubLibrary.lua"))) -- get the library

local window = library:CreateWindow("Resistance Tycoon Gun Mod")
local modtab = window:CreateTab("Gun Mod")
local cred = window:CreateTab("Credits")

local godgun = modtab:CreateButton("God gun (for lazy people)", function(val) -- mod the gun using the preset
	for i,v in pairs(godgunmods) do
		gundata[i] = v
	end
end)

local pipegun = modtab:CreateButton("Pipe gun (example)", function(val) -- mod the gun using the preset
	for i,v in pairs(pipegunmods) do
		gundata[i] = v
	end
end)

local selectmod = modtab:CreateDropdown("Select mod", mods, function(val)
	selectedmod = val
	local input, inputcontainer
	if type(gundata[val]) == "boolean" then -- if bool then use toggle
		input, inputcontainer = modtab:CreateToggle("Value (boolean)",gundata[val], function(boolval)
			gundata[val] = boolval
		end)
	else -- if string or number then use textbox for input
		input, inputcontainer = modtab:CreateTextbox("Value ("..type(gundata[val])..")", function(textval)
			if type(gundata[val]) == "number" then
				gundata[val] = tonumber(textval)
			else
				gundata[val] = textval
			end
		end, gundata[val])
	end
	repeat wait() until selectedmod ~= val
	inputcontainer:Destroy()
	input = nil
end)

--credits
local label = cred:CreateLabel("Interface : Xploit Library made by Code_Xploit")
local label = cred:CreateLabel("Scripting : Xploit SDS Team")

player.Character.Humanoid.Died:Connect(function()
	window:Destroy() -- remove window if player died
end)


