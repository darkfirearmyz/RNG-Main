local Language = {
	AlreadyWearing = "You are already wearing that.",
	Bag = "Bag",
	Bag2 = "Opens or closes your bag.",
	Bracelet = "Bracelet",
	Ear = "Ear",
	Ear2 = "ear accessory",
	Glasses = "Glasses",
	Gloves = "Gloves",
	Hair = "Hair",
	Hair2 = "Put your hair up/down/in a bun/ponytail.",
	Hat = "Hat",
	Info = "Info",
	Information = "If the button is blue, you have a saved item.",
	Mask = "Mask",
	Neck = "Neck",
	Neck2 = "neck accessory",
	NotAllowedPed = "This ped model does not allow for this option.",
	NothingToRemove = "You dont appear to have anything to remove.",
	NoVariants = "There dont seem to be any variants for this.",
	Pants = "Pants",
	PleaseWait = "Please wait...",
	Shirt = "Shirt",
	Shoes = "Shoes",
	TakeOffOn = "Take your %s off/on.",
	Top = "Top",
	Top2 = "Toggle shirt variation.",
	Vest = "Vest",
	Visor = "Visor",
	Visor2 = "Toggle hat variation.",
	Watch = "Watch",
	NoShirtOn = "You cannot do this without your shirt on.",
	Reset = "Revert",
	Reset2 = "Revert everything back to normal.",
	Exit = "Close",
	-- Commands
	BAG = "bag",
	BRACELET = "bracelet",
	EAR = "ear",
	GLASSES = "glasses",
	GLOVES = "gloves",
	HAIR = "hair",
	HAT = "hat",
	MASK = "mask",
	NECK = "neck",
	SHOES = "shoes",
	TOP = "top",
	VEST = "vest",
	VISOR = "visor",
	WATCH = "watch",
	PANTS = "pants",
	SHIRT = "shirt",
	RESET = "revertclothing",
	BAGOFF = "bagoff",
}
local Bags = {				-- This is where bags/parachutes that should have the bag sprite, instead of the parachute sprite.
	[40] = true,
	[41] = true,
	[44] = true,
	[45] = true
}
function Lang(what)
	local Dict = Language
	if not Dict[what] then return Locale["en"][what] end -- If we cant find a translation, use the english one.
	return Dict[what]
end
local Commands = {
	[Lang("TOP")] = {
		Func = function() ToggleClothing("Top") end,
		Sprite = "top",
		Desc = Lang("Top2"),
		Button = 1,
		Name = Lang("Top")
	},
	[Lang("GLOVES")] = {
		Func = function() ToggleClothing("Gloves") end,
		Sprite = "gloves",
		Desc = string.format(Lang("TakeOffOn"), string.lower(Lang("Gloves"))),
		Button = 2,
		Name = Lang("Gloves")
	},
	[Lang("VISOR")] = {
		Func = function() ToggleProps("Visor") end,
		Sprite = "visor",
		Desc = Lang("Visor2"),
		Button = 3,
		Name = Lang("Visor")
	},
	[Lang("BAG")] = {
		Func = function() ToggleClothing("Bag") end,
		Sprite = "bag",
		Desc = Lang("Bag2"),
		Button = 8,
		Name = Lang("Bag")
	},
	[Lang("SHOES")] = {
		Func = function() ToggleClothing("Shoes") end,
		Sprite = "shoes",
		Desc = string.format(Lang("TakeOffOn"), string.lower(Lang("Shoes"))),
		Button = 5,
		Name = Lang("Shoes")
	},
	[Lang("VEST")] = {
		Func = function() ToggleClothing("Vest") end,
		Sprite = "vest",
		Desc = string.format(Lang("TakeOffOn"), string.lower(Lang("Vest"))),
		Button = 14,
		Name = Lang("Vest")
	},
	[Lang("HAIR")] = {
		Func = function() ToggleClothing("Hair") end,
		Sprite = "hair",
		Desc = Lang("Hair2"),
		Button = 7,
		Name = Lang("Hair")
	},
	[Lang("HAT")] = {
		Func = function() ToggleProps("Hat") end,
		Sprite = "hat",
		Desc = string.format(Lang("TakeOffOn"), string.lower(Lang("Hat"))),
		Button = 4,
		Name = Lang("Hat")
	},
	[Lang("GLASSES")] = {
		Func = function() ToggleProps("Glasses") end,
		Sprite = "glasses",
		Desc = string.format(Lang("TakeOffOn"), string.lower(Lang("Glasses"))),
		Button = 9,
		Name = Lang("Glasses")
	},
	[Lang("EAR")] = {
		Func = function() ToggleProps("Ear") end,
		Sprite = "ear",
		Desc = string.format(Lang("TakeOffOn"), string.lower(Lang("Ear2"))),
		Button = 10,
		Name = Lang("Ear")
	},
	[Lang("NECK")] = {
		Func = function() ToggleClothing("Neck") end,
		Sprite = "neck",
		Desc = string.format(Lang("TakeOffOn"), string.lower(Lang("Neck2"))),
		Button = 11,
		Name = Lang("Neck")
	},
	[Lang("WATCH")] = {
		Func = function() ToggleProps("Watch") end,
		Sprite = "watch",
		Desc = string.format(Lang("TakeOffOn"), string.lower(Lang("Watch"))),
		Button = 12,
		Name = Lang("Watch"),
		Rotation = 5.0
	},
	[Lang("BRACELET")] = {
		Func = function() ToggleProps("Bracelet") end,
		Sprite = "bracelet",
		Desc = string.format(Lang("TakeOffOn"), string.lower(Lang("Bracelet"))),
		Button = 13,
		Name = Lang("Bracelet")
	},
	[Lang("MASK")] = {
		Func = function() ToggleClothing("Mask") end,
		Sprite = "mask",
		Desc = string.format(Lang("TakeOffOn"), string.lower(Lang("Mask"))),
		Button = 6,
		Name = Lang("Mask")
	}
}

local ExtraCommands = {
	[Lang("PANTS")] = {
		Func = function() ToggleClothing("Pants", true) end,
		Sprite = "pants",
		Desc = string.format(Lang("TakeOffOn"), string.lower(Lang("Pants"))),
		Name = Lang("Pants"),
		OffsetX = -0.04,
		OffsetY = 0.0,
	},
	[Lang("SHIRT")] = {
		Func = function() ToggleClothing("Shirt", true) end,
		Sprite = "shirt",
		Desc = string.format(Lang("TakeOffOn"), string.lower(Lang("Shirt"))),
		Name = Lang("Shirt"),
		OffsetX = 0.04,
		OffsetY = 0.0,
	},
	[Lang("RESET")] = {
		Func = function() if not ResetClothing(true) then Notify(Lang("AlreadyWearing")) end end,
		Sprite = "reset",
		Desc = Lang("Reset2"),
		Name = Lang("Reset"),
		OffsetX = 0.12,
		OffsetY = 0.2,
		Rotate = true
	},
	["clothingexit"] = {
		Func = function() MenuOpened = false end,
		Sprite = "exit",
		Desc = "",
		Name = Lang("Exit"),
		OffsetX = 0.12,
		OffsetY = -0.2,
		Enabled = false
	},
	[Lang("BAGOFF")] = {
		Func = function() ToggleClothing("Bagoff", true) end,
		Sprite = "bagoff",
		SpriteFunc = function()
			local Bag = GetPedDrawableVariation(PlayerPedId(), 5)
			local BagOff = LastEquipped["Bagoff"]
			if LastEquipped["Bagoff"] then
				if Bags[BagOff.Drawable] then
					return "bagoff"
				else
					return "paraoff"
				end
			end
			if Bag ~= 0 then
				if Bags[Bag] then
					return "bagoff"
				else
					return "paraoff"
				end
			else
				return false
			end
		end,
		Desc = string.format(Lang("TakeOffOn"), string.lower(Lang("Bag"))),
		Name = Lang("Bag"),
		OffsetX = -0.12,
		OffsetY = 0.2,
	},
}



