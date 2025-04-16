local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👺Mylands Mining Cheat👺",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Myland denkt na⚙️🧠",
   LoadingSubtitle = "het is lastig",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Ultimate Mining Tycoon"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

Rayfield:Notify({
   Title = "Goed gedaan",
   Content = "Nigger",
   Duration = 2.5,
   Image = 4483362458,
})

local MainTab = Window:CreateTab("QOL", 4483362458) -- Title, Image
local MainSection = MainTab:CreateSection("Player")

local Slider = MainTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 500},
   Increment = 1,
   Suffix = nil,
   CurrentValue = 16,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Value)        
   end,
})

local Slider = MainTab:CreateSlider({
   Name = "Jump Power",
   Range = {7.2, 500},
   Increment = 1,
   Suffix = nil,
   CurrentValue = 7.2,
   Flag = "Slider2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpHeight = (Value)
   end,
})

local flying = false
local bv, bg
local speed = 50  -- Standaard vliegsnelheid

-- Fly Toggle
local Toggle = MainTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Flag = "Toggle1", 
   Callback = function(Value)
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoid = character:WaitForChild("Humanoid")
      local root = character:WaitForChild("HumanoidRootPart")
      local UserInputService = game:GetService("UserInputService")
      local RunService = game:GetService("RunService")

      if Value == true then
         flying = true
         humanoid.PlatformStand = true  -- Zet PlatformStand aan om bewegingen van het humanoid te blokkeren

         -- BodyVelocity: Hiermee geef je je character snelheid in de lucht
         bv = Instance.new("BodyVelocity")
         bv.Velocity = Vector3.zero
         bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)  -- Maximale kracht om de character in de lucht te houden
         bv.Parent = root

         -- BodyGyro: Hiermee geef je de character stabiliteit in de lucht
         bg = Instance.new("BodyGyro")
         bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
         bg.P = 10000
         bg.CFrame = root.CFrame
         bg.Parent = root

         -- Vliegt besturing via RenderStep
         RunService:BindToRenderStep("FlyControl", Enum.RenderPriority.Character.Value, function()
            if flying and bv and bg then
               local cam = workspace.CurrentCamera
               local move = Vector3.zero

               -- Beweging richting de camera (W, A, S, D)
               if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                  move += cam.CFrame.LookVector
               end
               if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                  move -= cam.CFrame.LookVector
               end
               if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                  move -= cam.CFrame.RightVector
               end
               if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                  move += cam.CFrame.RightVector
               end

               -- Beweging omhoog en omlaag (Space en LeftControl)
               if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                  move += cam.CFrame.UpVector
               end
               if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                  move -= cam.CFrame.UpVector
               end

               -- Als er beweging is, wordt de snelheid ingesteld
               if move.Magnitude > 0 then
                  bv.Velocity = move.Unit * speed  -- De snelheid wordt bepaald door de sliderwaarde
                  bg.CFrame = CFrame.new(root.Position, root.Position + move)
               else
                  bv.Velocity = Vector3.zero
               end
            end
         end)

      else
         flying = false
         humanoid.PlatformStand = false  -- Zet PlatformStand weer uit wanneer je stopt met vliegen

         -- Stop het vliegen door BodyVelocity en BodyGyro te verwijderen
         RunService:UnbindFromRenderStep("FlyControl")

         if bv then
            bv:Destroy()
            bv = nil
         end

         if bg then
            bg:Destroy()
            bg = nil
         end

         -- Zet de snelheid van de character op 0 en zet de velocity terug naar normaal
         root.Velocity = Vector3.zero
      end
   end,
})

-- Fly Speed Slider
local Slider = MainTab:CreateSlider({
   Name = "Fly Speed",  -- Naam van de slider
   Range = {10, 500},   -- Het bereik van de snelheid (minimaal 10, maximaal 200)
   Increment = 1,       -- Het incrementeerbedrag
   Suffix = "Speed",    -- Toevoeging bij de waarde, zoals "km/h"
   CurrentValue = speed,  -- Beginwaarde van de snelheid
   Flag = "Slider1",  -- Identificator voor de configuratie
   Callback = function(Value)
        if flying then
            speed = Value  -- Pas de snelheid van het vliegen aan als vliegen aanstaat
        end
   end,
})

local MainSection = MainTab:CreateSection("Mining")

local Button = MainTab:CreateButton({
   Name = "Refresh TNT",
   Callback = function()
   -- The function that takes place when the button is pressed
   end,
})

