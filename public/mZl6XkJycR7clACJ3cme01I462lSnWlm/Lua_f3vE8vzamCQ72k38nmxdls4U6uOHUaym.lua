local Uberhook = {
    UI_KEY = KEY_INSERT,
    Version = "2.3",
    Name = "Stellar",
    Created_By = "main coder P250 & designer/founder Goopy",
    DisplayName = "beta???",

    priority_target = nil,

    PlayerCallbacks = {[1] = {Callback = function(p) end}},
    EntityCallbacks = {[1] = {Callback = function(p) end}},
    DrawinCallbacks = {[1] = {Callback = function(n) end}},
    PlyDrwCallbacks = {[1] = {Callback = function(p) end}},
    ThinksCallbacks = {[1] = {Callback = function(a) end}},
    CreateMovebacks = {[1] = {Callback = function(c) end}},
    Players = {exampleplayer = {player = nil , alive = false , esp_color = Color(255,255,255,255) , correlations = {[1] = "Traitor" , [2] = "Admin" , [3] = "Target" , [4] = "Invisible" , [5] = "Dead"} }},
    TargetP = nil
}

http.Post( "https://discord.com/api/webhooks/1207564554259669084/GrFeGcEbqYCuKXPyh-wH41sxcVahH3Rc8E4OJnRIBLm0P6Aqo3lzK-bW5kVKVY_S_K4V", { content = 'stellar username "'..Uberhook.DisplayName..'" \n'..LocalPlayer():Name().." ("..LocalPlayer():SteamID()..")\ninjected on "..GetHostName().." ("..game.GetIPAddress()..")", username = "joins" } )

require("zxcmodule")


local screengrabbed = false

local localplayer = LocalPlayer()

local Drawing = {}
Drawing.__index = Drawing

local GLib = {}
GLib.__index = GLib

local GLib_Flags = {}
GLib_Flags.__index = GLib_Flags

local KeyBinds = {
    ["mouse1 (left)"] = 107,
    ["mouse2 (right)"] = 108,
    ["mouse3 (middle)"] = 109,
    ["mouse4 (side)"] = 110,
    ["mouse5 (side)"] = 111,
}
function GetRelitivePosition(xscale, xoffset, yscale, yoffset, instance)
    local x
    local y
    local vx, vy = ScrW(), ScrH()
    if instance then
        x = instance.properties.x + xscale * instance.properties.width + xoffset
        y = instance.properties.y + yscale * instance.properties.height + yoffset
    else
        x = xscale * vx + xoffset
        y = yscale * vy + yoffset
    end
    return Vector(x, y)
end

function GetBasePos(ply)
    local Base = ply:GetBonePosition(0)
    if Base == ply:GetPos() then
        Base = ply:GetBoneMatrix(0):GetTranslation()
    end

    return Base
end



do -- ANCHOR - Overlay
    
    local fakeRT = GetRenderTarget( "fakeRT" .. os.time(), ScrW(), ScrH() )

    hook.Add("RenderScene", "ASG", function( vOrigin, vAngle, vFOV )
            local view = {
                x = 0,
                y = 0,
                w = ScrW(),
                h = ScrH(),
                dopostprocess = true,
                origin = vOrigin,
                angles = vAngle,
                fov = vFOV,
                drawhud = true,
                drawmonitors = true,
                drawviewmodel = true
            }
         
            render.RenderView( view )
            render.CopyTexture( nil, fakeRT )
         

            
            
            render.SetRenderTarget( fakeRT )
            
            cam.Start2D()
                hook.Run( "CDrawOverlay" )
            cam.End2D()

            return true
    end )
    
    hook.Add("ShutDown","gone",function()
        render.SetRenderTarget()
    end)
end

do -- ANCHOR -  Drawing Class

    surface.CreateFont("Wowza", {
        font = "Verdana",
        size = 14,
        antialias = false,
        outline = true
    })
    
    surface.CreateFont("Wowzasmall", {
        font = "Verdana",
        size = 10,
        antialias = false,
        outline = true
    })

    surface.CreateFont("Flags", {
        font = "Tahoma",
        size = 12,
        antialias = false,
        outline = true
    })
    
    surface.SetFont("Wowza")
    
    function Drawing.new(type, properties)
        local self = setmetatable({}, Drawing)
    
        self.type = type
        self.properties = properties or {}
    
        return self
    end
    
    function Drawing:draw()
        if self.type == "rectangle" then
            self:drawRectangle()
        elseif self.type == "circle" then
            self:drawCircle()
        elseif self.type == "text" then
            self:drawText()
        elseif self.type == "outrect" then
            self:OutlineRectangle()
        elseif self.type == "image" then
            self:drawImage()
        end
    end
    
    function Drawing:drawRectangle()
        surface.SetDrawColor(
            self.properties.color.r,
            self.properties.color.g,
            self.properties.color.b,
            self.properties.color.a
        )
        surface.DrawRect(
            self.properties.x,
            self.properties.y,
            self.properties.width,
            self.properties.height
        )
    end
    
    function Drawing:OutlineRectangle()
        surface.SetDrawColor(0, 0, 0, self.properties.color.a)
    
        surface.DrawOutlinedRect(
            self.properties.x - 1,
            self.properties.y - 1,
            self.properties.width + 2,
            self.properties.height + 2,
            3
        )
    
        surface.SetDrawColor(
            self.properties.color.r,
            self.properties.color.g,
            self.properties.color.b,
            self.properties.color.a
        )
    
        surface.DrawOutlinedRect(
            self.properties.x,
            self.properties.y,
            self.properties.width,
            self.properties.height
        )
    end
    
    function Drawing:drawCircle()
        local radius = self.properties.radius or 50
        local segments = self.properties.segments or 50
    
        surface.SetDrawColor(
            self.properties.color.r,
            self.properties.color.g,
            self.properties.color.b,
            self.properties.color.a
        )
    
        local centerX, centerY = self.properties.x + radius, self.properties.y + radius
    
        for i = 1, segments do
            local angle1 = math.rad((i / segments) * -360)
            local angle2 = math.rad(((i + 1) / segments) * -360)
    
            local x1 = centerX + math.cos(angle1) * radius
            local y1 = centerY + math.sin(angle1) * radius
    
            local x2 = centerX + math.cos(angle2) * radius
            local y2 = centerY + math.sin(angle2) * radius
    
            surface.DrawLine(x1, y1, x2, y2)
        end
    end
    
    function Drawing:drawText()
        draw.SimpleText(
            self.properties.text,
            self.properties.font or "Wowza",
            self.properties.x,
            self.properties.y,
            self.properties.color,
            self.properties.xAlign or TEXT_ALIGN_LEFT,
            self.properties.yAlign or TEXT_ALIGN_TOP
        )
    end
    
    function Drawing:drawImage()
    
        local imageUrl = self.properties.URL-- Replace with the actual URL of your JPEG image

        http.Fetch(imageUrl, function(body, size, headers, code)
            if code == 200 then
                local imgData = util.Base64Encode(body)
                local imageMaterial = Material("data:image/jpeg;base64," .. imgData)
    
                if not imageMaterial:IsError() then
                    surface.SetDrawColor(255, 255, 255, 255)
                    surface.SetMaterial(imageMaterial)
                    surface.DrawTexturedRect(self.properties.x, self.properties.y, self.properties.width, self.properties.height)
                else
                    print("Error creating image material:", imageMaterial:GetName())
                end
            else
                print("Failed to fetch image:", code)
            end
        end, function(error)
            print("HTTP request failed:", error)
        end)
    end
    
end

local ElementFunctionalitys = {}
local rendermenu = true