local Sounds = { -- In case you wanna change out the sounds they are located here.
	["Close"] = {"TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	["Open"] = {"NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	["Select"] = {"SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET"}
}
function Text(x, y, scale, text, colour, align, force, w)
    local align = align or 0
    local colour = colour or {255, 255, 255}
    SetTextFont(0)
    SetTextJustification(align)
    SetTextScale(scale, scale)
    SetTextColour(colour[1], colour[2], colour[3], 255)
    SetTextOutline()
    if w then SetTextWrap(w.x, w.y) end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function SoundPlay(which)
	local Sound = Sounds[which]
	PlaySoundFrontend(-1, Sound[1], Sound[2])
end

local function Distance(x1, y1, x2, y2)
	local dx = x1 - x2
	local dy = y1 - y2
	return math.sqrt(dx * dx + dy * dy)
end

local function DisableControl()
	DisableControlAction(1, 1, true)
	DisableControlAction(1, 2, true)
	DisableControlAction(1, 18, true)
	DisableControlAction(1, 68, true)
	DisableControlAction(1, 69, true)
	DisableControlAction(1, 70, true)
	DisableControlAction(1, 91, true)
	DisableControlAction(1, 92, true)
	DisableControlAction(1, 24, true)
	DisableControlAction(1, 25, true)
	DisableControlAction(1, 14, true)
	DisableControlAction(1, 15, true)
	DisableControlAction(1, 16, true)
	DisableControlAction(1, 17, true)
	DisablePlayerFiring(PlayerId(), true)	-- We wouldnt want the player punching by accident.
	ShowCursorThisFrame()
end

local function GetCursor() -- This might break for people with weird resolutions? Im really not sure.
	local sx, sy = GetActiveScreenResolution()
	local cx, cy = GetNuiCursorPosition()
	local cx, cy = (cx / sx) + 0.008, (cy / sy) + 0.027
	return cx, cy
end


local function DrawButton(b)
	local Rot = b.Rotate or 0.0
	if b.Shadow then
		DrawSprite("dp_clothing", "circle", b.x, b.y, b.Size.Circle.x/0.80, b.Size.Circle.y/0.80, Rot, b.Colour.r, b.Colour.g, b.Colour.b, b.Alpha)
	end
	DrawSprite("dp_clothing", b.Sprite, b.x, b.y, b.Size.Sprite.x/0.68, b.Size.Sprite.y/0.68, b.Rotation, 255, 255, 255, b.Alpha)
	if IsDisabledControlJustPressed(1, 24) then
		local x,y = GetCursor()
		local Distance = Distance(b.x+0.005, b.y+0.025, x, y)
		if Distance < 0.025 then return true end
	end
	return false
end

local function Check(ped) -- We check if the player should be able to open the menu.
	if IsPedInAnyVehicle(ped) then
		return false
	elseif IsPedSwimmingUnderWater(ped) then
		return false
	elseif IsPedRagdoll(ped) then
		return false
	elseif IsHudComponentActive(19) then -- If the weapon wheel is open, we close!
		return false
	end
	return true
end

local DefaultButton = {x = 0.0254, y = 0.0445}
local DefaultCircle = {x = 0.0345 / 1.2, y = 0.06 / 1.2}
local Buttons = {}
local ExtraButtons = {}
local InfoButtonRot = 0.0
MenuOpened = false

local function GenerateTheButtons() -- We generate the buttons here to save on a little bit of performance.
	local x, y, rx, ry = 0.65, 0.5, 0.1, 0.175
	for k,v in pairs(Commands) do
		local i = v.Button
		local Angle = i * math.pi / 7 local Ptx, Pty = x + rx * math.cos(Angle), y + ry * math.sin(Angle)
		Buttons[i] = {
			Command = k,
			Desc = v.Desc or "",
			Rotation = v.Rotation or 0.0,
			Size = {Sprite = DefaultButton},
			Sprite = v.Sprite,
			Text = v.Name,
			x = Ptx, y = Pty,
			Rotation = 0.0
		}
	end
	for k,v in pairs(ExtraCommands) do
		local Enabled = v.Enabled if Enabled == nil then Enabled = true end
		ExtraButtons[k] = {
			Command = k,
			Desc = v.Desc or "",
			OffsetX = v.OffsetX, OffsetY = v.OffsetY,
			Size = { Circle = {x = DefaultCircle.x, y = DefaultCircle.y}, Sprite = {x = DefaultButton.x/1.35, y = DefaultButton.y/1.35}},
			Sprite = v.Sprite,
			SpriteFunc = v.SpriteFunc,
			Text = v.Name,
			Enabled = Enabled,
			Rotate = v.Rotate,
			Rotation = 0.0
		}
	end
end

local function PushedButton(button, extra, rotate, info) -- https://www.youtube.com/watch?v=v57i1Ze0jB8
	Citizen.CreateThread(function()	
		SoundPlay("Select")
		local Button = nil
		if extra then Button = ExtraButtons[button] elseif info then Button = InfoButton else Button = Buttons[button] end
		if rotate then
			for i = 1, 18 do
				if not info then Button.Rotation = -i*20+0.0 Wait(1) else InfoButtonRot = -i*20+0.0 Wait(1) end
			end return
		end
		if not extra then
			Button.Size = {Sprite = {x = DefaultButton.x/1.1, y = DefaultButton.y/1.1}}
			Wait(100)
			Button.Size = {Sprite = {x = DefaultButton.x, y = DefaultButton.y}}
		else
			Button.Size = { Circle = {x = DefaultCircle.x, y = DefaultCircle.y}, Sprite = {x = DefaultButton.x/1.3/1.1, y = DefaultButton.y/1.3/1.1}}
			Wait(100)
			Button.Size = { Circle = {x = DefaultCircle.x, y = DefaultCircle.y}, Sprite = {x = DefaultButton.x/1.35, y = DefaultButton.y/1.35}}
		end
	end)
end

local function HoveredButton()
	local x,y = GetCursor()
	for k,v in pairs(Buttons) do
		local Distance = Distance(v.x+0.005, v.y+0.025, x, y)
		if Distance < 0.025 then
			Text(0.65, 0.5-0.10, 0.3, v.Text, false, false, true)
			Text(0.65, 0.5-0.08, 0.22, v.Desc, {210,210,210}, false, true, {x = 0.1, y = 0.2})
		end
	end
	for k,v in pairs(ExtraButtons) do
		if v.Enabled then
			local Distance = Distance(0.65+v.OffsetX+0.005, 0.5+v.OffsetY+0.025, x, y)
			local ShouldDisplay = true
			if v.SpriteFunc then
				local SpriteVar = v.SpriteFunc()
				if SpriteVar then
					ShouldDisplay = true
				else
					ShouldDisplay = false
				end
			end
			if ShouldDisplay then
				if Distance < 0.025 then
					Text(0.65, 0.5-0.10, 0.3, v.Text, false, false, true)
					Text(0.65, 0.5-0.08, 0.22, v.Desc, {210,210,210}, false, true, {x = 0.1, y = 0.2})
				end
			end
		end
	end
	local Distance = Distance(0.65+0.005, 0.5+0.025, x, y)
	if Distance < 0.015 then
		Text(0.65, 0.5-0.09, 0.3, Lang("Info"), false, false, true)
	end
end

--[[
		This is the function that draws the GUI, im using native DrawSprites and Texts.
		Its not the most efficient thing ms wise, but it does the job pretty well, and i dont have to bother with NUI HTML stuff.
		If you have any performance tips, let me know.
]]--

local function DrawGUI()
	DisableControl() -- Disable control while GUI is active.
	HoveredButton()	 -- This checks if you are hovering a button, and if you are it displays name and description.
	local x, y, rx, ry = 0.65, 0.5, 0.1, 0.175
	for k,v in pairs(Buttons) do
		local Colour local Alpha
		if LastEquipped[FirstUpper(v.Sprite)] then
			Alpha = 180 Colour = {r=0,g=100,b=210,a=220}
		else 
			Alpha = 255 Colour = {r=0,g=0,b=0,a=255}
		end
		DrawSprite("dp_wheel", k.."", x, y, 0.4285, 0.7714, 0.0, Colour.r, Colour.g, Colour.b, Colour.a)
		local Button = DrawButton({	-- Lets draw the buttons!
			Alpha = Alpha,
			Colour = Colour,
			Rotation = v.Rotation,
			Size = v.Size,
			Sprite = v.Sprite,
			Text = v.Text,
			x = v.x, y = v.y,
			Rotation = v.Rotation,
		})
		if Button and not Cooldown then	-- If the button is clicked we execute the command, just like if the player typed it in chat.
			if v.Sprite == "gloves" then
				if not LastEquipped["Shirt"] then
					PushedButton(k)  ExecuteCommand(v.Command)  
				else
					Notify(Lang("NoShirtOn"))
				end
			else
				PushedButton(k)  ExecuteCommand(v.Command)  
			end
			
		end
	end
	for k,v in pairs(ExtraButtons) do
		if v.Enabled then
			local Colour local Alpha
			if LastEquipped[FirstUpper(v.Sprite)] then
				Alpha = 180 Colour = {r=0,g=100,b=210,a=220}
			else 
				Alpha = 255 Colour = {r=0,g=0,b=0,a=255}
			end
			local sprite = v.Sprite
			if v.SpriteFunc then
				local SpriteVar = v.SpriteFunc()
				if SpriteVar then
					sprite = SpriteVar
				else
					sprite = false
				end
			end
			if sprite then
				local Button = DrawButton({
					Alpha = Alpha,
					Colour = Colour,
					Shadow = true,
					Size = v.Size,
					Sprite = sprite,
					Text = v.Text,
					x = x + v.OffsetX,
					y = y + v.OffsetY,
					Rotation = v.Rotation,
				})
				if Button and not Cooldown then
					PushedButton(k, true, v.Rotate) ExecuteCommand(v.Command)  
				end
			end
		end
	end
	if Cooldown then Text(x, y+0.05, 0.28, Lang("PleaseWait"), false, false, true) end 		-- Cooldown indicator, if theres a cooldown we display a little text.
	local InfoButton = DrawButton({
		Alpha = 255,
		Colour = {r=0,g=0,b=0},
		Shadow = true,
		Size = {Circle = {x = 0.0345, y = 0.06}, Sprite = {x = 0.0234, y = 0.0425}},
		Sprite = "info",
		Text = Lang("Info"),
		x = x, y = y,
		Rotation = InfoButtonRot,
	})
	if InfoButton then 			
		PushedButton(k, true, true, true)										
		Notify(Lang("Information"))
		for k,v in pairs(LastEquipped) do log(k.." : "..json.encode(v)) end		-- If the info button is pressed we log all "LastEquipped" items, for debugging purposes.
	end
end

local TextureDicts = {"dp_clothing", "dp_wheel"}
Citizen.CreateThread(function()
	for k,v in pairs(TextureDicts) do while not HasStreamedTextureDictLoaded(v) do Wait(100) RequestStreamedTextureDict(v, true) end end
	GenerateTheButtons()
	while true do Wait(0)
		if IsControlPressed(1, GetKey("Y")) and not (tvRP.isInComa() or tvRP.isStaffedOn()) then
			local Ped = PlayerPedId() 
			if Check(Ped) then MenuOpened = true end
		else MenuOpened = false end
		if IsControlJustPressed(1, GetKey("Y")) and not (tvRP.isInComa() or tvRP.isStaffedOn()) then
			local Ped = PlayerPedId() 
			if Check(Ped) then SoundPlay("Open") SetCursorLocation(0.65, 0.5) end
		elseif IsControlJustReleased(1, GetKey("Y")) then
			if Check(Ped) then MenuOpened = false SoundPlay("Close") end
		end
		if MenuOpened then DrawGUI() end
	end
end)




function AddNewVariation(which, gender, one, two, single)
	local Where = Variations[which][gender]
	if not single then
		Where[one] = two
		Where[two] = one
	else
		Where[one] = two
	end
end

Citizen.CreateThread(function()
	-- Male Visor/Hat Variations
	AddNewVariation("Visor", "Male", 9, 10)
	AddNewVariation("Visor", "Male", 18, 67)
	AddNewVariation("Visor", "Male", 82, 67)
	AddNewVariation("Visor", "Male", 44, 45)
	AddNewVariation("Visor", "Male", 50, 68)
	AddNewVariation("Visor", "Male", 51, 69)
	AddNewVariation("Visor", "Male", 52, 70)
	AddNewVariation("Visor", "Male", 53, 71)
	AddNewVariation("Visor", "Male", 62, 72)
	AddNewVariation("Visor", "Male", 65, 66)
	AddNewVariation("Visor", "Male", 73, 74)
	AddNewVariation("Visor", "Male", 76, 77)
	AddNewVariation("Visor", "Male", 79, 78)
	AddNewVariation("Visor", "Male", 80, 81)
	AddNewVariation("Visor", "Male", 91, 92)
	AddNewVariation("Visor", "Male", 104, 105)
	AddNewVariation("Visor", "Male", 109, 110)
	AddNewVariation("Visor", "Male", 116, 117)
	AddNewVariation("Visor", "Male", 118, 119)
	AddNewVariation("Visor", "Male", 123, 124)
	AddNewVariation("Visor", "Male", 125, 126)
	AddNewVariation("Visor", "Male", 127, 128)
	AddNewVariation("Visor", "Male", 130, 131)
	-- Female Visor/Hat Variations
	AddNewVariation("Visor", "Female", 43, 44)
	AddNewVariation("Visor", "Female", 49, 67)
	AddNewVariation("Visor", "Female", 64, 65)
	AddNewVariation("Visor", "Female", 65, 64)
	AddNewVariation("Visor", "Female", 51, 69)
	AddNewVariation("Visor", "Female", 50, 68)
	AddNewVariation("Visor", "Female", 52, 70)
	AddNewVariation("Visor", "Female", 62, 71)
	AddNewVariation("Visor", "Female", 72, 73)
	AddNewVariation("Visor", "Female", 75, 76)
	AddNewVariation("Visor", "Female", 78, 77)
	AddNewVariation("Visor", "Female", 79, 80)
	AddNewVariation("Visor", "Female", 18, 66)
	AddNewVariation("Visor", "Female", 66, 81)
	AddNewVariation("Visor", "Female", 81, 66)
	AddNewVariation("Visor", "Female", 86, 84)
	AddNewVariation("Visor", "Female", 90, 91)
	AddNewVariation("Visor", "Female", 103, 104)
	AddNewVariation("Visor", "Female", 108, 109)
	AddNewVariation("Visor", "Female", 115, 116)
	AddNewVariation("Visor", "Female", 117, 118)
	AddNewVariation("Visor", "Female", 122, 123)
	AddNewVariation("Visor", "Female", 124, 125)
	AddNewVariation("Visor", "Female", 126, 127)
	AddNewVariation("Visor", "Female", 129, 130)
	-- Male Bags
	AddNewVariation("Bags", "Male", 45, 44)
	AddNewVariation("Bags", "Male", 41, 40)
	-- Female Bags
	AddNewVariation("Bags", "Female", 45, 44)
	AddNewVariation("Bags", "Female", 41, 40)
	-- Male Hair
	AddNewVariation("Hair", "Male", 7, 15, true)
	AddNewVariation("Hair", "Male", 43, 15, true)
	AddNewVariation("Hair", "Male", 9, 43, true)
	AddNewVariation("Hair", "Male", 11, 43, true)
	AddNewVariation("Hair", "Male", 15, 43, true)
	AddNewVariation("Hair", "Male", 16, 43, true)
	AddNewVariation("Hair", "Male", 17, 43, true)
	AddNewVariation("Hair", "Male", 20, 43, true)
	AddNewVariation("Hair", "Male", 22, 43, true)
	AddNewVariation("Hair", "Male", 45, 43, true)
	AddNewVariation("Hair", "Male", 47, 43, true)
	AddNewVariation("Hair", "Male", 49, 43, true)
	AddNewVariation("Hair", "Male", 51, 43, true)
	AddNewVariation("Hair", "Male", 52, 43, true)
	AddNewVariation("Hair", "Male", 53, 43, true)
	AddNewVariation("Hair", "Male", 56, 43, true)
	AddNewVariation("Hair", "Male", 58, 43, true)
	-- Female Hair
	AddNewVariation("Hair", "Female", 1, 49, true)
	AddNewVariation("Hair", "Female", 2, 49, true)
	AddNewVariation("Hair", "Female", 7, 49, true)
	AddNewVariation("Hair", "Female", 9, 49, true)
	AddNewVariation("Hair", "Female", 10, 49, true)
	AddNewVariation("Hair", "Female", 11, 48, true)
	AddNewVariation("Hair", "Female", 14, 53, true)
	AddNewVariation("Hair", "Female", 15, 42, true)
	AddNewVariation("Hair", "Female", 21, 42, true)
	AddNewVariation("Hair", "Female", 23, 42, true)
	AddNewVariation("Hair", "Female", 31, 53, true)
	AddNewVariation("Hair", "Female", 39, 49, true)
	AddNewVariation("Hair", "Female", 40, 49, true)
	AddNewVariation("Hair", "Female", 42, 53, true)
	AddNewVariation("Hair", "Female", 45, 49, true)
	AddNewVariation("Hair", "Female", 48, 49, true)
	AddNewVariation("Hair", "Female", 49, 48, true)
	AddNewVariation("Hair", "Female", 52, 53, true)
	AddNewVariation("Hair", "Female", 53, 42, true)
	AddNewVariation("Hair", "Female", 54, 55, true)
	AddNewVariation("Hair", "Female", 59, 42, true)
	AddNewVariation("Hair", "Female", 59, 54, true)
	AddNewVariation("Hair", "Female", 68, 53, true)
	AddNewVariation("Hair", "Female", 76, 48, true)
	-- Male Top/Jacket Variations
	AddNewVariation("Jackets", "Male", 29, 30)
	AddNewVariation("Jackets", "Male", 31, 32)
	AddNewVariation("Jackets", "Male", 42, 43)
	AddNewVariation("Jackets", "Male", 68, 69)
	AddNewVariation("Jackets", "Male", 74, 75)
	AddNewVariation("Jackets", "Male", 87, 88)
	AddNewVariation("Jackets", "Male", 99, 100)
	AddNewVariation("Jackets", "Male", 101, 102)
	AddNewVariation("Jackets", "Male", 103, 104)
	AddNewVariation("Jackets", "Male", 126, 127)
	AddNewVariation("Jackets", "Male", 129, 130)
	AddNewVariation("Jackets", "Male", 184, 185)
	AddNewVariation("Jackets", "Male", 188, 189)
	AddNewVariation("Jackets", "Male", 194, 195)
	AddNewVariation("Jackets", "Male", 196, 197)
	AddNewVariation("Jackets", "Male", 198, 199)
	AddNewVariation("Jackets", "Male", 200, 203)
	AddNewVariation("Jackets", "Male", 202, 205)
	AddNewVariation("Jackets", "Male", 206, 207)
	AddNewVariation("Jackets", "Male", 210, 211)
	AddNewVariation("Jackets", "Male", 217, 218)
	AddNewVariation("Jackets", "Male", 229, 230)
	AddNewVariation("Jackets", "Male", 232, 233)
	AddNewVariation("Jackets", "Male", 251, 253)
	AddNewVariation("Jackets", "Male", 256, 261)
	AddNewVariation("Jackets", "Male", 262, 263)
	AddNewVariation("Jackets", "Male", 265, 266)
	AddNewVariation("Jackets", "Male", 267, 268)
	AddNewVariation("Jackets", "Male", 279, 280)
	-- Female Top/Jacket Variations
	AddNewVariation("Jackets", "Female", 53, 52) 
	AddNewVariation("Jackets", "Female", 57, 58) 
	AddNewVariation("Jackets", "Female", 62, 63) 
	AddNewVariation("Jackets", "Female", 90, 91) 
	AddNewVariation("Jackets", "Female", 92, 93) 
	AddNewVariation("Jackets", "Female", 94, 95) 
	AddNewVariation("Jackets", "Female", 187, 186)
	AddNewVariation("Jackets", "Female", 190, 191) 
	AddNewVariation("Jackets", "Female", 196, 197) 
	AddNewVariation("Jackets", "Female", 198, 199) 
	AddNewVariation("Jackets", "Female", 200, 201)
	AddNewVariation("Jackets", "Female", 202, 205) 
	AddNewVariation("Jackets", "Female", 204, 207) 
	AddNewVariation("Jackets", "Female", 210, 211)
	AddNewVariation("Jackets", "Female", 214, 215)
	AddNewVariation("Jackets", "Female", 227, 228) 
	AddNewVariation("Jackets", "Female", 239, 240) 
	AddNewVariation("Jackets", "Female", 242, 243) 
	AddNewVariation("Jackets", "Female", 259, 261)
	AddNewVariation("Jackets", "Female", 265, 270) 
	AddNewVariation("Jackets", "Female", 271, 272) 
	AddNewVariation("Jackets", "Female", 274, 275) 
	AddNewVariation("Jackets", "Female", 276, 277)
	AddNewVariation("Jackets", "Female", 292, 293) 
end)

-- And this is the master table, i put it down here since it has all the glove variations, and thats quite the eyesore.
-- You probably dont wanna touch anything down here really.
-- I generated these glove ones with a tool i made, im pretty certain its accurate, there might be native function for this.
-- If there is i wish i knew of it before i spent hours doing it this way.

Variations = {
	Jackets = {Male = {}, Female = {}},
	Hair = {Male = {}, Female = {}},
	Bags = {Male = {}, Female = {}},
	Visor = {Male = {}, Female = {}},
	Gloves = {
		Male = {
			[16] = 4,
			[17] = 4,
			[18] = 4,
			[19] = 0,
			[20] = 1,
			[21] = 2,
			[22] = 4,
			[23] = 5,
			[24] = 6,
			[25] = 8,
			[26] = 11,
			[27] = 12,
			[28] = 14,
			[29] = 15,
			[30] = 0,
			[31] = 1,
			[32] = 2,
			[33] = 4,
			[34] = 5,
			[35] = 6,
			[36] = 8,
			[37] = 11,
			[38] = 12,
			[39] = 14,
			[40] = 15,
			[41] = 0,
			[42] = 1,
			[43] = 2,
			[44] = 4,
			[45] = 5,
			[46] = 6,
			[47] = 8,
			[48] = 11,
			[49] = 12,
			[50] = 14,
			[51] = 15,
			[52] = 0,
			[53] = 1,
			[54] = 2,
			[55] = 4,
			[56] = 5,
			[57] = 6,
			[58] = 8,
			[59] = 11,
			[60] = 12,
			[61] = 14,
			[62] = 15,
			[63] = 0,
			[64] = 1,
			[65] = 2,
			[66] = 4,
			[67] = 5,
			[68] = 6,
			[69] = 8,
			[70] = 11,
			[71] = 12,
			[72] = 14,
			[73] = 15,
			[74] = 0,
			[75] = 1,
			[76] = 2,
			[77] = 4,
			[78] = 5,
			[79] = 6,
			[80] = 8,
			[81] = 11,
			[82] = 12,
			[83] = 14,
			[84] = 15,
			[85] = 0,
			[86] = 1,
			[87] = 2,
			[88] = 4,
			[89] = 5,
			[90] = 6,
			[91] = 8,
			[92] = 11,
			[93] = 12,
			[94] = 14,
			[95] = 15,
			[96] = 4,
			[97] = 4,
			[98] = 4,
			[99] = 0,
			[100] = 1,
			[101] = 2,
			[102] = 4,
			[103] = 5,
			[104] = 6,
			[105] = 8,
			[106] = 11,
			[107] = 12,
			[108] = 14,
			[109] = 15,
			[110] = 4,
			[111] = 4,
			[115] = 112,
			[116] = 112,
			[117] = 112,
			[118] = 112,
			[119] = 112,
			[120] = 112,
			[121] = 112,
			[122] = 113,
			[123] = 113,
			[124] = 113,
			[125] = 113,
			[126] = 113,
			[127] = 113,
			[128] = 113,
			[129] = 114,
			[130] = 114,
			[131] = 114,
			[132] = 114,
			[133] = 114,
			[134] = 114,
			[135] = 114,
			[136] = 15,
			[137] = 15,
			[138] = 0,
			[139] = 1,
			[140] = 2,
			[141] = 4,
			[142] = 5,
			[143] = 6,
			[144] = 8,
			[145] = 11,
			[146] = 12,
			[147] = 14,
			[148] = 112,
			[149] = 113,
			[150] = 114,
			[151] = 0,
			[152] = 1,
			[153] = 2,
			[154] = 4,
			[155] = 5,
			[156] = 6,
			[157] = 8,
			[158] = 11,
			[159] = 12,
			[160] = 14,
			[161] = 112,
			[162] = 113,
			[163] = 114,
			[165] = 4,
			[166] = 4,
			[167] = 4,
		},
		Female = {
			[16] = 11,
			[17] = 3,
			[18] = 3,
			[19] = 3,
			[20] = 0,
			[21] = 1,
			[22] = 2,
			[23] = 3,
			[24] = 4,
			[25] = 5,
			[26] = 6,
			[27] = 7,
			[28] = 9,
			[29] = 11,
			[30] = 12,
			[31] = 14,
			[32] = 15,
			[33] = 0,
			[34] = 1,
			[35] = 2,
			[36] = 3,
			[37] = 4,
			[38] = 5,
			[39] = 6,
			[40] = 7,
			[41] = 9,
			[42] = 11,
			[43] = 12,
			[44] = 14,
			[45] = 15,
			[46] = 0,
			[47] = 1,
			[48] = 2,
			[49] = 3,
			[50] = 4,
			[51] = 5,
			[52] = 6,
			[53] = 7,
			[54] = 9,
			[55] = 11,
			[56] = 12,
			[57] = 14,
			[58] = 15,
			[59] = 0,
			[60] = 1,
			[61] = 2,
			[62] = 3,
			[63] = 4,
			[64] = 5,
			[65] = 6,
			[66] = 7,
			[67] = 9,
			[68] = 11,
			[69] = 12,
			[70] = 14,
			[71] = 15,
			[72] = 0,
			[73] = 1,
			[74] = 2,
			[75] = 3,
			[76] = 4,
			[77] = 5,
			[78] = 6,
			[79] = 7,
			[80] = 9,
			[81] = 11,
			[82] = 12,
			[83] = 14,
			[84] = 15,
			[85] = 0,
			[86] = 1,
			[87] = 2,
			[88] = 3,
			[89] = 4,
			[90] = 5,
			[91] = 6,
			[92] = 7,
			[93] = 9,
			[94] = 11,
			[95] = 12,
			[96] = 14,
			[97] = 15,
			[98] = 0,
			[99] = 1,
			[100] = 2,
			[101] = 3,
			[102] = 4,
			[103] = 5,
			[104] = 6,
			[105] = 7,
			[106] = 9,
			[107] = 11,
			[108] = 12,
			[109] = 14,
			[110] = 15,
			[111] = 3,
			[112] = 3,
			[113] = 3,
			[114] = 0,
			[115] = 1,
			[116] = 2,
			[117] = 3,
			[118] = 4,
			[119] = 5,
			[120] = 6,
			[121] = 7,
			[122] = 9,
			[123] = 11,
			[124] = 12,
			[125] = 14,
			[126] = 15,
			[127] = 3,
			[128] = 3,
			[132] = 129,
			[133] = 129,
			[134] = 129,
			[135] = 129,
			[136] = 129,
			[137] = 129,
			[138] = 129,
			[139] = 130,
			[140] = 130,
			[141] = 130,
			[142] = 130,
			[143] = 130,
			[144] = 130,
			[145] = 130,
			[146] = 131,
			[147] = 131,
			[148] = 131,
			[149] = 131,
			[150] = 131,
			[151] = 131,
			[152] = 131,
			[154] = 153,
			[155] = 153,
			[156] = 153,
			[157] = 153,
			[158] = 153,
			[159] = 153,
			[160] = 153,
			[162] = 161,
			[163] = 161,
			[164] = 161,
			[165] = 161,
			[166] = 161,
			[167] = 161,
			[168] = 161,
			[169] = 15,
			[170] = 15,
			[171] = 0,
			[172] = 1,
			[173] = 2,
			[174] = 3,
			[175] = 4,
			[176] = 5,
			[177] = 6,
			[178] = 7,
			[179] = 9,
			[180] = 11,
			[181] = 12,
			[182] = 14,
			[183] = 129,
			[184] = 130,
			[185] = 131,
			[186] = 153,
			[187] = 0,
			[188] = 1,
			[189] = 2,
			[190] = 3,
			[191] = 4,
			[192] = 5,
			[193] = 6,
			[194] = 7,
			[195] = 9,
			[196] = 11,
			[197] = 12,
			[198] = 14,
			[199] = 129,
			[200] = 130,
			[201] = 131,
			[202] = 153,
			[203] = 161,
			[204] = 161,
			[206] = 3,
			[207] = 3,
			[208] = 3,
		}
	}
}

Locale = {}
Keys = { -- Who doesnt love a big old table of keys.
    [","] = 82, ["-"] = 84, ["."] = 81, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161,
    ["8"] = 162, ["9"] = 163, ["="] = 83, ["["] = 39, ["]"] = 40, ["A"] = 34, ["B"] = 29, ["BACKSPACE"] = 177, ["C"] = 26, ["CAPS"] = 137, 
    ["D"] = 9, ["DELETE"] = 178, ["UP"] = 172, ["DOWN"] = 173, ["E"] = 38, ["ENTER"] = 18, ["ESC"] = 322, ["F"] = 23, ["F1"] = 288, ["F10"] = 57, ["F2"] = 289,
    ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["G"] = 47, ["H"] = 74, ["HOME"] = 213, ["K"] = 311,
    ["L"] = 182, ["LEFT"] = 174, ["LEFTALT"] = 19, ["LEFTCTRL"] = 36, ["LEFTSHIFT"] = 21, ["M"] = 244, ["N"] = 249, ["N+"] = 96, ["N-"] = 97,
    ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118, ["NENTER"] = 201, ["P"] = 199, ["PAGEDOWN"] = 11,
    ["PAGEUP"] = 10, ["Q"] = 44, ["R"] = 45, ["RIGHT"] = 175, ["RIGHTCTRL"] = 70, ["S"] = 8, ["SPACE"] = 22, ["T"] = 245, ["TAB"] = 37,
    ["TOP"] = 27, ["U"] = 303, ["V"] = 0, ["W"] = 32, ["X"] = 73, ["Y"] = 246, ["Z"] = 20, ["~"] = 243,
}

function log(l) -- Just a simple logging thing, to easily log all kinds of stuff.
	if l == nil then print("nil") return end
	return
end

function GetKey(str)
	local Key = Keys[string.upper(str)]
	if Key then return Key else return false end
end

function IncurCooldown(ms)
	Citizen.CreateThread(function()
		Cooldown = true Wait(ms) Cooldown = false
	end)
end

-- This is my old implementation, unsure if its any better than above though, not sure if creating a thread as often as we do above is good? Time will tell i suppose.

--function IncurCooldown(ms)
--	Cooldown = ms
--end
--Citizen.CreateThread(function()
--	while true do Wait(500)
--		if Cooldown then
--			Wait(Cooldown)
--			Cooldown = false
--		end
--	end
--end)

function PairsKeys(t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0
	local iter = function ()
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]] end
	end
	return iter
