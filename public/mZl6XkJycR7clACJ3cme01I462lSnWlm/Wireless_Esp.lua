local esp_library = { cache  = {};  icache = {}; storeplayer = {} ; storeobject = {} ; loops = {}}

local RunService = game:GetService("RunService")
local lighting = game:GetService("Lighting");
local UserInputService = game:GetService("UserInputService")
local Mouse = game.UserInputService:GetMouseLocation() 
local camera = game.Workspace.CurrentCamera
local Players = game:GetService( "Players" );
local imagedata = game:HttpGet("https://i.imgur.com/YtRA29s.png")

function iwannadrawthis(Type , Options)
    local Object = Drawing.new(Type)

    for Property, Value in pairs(Options) do
        Object[Property] = Value
    end

    return Object
end

local function BoxMath(Torso) -- Pasted from amongus hook and bbot v2 X3
    local vTop = Torso.Position + (Torso.CFrame.UpVector * 1.8) + camera.CFrame.UpVector
    local vBottom = Torso.Position - (Torso.CFrame.UpVector * 2.5) - camera.CFrame.UpVector

    local top, topIsRendered = camera:WorldToViewportPoint(vTop)
    local bottom, bottomIsRendered = camera:WorldToViewportPoint(vBottom)

    local _width = math.max(math.floor(math.abs(top.x - bottom.x)), 3)
    local _height = math.max(math.floor(math.max(math.abs(bottom.y - top.y), _width / 2)), 3)
    local boxSize = Vector2.new(math.floor(math.max(_height / 1.5, _width)), _height)
    local boxPosition = Vector2.new(math.floor(top.x * 0.5 + bottom.x * 0.5 - boxSize.x * 0.5), math.floor(math.min(top.y, bottom.y)))

    return boxPosition, boxSize , (topIsRendered or bottomIsRendered)
end

local function BoxMath2(Torso) -- Pasted from amongus hook and bbot v2 X3
    local vTop = Torso

    local top, topIsRendered = camera:WorldToViewportPoint(vTop)

    local boxPosition = Vector2.new(top.X , top.Y)

    return boxPosition, topIsRendered
end

function esp_library.returndraw( )
    return {
        Box = Drawing.new("Square");
        Box_Outline =  Drawing.new("Square");
        Health = iwannadrawthis("Square" , { Color = Color3.new(0.011764705882352941, 0.6392156862745098, 0.011764705882352941) , Filled = true });
        Health_Outline =  Drawing.new("Square");
        Health_Fill =  Drawing.new("Square");
        WeaponText =  iwannadrawthis("Text" , {Size = 16, Font = 1 ,  Outline = true , Center = true , Color = Color3.new(1,1,1) });
        HealthText =  iwannadrawthis("Text" , {Size = 16, Font = 1 ,  Outline = true , Center = true , Color = Color3.new(1,1,1) });
        NameText =  iwannadrawthis("Text" , {Size = 16, Font = 1 , Outline = true , Center = true , Color = Color3.new(1,1,1) });
        DistanceText = iwannadrawthis("Text" , {Size = 16, Font = 1 , Outline = true , Center = false , Color = Color3.new(1,1,1) });
        LookVector = iwannadrawthis("Line" , {Color = Color3.new(1,1,1) , Thickness = 1});
        -- skeleton shit

        Head_UpperTorso = iwannadrawthis("Line" , {Color = Color3.new(1,1,1) , Thickness = 1});
        UpperTorso_LowerTorso = iwannadrawthis("Line" , {Color = Color3.new(1,1,1) , Thickness = 1});
        -- Left Arm
        UpperTorso_LeftUpperArm = iwannadrawthis("Line" , {Color = Color3.new(1,1,1) , Thickness = 1});
        LeftUpperArm_LeftLowerArm = iwannadrawthis("Line" , {Color = Color3.new(1,1,1) , Thickness = 1});
        LeftLowerArm_LeftHand = iwannadrawthis("Line" , {Color = Color3.new(1,1,1) , Thickness = 1});
        -- Right Arm
        UpperTorso_RightUpperArm = iwannadrawthis("Line" , {Color = Color3.new(1,1,1) , Thickness = 1});
        RightUpperArm_RightLowerArm = iwannadrawthis("Line" , {Color = Color3.new(1,1,1) , Thickness = 1});
        RightLowerArm_RightHand = iwannadrawthis("Line" , {Color = Color3.new(1,1,1) , Thickness = 1});
        -- Left Leg
        LowerTorso_LeftUpperLeg = iwannadrawthis("Line" , {Color = Color3.new(1,1,1) , Thickness = 1});
        LeftUpperLeg_LeftLowerLeg = iwannadrawthis("Line" , {Color = Color3.new(1,1,1) , Thickness = 1});
        LeftLowerLeg_LeftFoot = iwannadrawthis("Line" , {Color = Color3.new(1,1,1) , Thickness = 1});
        -- Right Leg
        LowerTorso_RightUpperLeg = iwannadrawthis("Line" , {Color = Color3.new(1,1,1) , Thickness = 1});
        RightUpperLeg_RightLowerLeg = iwannadrawthis("Line" , {Color = Color3.new(1,1,1) , Thickness = 1});
        RightLowerLeg_RightFoot = iwannadrawthis("Line" , {Color = Color3.new(1,1,1) , Thickness = 1});
    }