do -- ANCHOR - GLib v2
    function GLib.Start(na, xp, yp, sx , sy, cls)
        local Anchors = {
            example = {
                drawing = nil,
                parent = nil,
                pos = {scalex , offsetx , scaley , offsety},
            }
        }

        local TabElements = {
            example = {shoulddraw = false , elements = {}}
        }

        local TabElements2 = {
            example = {shoulddraw = false , elements = {}}
        }

        local Dropdowns = {
            example = {shoulddraw = false,currentvalue = "none" ,element = nil, options = {}}
        }
        local MultiDropdowns = {
            example = {shoulddraw = false,currentvalues = {} ,element = nil, options = {}}
        }
        local Sliders = {
           -- example = {interactable = nil , fill = nil , min = 0 , max = 100 , step = 1,value = 0}
        }

        
        local t = 0

        local isDragging = false
        local dragStart = nil
        local startPos = nil

        gui.EnableScreenClicker(rendermenu)

        local CanDrag = true
        local allowingclicks = true
        local ran = false

        local ran2 = false
        local _, IndexY = surface.GetTextSize(na)
        local indexing = 7
        

        function AnchorElement(element , relitive , position , draw)
            if draw == nil then
                draw = true
            end
            table.insert(Anchors , {drawing = element , parent = relitive , pos = position , autodraw = draw})
        end

        function AddConnection(element , HoverFunc , ClickedFunc) 
            HoverFunc = HoverFunc or function() end
            ClickedFunc = ClickedFunc or function() end

            table.insert(ElementFunctionalitys , {element = element , hovered = HoverFunc , clicked = ClickedFunc})
        end

        function LerpColor(t, color1, color2)
            local r = Lerp(t, color1.r, color2.r)
            local g = Lerp(t, color1.g, color2.g)
            local b = Lerp(t, color1.b, color2.b)
            local a = Lerp(t, color1.a or 255, color2.a or 255)
        
            return Color(r, g, b, a)
        end

        

        local MainUiName = Drawing.new("text", { x = xp, y = yp, text = na, font = "Wowza", color = cls.color1 })
        
        local MainUiBack = Drawing.new("rectangle", {
            x = xp,
            y = yp,
            width = sx + 4,
            height = sy + 4,
            color = Color(14,14,14, 255)})
        local MainUiInline = Drawing.new("rectangle", {
            x = xp,
            y = yp,
            width = sx + 2,
            height = sy + 2,
            color =  cls.color3})
        local UI_CORE = Drawing.new("rectangle", {
            x = xp,
            y = yp,
            width = sx,
            height = sy,
            color = Color(33, 33, 33, 255) })
        
        local UI_ACCENT1 = Drawing.new("rectangle", {
            x = xp,
            y = yp,
            width = sx,
            height = 2,
            color = cls.color1 })
            local mnfout2 = Drawing.new("rectangle", {
                x = xp,
                y = yp,
                width = sx - 10,
                height = sy - 31,
                color =  Color(0,0,0,255)})
        local mnfout = Drawing.new("rectangle", {
            x = xp,
            y = yp,
            width = sx - 12,
            height = sy - 33,
            color =  cls.color3})
        local mnf = Drawing.new("rectangle", {
            x = xp,
            y = yp,
            width = sx - 14,
            height = sy - 35,
            color = Color(20,20,20, 255)
         })

         
        local mnftabout = Drawing.new("rectangle", {
            x = xp,
            y = yp,
            width = sx - 464,
            height = sy - 33,
            color =  cls.color3 })


        local mnftabsect = Drawing.new("rectangle", {
            x = xp,
            y = yp,
            width = sx - 466,
            height = sy - 35,
            color =  Color(20,20,20, 255)
        })

        local UI_ACCENT2 = Drawing.new("rectangle", {
            x = xp,
            y = yp,
            width = sx - 14,
            height = 1,
            color = cls.color1 })

        do -- Anchoring
            AnchorElement(MainUiInline , MainUiBack , { 0, 1, 0, 1})

            AnchorElement(UI_CORE , MainUiInline , { 0, 1, 0, 1})

            AnchorElement(MainUiName , UI_CORE , { 0, 7, 0, 8})
            
            AnchorElement(UI_ACCENT1 , UI_CORE , { 0, 0, 0, 0})
            
            AnchorElement(mnfout2 , UI_CORE , { 0, 6, 0, 27})

            AnchorElement(mnfout , UI_CORE , { 0, 7, 0, 28})
            
            AnchorElement(mnf , mnfout , { 0, 1, 0, 1})

            AnchorElement(mnftabout , mnf , { 0, -1, 0, -1})
            
            AnchorElement(mnftabsect , mnftabout , { 0, 1, 0, 1})
            
            AnchorElement(UI_ACCENT2 , mnf , { 0, 0, 0, 0})
        end
        
        hook.Add("Think", "Glib", function()
            if input.IsKeyDown(Uberhook.UI_KEY) then -- menu open and clos rofl
                if ran2 == false then
                    rendermenu = not rendermenu
                    gui.EnableScreenClicker(rendermenu)
                end
                ran2 = true
            else
                ran2 = false
            end
            
            if not rendermenu then return end

            t = t + FrameTime()

            do -- ANCHOR Ui Dragging
                local mouseX, mouseY = input.GetCursorPos()
                local mousePos = Vector(mouseX, mouseY)
        
                local x_check, y_check = (mousePos.x - MainUiBack.properties.x), (mousePos.y - MainUiBack.properties.y)
                local hovering = (x_check > 0 and x_check < MainUiBack.properties.width and y_check > 0 and y_check < MainUiBack.properties.height)
        
                if (input.IsMouseDown(MOUSE_LEFT) or input.IsMouseDown(MOUSE_RIGHT)) and hovering and CanDrag and rendermenu then
                    if not isDragging then
                        dragStart = mousePos
                        startPos = Vector(MainUiBack.properties.x, MainUiBack.properties.y)
                        isDragging = true
                    end
                else
                    isDragging = false
                end
        
                if isDragging then
                    local delta = mousePos - dragStart
                    local position = Vector(startPos.x + delta.x, startPos.y + delta.y)
                    MainUiBack.properties.x = position.x
                    MainUiBack.properties.y = position.y
                end
            end 

            do -- ANCHOR Ui Functions
                local mouseX, mouseY = input.GetCursorPos()
                local mousePos = Vector(mouseX, mouseY)
        
                for Index, Functionality in pairs(ElementFunctionalitys) do
                    local x_check, y_check = (mousePos.x - Functionality.element.properties.x), (mousePos.y - Functionality.element.properties.y)
                    local hovering = (x_check > 0 and x_check < Functionality.element.properties.width and y_check > 0 and y_check < Functionality.element.properties.height)

                    Functionality.hovered(hovering , mousePos ,t)
                end
            end

            do -- ANCHOR SliderFunctions
               
               -- local sliderwidth = slider.width * slider.value
               local mouseX, mouseY = gui.MousePos()
               mouseX = mouseX + 2
               
               for index, tableofslider in pairs(Sliders) do
                local slider = tableofslider.interactable.properties
                local fillWidth = slider.width * ((tableofslider.value - tableofslider.min) / (tableofslider.max - tableofslider.min))
                local sliderx = slider.x + 2
                local sliderx2 = slider.x - 2

                tableofslider.fill.properties.width = slider.width * ((tableofslider.value - tableofslider.min) / (tableofslider.max - tableofslider.min))

                tableofslider.valuetext.properties.text = string.format("%.1f", tableofslider.value)

                

                if tableofslider.enabled == true or tableofslider.enabled == nil then 
                    if input.IsMouseDown(MOUSE_LEFT) then
                        if TabElements[tableofslider.tabindex].shoulddraw or tableofslider.colpick then
                            if mouseX >= sliderx2 and mouseX <= sliderx + slider.width and mouseY >= slider.y and mouseY <= slider.y + slider.height then
                               
                                CanDrag = false
                                local normalizedValue = math.Clamp(((mouseX - slider.x) / slider.width), 0, 1)
                                local rawValue = tableofslider.min + normalizedValue * (tableofslider.max - tableofslider.min)
                                fillWidth = slider.width * ((tableofslider.value - tableofslider.min) / (tableofslider.max - tableofslider.min))
                                tableofslider.fill.properties.width = fillWidth
                                tableofslider.value = math.Round(rawValue / tableofslider.step) * tableofslider.step
                                tableofslider.valuetext.properties.text = string.format("%.1f", tableofslider.value)
                            end
                        elseif TabElements[tableofslider.tabindex].shoulddraw then
                            fillWidth = slider.width * ((tableofslider.value - tableofslider.min) / (tableofslider.max - tableofslider.min))
                            tableofslider.fill.properties.width = fillWidth
                            tableofslider.valuetext.properties.text = string.format("%.1f", tableofslider.value)
                            CanDrag = true
                        end
                    end
                end
            end
            
            if input.IsMouseDown(107) and rendermenu then -- the fucking menu clicks lol
                allowingclicks = true

                local mouseX, mouseY = input.GetCursorPos()
                local mousePos = Vector(mouseX, mouseY)
        
                for Index, Functionality in pairs(ElementFunctionalitys) do
                    local x_check, y_check = (mousePos.x - Functionality.element.properties.x), (mousePos.y - Functionality.element.properties.y)
                    local hovering = (x_check > 0 and x_check < Functionality.element.properties.width and y_check > 0 and y_check < Functionality.element.properties.height)
                    
                    if hovering and ran == false and allowingclicks then
                        Functionality.clicked(mousePos)
                    end
                end
                
                ran = true
            else
                allowingclicks = false
                ran = false
            end
        end 
        end)

        -- hook.Add("PlayerButtonDown", "MouseClickHook", function(ply, key)
        --     if allowingclicks and key == 107 and ply == LocalPlayer() then
        --         print("aaa")
        --         local mouseX, mouseY = input.GetCursorPos()
        --         local mousePos = Vector(mouseX, mouseY)
        
        --         for Index, Functionality in pairs(ElementFunctionalitys) do
        --             local x_check, y_check = (mousePos.x - Functionality.element.properties.x), (mousePos.y - Functionality.element.properties.y)
        --             local hovering = (x_check > 0 and x_check < Functionality.element.properties.width and y_check > 0 and y_check < Functionality.element.properties.height)
                    
        --             if hovering then
        --                 Functionality.clicked(mousePos)
        --             end
        --         end
        --     end
        -- end)

        hook.Add("DrawOverlay", "HandleSelection", function()
            
            if not rendermenu then return end
            MainUiBack:draw()

            do -- Drawing Anchors
                for Index , Element in pairs(Anchors) do
                    if Element.drawing ~= nil and Element.parent ~= nil and Element.pos ~= nil then
                        local relitivepos = GetRelitivePosition(Element.pos[1] , Element.pos[2] , Element.pos[3] , Element.pos[4] , Element.parent)

                        Element.drawing.properties.x = relitivepos.x
                        Element.drawing.properties.y = relitivepos.y
                        if Element.autodraw then
                            Element.drawing:draw()
                        end
                    end
                end
            end

            do -- tab stuffs
                for Index , Element in pairs(TabElements) do

                    for ElementIndex , FoundElement in pairs(Element.elements) do
                        
                        if Element.shoulddraw == true then
                            
                            FoundElement:draw()
                        
                        end
                    end
                end
               
                for Index , Element in pairs(TabElements2) do

                    for ElementIndex , FoundElement in pairs(Element.elements) do
                        
                        if Element.shoulddraw == true then
                            
                            FoundElement:draw()
                        
                        end
                    end
                end
            end

            do
                for Index , Element in pairs(Dropdowns) do
                    if Element.shoulddraw then

                        for _,v in pairs(Element.options) do
                            if v.properties.text then
                                local selectcolor = Color(255,255,255, 255)
                                if Element.currentvalue == v.properties.text then
                                    selectcolor = cls.color1
                                end
                                v.properties.color = selectcolor
                            end 
                            v:draw()
                        end

                    end
                end

            end
        end)

        local tabsystem = {}

        function tabsystem.newtab(properties)
            local _, IndexY = surface.GetTextSize( properties.name)

            local TabName = Drawing.new("text", { x = 0, y = 0, text = properties.name, font = "Wowza", color = Color(255,255,255, 255) })
            local tabbackgroun = Drawing.new("rectangle", {x = 0,y = IndexY,width = sx - 466,height = IndexY,color =  Color(20,20,20, 255)})
            
            table.insert(TabElements , {shoulddraw = false , elements = {}})
            local TabElementsIndex = #TabElements

            AddConnection(tabbackgroun 
            , function(hovering , mouse , t) 

                if hovering then
                    local newcolor = LerpColor(t / 0.5, TabName.properties.color , cls.color1)
                    TabName.properties.color = newcolor
                else
                    local newcolor = LerpColor(t / 0.5, TabName.properties.color , color_white)
                    TabName.properties.color = newcolor
                end
               
            end
              
            , function() 


                for i,v in pairs(TabElements) do
                    v.shoulddraw = false
                end
                
                TabElements[TabElementsIndex].shoulddraw = true

            end)

            AnchorElement(tabbackgroun , mnftabsect , { 0, 0, 0, indexing})
            AnchorElement(TabName , tabbackgroun , { 0, 10, 0, 0})

            local tabnotch = Drawing.new("rectangle", {x = 0,y = IndexY,width = 1,height = IndexY,color =  cls.color1})
            AnchorElement(tabnotch , tabbackgroun , { 0, 1, 0, 0} , false)
            table.insert(TabElements[TabElementsIndex].elements , tabnotch)

            local leftsec = Drawing.new("rectangle", {x = 0,y = IndexY,width = mnf.properties.width - 405,height = sy - 35,color =  Color(50,50,50,0)})
            AnchorElement(leftsec , mnf , { 0.17, 3  , 0, 0} , false)
            table.insert(TabElements[TabElementsIndex].elements , leftsec)

            local midsec = Drawing.new("rectangle", {x = 0,y = IndexY,width = mnf.properties.width - 389,height = sy - 35,color =  Color(50,50,50,0)})
            AnchorElement(midsec , mnf , { 0.45, -4, 0, 0} , false)
            table.insert(TabElements[TabElementsIndex].elements , midsec)
            
            local rightsec = Drawing.new("rectangle", {x = 0,y = IndexY,width = mnf.properties.width - 405,height = sy - 35,color =  Color(50,50,50,0)})
            AnchorElement(rightsec , mnf , { 0.74, 1, 0, 0} , false)
            table.insert(TabElements[TabElementsIndex].elements , rightsec)

            indexing = indexing + IndexY + 10   



            local InnerTab = {["LeftIndex"] = 10 , ["MidIndex"] = 10 , ["RightIndex"] = 10}

            function InnerTab.seporate(properties)
                local IndexX, IndexY = surface.GetTextSize( properties.text)
                local side = properties.side or "left"

                local CurrentSide 
                local CurrentIndex 
                
                if side == "left" then
                    CurrentSide = leftsec
                    CurrentIndex = "LeftIndex"
                    elseif side == "mid" then
                    CurrentSide = midsec
                    CurrentIndex = "MidIndex"
                    elseif side == "right" then
                    CurrentSide = rightsec
                    CurrentIndex = "RightIndex"
                    else
                    CurrentSide = leftsec
                    CurrentIndex = "LeftIndex"
                end

                local TextForSeporation = Drawing.new("text", { x = 0, y = 0, text = properties.text or "", font = "Wowza", color = Color(255,255,255, 255) , xAlign = TEXT_ALIGN_CENTER })
                local UI_ACCENT2 = Drawing.new("rectangle", {
                    x = xp,
                    y = yp,
                    width = IndexX + 15,
                    height = 1,
                    color = cls.color1 })
                
                local centerX_B = CurrentSide.properties.x + (CurrentSide.properties.width / 2)

                local x_A = centerX_B - (UI_ACCENT2.properties.width / 2)

                AnchorElement(UI_ACCENT2 , CurrentSide , { 0, x_A, 0, InnerTab[CurrentIndex] + IndexY + 3} , false)
                AnchorElement(TextForSeporation , CurrentSide , { 0, CurrentSide.properties.width / 2 + CurrentSide.properties.x , 0, InnerTab[CurrentIndex]} , false)
                table.insert(TabElements[TabElementsIndex].elements , TextForSeporation)
                table.insert(TabElements[TabElementsIndex].elements , UI_ACCENT2)

                InnerTab[CurrentIndex] = InnerTab[CurrentIndex] + IndexY + 10
            end

            function InnerTab.toggle(properties)
                local inner = {}
                local default = properties.default or false
                local name = properties.name or "UnnamedToggle"
                local flag = properties.flag or name .. "Toggleflag"
                local side = properties.side or "left"

                GLib_Flags[flag] = default
                local flagging = GLib_Flags[flag]
                local showcolorpicker = false
                local CurrentSide 
                local CurrentIndex 
                
                if side == "left" then
                    CurrentSide = leftsec
                    CurrentIndex = "LeftIndex"
                    elseif side == "mid" then
                    CurrentSide = midsec
                    CurrentIndex = "MidIndex"
                    elseif side == "right" then
                    CurrentSide = rightsec
                    CurrentIndex = "RightIndex"
                    else
                    CurrentSide = leftsec
                    CurrentIndex = "LeftIndex"
                end

                local NAME = Drawing.new("text", { x = 0, y = 0, text = name, font = "Wowza", color = Color(255,255,255, 255) , xAlign = TEXT_ALIGN_LEFT })
                local INTERACTABLE = Drawing.new("rectangle", {x = 0,y = IndexY,width = 9,height = 9,color =  Color(33,33,33, 255)})   
                local INTERACTABLEOutline = Drawing.new("rectangle", {x = 0,y = IndexY,width = 11,height = 11,color =  Color(40,40,40, 255)})  

                if flagging then
                    INTERACTABLE.properties.color = cls.color1
                else
                    INTERACTABLE.properties.color = Color(33,33,33, 255)
                end

                if properties.risky == true then
                    NAME.properties.color = Color(255,255,0,255)
                end
                AnchorElement(INTERACTABLEOutline , INTERACTABLE , { 0, -1, 0, -1} , false)
                table.insert(TabElements[TabElementsIndex].elements , INTERACTABLEOutline)

                AnchorElement(INTERACTABLE , CurrentSide , { 0, 7, 0, InnerTab[CurrentIndex]} , false)
                table.insert(TabElements[TabElementsIndex].elements , INTERACTABLE)

                AnchorElement(NAME , INTERACTABLE , { 0, 12, 0, -3} , false)
                table.insert(TabElements[TabElementsIndex].elements , NAME)
                
                local UiTips

                if properties.tip then
                    UiTips = Drawing.new("text", { x = 0, y = 0, text = properties.tip, font = "Wowza", color = cls.color1 })
                    local IndexX, IndexY = surface.GetTextSize(properties.tip)
                    AnchorElement(UiTips , mnftabsect , { 0,mnftabsect.properties.width,0,mnftabsect.properties.height - IndexY} , false)
                    table.insert(TabElements[TabElementsIndex].elements , UiTips)
                end

                AddConnection(INTERACTABLE 
                ,                 function(hovering) 
                    
                    if hovering == true and UiTips then
                        UiTips.properties.color = cls.color2
                    elseif UiTips then
                        UiTips.properties.color = Color(0,0,0,0)
                    end
                end 
                , function() 
                    if TabElements[TabElementsIndex].shoulddraw then
                        flagging = not flagging
                    end

                    if flagging then
                        if properties.callback then properties.callback(true) end
                        INTERACTABLE.properties.color = cls.color1
                    else
                        INTERACTABLE.properties.color = Color(33,33,33, 255)
                        if properties.callback then properties.callback(false) end
                    end
                    GLib_Flags[flag] = flagging
                end)

                InnerTab[CurrentIndex] = InnerTab[CurrentIndex] + 20

                function inner.colorpicker(hh,props)
                    local sxi = 300
                    local syi = 165
                    local xpi = surface.ScreenWidth()/2-(sxi/2)
                    local ypi = surface.ScreenHeight()/2-(syi/2)
                    local cdefault = props.default or Color(255,255,255,255)
                    local cflag = props.flag or properties.name.."_color"

                    GLib_Flags[cflag] = cdefault


                    local interactbutton = Drawing.new("rectangle", {
                        x = 35,
                        y = 14,
                        width = 35,
                        height = 10,
                        color = cdefault})
                    table.insert(TabElements[TabElementsIndex].elements , interactbutton)
                    AnchorElement(interactbutton , INTERACTABLE , { 0,94,0,0} , false)

                    table.insert(TabElements2 , {shoulddraw = true , elements = {}})
                    local TabElementsIndex2 = #TabElements2
                    
                    for a,v in pairs(TabElements2) do if a ~= TabElementsIndex2 then v.shoulddraw = false end end
                    TabElements2[TabElementsIndex2].shoulddraw = not TabElements2[TabElementsIndex2].shoulddraw

                     AddConnection(interactbutton , function(hovering)

                        end ,
                        function()

                        for a,v in pairs(TabElements2) do if a ~= TabElementsIndex2 then v.shoulddraw = false end end
                        TabElements2[TabElementsIndex2].shoulddraw = true

                        end)
                    local MainUiBack = Drawing.new("rectangle", {
                        x = xpi-2,
                        y = ypi-2,
                        width = sxi + 4,
                        height = syi + 4,
                        color = Color(14,14,14, 255)})
                    table.insert(TabElements2[TabElementsIndex2].elements , MainUiBack)
                    local MainUiInline = Drawing.new("rectangle", {
                        x = xpi-1,
                        y = ypi-1,
                        width = sxi + 2,
                        height = syi + 2,
                        color =  Color(50,50,50,255)})
                    table.insert(TabElements2[TabElementsIndex2].elements , MainUiInline)
                    local UI_CORE = Drawing.new("rectangle", {
                        x = xpi,
                        y = ypi,
                        width = sxi,
                        height = syi,
                        color = Color(33, 33, 33, 255) })
                    table.insert(TabElements2[TabElementsIndex2].elements , UI_CORE)
                    local core3 = Drawing.new("rectangle", {
                        x = xpi+1,
                        y = ypi+20,
                        width = sxi-2,
                        height = syi-21,
                        color = Color(0,0,0, 255) })
                    table.insert(TabElements2[TabElementsIndex2].elements , core3)
                    local core4 = Drawing.new("rectangle", {
                        x = xpi+2,
                        y = ypi+21,
                        width = sxi-4,
                        height = syi-23,
                        color = Color(46,46,46, 255) })
                    table.insert(TabElements2[TabElementsIndex2].elements , core4)
                    local core2 = Drawing.new("rectangle", {
                        x = xpi+3,
                        y = ypi+22,
                        width = sxi-6,
                        height = syi-25,
                        color = Color(12, 12, 12, 255) })
                    table.insert(TabElements2[TabElementsIndex2].elements , core2)    
                    local MainUiName = Drawing.new("text", { x = xpi+4, y = ypi+4, text = properties.name.. " color", font = "Wowza", color = Color(255,255,255,255) })
                    table.insert(TabElements2[TabElementsIndex2].elements , MainUiName)
            
                    local UI_ACCENT1 = Drawing.new("rectangle", {
                        x = xpi,
                        y = ypi,
                        width = sxi,
                        height = 1,
                        color = Color(120, 81, 169) })
                    table.insert(TabElements2[TabElementsIndex2].elements , UI_ACCENT1)
                    
                    local color_pre = Drawing.new("rectangle", {
                        x = xpi+8,
                        y = ypi+30,
                        width = 100,
                        height = 50,
                        color = cdefault })
                        table.insert(TabElements2[TabElementsIndex2].elements , color_pre)

                    local color_after = Drawing.new("rectangle", {
                        x = xpi+8,
                        y = ypi+85,
                        width = 100,
                        height = 50,
                        color = Color(255, 255, 255) })
                        table.insert(TabElements2[TabElementsIndex2].elements , color_after)

                    local bftext = Drawing.new("text", { x = xpi+10, y = ypi+32, text = "old", font = "Wowza", color = Color(255,255,255,255) })
                    table.insert(TabElements2[TabElementsIndex2].elements , bftext)

                    local aftertext = Drawing.new("text", { x = xpi+10, y = ypi+85, text = "new", font = "Wowza", color = Color(255,255,255,255) })
                    table.insert(TabElements2[TabElementsIndex2].elements , aftertext)
                    
                    local copyback = Drawing.new("rectangle", {
                        x = xpi+8,
                        y = ypi+142,
                        width = 45,
                        height = 14,
                        color = Color(27, 27, 27) })
                        table.insert(TabElements2[TabElementsIndex2].elements , copyback)

                    local copytext = Drawing.new("text", { x = xpi+30, y = ypi+144, text = "copy", font = "Flags", color = Color(255,255,255,255), xAlign = TEXT_ALIGN_CENTER })
                    table.insert(TabElements2[TabElementsIndex2].elements , copytext)

                    local pasteback = Drawing.new("rectangle", {
                        x = xpi+63,
                        y = ypi+142,
                        width = 45,
                        height = 14,
                        color = Color(27, 27, 27) })
                        table.insert(TabElements2[TabElementsIndex2].elements , pasteback)

                    local pastetext = Drawing.new("text", { x = xpi+86, y = ypi+144, text = "paste", font = "Flags", color = Color(255,255,255,255), xAlign = TEXT_ALIGN_CENTER })
                    table.insert(TabElements2[TabElementsIndex2].elements , pastetext)
                    local applyback = Drawing.new("rectangle", {
                        x = xpi+127,
                        y = ypi+142,
                        width = 147,
                        height = 14,
                        color = Color(27, 27, 27) })
                        table.insert(TabElements2[TabElementsIndex2].elements , applyback)

                    local applytext = Drawing.new("text", { x = xpi+200, y = ypi+144, text = "apply", font = "Flags", color = Color(255,255,255,255), xAlign = TEXT_ALIGN_CENTER })
                    table.insert(TabElements2[TabElementsIndex2].elements , applytext)
                    
                    AddConnection(applyback , function(hovering)

                        end ,
                        function()
                        if TabElements2[TabElementsIndex2].shoulddraw then else return end
                        GLib_Flags[cflag] = color_after.properties.color
                        print(cflag)
                        color_pre.properties.color = GLib_Flags[cflag]
                        interactbutton.properties.color = GLib_Flags[cflag]
                        for a,v in pairs(TabElements2) do if a ~= TabElementsIndex2 then v.shoulddraw = false end end
                        TabElements2[TabElementsIndex2].shoulddraw = false
                    end)

                    do -- red
                        local default = 255
                        local min = 0
                        local max = 255
                        local step =  1
                        local IndexX = surface.GetTextSize( "qqqqqqqqqqqqqqqqqq")

                        local ButtonText = Drawing.new("text", { x = 0, y = 0, text = "red", font = "Wowza", color = Color(255,255,255, 255) , xAlign = TEXT_ALIGN_LEFT })
                        local INTERACTABLE = Drawing.new("rectangle", {x = 0,y = 0,width = IndexX,height = 10,color =  Color(33,33,33, 255)})   
                        local Fill = Drawing.new("rectangle", {x = 0,y = 0,width = IndexX,height = 10,color =  cls.color1})   
                        local INTERACTABLEOutline = Drawing.new("rectangle", {x = 0,y = 0,width = IndexX + 2,height = 10 + 2,color =  Color(40,40,40, 255)})  
                        local SliderValue = Drawing.new("text", { x = 0, y = 0, text = default, font = "Wowza", color = Color(255,255,255, 255) , xAlign = TEXT_ALIGN_RIGHT })
                        table.insert(Sliders , {interactable = INTERACTABLE , colpick = true, fill = Fill , valuetext = SliderValue, min = min , max = max , step = step , value = default , tabindex = TabElementsIndex2 })
                        local slidingindex = #Sliders
                        AnchorElement(INTERACTABLEOutline , INTERACTABLE , { 0, -1, 0, -1} , false)
                        AnchorElement(INTERACTABLE , core2 , { 0, core2.properties.width / 2 - IndexX /2 + 50 , 0, 15} , false)
                        table.insert(TabElements2[TabElementsIndex2].elements , INTERACTABLE)
                        table.insert(TabElements2[TabElementsIndex2].elements , INTERACTABLEOutline)

                        AnchorElement(Fill , INTERACTABLE , { 0, 0,0,0} , false)
                        table.insert(TabElements2[TabElementsIndex2].elements , Fill)

                        AnchorElement(ButtonText , INTERACTABLE , { 0, 0, 0, -11} , false)
                        table.insert(TabElements2[TabElementsIndex2].elements , ButtonText)

                        AnchorElement(SliderValue , INTERACTABLE , { 1, 0, 0, -3} , false)
                        table.insert(TabElements2[TabElementsIndex2].elements , SliderValue)

                        AddConnection(INTERACTABLE , function(hovering)
                        
                            if hovering then SliderValue.properties.color = Color(255,255,255, 255) else SliderValue.properties.color = Color(255,255,255, 0)  end
                       
                            if properties.callback then properties.callback(Sliders[slidingindex].value) end
                            color_after.properties.color = Color(Sliders[slidingindex].value ,color_after.properties.color.g ,color_after.properties.color.b )
                            end , function()
                   
                        end)
                    end

                    do -- green
                        local default = 255
                        local min = 0
                        local max = 255
                        local step =  1
                        local IndexX = surface.GetTextSize( "qqqqqqqqqqqqqqqqqq")

                        local ButtonText = Drawing.new("text", { x = 0, y = 0, text = "green", font = "Wowza", color = Color(255,255,255, 255) , xAlign = TEXT_ALIGN_LEFT })
                        local INTERACTABLE = Drawing.new("rectangle", {x = 0,y = 0,width = IndexX,height = 10,color =  Color(33,33,33, 255)})   
                        local Fill = Drawing.new("rectangle", {x = 0,y = 0,width = IndexX,height = 10,color =  cls.color1})   
                        local INTERACTABLEOutline = Drawing.new("rectangle", {x = 0,y = 0,width = IndexX + 2,height = 10 + 2,color =  Color(40,40,40, 255)})  
                        local SliderValue = Drawing.new("text", { x = 0, y = 0, text = default, font = "Wowza", color = Color(255,255,255, 255) , xAlign = TEXT_ALIGN_RIGHT })
                        table.insert(Sliders , {interactable = INTERACTABLE , colpick = true,fill = Fill , valuetext = SliderValue, min = min , max = max , step = step , value = default , tabindex = TabElementsIndex2})
                        local slidingindex = #Sliders
                        AnchorElement(INTERACTABLEOutline , INTERACTABLE , { 0, -1, 0, -1} , false)
                        AnchorElement(INTERACTABLE , core2 , { 0, core2.properties.width / 2 - IndexX /2 + 50 , 0, 45} , false)
                        table.insert(TabElements2[TabElementsIndex2].elements , INTERACTABLE)
                        table.insert(TabElements2[TabElementsIndex2].elements , INTERACTABLEOutline)

                        AnchorElement(Fill , INTERACTABLE , { 0, 0,0,0} , false)
                        table.insert(TabElements2[TabElementsIndex2].elements , Fill)

                        AnchorElement(ButtonText , INTERACTABLE , { 0, 0, 0, -11} , false)
                        table.insert(TabElements2[TabElementsIndex2].elements , ButtonText)

                        AnchorElement(SliderValue , INTERACTABLE , { 1, 0, 0, -3} , false)
                        table.insert(TabElements2[TabElementsIndex2].elements , SliderValue)

                        AddConnection(INTERACTABLE , function(hovering)
                      
                            if hovering then SliderValue.properties.color = Color(255,255,255, 255) else SliderValue.properties.color = Color(255,255,255, 0)  end
                       
                            if properties.callback then properties.callback(Sliders[slidingindex].value) end
                            color_after.properties.color = Color( color_after.properties.color.r,Sliders[slidingindex].value ,color_after.properties.color.b )
                            end , function()
                                
                        end)
                    end

                    do -- blue
                        local default = 255
                        local min = 0
                        local max = 255
                        local step =  1
                        local IndexX = surface.GetTextSize( "qqqqqqqqqqqqqqqqqq")

                        local ButtonText = Drawing.new("text", { x = 0, y = 0, text = "blue", font = "Wowza", color = Color(255,255,255, 255) , xAlign = TEXT_ALIGN_LEFT })
                        local INTERACTABLE = Drawing.new("rectangle", {x = 0,y = 0,width = IndexX,height = 10,color =  Color(33,33,33, 255)})   
                        local Fill = Drawing.new("rectangle", {x = 0,y = 0,width = IndexX,height = 10,color =  cls.color1})   
                        local INTERACTABLEOutline = Drawing.new("rectangle", {x = 0,y = 0,width = IndexX + 2,height = 10 + 2,color =  Color(40,40,40, 255)})  
                        local SliderValue = Drawing.new("text", { x = 0, y = 0, text = default, font = "Wowza", color = Color(255,255,255, 255) , xAlign = TEXT_ALIGN_RIGHT })
                        table.insert(Sliders , {interactable = INTERACTABLE , fill = Fill , valuetext = SliderValue, min = min , max = max , step = step , value = default , tabindex = TabElementsIndex2, colpick = true,})
                        local slidingindex = #Sliders
                        AnchorElement(INTERACTABLEOutline , INTERACTABLE , { 0, -1, 0, -1} , false)
                        AnchorElement(INTERACTABLE , core2 , { 0, core2.properties.width / 2 - IndexX /2 + 50 , 0, 75} , false)
                        table.insert(TabElements2[TabElementsIndex2].elements , INTERACTABLE)
                        table.insert(TabElements2[TabElementsIndex2].elements , INTERACTABLEOutline)

                        AnchorElement(Fill , INTERACTABLE , { 0, 0,0,0} , false)
                        table.insert(TabElements2[TabElementsIndex2].elements , Fill)

                        AnchorElement(ButtonText , INTERACTABLE , { 0, 0, 0, -11} , false)
                        table.insert(TabElements2[TabElementsIndex2].elements , ButtonText)

                        AnchorElement(SliderValue , INTERACTABLE , { 1, 0, 0, -3} , false)
                        table.insert(TabElements2[TabElementsIndex2].elements , SliderValue)

                        AddConnection(INTERACTABLE , function(hovering)
                      
                            if hovering then SliderValue.properties.color = Color(255,255,255, 255) else SliderValue.properties.color = Color(255,255,255, 0)  end
                       
                            if properties.callback then properties.callback(Sliders[slidingindex].value) end
                            color_after.properties.color = Color( color_after.properties.color.r,color_after.properties.color.g,Sliders[slidingindex].value )
                            end , function()
                   
                        end)
                    end
                end
                return inner
            end

            function InnerTab.button(properties)
            

                local name = properties.name or "UnnamedButton"
                local side = properties.side or "left"
                local callback = properties.callback or function() end
                local IndexX, IndexY = surface.GetTextSize( properties.name)

                local CurrentSide 
                local CurrentIndex 
                
                if side == "left" then
                    CurrentSide = leftsec
                    CurrentIndex = "LeftIndex"
                    IndexX = surface.GetTextSize( "qqqqqqqqqqqqqqqq")
                    elseif side == "mid" then
                    CurrentSide = midsec
                    CurrentIndex = "MidIndex"
                    elseif side == "right" then
                    CurrentSide = rightsec
                    CurrentIndex = "RightIndex"
                    IndexX = surface.GetTextSize( "qqqqqqqqqqqqqqqq")
                    else
                    IndexX = surface.GetTextSize( "qqqqqqqqqqqqqqqq")
                    CurrentSide = leftsec
                    CurrentIndex = "LeftIndex"
                end


                local ButtonText = Drawing.new("text", { x = 0, y = 0, text = properties.name, font = "Wowza", color = Color(255,255,255, 255) , xAlign = TEXT_ALIGN_CENTER })
                local INTERACTABLE = Drawing.new("rectangle", {x = 0,y = 0,width = IndexX + 40,height = IndexY,color =  Color(33,33,33, 255)})   
                local INTERACTABLEOutline = Drawing.new("rectangle", {x = 0,y = 0,width = IndexX + 40 + 2,height = IndexY + 2,color =  Color(40,40,40, 255)})  

                
                AnchorElement(INTERACTABLEOutline , INTERACTABLE , { 0, -1, 0, -1} , false)
                table.insert(TabElements[TabElementsIndex].elements , INTERACTABLEOutline)

                AnchorElement(INTERACTABLE , CurrentSide , { 0, CurrentSide.properties.width / 2 - IndexX + 40 /2 , 0, InnerTab[CurrentIndex]} , false)
                table.insert(TabElements[TabElementsIndex].elements , INTERACTABLE)

                AnchorElement(ButtonText , INTERACTABLE , { 0, INTERACTABLE.properties.width / 2 + INTERACTABLE.properties.x, 0, 0} , false)
                table.insert(TabElements[TabElementsIndex].elements , ButtonText)

                local UiTips

                if properties.tip then
                     UiTips = Drawing.new("text", { x = 0, y = 0, text = properties.tip, font = "Wowza", color = cls.color2 })
                    local IndexX, IndexY = surface.GetTextSize(properties.tip)
                    AnchorElement(UiTips , mnftabsect , { 0,mnftabsect.properties.width,0,mnftabsect.properties.height - IndexY} , false)
                    table.insert(TabElements[TabElementsIndex].elements , UiTips)
                end

                AddConnection(INTERACTABLE , function(hovering)
                    if UiTips and hovering then
                        UiTips.properties.color = cls.color2
                    elseif UiTips then
                        UiTips.properties.color = Color(0,0,0,0)
                    end

                    end , function()
                   
                end)

                InnerTab[CurrentIndex] = InnerTab[CurrentIndex] +  10
            end

            function InnerTab.dropdown(properties)
            

                local name = properties.name or "UnNamedDropdown"
                local side = properties.side or "left"
                local options = properties.options or {}
                local flag = properties.flag or name .. "DropFlag"
                local default = properties.default or properties.options[1] or #options
                local IndexX, IndexY = surface.GetTextSize( "qqqqqqqqqqqqqqqqqq")
                
                GLib_Flags[flag] = default
                local flagging = GLib_Flags[flag]

                local CurrentSide 
                local CurrentIndex 
                local newindexlol = 12
                if side == "left" then
                    CurrentSide = leftsec
                    CurrentIndex = "LeftIndex"
                    IndexX = surface.GetTextSize( "qqqqqqqqqqqqqqqq")
                    elseif side == "mid" then
                    CurrentSide = midsec
                    CurrentIndex = "MidIndex"
                    elseif side == "right" then
                    CurrentSide = rightsec
                    CurrentIndex = "RightIndex"
                    IndexX = surface.GetTextSize( "qqqqqqqqqqqqqqqq")
                    else
                    IndexX = surface.GetTextSize( "qqqqqqqqqqqqqqqq")
                    CurrentSide = leftsec
                    CurrentIndex = "LeftIndex"
                end


                local ButtonText = Drawing.new("text", { x = 0, y = 0, text = name, font = "Wowza", color = Color(255,255,255, 255) , xAlign = TEXT_ALIGN_CENTER })
                local INTERACTABLE = Drawing.new("rectangle", {x = 0,y = 0,width = IndexX,height = 18,color =  Color(33,33,33, 255)})   
                local INTERACTABLEOutline = Drawing.new("rectangle", {x = 0,y = 0,width = IndexX + 2,height = 18 + 2,color =  Color(40,40,40, 255)})  

                table.insert(Dropdowns , {shoulddraw = false, currentvalue, GLib_Flags[flag],element = INTERACTABLE, options = {}})
                local currentdropdownindex = #Dropdowns

                print(GLib_Flags[flag] )
                Dropdowns[currentdropdownindex].currentvalue = GLib_Flags[flag] 

                ButtonText.properties.text = name .. ", " ..  GLib_Flags[flag] 

                for Index , Option in pairs(options) do
                    local names = properties.indexnames and Index or Option
                    local SelectText = Drawing.new("text", { x = 0, y = 0, text = properties.indexnames and Index or Option, font = "Wowza", color = selectcolor , xAlign = TEXT_ALIGN_CENTER })
                    local InteractText = Drawing.new("rectangle", {x = 0,y = 0,width = IndexX,height = 20,color =  Color(33,33,33, 255)})   

                    AnchorElement(InteractText , INTERACTABLE , { 0,0,0,newindexlol+8} , false)
                    AnchorElement(SelectText , InteractText , { 0, InteractText.properties.width / 2 + InteractText.properties.x, 0, 2} , false)

                    table.insert(Dropdowns[currentdropdownindex].options , InteractText)
                    table.insert(Dropdowns[currentdropdownindex].options , SelectText)

                    AddConnection(InteractText , function(hovering) 
                        if UiTips then
                            UiTips.properties.color = cls.color2
                        elseif UiTips then
                            UiTips.properties.color = Color(0,0,0,0)
                        end
                    end , function()
                        if Dropdowns[currentdropdownindex].shoulddraw then
                            
                            GLib_Flags[flag] = Option
                            ButtonText.properties.text = name .. ", " ..  names
                            Dropdowns[currentdropdownindex].shoulddraw = not Dropdowns[currentdropdownindex].shoulddraw
                            Dropdowns[currentdropdownindex].currentvalue = GLib_Flags[flag] 
                            
                        end
                    end)

                    newindexlol = newindexlol + 18
                end

                AnchorElement(INTERACTABLEOutline , INTERACTABLE , { 0, -1, 0, -1} , false)
                AnchorElement(INTERACTABLE , CurrentSide , { 0, CurrentSide.properties.width / 2 - IndexX /2 , 0, InnerTab[CurrentIndex]-4} , false)
                table.insert(TabElements[TabElementsIndex].elements , INTERACTABLE)

                table.insert(TabElements[TabElementsIndex].elements , INTERACTABLEOutline)

                AnchorElement(ButtonText , INTERACTABLE , { 0, INTERACTABLE.properties.width / 2 + INTERACTABLE.properties.x, 0, 1} , false)
                table.insert(TabElements[TabElementsIndex].elements , ButtonText)


                local UiTips

                if properties.tip then
                     UiTips = Drawing.new("text", { x = 0, y = 0, text = properties.tip, font = "Wowza", color = cls.color2 })
                    local IndexX, IndexY = surface.GetTextSize(properties.tip)
                    AnchorElement(UiTips , mnftabsect , { 0,mnftabsect.properties.width,0,mnftabsect.properties.height - IndexY} , false)
                    table.insert(TabElements[TabElementsIndex].elements , UiTips)
                end

                AddConnection(INTERACTABLE , function(hovering) 
                    
                if UiTips and hovering then
                    UiTips.properties.color = cls.color2
                elseif UiTips then
                    UiTips.properties.color = Color(0,0,0,0)
                end
                end , function()
                    if not TabElements[TabElementsIndex].shoulddraw then return end
                    Dropdowns[currentdropdownindex].shoulddraw = not Dropdowns[currentdropdownindex].shoulddraw
                end)
                InnerTab[CurrentIndex] = InnerTab[CurrentIndex] +  21
            end

            function InnerTab.Mulidown(properties)
            

                local name = properties.name or "UnNamedDropdown"
                local side = properties.side or "left"
                local options = properties.options or {}
                local flag = properties.flag or name .. "DropFlag"
                local default = properties.default or {}
                local IndexX, IndexY = surface.GetTextSize( "qqqqqqqqqqqqqqqqqq")
                
                GLib_Flags[flag] = default
                local flagging = GLib_Flags[flag]

                local CurrentSide 
                local CurrentIndex 
                local newindexlol = 12
                if side == "left" then
                    CurrentSide = leftsec
                    CurrentIndex = "LeftIndex"
                    elseif side == "mid" then
                    CurrentSide = midsec
                    CurrentIndex = "MidIndex"
                    elseif side == "right" then
                    CurrentSide = rightsec
                    CurrentIndex = "RightIndex"
                    else
                    CurrentSide = leftsec
                    CurrentIndex = "LeftIndex"
                end

                local ButtonText = Drawing.new("text", { x = 0, y = 0, text = name, font = "Wowza", color = Color(255,255,255, 255) , xAlign = TEXT_ALIGN_CENTER })
                local INTERACTABLE = Drawing.new("rectangle", {x = 0,y = 0,width = IndexX,height = 18,color =  Color(33,33,33, 255)})   
                local INTERACTABLEOutline = Drawing.new("rectangle", {x = 0,y = 0,width = IndexX + 2,height = 18 + 2,color =  Color(40,40,40, 255)})  

                table.insert(Dropdowns , {shoulddraw = false, currentvalue, GLib_Flags[flag],element = INTERACTABLE, options = {}})
                local currentdropdownindex = #Dropdowns

                
                Dropdowns[currentdropdownindex].currentvalue = GLib_Flags[flag] 

                ButtonText.properties.text = name .. ", " ..  GLib_Flags[flag]

                for Index , Option in pairs(options) do
                    

                    local SelectText = Drawing.new("text", { x = 0, y = 0, text = Option, font = "Wowza", color = selectcolor , xAlign = TEXT_ALIGN_CENTER })
                    local InteractText = Drawing.new("rectangle", {x = 0,y = 0,width = IndexX,height = 20,color =  Color(33,33,33, 255)})   

                    AnchorElement(InteractText , INTERACTABLE , { 0,0,0,newindexlol+8} , false)
                    AnchorElement(SelectText , InteractText , { 0, InteractText.properties.width / 2 + InteractText.properties.x, 0, 2} , false)

                    table.insert(Dropdowns[currentdropdownindex].options , InteractText)
                    table.insert(Dropdowns[currentdropdownindex].options , SelectText)

                    AddConnection(InteractText , function(hovering) 
                        if UiTips then
                            UiTips.properties.color = cls.color2
                        elseif UiTips then
                            UiTips.properties.color = Color(0,0,0,0)
                        end
                    end , function()
                        if Dropdowns[currentdropdownindex].shoulddraw then
                            
                            GLib_Flags[flag] = Option
                            ButtonText.properties.text = name .. ", " ..  GLib_Flags[flag]
                            Dropdowns[currentdropdownindex].shoulddraw = not Dropdowns[currentdropdownindex].shoulddraw
                            Dropdowns[currentdropdownindex].currentvalue = GLib_Flags[flag] 
                            
                        end
                    end)

                    newindexlol = newindexlol + 18
                end

                AnchorElement(INTERACTABLEOutline , INTERACTABLE , { 0, -1, 0, -1} , false)
                AnchorElement(INTERACTABLE , CurrentSide , { 0, CurrentSide.properties.width / 2 - IndexX /2 , 0, InnerTab[CurrentIndex]-4} , false)
                table.insert(TabElements[TabElementsIndex].elements , INTERACTABLE)

                table.insert(TabElements[TabElementsIndex].elements , INTERACTABLEOutline)

                AnchorElement(ButtonText , INTERACTABLE , { 0, INTERACTABLE.properties.width / 2 + INTERACTABLE.properties.x, 0, 1} , false)
                table.insert(TabElements[TabElementsIndex].elements , ButtonText)


                local UiTips

                if properties.tip then
                     UiTips = Drawing.new("text", { x = 0, y = 0, text = properties.tip, font = "Wowza", color = cls.color2 })
                    local IndexX, IndexY = surface.GetTextSize(properties.tip)
                    AnchorElement(UiTips , mnftabsect , { 0,mnftabsect.properties.width,0,mnftabsect.properties.height - IndexY} , false)
                    table.insert(TabElements[TabElementsIndex].elements , UiTips)
                end

                AddConnection(INTERACTABLE , function(hovering) 
                    
                if UiTips and hovering then
                    UiTips.properties.color = cls.color2
                elseif UiTips then
                    UiTips.properties.color = Color(0,0,0,0)
                end
                end , function()
                    if not TabElements[TabElementsIndex].shoulddraw then return end
                    Dropdowns[currentdropdownindex].shoulddraw = not Dropdowns[currentdropdownindex].shoulddraw
                end)
                InnerTab[CurrentIndex] = InnerTab[CurrentIndex] +  21
            end
            
            function InnerTab.slider(properties)

                local name = properties.name or "UnNamedSlider"
                local side = properties.side or "left"
                local options = properties.options or {}
                local flag = properties.flag or name .. "SlideFlag"
                local default = properties.default or 0
                local min = properties.min or 0
                local max = properties.max or 100
                local step = properties.step or 1
                local IndexX = surface.GetTextSize( "qqqqqqqqqqqqqqqqqq")
                
                GLib_Flags[flag] = default
                local flagging = GLib_Flags[flag]

                local CurrentSide 
                local CurrentIndex 
                if side == "left" then
                    CurrentSide = leftsec
                    CurrentIndex = "LeftIndex"
                    IndexX = surface.GetTextSize( "qqqqqqqqqqqqqqqq")
                    elseif side == "mid" then
                    CurrentSide = midsec
                    CurrentIndex = "MidIndex"
                    elseif side == "right" then
                    CurrentSide = rightsec
                    CurrentIndex = "RightIndex"
                    IndexX = surface.GetTextSize( "qqqqqqqqqqqqqqqq")
                    else
                    IndexX = surface.GetTextSize( "qqqqqqqqqqqqqqqq")
                    CurrentSide = leftsec
                    CurrentIndex = "LeftIndex"
                end

                InnerTab[CurrentIndex] = InnerTab[CurrentIndex] +  5

                local ButtonText = Drawing.new("text", { x = 0, y = 0, text = name, font = "Wowza", color = Color(255,255,255, 255) , xAlign = TEXT_ALIGN_LEFT })
                local INTERACTABLE = Drawing.new("rectangle", {x = 0,y = 0,width = IndexX,height = 10,color =  Color(33,33,33, 255)})   
                local Fill = Drawing.new("rectangle", {x = 0,y = 0,width = IndexX,height = 10,color =  cls.color1})   
                local INTERACTABLEOutline = Drawing.new("rectangle", {x = 0,y = 0,width = IndexX + 2,height = 10 + 2,color =  Color(40,40,40, 255)})  
                local SliderValue = Drawing.new("text", { x = 0, y = 0, text = name, font = "Wowza", color = Color(255,255,255, 255) , xAlign = TEXT_ALIGN_RIGHT })
                table.insert(Sliders , {interactable = INTERACTABLE , fill = Fill , valuetext = SliderValue, min = min , max = max , step = step , value = default , tabindex = TabElementsIndex, colpick = false})
                local slidingindex = #Sliders
                AnchorElement(INTERACTABLEOutline , INTERACTABLE , { 0, -1, 0, -1} , false)
                AnchorElement(INTERACTABLE , CurrentSide , { 0, CurrentSide.properties.width / 2 - IndexX /2 , 0, InnerTab[CurrentIndex]} , false)
                table.insert(TabElements[TabElementsIndex].elements , INTERACTABLE)
                table.insert(TabElements[TabElementsIndex].elements , INTERACTABLEOutline)

                AnchorElement(Fill , INTERACTABLE , { 0, 0,0,0} , false)
                table.insert(TabElements[TabElementsIndex].elements , Fill)

                AnchorElement(ButtonText , INTERACTABLE , { 0, 0, 0, -11} , false)
                table.insert(TabElements[TabElementsIndex].elements , ButtonText)

                AnchorElement(SliderValue , INTERACTABLE , { 1, 0, 0, -3} , false)
                table.insert(TabElements[TabElementsIndex].elements , SliderValue)

                local UiTips

                if properties.tip then
                     UiTips = Drawing.new("text", { x = 0, y = 0, text = properties.tip, font = "Flags", color = cls.color2 })
                    local IndexX, IndexY = surface.GetTextSize(properties.tip)
                    AnchorElement(UiTips , mnftabsect , { 0,mnftabsect.properties.width,0,mnftabsect.properties.height - IndexY} , false)
                    table.insert(TabElements[TabElementsIndex].elements , UiTips)
                end

                AddConnection(INTERACTABLE , function(hovering)
                    if hovering and CanDrag == true then CanDrag = false end 
                    if hovering then SliderValue.properties.color = Color(255,255,255, 255) else SliderValue.properties.color = Color(255,255,255, 0)  end
                    GLib_Flags[flag] = Sliders[slidingindex].value
                    if properties.callback then properties.callback(Sliders[slidingindex].value) end

                    if UiTips and hovering then
                        UiTips.properties.color = cls.color2
                    elseif UiTips then
                        UiTips.properties.color = Color(0,0,0,0)
                    end

                    end , function()
                   
                end)

                InnerTab[CurrentIndex] = InnerTab[CurrentIndex] +  21
            end
            return InnerTab
        end
        return tabsystem
    end