end

function FirstUpper(str)
	return (str:gsub("^%l", string.upper))
end


function Notify(message) -- However you want your notifications to be shown, you can switch it up here.
	tvRP.notify(message)
end

function IsMpPed(ped)
	local Male = `mp_m_freemode_01` 
	local Female = `mp_f_freemode_01`
	local CurrentModel = GetEntityModel(ped)
	if CurrentModel == Male then return "Male" elseif CurrentModel == Female then return "Female" else return false end
end

RegisterNetEvent('dpc:EquipLast')
AddEventHandler('dpc:EquipLast', function()
	local Ped = PlayerPedId()
	for k,v in pairs(LastEquipped) do
		if v then
			if v.Drawable then SetPedComponentVariation(Ped, v.ID, v.Drawable, v.Texture, 0)
			elseif v.Prop then ClearPedProp(Ped, v.ID) SetPedPropIndex(Ped, v.ID, v.Prop, v.Texture, true) end
		end
	end
	LastEquipped = {}
end)

RegisterNetEvent('dpc:ResetClothing')
AddEventHandler('dpc:ResetClothing', function()
	LastEquipped = {}
end)

RegisterNetEvent('dpc:ToggleMenu')
AddEventHandler('dpc:ToggleMenu', function()
	MenuOpened = not MenuOpened
	if MenuOpened then SoundPlay("Open") SetCursorLocation(0.65, 0.5) else SoundPlay("Close") end
end)