end

function esp_library.returndrawi( )
    return {
        NameText =  iwannadrawthis("Text" , {Size = 16, Font = 1 , Outline = true , Center = true , Color = Color3.new(1,1,1) });
        DistanceText = iwannadrawthis("Text" , {Size = 16, Font = 1 , Outline = true , Center = false , Color = Color3.new(1,1,1) });
    }
end

function esp_library.start(  )
    
    local function newrender( player )
        local esptable = esp_library.returndraw( );

        esp_library.cache[player] = esptable
    end

    local function getridofit( esptable , plr )

        local Data = esptable
    
        if (Data) then
            esptable = nil
    
            for i,v in pairs(Data) do
                v:Destroy()
                Data[i] = nil
            end
        end
        if esp_library.cache[plr] then
            esp_library.cache[plr] = nil
        end
    end

    local function idontwannaseeit( esptable )
        local Data = esptable
    
        if (Data) then
            esptable = nil
    
            for i,v in pairs(Data) do
                v.Visible = false
            end
        end
    end

    local function getweaponfromcharacter( character )
        for _i , Value in pairs(character:GetChildren()) do
            if Value.Name ~= "HolsterModel" and Value:IsA("Model") and Value.Name ~= "Hair" and (Value:FindFirstChild("Detail") or Value:FindFirstChild("Main") or Value:FindFirstChild("Handle") or Value:FindFirstChild("Attachments") or Value:FindFirstChild("ArrowAttach") or Value:FindFirstChild("Attach")  ) and Value.PrimaryPart then
                return Value.Name
            end
        end
    
        return "None"
    end 

    local function fuckthisshit( player )
        if not esp_library.storeplayer[player] then
            esp_library.storeplayer[player] = player
        end



        if esp_library.storeplayer[player] then

            if Players:FindFirstChild( player.Name ) then 
            else
                esp_library.storeplayer[player] = nil 
            end

            if not player.Character then return true end

            if not player.Character:FindFirstChild("Humanoid") then return true end

            if not player.Character:FindFirstChild("HumanoidRootPart") then return true end

            if player == game.Players.LocalPlayer then return true end
            if player.Name == game.Players.LocalPlayer.Name then return true end
            if player.Character == game.Players.LocalPlayer.Character then return true end

            local HRP = player.Character:FindFirstChild("HumanoidRootPart");
            local HP = player.Character:FindFirstChild("Humanoid")

            local _3DPOS = HRP.Position
            local distance = (_3DPOS - workspace.CurrentCamera.CFrame.p).magnitude

            local _POS , _SIZE , _RENDERED  = BoxMath( HRP ); 

            if distance > library.flags["visual_main_render"] then
                return true
            end
            
            if not _RENDERED then
                return true
            end

            if player == localplayer then
                return true
            end

            return false
        end 
    end

    local newloop 
    newloop = game.RunService.RenderStepped:Connect( function( delta ) 

        for _i , player in pairs(Players:GetChildren()) do
            if fuckthisshit(player) then
                getridofit( esp_library.cache[player] , player );
            elseif not esp_library.cache[player] then 
                newrender( player )
            end
        end

        for player , cache in pairs(esp_library.cache) do
        
            if Players:FindFirstChild( player.Name ) then 
    
            else
                getridofit( esp_library.cache[player] );

                continue  
            end 

            if not esp_library.cache[player] then continue end

            if not esp_library.cache[player].Box then continue end

            if not player.Character then idontwannaseeit( esp_library.cache[player] ); continue end

            if not player.Character:FindFirstChild("Humanoid") then idontwannaseeit( esp_library.cache[player] ); continue end

            if not cache then continue end

            if not player.Character:FindFirstChild("HumanoidRootPart") then idontwannaseeit( esp_library.cache[player] ); continue  end

            -- sanity checks are done :3
            local HRP = player.Character:FindFirstChild("HumanoidRootPart");
            local HP = player.Character:FindFirstChild("Humanoid")

            local _3DPOS = HRP.Position
            local _POS , _SIZE , _RENDERED  = BoxMath( HRP ); 

            _RENDERED = _RENDERED and HP.Health > 0 and library.flags["visual_main_enabled"]

            local istarget = (target.aimbot == player and Color3.new(1,0,0)) or (target.silent == player and Color3.new(1,0,0)) or Color3.new(1,1,1)

            
            do -- box
                cache.Box.Size = _SIZE
                cache.Box.Position = _POS
                cache.Box.Visible = _RENDERED
                cache.Box.Color = Color3.new(1,1,1)
                cache.Box.Visible = _RENDERED and library.flags["visual_main_drawbox"]
                cache.Box.ZIndex = 2

                cache.Box_Outline.Size = _SIZE
                cache.Box_Outline.Position = _POS
                cache.Box_Outline.Visible = _RENDERED and library.flags["visual_main_drawbox"]
                cache.Box_Outline.Color = Color3.new(0,0,0)
                cache.Box_Outline.Thickness = 2
            end

            do -- healthbar
                local _HEALTHBARPOS = Vector2.new(math.floor(_POS.x) - 6, math.floor(_POS.y) - 1)
                local _HEALTHBARSIZE = Vector2.new(3 , _SIZE.Y + 1)
                local _HEALTH = Vector2.new(3 , _SIZE.Y - (HP.Health / HP.MaxHealth) * _SIZE.Y)

                cache.Health.Position = _HEALTHBARPOS
                cache.Health.Size = _HEALTHBARSIZE
                cache.Health.Visible = _RENDERED and library.flags["visual_main_health"]

                cache.Health_Outline.Position = _HEALTHBARPOS
                cache.Health_Outline.Size = _HEALTHBARSIZE + Vector2.new(1,1)
                cache.Health_Outline.Visible = _RENDERED and library.flags["visual_main_health"]

                cache.Health_Fill.Position = _HEALTHBARPOS
                cache.Health_Fill.Size = _HEALTH + Vector2.new(1,1)
                cache.Health_Fill.Visible = _RENDERED and library.flags["visual_main_health"]
                cache.Health_Fill.ZIndex = 2
                cache.Health_Fill.Filled = true
            end

            do -- text 
                local _NAMEPOS = Vector2.new(_SIZE.X / 2 + _POS.X, _POS.Y - 16)
                local _CUSTOMPOS2 =  Vector2.new(_SIZE.X + _POS.X + 4, _POS.Y)
                local _CUSTOMPOS = Vector2.new(_SIZE.X / 2 + _POS.X, (_POS.Y + _SIZE.Y) + 3)
                local Distance = (_3DPOS - workspace.CurrentCamera.CFrame.p).magnitude

                cache.NameText.Position = _NAMEPOS
                cache.NameText.Text = player.Name
                cache.NameText.Visible = _RENDERED and library.flags["visual_main_drawname"]
                cache.NameText.Color = istarget

                cache.DistanceText.Position = _CUSTOMPOS2
                cache.DistanceText.Text = math.round(Distance) .. " s"
                cache.DistanceText.Visible = _RENDERED and library.flags["visual_main_drawdistance"]

                cache.WeaponText.Position = _CUSTOMPOS
                cache.WeaponText.Text = getweaponfromcharacter( player.Character );
                cache.WeaponText.Visible = _RENDERED and library.flags["visual_main_drawweapon"]
            end

            do -- skeleton
                pcall(function()
                local H = camera:WorldToViewportPoint(player.Character.Head.Position)
                --Spine
                local UT = camera:WorldToViewportPoint((player.Character.UpperTorso.CFrame * CFrame.new(0, .4, 0)).Position)
                local LT = camera:WorldToViewportPoint(player.Character.LowerTorso.Position)
                -- Left Arm
                local LUA = camera:WorldToViewportPoint(player.Character.LeftUpperArm.Position)
                local LLA = camera:WorldToViewportPoint(player.Character.LeftLowerArm.Position)
                local LH = camera:WorldToViewportPoint(player.Character.LeftHand.Position)
                -- Right Arm
                local RUA = camera:WorldToViewportPoint(player.Character.RightUpperArm.Position)
                local RLA = camera:WorldToViewportPoint(player.Character.RightLowerArm.Position)
                local RH = camera:WorldToViewportPoint(player.Character.RightHand.Position)
                -- Left leg
                local LUL = camera:WorldToViewportPoint(player.Character.LeftUpperLeg.Position)
                local LLL = camera:WorldToViewportPoint(player.Character.LeftLowerLeg.Position)
                local LF = camera:WorldToViewportPoint(player.Character.LeftFoot.Position)
                -- Right leg
                local RUL = camera:WorldToViewportPoint(player.Character.RightUpperLeg.Position)
                local RLL = camera:WorldToViewportPoint(player.Character.RightLowerLeg.Position)
                local RF = camera:WorldToViewportPoint(player.Character.RightFoot.Position)

                local start = camera:WorldToViewportPoint(player.Character.Head.CFrame.Position)
                local fin = camera:WorldToViewportPoint((player.Character.Head.CFrame * CFrame.new(0, 0, -2)).Position)

                cache.LookVector.From = Vector2.new(start.X, start.Y)
                cache.LookVector.To = Vector2.new(fin.X, fin.Y)
                cache.LookVector.Visible = _RENDERED and library.flags["visual_main_drawvector"]
                --Head
                cache.Head_UpperTorso.From = Vector2.new(H.X, H.Y)
                cache.Head_UpperTorso.To = Vector2.new(UT.X, UT.Y)
                cache.Head_UpperTorso.Visible = _RENDERED and library.flags["visual_main_drawskeleton"]
                --Spine
                cache.UpperTorso_LowerTorso.From = Vector2.new(UT.X, UT.Y)
                cache.UpperTorso_LowerTorso.To = Vector2.new(LT.X, LT.Y)
                cache.UpperTorso_LowerTorso.Visible = _RENDERED and library.flags["visual_main_drawskeleton"]
                -- Left Arm
                cache.UpperTorso_LeftUpperArm.From = Vector2.new(UT.X, UT.Y)
                cache.UpperTorso_LeftUpperArm.To = Vector2.new(LUA.X, LUA.Y)
                cache.UpperTorso_LeftUpperArm.Visible = _RENDERED and library.flags["visual_main_drawskeleton"]

                cache.LeftUpperArm_LeftLowerArm.From = Vector2.new(LUA.X, LUA.Y)
                cache.LeftUpperArm_LeftLowerArm.To = Vector2.new(LLA.X, LLA.Y)
                cache.LeftUpperArm_LeftLowerArm.Visible = _RENDERED and library.flags["visual_main_drawskeleton"]

                cache.LeftLowerArm_LeftHand.From = Vector2.new(LLA.X, LLA.Y)
                cache.LeftLowerArm_LeftHand.To = Vector2.new(LH.X, LH.Y)
                cache.LeftLowerArm_LeftHand.Visible = _RENDERED and library.flags["visual_main_drawskeleton"]
                -- Right Arm
                cache.UpperTorso_RightUpperArm.From = Vector2.new(UT.X, UT.Y)
                cache.UpperTorso_RightUpperArm.To = Vector2.new(RUA.X, RUA.Y)
                cache.UpperTorso_RightUpperArm.Visible = _RENDERED and library.flags["visual_main_drawskeleton"]

                cache.RightUpperArm_RightLowerArm.From = Vector2.new(RUA.X, RUA.Y)
                cache.RightUpperArm_RightLowerArm.To = Vector2.new(RLA.X, RLA.Y)
                cache.RightUpperArm_RightLowerArm.Visible = _RENDERED and library.flags["visual_main_drawskeleton"]

                cache.RightLowerArm_RightHand.From = Vector2.new(RLA.X, RLA.Y)
                cache.RightLowerArm_RightHand.To = Vector2.new(RH.X, RH.Y)
                cache.RightLowerArm_RightHand.Visible = _RENDERED and library.flags["visual_main_drawskeleton"]
                -- Left Leg
                cache.LowerTorso_LeftUpperLeg.From = Vector2.new(LT.X, LT.Y)
                cache.LowerTorso_LeftUpperLeg.To = Vector2.new(LUL.X, LUL.Y)
                cache.LowerTorso_LeftUpperLeg.Visible = _RENDERED and library.flags["visual_main_drawskeleton"]

                cache.LeftUpperLeg_LeftLowerLeg.From = Vector2.new(LUL.X, LUL.Y)
                cache.LeftUpperLeg_LeftLowerLeg.To = Vector2.new(LLL.X, LLL.Y)
                cache.LeftUpperLeg_LeftLowerLeg.Visible = _RENDERED and library.flags["visual_main_drawskeleton"]

                cache.LeftLowerLeg_LeftFoot.From = Vector2.new(LLL.X, LLL.Y)
                cache.LeftLowerLeg_LeftFoot.To = Vector2.new(LF.X, LF.Y)
                cache.LeftLowerLeg_LeftFoot.Visible = _RENDERED and library.flags["visual_main_drawskeleton"]
                -- Right Leg
                cache.LowerTorso_RightUpperLeg.From = Vector2.new(LT.X, LT.Y)
                cache.LowerTorso_RightUpperLeg.To = Vector2.new(RUL.X, RUL.Y)
                cache.LowerTorso_RightUpperLeg.Visible = _RENDERED and library.flags["visual_main_drawskeleton"]

                cache.RightUpperLeg_RightLowerLeg.From = Vector2.new(RUL.X, RUL.Y)
                cache.RightUpperLeg_RightLowerLeg.To = Vector2.new(RLL.X, RLL.Y)
                cache.RightUpperLeg_RightLowerLeg.Visible = _RENDERED and library.flags["visual_main_drawskeleton"]

                cache.RightLowerLeg_RightFoot.From = Vector2.new(RLL.X, RLL.Y)
                cache.RightLowerLeg_RightFoot.To = Vector2.new(RF.X, RF.Y)
                cache.RightLowerLeg_RightFoot.Visible = _RENDERED and library.flags["visual_main_drawskeleton"]
                end)
            end
        end 

        for index , func in pairs(esp_library.loops) do
            func()
        end
    end )

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= Players.LocalPlayer then 
            newrender( plr );
        end
    end

    Players.PlayerAdded:Connect( function( plr )
        newrender( plr );
    end )