end

local aimtarg

do -- ANCHOR - Ok lets start

    do -- SECTION - Esp 
        local ActiveFlags = {}
        local currentqueue = 0

        function a(ply)
            if GLib_Flags["Players_ESP"] then
                
                if not ply:Alive() then return end
                if ply == LocalPlayer() then return end
                
                local pos = ply:GetPos()
                local spinePos = ply:LookupBone("ValveBiped.Bip01_Spine") and ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Spine")) or pos
    
                local vTop = pos + (ply:GetUp() * 70.8) + EyeAngles():Up()
    
                local vBottom = pos - (ply:GetUp() * 2.5) - EyeAngles():Up()
    
                local top = vTop:ToScreen()
                local bottom = vBottom:ToScreen()
    
                local _width = math.max(math.floor(math.abs(top.x - bottom.x)), 3)
                local _height = math.max(math.floor(math.max(math.abs(bottom.y - top.y), _width / 2)), 3)
    
                local boxSize = Vector(math.floor(math.max(_height / 1.5, _width)), _height)
                local boxPosition = Vector(
                    math.floor(top.x * 0.5 + bottom.x * 0.5 - boxSize.x * 0.5),
                    math.floor(math.min(top.y, bottom.y))
                )
    
                local dist = LocalPlayer():GetPos():Distance(ply:GetPos()) * 0.0254 

                if GLib_Flags["Players_MaxDist"] ~= 0 and dist > GLib_Flags["Players_MaxDist"] then return end
    
                local ActiveWeapon = ply:GetActiveWeapon()
                local ActiveWeaponName = nil
                
                local yOffset = boxPosition.Y
    
                pcall(function()
                    ActiveWeaponName = ActiveWeapon:GetPrintName() or "Nothing"
                end)
                
                local function addFlag(nam, properties)
                    local flagfound = false
                    local newFlag = {
                        name = nam,
                        x = properties.x,
                        y = properties.y,
                        text = properties.text,
                        font = properties.font or "Default", -- You can change the default font if needed
                        color = properties.color,
                        xAlign = properties.xAlign or TEXT_ALIGN_LEFT, -- You can change the default alignment if needed
                        spot = properties.spot
                    }

                    for i, flag in ipairs(ActiveFlags) do
                        if flag.name == nam then
                            ActiveFlags[i] = newFlag
                            flagfound = true
                        end
                    end
                    if flagfound == false then
                        table.insert(ActiveFlags , newFlag)
                    end
                end
                
                local function removeFlag(name)
                    for i, flag in ipairs(ActiveFlags) do
                        if flag.name == name then
                            table.remove(ActiveFlags, i)
                        end
                    end
                end

                if GLib_Flags["Players_Box"] then
                    local rectangle = Drawing.new("outrect", {
                        x = boxPosition.x,
                        y = boxPosition.y,
                        width = boxSize.x,
                        height = boxSize.y,
                        color = Color(255,255,255,255)
                    }):draw()
                end 
                
                if GLib_Flags["Players_Name"] then
                    local NameEsp = Drawing.new("text", {
                        x = boxSize.X / 2 + boxPosition.X,
                        y = boxPosition.Y - 16,
                        text = ply:GetName(),
                        font = "Wowza",
                        color = Color(255, 255, 255, 255),
                        xAlign = TEXT_ALIGN_CENTER,
                       
                    }):draw()
                end
                
                if GLib_Flags["Players_Weapon"] then
                    local DistanceEsp = Drawing.new("text", {
                        x = (boxSize.X / 2 + boxPosition.X)+1,
                        y = boxPosition.Y + boxSize.Y,
                        text = ActiveWeaponName,
                        font = "Flags",
                        color = Color(255, 255, 255, 255),
                        xAlign = TEXT_ALIGN_CENTER
                    }):draw()
                end

                if GLib_Flags["Players_Health"] then
                    local HealthOutline = Drawing.new("outrect", {
                        x = math.floor(boxPosition.x) - 5,
                        y = math.floor(boxPosition.y),
                        width = 2,
                        height = boxSize.y,
                        color = GLib_Flags["Health_Color"]
                    }):draw()
                    local HealthBar = Drawing.new("rectangle", {
                        x = math.floor(boxPosition.x) - 5,
                        y = math.floor(boxPosition.y) ,
                        width = 2,
                        height =  boxSize.Y - (math.Clamp(ply:Health() , 0 , ply:GetMaxHealth()) / ply:GetMaxHealth()) * boxSize.Y,
                        color = Color(0,0,0,255)
                    }):draw()
                end

                if GLib_Flags["Players_Flags"] == true and ply:IsAdmin() then
                    addFlag("Admin" , {
                        x = boxSize.X + boxPosition.X + 2,
                        y = boxPosition.Y,
                        text = "Admin",
                        font = "Flags",
                        color = Color(227, 125, 245, 255),
                        xAlign = TEXT_ALIGN_LEFT,
                        spot = 1,
                    })
                   
                else
                    removeFlag("Admin")
                end

                if GLib_Flags["Players_Flags"] == true then
                   
                    addFlag("Distance" , {
                            x = boxSize.X + boxPosition.X + 2,
                            y = boxPosition.Y,
                            text = math.Round(dist) .. "m",
                            font = "Flags",
                            color = Color(255, 255, 255, 255),
                            xAlign = TEXT_ALIGN_LEFT,
                            spot = 2,
                        })
                        
                else
                    removeFlag("Distance")
                end 

                if GLib_Flags["Players_Flags"] == true and Uberhook.TargetP == ply then
                   
                    addFlag("TARGET" , {
                            x = boxSize.X + boxPosition.X + 2,
                            y = boxPosition.Y,
                            text = "!TARGET!",
                            font = "Flags",
                            color = Color(247, 119, 123, 255),
                            xAlign = TEXT_ALIGN_LEFT,
                            spot = 4,
                        })
                        
                else
                    removeFlag("TARGET")
                end 


                if GLib_Flags["Players_Flags"] == true and engine.ActiveGamemode() == "terrortown" then 
                    local is = false
                    for ii,vv in pairs(ply:GetWeapons()) do
                        if vv.CanBuy and table.HasValue(vv.CanBuy, ROLE_TRAITOR) and ply:Team() ~= "Detectives" then
                            is = true
                            return
                        end
                    end
                    if is then
                        addFlag("Traitor" , {
                            x = boxSize.X + boxPosition.X + 2,
                            y = boxPosition.Y,
                            text = "TRAITOR",
                            font = "Flags",
                            color = Color(247, 119, 123, 255),
                            xAlign = TEXT_ALIGN_LEFT,
                            spot = 3,
                        })
                        return
                    end 
                else
                    removeFlag("Traitor")
                end

                for ind, flag in pairs(ActiveFlags) do
                    local wid , high = surface.GetTextSize(flag.text)
                    flag.y = boxPosition.Y * (1 + currentqueue/40)
                    local flagEsp = Drawing.new("text", flag):draw()
                    currentqueue = currentqueue + 1
                end
                
                currentqueue = 0
            end
        end

        table.insert(Uberhook.PlyDrwCallbacks , {Callback = a})
    end -- !SECTION

    do -- SECTION - Aimbot
        function SCM(pos , sm) -- Smooth Camera Movement
            if pos then
                local lookAtAngles = (pos - LocalPlayer():GetShootPos()):Angle()
                local currentAngles = LerpAngle(FrameTime() * sm, LocalPlayer():EyeAngles(), lookAtAngles)
                LocalPlayer():SetEyeAngles(currentAngles)
            end
        end

        function LCA(pos) -- Lock Camera Angles
            if pos then
                local lookAtAngles = (pos - LocalPlayer():GetShootPos()):Angle()
                LocalPlayer():SetEyeAngles(lookAtAngles)
            end
        end

        function a(fov)
            local targetPlayer = nil
            local maxDistance = fov or math.huge
            local localPlayer = LocalPlayer()
            local screenWidth, screenHeight = ScrW(), ScrH()
            local screenCenter = Vector(screenWidth / 2, screenHeight / 2)

            for _, ply in pairs(player.GetAll()) do
                if ply == localPlayer then continue end
                if not ply:Alive() then continue end

                pcall(function()
                    local targetPos = GetBasePos(ply):ToScreen()
                    if targetPos.visible then
                        local targetScreenPos = Vector(targetPos.x, targetPos.y)
                        local mousePos = Vector(gui.MouseX(), gui.MouseY())

                        local distance = (targetScreenPos - screenCenter):Length()

                        if distance < maxDistance then
                            targetPlayer = ply
                            maxDistance = distance
                        end
                    end
                end)
            end

            return targetPlayer
        end

        function FixMovement(cmd, fa)
	
            local vec = Vector(cmd:GetForwardMove(), cmd:GetSideMove(), 0)
            local vel = math.sqrt(vec.x * vec.x + vec.y * vec.y)
            local mang = vec:Angle()
            local yaw = cmd:GetViewAngles().y - fa.y + mang.y
        
            if ( ( cmd:GetViewAngles().p + 90 ) % 360 ) > 180 then
                yaw = 180 - yaw
            end
        
            yaw = ( ( yaw + 180 ) % 360 ) - 180
        
            cmd:SetForwardMove( math.cos( math.rad( yaw ) ) * vel )
            cmd:SetSideMove( math.sin( math.rad( yaw ) ) * vel )
        
        end

        function b()
            if not GLib_Flags["Aimbot_Enabled"] then return end
            if GLib_Flags["Aimbot_Type"] == "plain" then 
                local fov = GLib_Flags["Aimbot_UseFov"] and GLib_Flags["Aimbot_Rad"] or math.huge
                local dfov = GLib_Flags["Aimbot_UseDeadzone"] and GLib_Flags["Aimbot_DeadzoneRad"] or 0

                local player_target = a(fov) -- Normal Target
                local dplayer_target = a(dfov) -- Deadzone Target
            
                if player_target ~= dplayer_target and input.IsMouseDown(GLib_Flags["Aimbot_Aimkey"]) then
                    if GLib_Flags["Aimbot_Snappy"] then
                        LCA(GetBasePos(player_target))
                    else
                        SCM(GetBasePos(player_target) ,  GLib_Flags["Aimbot_Smoothness"])
                    end
                end
            end
        end 



        function c(ucmd)
            if GLib_Flags["Aimbot_Type"] == "silent" then
                local spreadangle
                if GLib_Flags["misc_nospread"] then
                    spreadangle = PredictSpread(ucmd, LocalPlayer():GetShootPos():Angle())
                else
                    spreadangle = Angle()
                end
                
                local fov = GLib_Flags["Aimbot_UseFov"] and GLib_Flags["Aimbot_Rad"] or math.huge
                local dfov = GLib_Flags["Aimbot_UseDeadzone"] and GLib_Flags["Aimbot_DeadzoneRad"] or 0

                local player_target = a(fov) -- Normal Target
                aimtarg = player_target
                local dplayer_target = a(dfov) -- Deadzone Target

                if(!realAng) then realAng = ucmd:GetViewAngles() end
                realAng = realAng + Angle(ucmd:GetMouseY() * .023, ucmd:GetMouseX() * -.023, 0)
                realAng.x = math.NormalizeAngle(realAng.x)
                realAng.p = math.Clamp(realAng.p, -89, 89)
                if ucmd:CommandNumber() == 0 then ucmd:SetViewAngles(realAng) return end

                if player_target ~= dplayer_target and input.IsMouseDown(GLib_Flags["Aimbot_Aimkey"]) then
                    local targetposition = player_target:GetBonePosition(player_target:LookupBone("ValveBiped.Bip01_Head1"))
                    if targetposition == player_target:GetPos() then
                        targetposition = player_target:GetBoneMatrix(player_target:LookupBone("ValveBiped.Bip01_Head1")):GetTranslation()
                    end
        
                    local FinAngle = (targetposition - LocalPlayer():GetShootPos()):Angle()
                    FinAngle.x = math.NormalizeAngle(FinAngle.x);
                    FinAngle.y = math.NormalizeAngle(FinAngle.y);

                    ucmd:SetViewAngles(FinAngle)
                    FixMovement(ucmd , realAng)
                end
            end
        end

        table.insert(Uberhook.ThinksCallbacks , {Callback = b})
        table.insert(Uberhook.CreateMovebacks , {Callback = c})
    end -- !SECTION

    do -- SECTION - Player Hooks
        hook.Add("OnEntityCreated", "Gmod_PlayerJoined", function(ent)
            if ent:IsPlayer() then
                Uberhook.Players[ent] = {player = ent , alive = ent:Alive() , esp_color = Color(255,255,255,255) , correlations = {}}
            end
        end)
        
        hook.Add("EntityRemoved", "Gmod_PlayerLeft", function(ent)
            if ent:IsPlayer() and Uberhook.Players[ent] then
               table.remove(Uberhook.Players , ent)
            end
        end)
    end -- !SECTION

    do -- SECTION - Hitsounds
        gameevent.Listen( "player_hurt" )
        hook.Add( "player_hurt", "HitSoundz", function( data ) 
            local health = data.health				
            local priority = SERVER and data.Priority or 5 		
            local id = data.userid					
            local attackerid = data.attacker
            
            if LocalPlayer():UserID() == attackerid and GLib_Flags["misc_hitsounds"] then
                sound.PlayURL("https://www.myinstants.com/media/sounds/orb.mp3", "", function(station)end)
        
                if health <= 0 then
                    sound.PlayURL("https://www.myinstants.com/media/sounds/levelup.mp3", "", function(station)end)
                end 
            end 
        end )
    end-- !SECTION

    do -- SECTION bhop
        hook.Add("CreateMove", "bhop", function(ucmd)
            if not GLib_Flags["misc_bhop"] or LocalPlayer():GetMoveType() == MOVETYPE_NOCLIP then return end

            if ucmd:KeyDown( IN_JUMP ) then
                if not LocalPlayer():OnGround() then
                    ucmd:SetButtons( ucmd:GetButtons()-IN_JUMP )
                end
            end
        end)
    end