RegisterNetEvent('dpc:Menu')
AddEventHandler('dpc:Menu', function(status)
	MenuOpened = status
	if MenuOpened then SoundPlay("Open") else SoundPlay("Close") end
end)

--[[

	These are the tables for all the info we will need when dealing with the functions.

	["Handle"] = {      			First we name it, this is the string that will be put in the command to be used with ToggleClothing, or ToggleProps.
		Drawable = 11,  			Then we assign its drawable/prop id. 
		Table = Variations.Jackets,	Then we assign its table found in Variations, if it has one, alternatively we can do.
									Table = {
										Standalone = true,
										Male = 34,
										Female = 35
									},
									Which makes it standalone, this example is for shoes, now when the player does the command it checks if they are currently wearing id 34.
									If they are not it takes the drawable off and saves the one they had equipped.

		Emote = {  							Hey lets do the Emote, Pretty self explanatory.
			Dict = "missmic4",				This is the dict of the emote.
			Anim = "michael_tux_fidget",	Anim of the emote.
			Move = 51,						The move type of the emote, 51 is upper body only so you can move, 0 does not allow you to move.
			Dur = 1500						Duration of the emote.
											Alternatively for the props theres a seperate emote for taking off/putting on the prop.
		}
	},

]]--

local Drawables = {
	["Top"] = {
		Drawable = 11,
		Table = Variations.Jackets,
		Emote = {Dict = "missmic4", Anim = "michael_tux_fidget", Move = 51, Dur = 1500}
	},
	["Gloves"] = {
		Drawable = 3,
		Table = Variations.Gloves,
		Remember = true,
		Emote = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200}
	},
	["Shoes"] = {
		Drawable = 6,
		Table = {Standalone = true, Male = 34, Female = 35},
		Emote = {Dict = "random@domestic", Anim = "pickup_low", Move = 0, Dur = 1200}
	},
	["Neck"] = {
		Drawable = 7,
		Table = {Standalone = true, Male = 0, Female = 0 },
		Emote = {Dict = "clothingtie", Anim = "try_tie_positive_a", Move = 51, Dur = 2100}
	},
	["Vest"] = {
		Drawable = 9,
		Table = {Standalone = true, Male = 0, Female = 0 },
		Emote = {Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200}
	},
	["Bag"] = {
		Drawable = 5,
		Table = Variations.Bags,
		Emote = {Dict = "anim@heists@ornate_bank@grab_cash", Anim = "intro", Move = 51, Dur = 1600}
	},
	["Mask"] = {
		Drawable = 1,
		Table = {Standalone = true, Male = 0, Female = 0 },
		Emote = {Dict = "mp_masks@standard_car@ds@", Anim = "put_on_mask", Move = 51, Dur = 800}
	},
	["Hair"] = {
		Drawable = 2,
		Table = Variations.Hair,
		Remember = true,
		Emote = {Dict = "clothingtie", Anim = "check_out_a", Move = 51, Dur = 2000}
	},
}