end

function esp_library.itemstart( path , enabledflag , filter )
    esp_library[enabledflag .. "ESP_FLAG"] = {}

    esp_library[enabledflag .. "ESP_FLAGS"] = {}

    local store = esp_library[enabledflag .. "ESP_FLAGS"]

    local cached = esp_library[enabledflag .. "ESP_FLAG"]

    local function newrender( item )
        
        if filter then
            if filter.name then
                if item.name ~= filter.name then return end
            end

            if filter.search then
                if not string.match(item.name , filter.search) then return end
            end

            if filter.haschild then
                if not item:FindFirstChild(filter.haschild) then return end
            end

            if filter.nochild then 
                if item:FindFirstChild(filter.nochild) then return end
            end
        end

        local esptable = esp_library.returndrawi( );

        cached[item] = esptable
    end

    local function getridofit( esptable , plr)

        local Data = esptable
    
        if (Data) then
            esptable = nil
    
            for i,v in pairs(Data) do
                v:Destroy()
                Data[i] = nil
            end
        end
        if cached[plr] then
            cached[plr] = nil
        end
    end

    local function fuckthisshit( storeobject )
        if not library.flags[enabledflag] then return true end
        if not library.flags["prefab_enabled"] then return true end
        if path:FindFirstChild( storeobject.Name ) then 
        else
                return true
        end

        local HRP = storeobject.PrimaryPart

        if filter and filter.checkpart then
            if filter.checkplace and storeobject:FindFirstChild(filter.checkplace) then
                HRP = storeobject:FindFirstChild(filter.checkplace):FindFirstChild(filter.checkpart)
            else 
                HRP = storeobject:FindFirstChild(filter.checkpart)
            end
        end

        local _3DPOS 
        pcall(function()
            if HRP.Position then
                _3DPOS = HRP.Position
            end
        end)
        pcall(function()
            if HRP.WorldPosition then
                _3DPOS= HRP.WorldPosition
            end
        end)
        pcall(function()
            if HRP.WorldCFrame then
                _3DPOS= HRP.WorldCFrame.P
            end
        end)

        if filter and filter.debug then warn("pass1") end

        if not _3DPOS then return true end

        local distance = (_3DPOS - workspace.CurrentCamera.CFrame.p).magnitude

        local _POS , _RENDERED  = BoxMath2( _3DPOS ); 
        
        if distance > library.flags["prefab_maxrender"] then
            return true
        end

        if filter and filter.debug then warn("pass1") end
        
        if not _RENDERED then
            return true
        end

        
        return false
    end

    local function idontwannaseeit( esptable )
        local Data = esptable
    
        if (Data) then
            esptable = nil
    
            for i,v in pairs(Data) do
                v.Visible = false
            end
        end
    end
    
    esp_library.loops[enabledflag .. "ESP_FLAGS"] = function()
        
        for _i , player in pairs(path:GetChildren()) do
            if fuckthisshit(player) then
                getridofit( cached[player] , player );
            elseif not cached[player] then 
                newrender( player )
            end
        end

        for player , cache in pairs(cached) do

            local enabled = true

            local HRP = player.PrimaryPart

            if enabledflag then
                enabled = library.flags[enabledflag] and library.flags["prefab_enabled"]
            end

            if findFirstInstance(path , player) then   
            else
                cache.NameText.Visible = false
                
                getridofit( cached[player] , player );

                continue  
            end

            if filter and filter.checkpart then
                if filter.checkplace and player:FindFirstChild(filter.checkplace) then
                    HRP = player:FindFirstChild(filter.checkplace):FindFirstChild(filter.checkpart)
                else 
                    HRP = player:FindFirstChild(filter.checkpart)
                end

            end

            if not HRP then 
                cache.NameText.Visible = false

                continue
            end
    
            -- if not player:FindFirstChild("Detail") then idontwannaseeit( cached[player] ); continue end

            -- sanity checks are done :3
            local _3DPOS 
            pcall(function()
                if HRP.Position then
                    _3DPOS = HRP.Position
                end
            end)
            pcall(function()
                if HRP.WorldPosition then
                    _3DPOS= HRP.WorldPosition
                end
            end)
            pcall(function()
                if HRP.WorldCFrame then
                    _3DPOS= HRP.WorldCFrame.P
                end
            end)

            local Distance = (_3DPOS - workspace.CurrentCamera.CFrame.p).magnitude

            if Distance > library.flags["prefab_maxrender"] then
                cache.NameText.Visible = false
                continue
            end

            local _POS , _RENDERED  = BoxMath2( _3DPOS ); 
            
            
            do -- text 
                local Distance = (_3DPOS - workspace.CurrentCamera.CFrame.p).magnitude

                cache.NameText.Position =  Vector2.new(_POS.X, _POS.Y)
                cache.NameText.Text = player.Name .. " " ..  math.round(Distance) .. " s"
                cache.NameText.Visible = _RENDERED and enabled
            end
    
        end 
    end

    for _i, item in pairs(path:GetChildren()) do
        local continue = false
        if filter then
            if filter.name and item.Name ~= filter.name then
                -- Skip processing if the item name does not match the filter name
                -- Equivalent to "continue"
                do
                    continue = true
                end
            end
    
            if filter.search and not string.match(item.Name, filter.search) then
                -- Skip processing if the item name does not match the search pattern
                -- Equivalent to "continue"
                do
                    continue = true
                end
            end
    
            if filter.haschild and not item:FindFirstChild(filter.haschild) then
                -- Skip processing if the item does not have the specified child
                -- Equivalent to "continue"
                do
                    continue = true
                end
            end
    
            if filter.nochild and item:FindFirstChild(filter.nochild) then
                -- Skip processing if the item has the specified child
                -- Equivalent to "continue"
                do
                    continue = true
                end
            end
        end
    
        if not continue then
            -- Process the item if it passes all the filter conditions
            newrender(item)
        end
    end
    
    path.ChildAdded:Connect( function( item )

        if filter then
            if filter.name then
                if item.name ~= filter.name then return end
            end

            if filter.search then
                if not string.match(item.name , filter.search) then return end
            end

            if filter.haschild then
                if not item:FindFirstChild(filter.haschild) then return end
            end

            if filter.nochild then 
                if item:FindFirstChild(filter.nochild) then return end
            end
        end

        newrender( item );
    end )
end

return esp_library