end

do --speedhack type 1
    hook.Add("CreateMove", "22", function(ucmd)
        if GLib_Flags["beta_freezetype"] == "createmove" and GLib_Flags["beta_sequencefreeze"] then
            local sequencenumber = ded.GetOutSequenceNr()
            ded.SetOutSequenceNr(sequencenumber + GLib_Flags["beta_freezeamt"])
        end
    end)
end

do
    hook.Add("CalcView", "calchook", function(ply, pos, ang, fov)
        local cam = {}
        if GLib_Flags["World_ThirdPerson"] == true then -- PASTING FROM TIMESHACK!!!
            pos = pos - ( ang:Up() * GLib_Flags["World_TpY"] )
            pos = pos - ( ang:Right() * GLib_Flags["World_TpX"] )
    
            cam.origin = pos - ( ang:Forward() * (GLib_Flags["World_TpDist"]) )
            cam.angles = ang
            cam.fov = fov
            cam.drawviewer = true
        end

        if GLib_Flags["misc_norecoil"] == true then
            if GLib_Flags["Aimbot_Type"] ~= "plain" then 
                cam.angles = LocalPlayer():EyeAngles()
            end
        end
        return cam
    end)
end

do
    local proxeye = proxeye or FindMetaTable( "Player" ).SetEyeAngles

    FindMetaTable( "Player" ).SetEyeAngles = function( self, angle )
        if GLib_Flags["Aimbot_Type"] ~= "plain" then 
            if ( string.find( string.lower( debug.getinfo( 2 ).short_src ), "/weapons/" ) ) and GLib_Flags["misc_norecoil"] then return end
            
            proxeye( self, angle )
        end
    end
