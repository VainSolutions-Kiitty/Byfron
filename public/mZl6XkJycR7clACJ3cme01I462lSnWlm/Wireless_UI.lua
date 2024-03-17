local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local mouse = game.Players.LocalPlayer:GetMouse()
local font = getgenv().uifont
local ls = string.lower

local function smoothClose(guiFrame)
    local properties = {
        BackgroundTransparency = 1,
    }
    local tweenInfo = TweenInfo.new( 0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 	0, false, 0 )
    local tween = TweenService:Create(guiFrame, tweenInfo, properties)
    tween:Play()

    tween.Completed:Wait()
    guiFrame.Visible = false	

end

local function smoothOpen(guiFrame)
    guiFrame.Visible = true

    local properties = {
        BackgroundTransparency = 0,
    }
    local tweenInfo = TweenInfo.new( 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 	0, false, 0 )
    local tween = TweenService:Create(guiFrame, tweenInfo, properties)
    tween:Play()
end


local instance = {obj = {}}

function instance.new(class, properties)
    local inst = Instance.new(class)
    for property, value in next, properties do
        inst[property] = value
    end
    table.insert(instance.obj, inst)
    return inst
end

function library:init( )
    local uiparent = game.CoreGui


    if RunService:IsStudio() then	
        uiparent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local founded_ui = uiparent:FindFirstChild("PROJECTMAIN")
    if founded_ui then founded_ui:Destroy() end

    local PROJECTMAIN_PROJECTE = instance.new("ScreenGui", {
        Name = "PROJECTMAIN";
        Parent = uiparent;
        IgnoreGuiInset = true;
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    })

    local OutterFrame_PROJECTMAIN = instance.new("Frame", {
        BackgroundColor3 = Color3.fromRGB(8, 8, 8);
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 2;
        Name = "OutterFrame";
        Parent = PROJECTMAIN_PROJECTE;
        Position = UDim2.new(0.177672952, 0, 0.2157107, 0);
        Size = UDim2.new(0, 466, 0, 368);
        Draggable = true;
        Active = true;
    })
    
    local Poopie_PROJECTMAIN = instance.new("UIStroke", {
        Color = Color3.fromRGB(21, 21, 21);
        Parent = OutterFrame_PROJECTMAIN
    })
    
    local InnerTabFrame_OutterFrame = instance.new("Frame", {
        BackgroundColor3 = Color3.fromRGB(7, 7, 7);
        BorderColor3 = Color3.fromRGB(11, 11, 11);
        Name = "InnerTabFrame";
        Parent = OutterFrame_PROJECTMAIN;
        Position = UDim2.new(0.0090193199, 0, 0.0560097061, -5);
        Size = UDim2.new(0, 458, 0, 348);
    })

    local TabHolder_InnerTabFrame = instance.new("Folder", {
        Name = "TabHolder";
        Parent = InnerTabFrame_OutterFrame;
    })

    local Tabs_OutterFrame = instance.new("Frame", {
        AutomaticSize = Enum.AutomaticSize.X;
        AnchorPoint = Vector2.new(0.5,0);
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        Name = "Tabs";
        Parent = OutterFrame_PROJECTMAIN;
        Position = UDim2.new(0.5, 0, 0, 2);
        Size = UDim2.new(0, 0, 0, 14);
    })

    local UIListLayout_Tabs = instance.new("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal;
        Parent = Tabs_OutterFrame;
        SortOrder = Enum.SortOrder.LayoutOrder;
    })

    local TextLabel_OutterFrame = instance.new("TextLabel", {
        BackgroundColor3 = Color3.fromRGB(255, 144, 8);
        BackgroundTransparency = 1.000;
        BorderColor3 = Color3.fromRGB(0, 0, 0);
        BorderSizePixel = 0;
        FontFace = font;
        Parent = OutterFrame_PROJECTMAIN;
        Position = UDim2.new(0.00961297192, 0, 0.00297641754, 0);
        Size = UDim2.new(0, 72, 0, 13);
        RichText= true;
        Text = 'By<font color="rgb(255,125,0)">fron</font>.org';
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 12.000;
        TextStrokeTransparency = 0.000;
        TextXAlignment = Enum.TextXAlignment.Left;
    })
    
    local function addloop( callback ) 
        table.insert( library.loops, callback );
    end

    RunService:BindToRenderStep("Loop Handler", 0, function( delta )
        for _i, func in pairs(library.loops) do
            func( delta );
        end
    end)
    
    local tab_system = { };
    
    UserInputService.InputBegan:Connect(function(input)
        if library.ui_open and input.KeyCode == Enum.KeyCode.Delete then	
            tab_system.closeall( );

            smoothClose( OutterFrame_PROJECTMAIN );
            smoothClose( InnerTabFrame_OutterFrame );
            library.ui_open = false	
        elseif not library.ui_open and input.KeyCode == Enum.KeyCode.Delete then	
            smoothOpen( OutterFrame_PROJECTMAIN );
            smoothOpen( InnerTabFrame_OutterFrame );
            library.ui_open = true		
        end
    end)
    
    local function GetElementSystem( ParentFrame  )
        local element_system = { };

        function element_system.new( type, properties , func )
            local currenttype = type or "toggle"

            local function element_toggle( properties )

                if properties.flag then
                    library.flags[properties.flag]  = properties.default or false
                end

                local toggle_Elements = instance.new("TextButton", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 1.000;
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    FontFace = font;
                    Name = "toggle";
                    Parent = ParentFrame;
                    Size = UDim2.new(1, 0, 0, 18);
                    Text = "";
                    TextColor3 = Color3.fromRGB(0, 0, 0);
                    TextSize = 14.000;
                    TextTransparency = 1.000;
                    ZIndex = 3;
                })

                local color_toggle = instance.new("ImageButton", {
                    BackgroundColor3 = Color3.fromRGB(35,35,35);
                    BorderColor3 = Color3.fromRGB(11,11,11);
                    BorderSizePixel = 1;
                    ImageColor3 = Color3.fromRGB(0, 0, 0);
                    ImageTransparency = 1.000;
                    Name = "color";
                    Parent = toggle_Elements;
                    Position = UDim2.new(0, 1, 0, 4);
                    Size = UDim2.new(0, 9, 0, 9);
                    AutoButtonColor = false;
                    ZIndex = 3;
                })

                local title_color = instance.new("TextLabel", {
                    BackgroundColor3 = Color3.fromRGB(22, 22, 22);
                    BackgroundTransparency = 1.000;
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    FontFace = font;
                    Name = "title";
                    Parent = color_toggle;
                    Position = UDim2.new(1, 0, 0, 0);
                    Size = UDim2.new(0, 95, 0, 10);
                    Text = properties.name;
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 12.000;
                    TextStrokeTransparency = 0.200;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    ZIndex = 3;
                })

                local padding_title = instance.new("UIPadding", {
                    Name = "padding";
                    PaddingLeft = UDim.new(0, 5);
                    Parent = title_color;
                })

                local t1 = TweenService:Create(color_toggle , TweenInfo.new(0.07 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {BackgroundColor3 = library.accent});
                local t2 = TweenService:Create(color_toggle , TweenInfo.new(0.07 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {BackgroundColor3 = Color3.fromRGB(35, 35, 35)});

                local toggledata = { value = properties.default or false ; flag = properties.flag or nil}

                function toggledata.setflag( )
                    if properties.flag then 
                        library.flags[properties.flag] = toggledata.value
                    end
                end

                function toggledata.update( )
                    if toggledata.value then
                        t1:Play()
                        toggledata.setflag( );

                        return
                    end

                    t2:Play()
                    toggledata.setflag( );
                end

                function toggledata.set( bool )
                    toggledata.value = bool

                    toggledata.setflag( );
                    toggledata.update( );
                end

                color_toggle.MouseButton1Click:Connect(function()
                    toggledata.set( not toggledata.value )
                    if properties.callback then
                        properties.callback(toggledata.value)
                    end
                end)

                table.insert(library.toggles , toggledata)

                local function element_keybind( propertiess )
                    local Keypicker_ToggleKey = instance.new("TextButton", {
                        BackgroundColor3 = Color3.fromRGB(29, 29, 29);
                        BorderColor3 = Color3.fromRGB(11, 11, 11);
                        FontFace = font;
                        Name = "Keypicker";
                        Parent = toggle_Elements;
                        Position = UDim2.new(1,-45,0,0);
                        Size = UDim2.new(0, 35, 0, 9);
                        Text = "E";
                        TextColor3 = Color3.fromRGB(59, 59, 59);
                        TextSize = 10.000;
                        TextStrokeTransparency = 0.000;
                        ZIndex = 10
                    })
                    local ContextFrame_colorBackground = instance.new("Frame", {
                        BackgroundColor3 = Color3.fromRGB(29, 29, 29);
                        BorderColor3 = Color3.fromRGB(0, 0, 0);
                        Name = "ContextFrame";
                        Parent = Keypicker_ToggleKey;
                        Position = UDim2.new(0, 0, 0, 0);
                        Size = UDim2.new(0, 47, 0, 42);
                        ZIndex = 10;
                        Visible = false;
                    })

                    local HB_ContextFrame = instance.new("TextButton", {
                        BackgroundColor3 = Color3.fromRGB(76, 76, 76);
                        BorderColor3 = Color3.fromRGB(0, 0, 0);
                        BorderSizePixel = 0;
                        FontFace = font;
                        Name = "HB";
                        Parent = ContextFrame_colorBackground;
                        Size = UDim2.new(0, 47, 0, 14);
                        Text = "Hold";
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        TextSize = 10.000;
                        TextStrokeTransparency = 0.000;
                        ZIndex = 11;
                    })

                    local TB_ContextFrame = instance.new("TextButton", {
                        BackgroundColor3 = Color3.fromRGB(76, 76, 76);
                        BorderColor3 = Color3.fromRGB(0, 0, 0);
                        BorderSizePixel = 0;
                        FontFace = font;
                        Name = "TB";
                        Parent = ContextFrame_colorBackground;
                        Position = UDim2.new(0, 0, 0.341990888, 0);
                        Size = UDim2.new(0, 47, 0, 14);
                        Text = "Toggle";
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        TextSize = 10.000;
                        TextStrokeTransparency = 0.000;
                        ZIndex = 11;
                    })

                    local AB_ContextFrame = instance.new("TextButton", {
                        BackgroundColor3 = Color3.fromRGB(76, 76, 76);
                        BorderColor3 = Color3.fromRGB(0, 0, 0);
                        BorderSizePixel = 0;
                        FontFace = font;
                        Name = "AB";
                        Parent = ContextFrame_colorBackground;
                        Position = UDim2.new(0, 0, 0.660172939, 0);
                        Size = UDim2.new(0, 47, 0, 14);
                        Text = "Always";
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        TextSize = 10.000;
                        TextStrokeTransparency = 0.000;
                        ZIndex = 11;
                    })


                    local recording = false
                    Keypicker_ToggleKey.MouseButton1Click:Connect(function() 
                        recording = true
                    end)

                    Keypicker_ToggleKey.MouseButton2Click:Connect(function() 
                        ContextFrame_colorBackground.Visible = true
                    end)

                    local keybind = { key = Enum.KeyCode.World95 ; mode = "hold" ; keycore = nil}
                    local bindactive = false

                    function keybind.set( key: string ): nil	
                        if key.UserInputType == Enum.UserInputType.Keyboard then
                            Keypicker_ToggleKey.Text = key.Name
                            keybind.key = key
                        elseif key.UserInputType == Enum.UserInputType.MouseButton1 then
                            Keypicker_ToggleKey.Text = "MB1"
                            keybind.key = Enum.UserInputType.MouseButton1 
                        elseif key.UserInputType == Enum.UserInputType.MouseButton2 then
                            Keypicker_ToggleKey.Text = "MB2"
                            keybind.key = Enum.UserInputType.MouseButton2
                        end
                    end

                    function keybind.setmode( mode: string ):nil
                        keybind.mode = string.lower(mode);
                    end

                    HB_ContextFrame.MouseButton1Click:Connect(function( ) 
                        keybind.mode = "hold"
                        ContextFrame_colorBackground.Visible = false
                    end )

                    TB_ContextFrame.MouseButton1Click:Connect(function( ) 
                        keybind.mode = "toggle" 
                        ContextFrame_colorBackground.Visible = false
                    end )

                    AB_ContextFrame.MouseButton1Click:Connect(function( ) 
                        keybind.mode = "always"
                        ContextFrame_colorBackground.Visible = false
                    end )

                    UserInputService.InputBegan:Connect(function(input)
                        do -- toggle
                            if keybind.key and input.KeyCode == keybind.key and keybind.mode == "toggle" then		
                                bindactive = not bindactive
                                if propertiess.flag then library.flags[propertiess.flag] = bindactive end	
                            end
                        end

                        do -- selector
                            if recording then	
                                local recordedInput = nil

                                if input.UserInputType == Enum.UserInputType.Keyboard then
                                    recordedInput = input.KeyCode.Name
                                    Keypicker_ToggleKey.Text = recordedInput
                                    keybind.key = input.KeyCode
                                elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                                    recordedInput = "MouseButton1"
                                    Keypicker_ToggleKey.Text = "MB1"
                                    keybind.key = Enum.UserInputType.MouseButton1 
                                elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                                    recordedInput = "MouseButton2"
                                    Keypicker_ToggleKey.Text = "MB2"
                                    keybind.key = Enum.UserInputType.MouseButton2
                                end

                                recording = false	
                            end	
                        end
                    end)

                    addloop(function( )
                        if keybind.mode == "always" then	
                            bindactive = true
                            if propertiess.flag then library.flags[propertiess.flag] = bindactive end	
                            return
                        elseif keybind.mode == "hold" and keybind.key ~=  Enum.UserInputType.MouseButton1 and keybind.key ~=  Enum.UserInputType.MouseButton2 then	
                            bindactive = UserInputService:IsKeyDown(keybind.key)
                            if propertiess.flag then library.flags[propertiess.flag] = bindactive end	
                            return
                        elseif keybind.mode == "hold" then	
                            bindactive = UserInputService:IsMouseButtonPressed(keybind.key)
                            if propertiess.flag then library.flags[propertiess.flag] = bindactive end	
                        end
                    end)

                    table.insert( library.keybinds , keybind )
                end

                return element_keybind
            end

            local function element_slider( properties )
                if properties.flag then
                    library.flags[properties.flag]  = properties.default or 0
                end

                local sliders_Elements = instance.new("TextButton", {
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 1.000;
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    FontFace = font;
                    Name = "sliders";
                    Parent = ParentFrame;
                    Size = UDim2.new(1, 0, 0, 27);
                    Text = "";
                    TextColor3 = Color3.fromRGB(0, 0, 0);
                    TextSize = 14.000;
                    TextTransparency = 1.000;
                })

                local title_sliders = instance.new("TextLabel", {
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = Color3.fromRGB(22, 22, 22);
                    BackgroundTransparency = 1.000;
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Name = "title";
                    Parent = sliders_Elements;
                    Position = UDim2.new(0, 1, 0, 2);
                    Size = UDim2.new(0, 0, 0, 13);
                    Text = properties.name;
                    FontFace = font;
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 12.000;
                    TextStrokeTransparency = 0.000;
                    TextXAlignment = Enum.TextXAlignment.Left;
                })

                local slide_sliders = instance.new("TextButton", {
                    BackgroundColor3 = Color3.fromRGB(24, 24, 24);
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 1;
                    Name = "slide";
                    Parent = sliders_Elements;
                    Position = UDim2.new(0, 1, 0, 17);
                    Size = UDim2.new(1, -35, 0, 3);
                    Text = "";
                    AutoButtonColor = false;
                })

                local Sliding = instance.new("Frame", {
                    BackgroundColor3 = library.accent;
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Name = "slide";
                    Parent = slide_sliders;
                    Position = UDim2.new(0, 0, 0, 0);
                    Size = UDim2.new(0.5, 0, 1, 0);
                })

                local pointer_slide = instance.new("TextButton", {
                    AnchorPoint = Vector2.new(0.5, 0.5);
                    BackgroundColor3 = Color3.fromRGB(67, 67, 67);
                    BackgroundTransparency = 1;
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    Name = "pointer";
                    Parent = Sliding;
                    Position = UDim2.new(1, 0, 0, 4);
                    Size = UDim2.new(0, 6, 0, 9);
                    Text = tostring(properties.default or properties.max or "0");
                    BorderSizePixel = 0;
                    FontFace = font;
                    TextColor3 = Color3.fromRGB(230, 230, 230);
                    TextSize = 12.000;
                    TextStrokeTransparency = 0.000;
                    TextXAlignment = Enum.TextXAlignment.Left;
                })

                local sliderdata = { value = properties.default or 0 ; loop = nil ; flag = properties.flag };
                local movingSlider = false
                
                local function setSliderSize(value)
                    local minValue = properties.min or 0
                    local maxValue = properties.max or 1500 
                    local valueRange = maxValue - minValue

                    -- Ensure the value is within the valid range
                    value = math.max(minValue, math.min(maxValue, value))

                    -- Calculate the fill percentage based on the input value
                    local fillPercentage = (value - minValue) / valueRange

                    -- Set the size of the slider based on the fill percentage
                    Sliding.Size = UDim2.new(fillPercentage, 0, 1, 0)
                end
                
                function sliderdata.setflag( )
                    if properties.flag then 
                        library.flags[properties.flag] = sliderdata.value
                    end
                end

                function sliderdata.set( value )
                    sliderdata.value = value
                    pointer_slide.Text = value
                    sliderdata.setflag( );
                    setSliderSize( sliderdata.value );
                end
                
                function sliderdata.update( )

                    local minValue = properties.min or 0
                    local maxValue = properties.max or 1500 
                    local step = properties.step or 1 
                    local valueRange = maxValue - minValue
                    
                    if not movingSlider then return end

                    local xOffset = math.clamp(mouse.X - slide_sliders.AbsolutePosition.X, 0, slide_sliders.AbsoluteSize.X)

                    local sliderValue = minValue + (xOffset / slide_sliders.AbsoluteSize.X) * (maxValue - minValue)
                    sliderdata.set( math.floor( sliderValue ) );

                end

                function sliderdata.openanimation( )

                end


                slide_sliders.MouseButton1Down:Connect(function()
                    movingSlider = true
                end)

                slide_sliders.MouseButton1Up:Connect(function()
                    movingSlider = false
                end)

                UserInputService.InputEnded:Connect( function(b) 

                    if b.UserInputType == Enum.UserInputType.MouseButton1 then
                        movingSlider = false
                    end

                end )
                
                
                sliderdata.set( sliderdata.value );
            
                sliderdata.loop = RunService.RenderStepped:Connect(sliderdata.update );
                
                table.insert(library.toggles , sliderdata)
            end

            local function element_dropdown( properties )
                if properties.flag then
                    library.flags[properties.flag]  = properties.default or "none"
                end
                local dropdown_mainSection = instance.new("Frame", {
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 1.000;
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Name = "dropdown";
                    Parent = ParentFrame;
                    Size = UDim2.new(1, 0, 0, 34);
                    ZIndex = 4;
                })

                local title_dropdown = instance.new("TextLabel", {
                    BackgroundColor3 = Color3.fromRGB(22, 22, 22);
                    BackgroundTransparency = 1.000;
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    FontFace = font;
                    Name = "title";
                    Parent = dropdown_mainSection;
                    Size = UDim2.new(0, 95, 0, 15);
                    Text = properties.name;
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 12.000;
                    Position = UDim2.new(0, 1, 0, 0);
                    TextStrokeTransparency = 0.200;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    ZIndex = 4;
                })

                local dropbox_dropdown = instance.new("TextLabel", {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30);
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    FontFace = font;
                    Name = "dropbox";
                    Parent = dropdown_mainSection;
                    Position = UDim2.new(0, 1, 0, 17);
                    Size = UDim2.new(1, -50, 0, 10);
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 12.000;
                    TextStrokeTransparency = 0.200;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    ZIndex = 4;
                })

                local padding_dropbox = instance.new("UIPadding", {
                    Name = "padding";
                    PaddingLeft = UDim.new(0, 5);
                    Parent = dropbox_dropdown;
                })

                local element_dropbox = instance.new("TextButton", {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45);
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    FontFace =  font;
                    Name = "element";
                    Parent = dropbox_dropdown;
                    Position = UDim2.new(1, 0, 0, 0);
                    Size = UDim2.new(0, 15, 0, 10);
                    Text = "+";
                    TextColor3 = Color3.fromRGB(233,233,233);
                    TextStrokeTransparency = 0;
                    TextSize = 13.000;
                    ZIndex = 2;
                    AutoButtonColor = false;
                })

                local drop_dropdown = instance.new("Frame", {
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = Color3.fromRGB(22, 22, 22);
                    BackgroundTransparency = 1;
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    Name = "drop";
                    Parent = dropdown_mainSection;
                    Position = UDim2.new(0, 0, 0, 30);
                    Size = UDim2.new(1,-29,0,0);
                    ZIndex = 4;
                    Visible = true;
                })

                local UIListLayout_drop = instance.new("UIListLayout", {
                    Parent = drop_dropdown;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                })

                local t1 = TweenService:Create(element_dropbox , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {TextColor3 = library.accent});
                local t2 = TweenService:Create(element_dropbox , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {TextColor3 = Color3.fromRGB(233,233,233)});

            local dropdowndata = { value = properties.default or properties.options[1] or "None" , open = false ; flag = properties.flag or nil };


                function dropdowndata.setflag( )
                    if properties.flag then 
                        library.flags[properties.flag] = dropdowndata.value
                    end
                end

                function dropdowndata.set( value )
                    dropdowndata.value = value
                    dropbox_dropdown.Text = value
                    dropdowndata.setflag( );
                end

                function dropdowndata.update( )
                    dropdowndata.set( dropdowndata.value )
                end

                function dropdowndata.toggle( )
                    if dropdowndata.open == true then
                        dropdowndata.derender( );
                        return
                    end
                    dropdowndata.render( );
                end     

                function dropdowndata.render( )
                    element_dropbox.Text = "-"

                    for _ , Value in pairs( properties.options ) do
                        local TextButton_drop = instance.new("TextButton", {
                            BackgroundColor3 = Color3.fromRGB(34, 34, 34);
                            BorderColor3 = Color3.fromRGB(0, 0, 0);
                            BorderSizePixel = 1;
                            FontFace = font;
                            Parent = drop_dropdown;
                            Size = UDim2.new(1,  - 5, 0, 10);
                            TextColor3 = Color3.fromRGB(255,255,255);
                            TextStrokeTransparency = 0;
                            Text = Value;
                            TextSize = 14.000;
                            ZIndex = 5;
                            AutoButtonColor = false;
                        })

                        local h = TweenService:Create(TextButton_drop , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {TextStrokeColor3 = Color3.fromRGB(45,45,45) });

                        if Value == dropdowndata.value then
                            h:Play()
                        end

                        local h1 = TweenService:Create(TextButton_drop , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {TextColor3 = library.accent});
                        local h2 = TweenService:Create(TextButton_drop , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {TextColor3 = Color3.fromRGB(233,233,233)});

                        TextButton_drop.MouseEnter:Connect(function(x,y)
                            h1:Play()
                        end)

                        TextButton_drop.MouseLeave:Connect(function(x,y)
                            h2:Play()
                        end)

                        TextButton_drop.MouseButton1Click:Connect(function(x,y)
                            dropdowndata.set( Value )
                            dropdowndata.derender( )
                        end)

                        wait()
                    end
                    dropdowndata.open = true
                end

                function dropdowndata.derender( )
                    element_dropbox.Text = "+"

                    for _ , TextButton in pairs( drop_dropdown:GetChildren() ) do
                        if TextButton.ClassName ~= "TextButton" then continue end

                        TextButton:Destroy()
                        wait()
                    end

                    dropdowndata.open = false
                end

                dropdowndata.update( );

                element_dropbox.MouseEnter:Connect(function(x,y)
                    t1:Play()
                end)

                element_dropbox.MouseLeave:Connect(function(x,y)
                    t2:Play()
                end)

                element_dropbox.MouseButton1Click:Connect(function(x,y)
                    t2:Play()
                    dropdowndata.toggle( )

                    dropdowndata.update( );
                end)
                
                table.insert(library.toggles , dropdowndata)
            end

            local function element_seporator( properties )
                local seporator = instance.new("TextButton", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 1.000;
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    FontFace = font;
                    Name = "seporator";
                    Parent = ParentFrame;
                    Size = UDim2.new(1, 0, 0, properties.size or 50);
                    Text = properties.name;
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 12.000;
                    TextStrokeTransparency = 0.200;
                    ZIndex = 3;
                })
            end
        
            local function element_button( properties )
                    local callback = properties.callback or function() end
                    local Active_LeftColumn = instance.new("TextButton", {
                        BackgroundColor3 = Color3.fromRGB(33, 33, 33);
                        BorderColor3 = Color3.fromRGB(11, 11, 11);
                        FontFace = font;
                        Name = "FuckingButton";
                        Parent = ParentFrame;
                        Text = properties.name;
                        Size = UDim2.new(0, 205, 0, 15);
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        TextSize = 12.000;
                        TextStrokeTransparency = 0.000;
                    })
                    
                Active_LeftColumn.MouseButton1Click:Connect(callback)
            end
        
            local function element_category( properties )

                local MainFrame_LeftColumn = instance.new("Frame", {
                    BackgroundColor3 = Color3.fromRGB(4, 4, 4);
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    Name = "MainFrame";
                    Parent = ParentFrame;
                    Size = UDim2.new(0, 205, 0, 319);
                })

                local MainEntrance_MainFrame = instance.new("ScrollingFrame", {
                    Active = true;
                    AutomaticCanvasSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 1.000;
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    CanvasSize = UDim2.new(0, 0, 0, 0);
                    Name = "MainEntrance";
                    Parent = MainFrame_LeftColumn;
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0);
                    ScrollBarThickness = 0;
                    Size = UDim2.new(1, 0, 1, 0);
                })

                local UIListLayout_MainEntrance = instance.new("UIListLayout", {
                    Parent = MainEntrance_MainFrame;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                })
                
                --local Frame_MainEntrance = instance.new("Frame", {
                --	BackgroundColor3 = Color3.fromRGB(71, 71, 71);
                --	BorderColor3 = Color3.fromRGB(0, 0, 0);
                --	BorderSizePixel = 0;
                --	Parent = MainEntrance_MainFrame;
                --	Size = UDim2.new(0, 205, 0, 14);
                --})
                local categorydata = {selected = properties.default or properties.options[1] , options = properties.options or {"No options"} , flag = properties.flag or nil}
                
                local function isEven(number)
                    return number % 2 == 0
                end
                
                local function update(otions)
                    for _ , TextButton in pairs( MainEntrance_MainFrame:GetChildren() ) do
                        if TextButton.ClassName ~= "TextButton" then continue end
                        TextButton:Destroy()
                    end
                    local configs = categorydata.options

                    for _ , Value in pairs( configs ) do
                        
                        local TextButton_drop = instance.new("TextButton", {
                            BackgroundColor3 = Color3.fromRGB(42, 42, 42);
                            BorderColor3 = Color3.fromRGB(0, 0, 0);
                            BorderSizePixel = 1;
                            FontFace = font;
                            Parent = MainEntrance_MainFrame;
                            Size = UDim2.new(0, 205, 0, 14);
                            TextColor3 = Color3.fromRGB(255,255,255);
                            TextStrokeTransparency = 0;
                            Text = Value;
                            TextSize = 12.000;
                            ZIndex = 5;
                            AutoButtonColor = false;
                        })
                        
                        if isEven(#MainEntrance_MainFrame:GetChildren()) then
                            TextButton_drop.BackgroundColor3 = Color3.fromRGB(46, 46, 46);
                        end
                        
                        local h = TweenService:Create(TextButton_drop , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {TextStrokeColor3 = Color3.fromRGB(45,45,45) });

                        local h1 = TweenService:Create(TextButton_drop , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {TextColor3 = library.accent});
                        local h2 = TweenService:Create(TextButton_drop , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {TextColor3 = Color3.fromRGB(233,233,233)});

                        TextButton_drop.MouseEnter:Connect(function(x,y)
                            h1:Play()
                        end)

                        TextButton_drop.MouseLeave:Connect(function(x,y)
                            h2:Play()
                        end)

                        TextButton_drop.MouseButton1Click:Connect(function(x,y)
                            categorydata.selected = Value
                            categorydata.update()
                        end)

                    
                        end
                end
                
                categorydata.update = update
                
                table.insert(library.toggles , categorydata)
                local categorytable =library.toggles[#library.toggles]
                return categorytable
            end
        
            local function element_textbox( properties )
                local TextBox_LeftColumn = instance.new("TextBox", {
                    BackgroundColor3 = Color3.fromRGB(21, 21, 21);
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    FontFace = font;
                    Parent =ParentFrame;
                    PlaceholderText = "Text Here";
                    Size = UDim2.new(0, 205, 0, 14);
                    Text = "";
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 12.000;
                    TextStrokeTransparency = 0.000;
                })
                
                local textboxdata = {text = properties.default or "" , flag = properties.flag or nil}
            
                textboxdata.set = function(text)
                TextBox_LeftColumn.Text = text
                textboxdata.text = TextBox_LeftColumn.Text
                    if properties.flag then
                        library.flags[properties.flag] = textboxdata.text
                    end
                end
            
                TextBox_LeftColumn.Changed:Connect(function(property)
                    if property == "Text" then
                        textboxdata.text = TextBox_LeftColumn.Text
                        if properties.flag then
                            library.flags[properties.flag] = textboxdata.text
                        end
                    end
                end)
            
                table.insert(library.toggles , textboxdata)
            end
        
            if ls(currenttype) == "toggle" then return element_toggle( properties ); end
            if ls(currenttype) == "slider" then return element_slider( properties ); end
            if ls(currenttype) == "dropdown" then return element_dropdown( properties ); end
            if ls(currenttype) == "seporator" then return element_seporator( properties ); end
            if ls(currenttype) == "button" then return element_button( properties ); end
            if ls(currenttype) == "category" then return element_category( properties ); end
            if ls(currenttype) == "textbox" then return element_textbox( properties ); end
        end

        return element_system
    end
    
    tab_system.closeall = function( )
        for _, tabdata in pairs(library.tabs) do tabdata.close( ); end
    end

    tab_system.new = function( properties )

        local InActive_StarterPlayer = instance.new("TextButton", {
            BackgroundColor3 = Color3.fromRGB(9,9,9);
            BorderColor3 = Color3.fromRGB(11, 11, 11);
            FontFace = font;
            Name = "InActive";
            Parent = Tabs_OutterFrame;
            Position = UDim2.new(0.199533328, 0, 0.000212533138, 0);
            Size = UDim2.new(0, 55, 0, 13);
            TextColor3 = Color3.fromRGB(233,233,233);
            TextSize = 12.000;
            Text = properties.name or "tab";
            TextStrokeTransparency = 0.000;
            AutoButtonColor = false	
        })

        local Frame_InActive = instance.new("Frame", {
            BackgroundColor3 = Color3.fromRGB(7,7,7);
            BackgroundTransparency = 1.000;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Parent = InActive_StarterPlayer;
            Position = UDim2.new(0, 0, 1, 0);
            Size = UDim2.new(0, 55, 0, 2);
            ZIndex = 5;
        })
        
        local NormalTab_StarterPack = instance.new("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1.000;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Name = "tab_" .. properties.name;
            Parent = TabHolder_InnerTabFrame;
            Position = UDim2.new(-2.22704857e-05, 0, -2.22876188e-05, 0);
            Size = UDim2.new(1.00444579, 0, 1.00002229, 0);
            Visible = false
        })

        local RightColumn_NormalTab = instance.new("Frame", {
            BackgroundColor3 = Color3.fromRGB(6,6,6);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            Name = "RightColumn";
            Parent = NormalTab_StarterPack;
            Position = UDim2.new(0.498239547, 5, 0.0235424712, 0);
            Size = UDim2.new(0, 217, 0, 332);
        })

        local UIListLayout_RightColumn = instance.new("UIListLayout", {
            Padding = UDim.new(0, 0);
            Parent = RightColumn_NormalTab;
            SortOrder = Enum.SortOrder.LayoutOrder;
        })

        local UIPadding_RightColumn = instance.new("UIPadding", {
            PaddingLeft = UDim.new(0, 6);
            PaddingTop = UDim.new(0, 6);
            Parent = RightColumn_NormalTab;
        })

        local LeftColumn_NormalTab = instance.new("Frame", {
            BackgroundColor3 = Color3.fromRGB(6,6,6);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            Name = "LeftColumn";
            Parent = NormalTab_StarterPack;
            Position = UDim2.new(0.014824573, 0, 0.0237661749, 0);
            Size = UDim2.new(0, 217, 0, 332);
        })

        local UIListLayout_LeftColumn = instance.new("UIListLayout", {
            Padding = UDim.new(0, 0);
            Parent = LeftColumn_NormalTab;
            SortOrder = Enum.SortOrder.LayoutOrder;
        })

        local UIPadding_LeftColumn = instance.new("UIPadding", {
            PaddingLeft = UDim.new(0, 6);
            PaddingTop = UDim.new(0, 6);
            Parent = LeftColumn_NormalTab;
        })

        local LeftName_NormalTab = instance.new("TextLabel", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1.000;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            FontFace = font;
            Name = "LeftName";
            Text = properties.lname or "Left";
            Parent = NormalTab_StarterPack;
            Position = UDim2.new(0.028978819, 0, 0.00282153301, -1);
            Size = UDim2.new(0, 34, 0, 12);
            TextColor3 = Color3.fromRGB(255, 255, 255);
            TextSize = 12.000;
            TextStrokeTransparency = 0.000;
        })

        local RightName_NormalTab = instance.new("TextLabel", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1.000;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            FontFace = font;
            Name = "RightName";
            Text = properties.rname or "Right";
            Parent = NormalTab_StarterPack;
            Position = UDim2.new(0.531928897, -4, 0.00282153301, -1);
            Size = UDim2.new(0, 34, 0, 12);
            TextColor3 = Color3.fromRGB(255, 255, 255);
            TextSize = 12.000;
            TextStrokeTransparency = 0.000;
        })
        
        local t1 = TweenService:Create(Frame_InActive , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {BackgroundTransparency = 0});
        local t2 = TweenService:Create(InActive_StarterPlayer , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {BackgroundColor3 = Color3.fromRGB(7,7,7)});

        local t4 = TweenService:Create(InActive_StarterPlayer , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {BackgroundColor3 = Color3.fromRGB(9,9,9)});
        local t3 = TweenService:Create(Frame_InActive , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {BackgroundTransparency = 1});
        
        local tt1 = TweenService:Create(InActive_StarterPlayer , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {TextColor3 = library.accent});
        local tt2 = TweenService:Create(InActive_StarterPlayer , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {TextColor3 = Color3.fromRGB(233,233,233)});

        local tabdata = { };

        function tabdata.close( )
            t3:Play()
            t4:Play()
            tt2:Play()
            
            NormalTab_StarterPack.Visible = false
        end 

        function tabdata.open ( )
            tab_system.closeall( );
            t1:Play()
            t2:Play()
            tt1:Play()
            
            NormalTab_StarterPack.Visible = true
        end

        InActive_StarterPlayer.MouseButton1Click:Connect(function( )
            tabdata.open( );
        end)
        
        table.insert(library.tabs , tabdata)
        
        return GetElementSystem( LeftColumn_NormalTab ) , GetElementSystem( RightColumn_NormalTab )
    end
    
    tab_system.news = function( properties )

        local InActive_StarterPlayer = instance.new("TextButton", {
            BackgroundColor3 = Color3.fromRGB(9,9,9);
            BorderColor3 = Color3.fromRGB(11, 11, 11);
            FontFace = font;
            Name = "InActive";
            Parent = Tabs_OutterFrame;
            Position = UDim2.new(0.199533328, 0, 0.000212533138, 0);
            Size = UDim2.new(0, 55, 0, 13);
            TextColor3 = Color3.fromRGB(233,233,233);
            TextSize = 12.000;
            Text = properties.name or "tab";
            TextStrokeTransparency = 0.000;
            AutoButtonColor = false	
        })

        local Frame_InActive = instance.new("Frame", {
            BackgroundColor3 = Color3.fromRGB(7,7,7);
            BackgroundTransparency = 1.000;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Parent = InActive_StarterPlayer;
            Position = UDim2.new(0, 0, 1, 0);
            Size = UDim2.new(0, 55, 0, 2);
            ZIndex = 5;
        })


        local MutliTab_StarterPack = instance.new("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1.000;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Name = "tab_" .. properties.name;
            Parent = TabHolder_InnerTabFrame;
            Position = UDim2.new(-2.2102804e-05, 0, 0.000141251425, 0);
            Size = UDim2.new(1.0021162, 0, 1.00483298, 0);
        })

        local InnerTabFrame_MutliTab = instance.new("Frame", {
            BackgroundColor3 = Color3.fromRGB(6,6,6);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            Name = "InnerTabFrame";
            Parent = MutliTab_StarterPack;
            Position = UDim2.new(0.0149999307, 0, 0.00100001087, 4);
            Size = UDim2.new(0, 443, 0, 10);
        })

        local UIListLayout_InnerTabFrame = instance.new("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal;
            Parent = InnerTabFrame_MutliTab;
            SortOrder = Enum.SortOrder.LayoutOrder;
        })

        local InnerTabHolder_MutliTab = instance.new("Folder", {
            Name = "InnerTabHolder";
            Parent = MutliTab_StarterPack;
        })

        local t1 = TweenService:Create(Frame_InActive , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {BackgroundTransparency = 0});
        local t2 = TweenService:Create(InActive_StarterPlayer , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {BackgroundColor3 = Color3.fromRGB(7,7,7)});

        local t4 = TweenService:Create(InActive_StarterPlayer , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {BackgroundColor3 = Color3.fromRGB(9,9,9)});
        local t3 = TweenService:Create(Frame_InActive , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {BackgroundTransparency = 1});

        local tt1 = TweenService:Create(InActive_StarterPlayer , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {TextColor3 = library.accent});
        local tt2 = TweenService:Create(InActive_StarterPlayer , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {TextColor3 = Color3.fromRGB(233,233,233)});

        local tabdata = { };

        function tabdata.close( )
            t3:Play()
            t4:Play()
            tt2:Play()

            MutliTab_StarterPack.Visible = false
        end 

        function tabdata.open ( )
            tab_system.closeall( );
            t1:Play()
            t2:Play()
            tt1:Play()

            MutliTab_StarterPack.Visible = true
        end

        InActive_StarterPlayer.MouseButton1Click:Connect(function( )
            tabdata.open( );
        end)

        table.insert(library.tabs , tabdata)

        local tab_sys2 = {}
        tab_sys2.closeall = function()
            for _, tabdata in pairs(library.stabs) do tabdata.close( ); end
        end
        
        tab_sys2.new = function( properties )
            local InActive_StarterPlayer = instance.new("TextButton", {
                BackgroundColor3 = Color3.fromRGB(9, 9, 9);
                BorderColor3 = Color3.fromRGB(11, 11, 11);
                FontFace = font;
                Name = "tab_" .. properties.name or "tab";
                Parent = InnerTabFrame_MutliTab;
                Position = UDim2.new(0.199533328, 0, 0.000212533138, 0);
                Size = UDim2.new(0, 55, 0, 13);
                TextColor3 = Color3.fromRGB(233,233,233);
                TextSize = 12.000;
                Text =  properties.name or "tab";
                TextStrokeTransparency = 0.000;
                AutoButtonColor = false	
            })
            
            local InnerTab_InnerTabHolder = instance.new("Frame", {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Name = "tab_" .. properties.name;
                Parent = InnerTabHolder_MutliTab;
                Size = UDim2.new(1, 0, 1, 0);
            })

            local LeftColumn_InnerTab = instance.new("Frame", {
                BackgroundColor3 = Color3.fromRGB(6,6,6);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                Name = "LeftColumn";
                Parent = InnerTab_InnerTabHolder;
                Position = UDim2.new(0.0149999969, 0, 0.0668961257, 0);
                Size = UDim2.new(0, 217, 0, 317);
            })

            local RightColumn_InnerTab = instance.new("Frame", {
                BackgroundColor3 = Color3.fromRGB(6,6,6);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                Name = "RightColumn";
                Parent = InnerTab_InnerTabHolder;
                Position = UDim2.new(0.498000056, 5, 0.0668961257, 0);
                Size = UDim2.new(0, 217, 0, 317);
            })

            local RightName_InnerTab = instance.new("TextLabel", {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                FontFace = font;
                Name = "RightName";
                Text = properties.rname or "Right";
                Parent = InnerTab_InnerTabHolder;
                Position = UDim2.new(0.531928837, -4, 0.0438960977, -1);
                Size = UDim2.new(0, 34, 0, 16);
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 12.000;
                TextStrokeTransparency = 0.000;
            })

            local LeftName_InnerTab = instance.new("TextLabel", {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                FontFace = font;
                Name = "LeftName";
                Text = properties.lname or "light";
                Parent = InnerTab_InnerTabHolder;
                Position = UDim2.new(0.0289788507, 0, 0.0438960977, -1);
                Size = UDim2.new(0, 34, 0, 16);
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 12.000;
                TextStrokeTransparency = 0.000;
            })
            
            local UIListLayout_RightColumn = instance.new("UIListLayout", {
                Padding = UDim.new(0, 0);
                Parent = RightColumn_InnerTab;
                SortOrder = Enum.SortOrder.LayoutOrder;
            })

            local UIPadding_RightColumn = instance.new("UIPadding", {
                PaddingLeft = UDim.new(0, 6);
                PaddingTop = UDim.new(0, 6);
                Parent = RightColumn_InnerTab;
            })

            local UIListLayout_LeftColumn = instance.new("UIListLayout", {
                Padding = UDim.new(0, 0);
                Parent = LeftColumn_InnerTab;
                SortOrder = Enum.SortOrder.LayoutOrder;
            })

            local UIPadding_LeftColumn = instance.new("UIPadding", {
                PaddingLeft = UDim.new(0, 6);
                PaddingTop = UDim.new(0, 6);
                Parent = LeftColumn_InnerTab;
            })
            for i,v in pairs(InnerTabFrame_MutliTab:GetChildren()) do
                if (v.Name:find("tab")) then
                    v.Size = UDim2.new(0, InnerTabFrame_MutliTab.AbsoluteSize.X / (#InnerTabFrame_MutliTab:GetChildren() - 1), 1, 0)
                end
            end
            
            local t2 = TweenService:Create(InActive_StarterPlayer , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {BackgroundColor3 = Color3.fromRGB(7,7,7)});

            local t4 = TweenService:Create(InActive_StarterPlayer , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {BackgroundColor3 = Color3.fromRGB(9, 9, 9)});

            local tt1 = TweenService:Create(InActive_StarterPlayer , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {TextColor3 = library.accent});
            local tt2 = TweenService:Create(InActive_StarterPlayer , TweenInfo.new(0.1 , Enum.EasingStyle.Sine , Enum.EasingDirection.In) , {TextColor3 = Color3.fromRGB(233,233,233)});

            local tabdata = { };

            function tabdata.close( )
                t4:Play()
                tt2:Play()

                InnerTab_InnerTabHolder.Visible = false
            end 

            function tabdata.open ( )
                tab_sys2.closeall( );
                t2:Play()
                tt1:Play()

                InnerTab_InnerTabHolder.Visible = true
            end

            InActive_StarterPlayer.MouseButton1Click:Connect(function( )
                tabdata.open( );
            end)

            table.insert(library.stabs , tabdata)
            return GetElementSystem(LeftColumn_InnerTab) , GetElementSystem(RightColumn_InnerTab)
        end
        return tab_sys2
    end
    return tab_system
end

local function deepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            v = deepCopy(v)
        end
        copy[k] = v
    end
    return copy
end

function library:loadconfig(cfg)
    local CfgMain = readfile("ifyoudontnoticemeyouraretard/" .. cfg)
    local configData = game:GetService("HttpService"):JSONDecode(CfgMain)

    for _,v in pairs(library.toggles) do
        if configData[v.flag] then
            v.set(configData[v.flag])
        end
    end
end


function library:GetConfigs()
    if RunService:IsStudio() then return end

    local Configs = listfiles("ifyoudontnoticemeyouraretard/")
    local configurationtable = {}

    for i,v in pairs(Configs) do
        local cfgnamee = v:sub(#"ifyoudontnoticemeyouraretard/" + 1)
        table.insert(configurationtable , cfgnamee)
    end
    --------print(configdropdown)
    configcategory.options = configurationtable

    configcategory:update(configurationtable)

    return configurationtable
end

---- Save function to write configuration to a file
function library:saveConfig(name)
    if RunService:IsStudio() then return end
    local configData = deepCopy(library.flags)

    local jsonData = game:GetService("HttpService"):JSONEncode(configData)
    writefile("ifyoudontnoticemeyouraretard/" .. "" .. library.flags["configsavename"] .. ".json", jsonData)
    ----------print(jsonData)
end