local Extras = {
	["Shirt"] = {
		Drawable = 11,
		Table = {
			Standalone = true, Male = 252, Female = 74,
			Extra = { 
						{Drawable = 8, Id = 15, Tex = 0, Name = "Extra Undershirt"},
			 			{Drawable = 3, Id = 15, Tex = 0, Name = "Extra Gloves"},
			 			{Drawable = 10, Id = 0, Tex = 0, Name = "Extra Decals"},
			  		}
			},
		Emote = {Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200}
	},
	["Pants"] = {
		Drawable = 4,
		Table = {Standalone = true, Male = 61, Female = 14},
		Emote = {Dict = "re@construction", Anim = "out_of_breath", Move = 51, Dur = 1300}
	},
	["Bagoff"] = {
		Drawable = 5,
		Table = {Standalone = true, Male = 0, Female = 0},
		Emote = {Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200}
	},
}

local Props = {
	["Visor"] = {
		Prop = 0,
		Variants = Variations.Visor,
		Emote = {
			On = {Dict = "mp_masks@standard_car@ds@", Anim = "put_on_mask", Move = 51, Dur = 600},
			Off = {Dict = "missheist_agency2ahelmet", Anim = "take_off_helmet_stand", Move = 51, Dur = 1200}
		}
	},
	["Hat"] = {
		Prop = 0,
		Emote = {
			On = {Dict = "mp_masks@standard_car@ds@", Anim = "put_on_mask", Move = 51, Dur = 600},
			Off = {Dict = "missheist_agency2ahelmet", Anim = "take_off_helmet_stand", Move = 51, Dur = 1200}
		}
	},
	["Glasses"] = {
		Prop = 1,
		Emote = {
			On = {Dict = "clothingspecs", Anim = "take_off", Move = 51, Dur = 1400},
			Off = {Dict = "clothingspecs", Anim = "take_off", Move = 51, Dur = 1400}
		}
	},
	["Ear"] = {
		Prop = 2,
		Emote = {
			On = {Dict = "mp_cp_stolen_tut", Anim = "b_think", Move = 51, Dur = 900},
			Off = {Dict = "mp_cp_stolen_tut", Anim = "b_think", Move = 51, Dur = 900}
		}
	},
	["Watch"] = {
		Prop = 6,
		Emote = {
			On = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
			Off = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200}
		}
	},
	["Bracelet"] = {
		Prop = 7,
		Emote = {
			On = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
			Off = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200}
		}
	},
}