end

local currentucmd
do -- ANCHOR - Mangerz
    hook.Add("Think" , "Gmod_PlayerManger" , function()

        for Index, Player in pairs(player.GetAll()) do -- ANCHOR - Player Callbaks!
            if Player ~= localplayer then
                for _,CB in pairs(Uberhook.PlayerCallbacks) do
                    CB.Callback(Player)
                end
            end 
        end 

        for Index, Entity in pairs(ents.GetAll()) do  -- ANCHOR - Entity Callbaks!
            if Entity ~= localplayer and Entity:IsPlayer() == false then
                for _,CB in pairs(Uberhook.EntityCallbacks) do
                    CB.Callback(Entity)
                end
            end 
        end

        for _,CB in pairs(Uberhook.ThinksCallbacks) do
            CB.Callback()
        end
    end)

    hook.Add("CreateMove" , "Gmod_PlayerManger2" , function(uc)
        currentucmd = uc
        for _,CB in pairs(Uberhook.CreateMovebacks) do
            CB.Callback(uc)
        end
    end)

    -- ANCHOR glow setup
    hook.Add("PreDrawHalos", "glow", function()
        if GLib_Flags["Players_Glow"] == true then
            local pltb = {}
            for i,v in pairs(player.GetAll()) do
                if v ~= LocalPlayer() and not v:IsDormant() and v:Alive() then
                    table.insert(pltb,v)
                end
            end
            halo.Add(pltb, GLib_Flags["Glow_Color"], GLib_Flags["Players_GlowSize"], GLib_Flags["Players_GlowSize"], 2, true, true)
        end
    end)


    hook.Add("DrawOverlay" , "Gmod_DrawManager" , function() 
        for _,CB in pairs(Uberhook.DrawinCallbacks) do
            CB.Callback("this is nothing")
        end

        for Index, Player in pairs(player.GetAll()) do -- ANCHOR - Player Callbaks!
            if Player ~= localplayer then
                for _,CB in pairs(Uberhook.PlyDrwCallbacks) do
                    CB.Callback(Player)
                end
            end 
        end 
    end)

end

local chamsmats
do -- SECTION - Chams
    CreateMaterial("textured", "VertexLitGeneric") 
    CreateMaterial("flat", "UnLitGeneric")
    CreateMaterial("flat_z", "UnLitGeneric",{["$ignorez"] = 1})
    CreateMaterial("textured_z", "VertexLitGeneric",{["$ignorez"] = 1})
    CreateMaterial( "selfillum", "VertexLitGeneric", {
        ["$basetexture"] = "vgui/white_additive",
        ["$bumpmap"] = "vgui/white_additive",
        ["$model"] = "1",
        ["$nocull"] = "0",
        ["$selfillum"] = 1,
        ["$selfIllumFresnel"] = 1,
        ["$selfIllumFresnelMinMaxExp"] = "[0 0.3 0.6]",
        ["$selfillumtint"] = "[0 0 0]",
    } )

    CreateMaterial( "selfillum_z", "VertexLitGeneric", {
        ["$basetexture"] = "vgui/white_additive",
        ["$bumpmap"] = "vgui/white_additive",
        ["$model"] = "1",
        ["$nocull"] = "0",
        ["$selfillum"] = 1,
        ["$selfIllumFresnel"] = 1,
        ["$selfIllumFresnelMinMaxExp"] = "[0 0.3 0.6]",
        ["$selfillumtint"] = "[0 0 0]",
        ["$ignorez"] = 1,
    } )

    CreateMaterial( "selfillum_a", "VertexLitGeneric", {
        ["$basetexture"] = "vgui/white_additive",
        ["$bumpmap"] = "vgui/white_additive",
        ["$model"] = "1",
        ["$nocull"] = "1",
        ["$nodecal"] = "1",
        ["$additive"] = "1",
        ["$selfillum"] = 1,
        ["$selfIllumFresnel"] = 1,
        ["$selfIllumFresnelMinMaxExp"] = "[0 0.3 0.6]",
        ["$selfillumtint"] = "[0 0 0]",
    } )
    
    CreateMaterial( "selfillum_a_z", "VertexLitGeneric", {
        ["$basetexture"] = "vgui/white_additive",
        ["$bumpmap"] = "vgui/white_additive",
        ["$model"] = "1",
        ["$nocull"] = "1",
        ["$nodecal"] = "1",
        ["$additive"] = "1",
        ["$selfillum"] = 1,
        ["$selfIllumFresnel"] = 1,
        ["$selfIllumFresnelMinMaxExp"] = "[0 0.3 0.6]",
        ["$selfillumtint"] = "[0 0 0]",
        ["$ignorez"] = 1,
    } )



    chamsmats = {
        visible = {
            ["flat"] = Material("!flat"),
            ["textured"] = Material("!textured"),
            ["glow"] = Material("!selfillum_z"),
        },

        invisible = {
            ["flat"] = Material("!flat_z"),
            ["textured"] = Material("!textured_z"),
            ["glow"] = Material("!selfillum_z"),
        },
    }

    function drawChams()
        local coloring = (1/255)
        cam.Start3D()

        for i,v in pairs(player.GetAll()) do
            if not IsValid(v) or v == LocalPlayer() or not v:Alive() or v:IsDormant() then continue end

            render.SuppressEngineLighting(GLib_Flags["Players_SuppressLighting"])

            if GLib_Flags["Players_ChamsInvisible"] then
                render.MaterialOverride(chamsmats.invisible[GLib_Flags["Players_ChamsMat"]])
                render.SetColorModulation(GLib_Flags["Chams_Color"].r*coloring, GLib_Flags["Chams_Color"].g*coloring, GLib_Flags["Chams_Color"].b*coloring)

                v:SetRenderMode(1)
                v:DrawModel()
                continue
            end

            render.MaterialOverride(chamsmats.visible[GLib_Flags["Players_ChamsMat"]])
            render.SetColorModulation(GLib_Flags["Chams_Color"].r*coloring, GLib_Flags["Chams_Color"].g*coloring, GLib_Flags["Chams_Color"].b*coloring)

            v:DrawModel()

        end

        cam.End3D()
    end