LastEquipped = {}
Cooldown = false

local function PlayToggleEmote(e, cb)
	local Ped = PlayerPedId()
	while not HasAnimDictLoaded(e.Dict) do RequestAnimDict(e.Dict) Wait(100) end
	if IsPedInAnyVehicle(Ped) then e.Move = 51 end
	TaskPlayAnim(Ped, e.Dict, e.Anim, 3.0, 3.0, e.Dur, e.Move, 0, false, false, false)
	local Pause = e.Dur-500 if Pause < 500 then Pause = 500 end
	IncurCooldown(Pause)
	Wait(Pause) -- Lets wait for the emote to play for a bit then do the callback.
	cb()
end

function ResetClothing(anim)
	local Ped = PlayerPedId()
	local e = Drawables.Top.Emote
	if anim then TaskPlayAnim(Ped, e.Dict, e.Anim, 3.0, 3.0, 3000, e.Move, 0, false, false, false) end
	for k,v in pairs(LastEquipped) do
		if v then
			if v.Drawable then SetPedComponentVariation(Ped, v.Id, v.Drawable, v.Texture, 0)
			elseif v.Prop then ClearPedProp(Ped, v.Id) SetPedPropIndex(Ped, v.Id, v.Prop, v.Texture, true) end
		end
	end
	LastEquipped = {}
end

function ToggleClothing(which, extra)
	if Cooldown then return end
	local Toggle = Drawables[which] if extra then Toggle = Extras[which] end
	local Ped = PlayerPedId()
	local Cur = { -- Lets check what we are currently wearing.
		Drawable = GetPedDrawableVariation(Ped, Toggle.Drawable), 
		Id = Toggle.Drawable,
		Ped = Ped,
		Texture = GetPedTextureVariation(Ped, Toggle.Drawable),
	}
	local Gender = IsMpPed(Ped)
	if which ~= "Mask" then
		if not Gender then Notify(Lang("NotAllowedPed")) return false end -- We cancel the command here if the person is not using a multiplayer model.
	end
	local Table = Toggle.Table[Gender]
	if not Toggle.Table.Standalone then -- "Standalone" is for things that dont require a variant, like the shoes just need to be switched to a specific drawable. Looking back at this i should have planned ahead, but it all works so, meh!
		for k,v in pairs(Table) do
			if not Toggle.Remember then
				if k == Cur.Drawable then
					PlayToggleEmote(Toggle.Emote, function() SetPedComponentVariation(Ped, Toggle.Drawable, v, Cur.Texture, 0) end) return true
				end
			else
				if not LastEquipped[which] then
					if k == Cur.Drawable then
						PlayToggleEmote(Toggle.Emote, function() LastEquipped[which] = Cur SetPedComponentVariation(Ped, Toggle.Drawable, v, Cur.Texture, 0) end) return true
					end
				else
					local Last = LastEquipped[which]
					PlayToggleEmote(Toggle.Emote, function() SetPedComponentVariation(Ped, Toggle.Drawable, Last.Drawable, Last.Texture, 0) LastEquipped[which] = false end) return true
				end
			end
		end
		Notify(Lang("NoVariants")) return
	else
		if not LastEquipped[which] then
			if Cur.Drawable ~= Table then 
				PlayToggleEmote(Toggle.Emote, function()
					LastEquipped[which] = Cur
					SetPedComponentVariation(Ped, Toggle.Drawable, Table, 0, 0)
					if Toggle.Table.Extra then
						local Extras = Toggle.Table.Extra
						for k,v in pairs(Extras) do
							local ExtraCur = {Drawable = GetPedDrawableVariation(Ped, v.Drawable),  Texture = GetPedTextureVariation(Ped, v.Drawable), Id = v.Drawable}
							SetPedComponentVariation(Ped, v.Drawable, v.Id, v.Tex, 0)
							LastEquipped[v.Name] = ExtraCur
						end
					end
				end)
				return true
			end
		else
			local Last = LastEquipped[which]
			PlayToggleEmote(Toggle.Emote, function()
				SetPedComponentVariation(Ped, Toggle.Drawable, Last.Drawable, Last.Texture, 0)
				LastEquipped[which] = false
				if Toggle.Table.Extra then
					local Extras = Toggle.Table.Extra
					for k,v in pairs(Extras) do
						if LastEquipped[v.Name] then
							local Last = LastEquipped[v.Name]
							SetPedComponentVariation(Ped, Last.Id, Last.Drawable, Last.Texture, 0)
							LastEquipped[v.Name] = false
						end
					end
				end
			end)
			return true
		end
	end
	Notify(Lang("AlreadyWearing")) return false