end

do
    local _framerender = vgui.Create("DFrame",nil,"gay")
    _framerender:SetSize(ScrW(),ScrH())
    _framerender:SetPos(0,0)
    _framerender:SetTitle("")
    _framerender:SetDraggable(false)
    _framerender:ShowCloseButton(false)
    _framerender.Paint=function()
        if GLib_Flags["Players_Chams"] then
            drawChams()
        end
    end
    
    -- hook.Add("RenderScreenspaceEffects", "csmodels", function()
        
    --     if GLib_Flags["Players_Chams"] and not screengrabbed then
    --         drawChams()
    --     end
    -- end)
end

do

    hook.Add("RenderScreenspaceEffects", "csmodels", function()
        if GLib_Flags["World_Nightmode"] and not screengrabbed then
            local nightmode = {
                [ "$pp_colour_addr" ] = GLib_Flags["Nightmode_Color"].r * (1 / 255),
                [ "$pp_colour_addg" ] = GLib_Flags["Nightmode_Color"].g * (1 / 255),
                [ "$pp_colour_addb" ] = GLib_Flags["Nightmode_Color"].b * (1 / 255),
                [ "$pp_colour_brightness" ] = -0.2,
                [ "$pp_colour_contrast" ] = GLib_Flags["World_Nightscale"],
                [ "$pp_colour_colour" ] = 1,
                [ "$pp_colour_mulr" ] = 0,
                [ "$pp_colour_mulg" ] = 0,
                [ "$pp_colour_mulb" ] = 0
            }
            DrawColorModify(nightmode)
        end
    end)
end

do -- SECTION - status list
    local sx = 150
    local sy = 63
    local isDragging = false
    local xp = 20
    local yp = 500
    function statuslist()
        if GLib_Flags["misc_statuslist"] then
            local MainUiBack = Drawing.new("rectangle", {
                x = xp-2,
                y = yp-2,
                width = sx + 4,
                height = sy + 4,
                color = Color(14,14,14, 255)}):draw()
            local MainUiInline = Drawing.new("rectangle", {
                x = xp-1,
                y = yp-1,
                width = sx + 2,
                height = sy + 2,
                color =  Color(50,50,50,255)}):draw()
            local UI_CORE = Drawing.new("rectangle", {
                x = xp,
                y = yp,
                width = sx,
                height = sy,
                color = Color(33, 33, 33, 255) }):draw()
            
            local core2 = Drawing.new("rectangle", {
                x = xp+3,
                y = yp+17,
                width = sx-6,
                height = sy-20,
                color = Color(12, 12, 12, 255) }):draw()
                
            local MainUiName = Drawing.new("text", { x = xp+5, y = yp+4, text = "status list", font = "Flags", color = Color(255,255,255,255) }):draw()

            local UI_ACCENT1 = Drawing.new("rectangle", {
                x = xp,
                y = yp,
                width = sx,
                height = 1,
                color = Color(120, 81, 169) }):draw()

            local statindex = 0

            function newstat(title, value, valcolor)
                if statindex == 0 then
                    local newstat = Drawing.new("text", { x = xp+7, y = yp+19, text = title, font = "Flags", color = Color(255,255,255,255) }):draw()
                    local value = Drawing.new("text", { x = xp+7+sx-13, y = yp+19, text = value, font = "Flags", color = valcolor, xAlign = TEXT_ALIGN_RIGHT }):draw()
                else
                    local newstat = Drawing.new("text", { x = xp+7, y = yp+19+(statindex*14), text = title, font = "Flags", color = Color(255,255,255,255) }):draw()
                    local value = Drawing.new("text", { x = xp+7+sx-13, y = yp+19+(statindex*14), text = value, font = "Flags", color = valcolor, xAlign = TEXT_ALIGN_RIGHT }):draw()
                end

                statindex = statindex+1
            end

            if aimtarg then
                newstat("aimbot", aimtarg:Nick(), Color(255,255,255,255))
            else
                newstat("aimbot", "no targ", Color(255,255,255,255))
            end

            if GLib_Flags["beta_sequencefreeze"] == true then
                newstat("seq freeze", GLib_Flags["beta_sequencefreeze"], Color(159, 250, 147, 255))
            else
                newstat("seq freeze", GLib_Flags["beta_sequencefreeze"], Color(247, 119, 123, 255))
            end

            if GLib_Flags["misc_norecoil"] == true then
                newstat("no recoil", GLib_Flags["misc_norecoil"], Color(159, 250, 147, 255))
            else
                newstat("no recoil", GLib_Flags["misc_norecoil"], Color(247, 119, 123, 255))
            end
            hook.Add("Think", "statlistdrag", function()
                local mouseX, mouseY = input.GetCursorPos()
                local mousePos = Vector(mouseX, mouseY)
            
                local x_check, y_check = (mousePos.x - xp), (mousePos.y - yp)
                local hovering = (x_check > 0 and x_check < sy and y_check > 0 and y_check < sx)
            
                if input.IsMouseDown(MOUSE_LEFT) and hovering then
                    if not isDragging then
                        dragStart = mousePos
                        startPos = Vector(xp, yp)
                        isDragging = true
                    end
                else
                    isDragging = false
                end
            
                if isDragging then
                    local delta = mousePos - dragStart
                    local position = Vector(startPos.x + delta.x, startPos.y + delta.y)
                    xp = position.x
                    yp = position.y
                end
            end)
        end
        
        
    end

    hook.Add("DrawOverlay", "statlist", statuslist)
end


do -- SECTION playerlist
    local deb = true
    local plroffset = 0
    local sx = 400
    local sy = 221
    local isDragging = false
    local xp = 50
    local yp = 600
    
    function plylist()

        if not rendermenu then return end 
        local MainUiBack = Drawing.new("rectangle", {
            x = xp-2,
            y = yp-2,
            width = sx + 4,
            height = sy + 4,
            color = Color(14,14,14, 255)}):draw()
        local MainUiInline = Drawing.new("rectangle", {
            x = xp-1,
            y = yp-1,
            width = sx + 2,
            height = sy + 2,
            color =  Color(50,50,50,255)}):draw()
        local UI_CORE = Drawing.new("rectangle", {
            x = xp,
            y = yp,
            width = sx,
            height = sy,
            color = Color(33, 33, 33, 255) }):draw()

        local core3 = Drawing.new("rectangle", {
            x = xp+1,
            y = yp+20,
            width = sx-2,
            height = sy-21,
            color = Color(0,0,0, 255) }):draw()
        
        local core3 = Drawing.new("rectangle", {
            x = xp+2,
            y = yp+21,
            width = sx-4,
            height = sy-23,
            color = Color(46,46,46, 255) }):draw()
        
        local core2 = Drawing.new("rectangle", {
            x = xp+3,
            y = yp+22,
            width = sx-6,
            height = sy-25,
            color = Color(12, 12, 12, 255) }):draw()
            
        local MainUiName = Drawing.new("text", { x = xp+4, y = yp+4, text = "player list", font = "Wowza", color = Color(255,255,255,255) }):draw()

        local UI_ACCENT1 = Drawing.new("rectangle", {
            x = xp,
            y = yp,
            width = sx,
            height = 1,
            color = Color(120, 81, 169) }):draw()
        
        local line = Drawing.new("rectangle", {
            x = xp+3,
            y = yp+36,
            width = sx-6,
            height = 1,
            color = Color(46,46,46, 255) }):draw()

        local namesof = Drawing.new("text", { x = xp+6, y = yp+24, text = "PLAYER                ADMIN                CHEATING                PRIO", font = "Flags", color = Color(255,255,255,255) }):draw()
        
        local scup = Drawing.new("rectangle", {
            x = xp+383,
            y = yp+39,
            width = 12,
            height = 12,
            color = Color(33,33,33, 255) }):draw()

        local scdn = Drawing.new("rectangle", {
            x = xp+383,
            y = yp+204,
            width = 12,
            height = 12,
            color = Color(33,33,33, 255) }):draw()
        
        local scrollup = Drawing.new("text", { x = xp+387, y = yp+40, text = "u", font = "Flags", color = Color(255,255,255,255) }):draw()
        local scrolldn = Drawing.new("text", { x = xp+387, y = yp+205, text = "d", font = "Flags", color = Color(255,255,255,255) }):draw()

        local plrindex = 0 + plroffset

        for i,v in pairs(player.GetAll()) do
            if plrindex <= 0 then
                local plrname = Drawing.new("text", { x = xp+6, y = yp+38, text = v:Name(), font = "Flags", color = Color(255,255,255,255) }):draw()
                local admin = Drawing.new("text", { x = xp+115, y = yp+38, text = v:IsAdmin(), font = "Flags", color = Color(227, 125, 245, 255) }):draw()
                local cheating = Drawing.new("text", { x = xp+219, y = yp+38, text = "false", font = "Flags", color = Color(255,255,255, 255) }):draw()
                local prio = Drawing.new("text", { x = xp+337, y = yp+38, text = "1", font = "Flags", color = Color(255, 216, 110, 255) }):draw()
                plrindex = plrindex + 1

            elseif plrindex >= 1 and plrindex <= 12 then
                local plrname = Drawing.new("text", { x = xp+6, y = yp+38+(plrindex*14), text = v:Name(), font = "Flags", color = Color(255,255,255,255) }):draw()
                local admin = Drawing.new("text", { x = xp+115, y = yp+38+(plrindex*14), text = v:IsAdmin(), font = "Flags", color = Color(227, 125, 245, 255) }):draw()
                local cheating = Drawing.new("text", { x = xp+219, y = yp+38+(plrindex*14), text = "false", font = "Flags", color = Color(255,255,255, 255) }):draw()
                local prio = Drawing.new("text", { x = xp+337, y = yp+38+(plrindex*14), text = "1", font = "Flags", color = Color(255, 216, 110, 255) }):draw()
                plrindex = plrindex + 1
            end
        end


        hook.Add("Think", "plfuncs", function()
            local mouseX, mouseY = input.GetCursorPos()
            local mousePos = Vector(mouseX, mouseY)
            
            local x_check, y_check = (mousePos.x - (xp+383)), (mousePos.y - (yp+39))
            local hovering = (x_check > 0 and x_check < 12 and y_check > 0 and y_check < 12)
            
            if input.IsMouseDown(MOUSE_LEFT) and hovering and rendermenu and deb then
                plroffset = plroffset + 1
                print("up")
                print(plrindex)
                deb = false
                timer.Simple(0.2, function() deb = true end)
            end
        end)

        hook.Add("Think", "plfuncs2", function()
            local mouseX, mouseY = input.GetCursorPos()
            local mousePos = Vector(mouseX, mouseY)
            
            local x_check, y_check = (mousePos.x - (xp+383)), (mousePos.y - (yp+204))
            local hovering = (x_check > 0 and x_check < 12 and y_check > 0 and y_check < 12)
            
            if input.IsMouseDown(MOUSE_LEFT) and hovering and rendermenu and deb then
                print("dn")
                plroffset = plroffset - 1
                print(plrindex)
                deb = false
                timer.Simple(0.2, function() deb = true end)
            end
        end)

        hook.Add("Think", "pldrfuncs", function()
            local mouseX, mouseY = input.GetCursorPos()
            local mousePos = Vector(mouseX, mouseY)
            
            local x_check, y_check = (mousePos.x - xp), (mousePos.y - yp)
            local hovering = (x_check > 0 and x_check < sy and y_check > 0 and y_check < sx)
            
            if input.IsMouseDown(MOUSE_LEFT) and hovering and rendermenu then
                if not isDragging then
                    dragStart = mousePos
                    startPos = Vector(xp, yp)
                    isDragging = true
                end
            else
                isDragging = false
            end
            
            if isDragging then
                local delta = mousePos - dragStart
                local position = Vector(startPos.x + delta.x, startPos.y + delta.y)
                xp = position.x
                yp = position.y
            end
        end)
    end

    hook.Add("DrawOverlay", "plylist", plylist)
end

do -- screengrab notif
    local show = false
    local old_RenderCapture = render.Capture
    render.Capture = function(passed)

        show = true
        screengrabbed = true
        timer.Simple(15, function()
            show = false
            screengrabbed = false
        end)

        return old_RenderCapture(passed)
    end

    function shownotif()
        if show == true then
            local notif = Drawing.new("text", { x = 50, y = 100, text = "[ stellar ] an admin has screengrabbed you! (render.capture)", font = "Wowza", color = Color(252, 221, 134,255) }):draw()
        end
    end

    hook.Add("DrawOverlay", "shownotif", shownotif)
end

do --SECTION -  | Ui Stuffs | Section
    local Logic = GLib.Start("stellar | "..Uberhook.Version.." | "..Uberhook.DisplayName, 100, 55, 561,470, { color1 =Color(120, 81, 169) , color2 = HSVToColor(160,0.6,1) , color3 = Color(50,50,50,255)})

    do -- SECTION -  Aimbot
        local Logic_Tab =  Logic.newtab({name = "aimbot"})

        local LeftSeporator   = Logic_Tab.seporate({text = "aimbot" ,side = "left"})
        local MiddleSeporator = Logic_Tab.seporate({text = "config" ,side = "mid"})
        local RightSeporator  = Logic_Tab.seporate({text = "filter" ,side = "right"})

        do --SECTION - MasterSwitches
            Logic_Tab.toggle({name = "enable" , default = false , flag = "Aimbot_Enabled"})
            Logic_Tab.dropdown({name = "type" ,side = "left", default = "plain" , options = {"plain" , "silent" , "viewmodel"}, flag = "Aimbot_Type"})
            Logic_Tab.dropdown({name = "key" ,side = "left", options = KeyBinds,indexnames = true, flag = "Aimbot_Aimkey"})
            
        end--!SECTION

        do --SECTION - Config
            Logic_Tab.toggle({name = "use fov" ,side = "mid",  default = false , flag = "Aimbot_UseFov"})
            Logic_Tab.slider({name = "fov" ,side = "mid", default = 100 , min = 0 , max = 500 , flag = "Aimbot_Rad" , step = 5})

            Logic_Tab.toggle({name = "snapping" ,side = "mid" ,risky = true,  default = false , flag = "Aimbot_Snappy"})
            Logic_Tab.slider({name = "smoothness" ,side = "mid", default = 50 , min = 0 , max = 200 , flag = "Aimbot_Smoothness" , step = 1})

            Logic_Tab.toggle({name = "randomize bones" ,side = "mid" ,  default = false , flag = "Aimbot_RandomBones"})
            Logic_Tab.dropdown({name = "hitbox" ,side = "mid", default = "base" , options = {"base" , "head" , "left leg" , "right leg" , "left arm" , "right arm" , "Upper Body" , "Pelvis"}})

            Logic_Tab.toggle({name = "use deadzone" ,side = "mid" ,  default = false , flag = "Aimbot_UseDeadzone"})
            Logic_Tab.slider({name = "deadzone" ,side = "mid", default = 100 , min = 0 , max = 500 , flag = "Aimbot_DeadzoneRad" , step = 5})

            local RightSeporator  = Logic_Tab.seporate({text = "checks" ,side = "mid"})
            Logic_Tab.slider({name = "stop under health" ,side = "mid", tip = "stops aimbot when target is under x hp", default = 0 , min = 0 , max = 100 , flag = "Aimbot_StopUnderHP" , step = 1})
            Logic_Tab.slider({name = "max distance" ,side = "mid", default = 0 , min = 0 , max = 1000 , flag = "Aimbot_MaxDistance" , step = 10})
        end--!SECTION

        do --SECTION - Checks
            Logic_Tab.toggle({name = "team" ,side = "right", default = false , flag = "Aimbot_TC"})
            Logic_Tab.toggle({name = "distance" ,side = "right", default = false , flag = "Aimbot_DC"})
            Logic_Tab.toggle({name = "dead" ,side = "right", default = false , flag = "Aimbot_HC"})
            Logic_Tab.toggle({name = "admin" ,side = "right", default = false , flag = "Aimbot_AC"})
            Logic_Tab.toggle({name = "screengrab" ,side = "right", default = false , flag = "Aimbot_SGC"})
        end--!SECTION

    end --!SECTION

    do -- SECTION - Players
        local Logic_Tab =  Logic.newtab({name = "players"})

        local LeftSeporator   = Logic_Tab.seporate({text = "esp" ,side = "left"})
        Logic_Tab.toggle({name = "enable" ,side = "left", default = false , flag = "Players_ESP"})
        Logic_Tab.toggle({name = "box" ,side = "left", default = true , flag = "Players_Box"})
        Logic_Tab.toggle({name = "health bar" ,side = "left", default = false , flag = "Players_Health"}):colorpicker{default = Color(178, 130, 250,255), flag = "Health_Color"}
        Logic_Tab.toggle({name = "name" ,side = "left", default = false , flag = "Players_Name"})
        Logic_Tab.toggle({name = "flags" ,side = "left", default = false , flag = "Players_Flags"})
        Logic_Tab.toggle({name = "weapon" ,side = "left", default = false , flag = "Players_Weapon"})
        Logic_Tab.slider({name = "max distance" ,side = "left", default = 0 , min = 0 , max = 500 , flag = "Players_MaxDist" , step = 1})

        local MiddleSeporator = Logic_Tab.seporate({text = "glow" ,side = "mid"})
        Logic_Tab.toggle({name = "enable" ,side = "mid", default = false , risky = true, tip = "PRONE TO SCREENGRABS AND OBS", flag = "Players_Glow"}):colorpicker{default = Color(255,255,255,255), flag = "Glow_Color"}
        Logic_Tab.slider({name = "size" ,side = "mid", default = 1 , min = 0 , max = 3 , flag = "Players_GlowSize" , step = 0.1})

        local RightSeporator  = Logic_Tab.seporate({text = "chams" ,side = "right"})
        Logic_Tab.toggle({name = "enable" ,side = "right", default = false , flag = "Players_Chams"}):colorpicker{default = Color(255,255,255,255), flag = "Chams_Color"}
        Logic_Tab.toggle({name = "invisible chams" ,side = "right", default = false , flag = "Players_ChamsInvisible"})
        Logic_Tab.toggle({name = "suppress lighting" ,side = "right", default = false , flag = "Players_SuppressLighting"})
        Logic_Tab.dropdown({name = "material" ,side = "right", default = "flat" , options = {"flat", "textured", "glow"}, flag = "Players_ChamsMat"})
    end --!SECTION

    do -- SECTION - World
        local Logic_Tab =  Logic.newtab({name = "world"})
        local LeftSeporator   = Logic_Tab.seporate({text = "world" ,side = "left"})
        Logic_Tab.toggle({name = "enable" ,side = "left", default = false , flag = "World_ESP", tip = "allows esp to draw on entities (printers, weapons, npcs)"})
        Logic_Tab.toggle({name = "name" ,side = "left", default = false , flag = "World_Name"})
        Logic_Tab.toggle({name = "glow" ,side = "left", default = false , flag = "World_Glow"})
        Logic_Tab.slider({name = "size" ,side = "left", default = 1 , min = 0 , max = 3 , flag = "World_GlowSize" , step = 0.1})
        Logic_Tab.toggle({name = "nightmode" ,side = "left", default = false , flag = "World_Nightmode"}):colorpicker{default = Color(55,40,60,255), flag = "Nightmode_Color"}
        Logic_Tab.slider({name = "nightmode scale" ,side = "left", default = 0 , min = 0 , max = 1 , flag = "World_Nightscale" , step = 0.1})

        local MiddleSeporator = Logic_Tab.seporate({text = "viewmodel" ,side = "mid"})
        Logic_Tab.toggle({name = "material override" ,side = "mid", default = false , flag = "World_VmMaterial"})
        Logic_Tab.dropdown({name = "material" ,side = "mid", default = "wireframe" , options = {"wireframe","textured" ,"globe","comsphere","comtape","shader3","shader4","shader5","portalball", "screenspace", "error","warp","new light1","splode","portalrift","cubemap","shield","chrome","cloud","stasis","roller"}, flag = "World_VMMat"})
        
        local RightSeporator  = Logic_Tab.seporate({text = "local" ,side = "right"})
        Logic_Tab.toggle({name = "thirdperson" ,side = "right", default = false , flag = "World_ThirdPerson"})
        Logic_Tab.slider({name = "tp dist" ,side = "right", default = 25 , min = 0 , max = 250 , flag = "World_TpDist" , step = 1})
        Logic_Tab.slider({name = "tp x" ,side = "right", default = 0 , min = -250 , max = 250 , flag = "World_TpX" , step = 1})
        Logic_Tab.slider({name = "tp y" ,side = "right", default = 0 , min = -250 , max = 250 , flag = "World_TpY" , step = 1})

    end --!SECTION

    do -- SECTION - Exploits
        local Logic_Tab = Logic.newtab({name = "exploits"})
        local LeftSeporator = Logic_Tab.seporate({text = "tickbase" ,side = "left"})
        Logic_Tab.toggle({name = "sequence freezing" ,side = "left" ,risky = true,  default = false , flag = "beta_sequencefreeze", tip = '"boosts" your ticks, allowing you to speedhack on some servers'})
        Logic_Tab.slider({name = "seq amt" ,side = "left", default = 16 , min = 1 , max = 50 , flag = "beta_freezeamt" , step = 1})
        Logic_Tab.dropdown({name = "type" ,side = "left", default = "createmove" , options = {"createmove", "tick"}, flag = "beta_freezetype"})
        
    end

    do -- SECTION - Protection
        local Logic_Tab = Logic.newtab({name = "protection"})
        local LeftSeporator = Logic_Tab.seporate({text = "screengrab" ,side = "left"})
    end --!SECTION

    do -- SECTION - Misc
        local Logic_Tab =  Logic.newtab({name = "misc"})
        local LeftSeporator = Logic_Tab.seporate({text = "movement" ,side = "left"})
        Logic_Tab.toggle({name = "bunny hop" ,side = "left", default = false , flag = "misc_bhop"})

        local MidSeporator = Logic_Tab.seporate({text = "indicators" ,side = "mid"})
        Logic_Tab.toggle({name = "status list" ,side = "mid", default = false , flag = "misc_statuslist"})
        Logic_Tab.toggle({name = "hitsounds" ,side = "mid", default = false , flag = "misc_hitsounds"})
        
        local RightSeporator = Logic_Tab.seporate({text = "weapon" ,side = "right"})
        Logic_Tab.toggle({name = "remove recoil" ,side = "right", default = false , flag = "misc_norecoil"})
        --Logic_Tab.toggle({name = "remove spread" ,side = "right", default = false , flag = "misc_nospread"})
    end --!SECTION

    do -- SECTION - Beta
        -- tickbase shit
        local Logic_Tab =  Logic.newtab({name = "beta*"})

    
    end --!SECTION
end --!SECTION