end

function ToggleProps(which)
	if Cooldown then return end
	local Prop = Props[which]
	local Ped = PlayerPedId()
	local Gender = IsMpPed(Ped)
	local Cur = { -- Lets get out currently equipped prop.
		Id = Prop.Prop,
		Ped = Ped,
		Prop = GetPedPropIndex(Ped, Prop.Prop), 
		Texture = GetPedPropTextureIndex(Ped, Prop.Prop),
	}
	if not Prop.Variants then
		if Cur.Prop ~= -1 then -- If we currently are wearing this prop, remove it and save the one we were wearing into the LastEquipped table.
			PlayToggleEmote(Prop.Emote.Off, function() LastEquipped[which] = Cur ClearPedProp(Ped, Prop.Prop) end) return true
		else
			local Last = LastEquipped[which] -- Detect that we have already taken our prop off, lets put it back on.
			if Last then
				PlayToggleEmote(Prop.Emote.On, function() SetPedPropIndex(Ped, Prop.Prop, Last.Prop, Last.Texture, true) end) LastEquipped[which] = false return true
			end
		end
		Notify(Lang("NothingToRemove")) return false
	else
		local Gender = IsMpPed(Ped)
		if not Gender then Notify(Lang("NotAllowedPed")) return false end -- We dont really allow for variants on ped models, Its possible, but im pretty sure 95% of ped models dont really have variants.
		local Variations = Prop.Variants[Gender]
		for k,v in pairs(Variations) do
			if Cur.Prop == k then
				PlayToggleEmote(Prop.Emote.On, function() SetPedPropIndex(Ped, Prop.Prop, v, Cur.Texture, true) end) return true
			end
		end
		Notify(Lang("NoVariants")) return false
	end
end

function DrawDev() -- Draw text for all the stuff we are wearing, to make grabbing the variants of stuff much simpler for people.
	local Entries = {}
	for k,v in PairsKeys(Drawables) do table.insert(Entries, { Name = k, Drawable = v.Drawable }) end
	for k,v in PairsKeys(Extras) do table.insert(Entries, { Name = k, Drawable = v.Drawable }) end
	for k,v in PairsKeys(Props) do table.insert(Entries, { Name = k, Prop = v.Prop }) end
	for k,v in pairs(Entries) do
		local Ped = PlayerPedId() local Cur
		if v.Drawable then
			Cur = { Id = GetPedDrawableVariation(Ped, v.Drawable),  Texture = GetPedTextureVariation(Ped, v.Drawable) }
		elseif v.Prop then
			Cur = { Id = GetPedPropIndex(Ped, v.Prop),  Texture = GetPedPropTextureIndex(Ped, v.Prop) }
		end
		Text(0.2, 0.8*k/18, 0.30, "~o~"..v.Name.."~w~ = \n     ("..Cur.Id.." , "..Cur.Texture..")", false, 1)
		DrawRect(0.23, 0.8*k/18+0.025, 0.07, 0.045, 0, 0, 0, 150)
	end
end

local TestThreadActive = nil
function DevTestVariants(d) -- If debug mode is enabled we can try all the variants to check for scuff.
	if not TestThreadActive then
		Citizen.CreateThread(function()
			TestThreadActive = true
			local Ped = PlayerPedId()
			local Drawable = Drawables[d]
			local Prop = Props[d]
			local Gender = IsMpPed(Ped)
			if Drawable then
				if Drawable.Table then
					if type(Drawable.Table[Gender]) == "table" then
						for k,v in PairsKeys(Drawable.Table[Gender]) do
							Notify(d.." : ~o~"..k)
							SoundPlay("Open")
							SetPedComponentVariation(Ped, Drawable.Drawable, k, 0, 0)
							Wait(300)
							Notify(d.." : ~b~"..v)
							SoundPlay("Close")
							SetPedComponentVariation(Ped, Drawable.Drawable, v, 0, 0)
							Wait(300)
						end
					end
				end
			elseif Prop then
				if Prop.Variants then
					for k,v in PairsKeys(Prop.Variants[Gender]) do
						Notify(d.." : ~o~"..k)
						SoundPlay("Open")
						SetPedPropIndex(Ped, Prop.Prop, k, 0, true)
						Wait(300)
						Notify(d.." : ~b~"..v)
						SoundPlay("Close")
						SetPedPropIndex(Ped, Prop.Prop, v, 0, true)
						Wait(300)
						ClearPedProp(Ped, Prop.Prop)
						Wait(200)
					end
				end
			end
			TestThreadActive = false
		end)
	else
		Notify("Already testing variants.")
	end
end

for k,v in pairs(Commands) do
    RegisterCommand(k, function(source, args, rawCommand)
        local player = PlayerId()
        local isDead = IsPlayerDead(player)
        if not (tvRP.isInComa() or tvRP.isStaffedOn()) then
            v.Func(source, args, rawCommand)
        else
            tvRP.notify("~r~Unable to do this right now.")
        end
    end, false)
    TriggerEvent("chat:addSuggestion", "/"..k, v.Desc)
end

for k,v in pairs(ExtraCommands) do
	RegisterCommand(k, function(source, args, rawCommand)
		local player = PlayerId()
		local isDead = IsPlayerDead(player)
		if not (tvRP.isInComa() or tvRP.isStaffedOn()) then
			v.Func(source, args, rawCommand)
		else
			tvRP.notify("~r~Unable to do this right now.")
		end
	end, false)
	TriggerEvent("chat:addSuggestion", "/"..k, v.Desc)
end


AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		ResetClothing()
	end
end)