local widget = require("widget")

function widget.newPanel( options )
    local customOptions = options or {}
    local opt = {}
    opt.location = customOptions.location or "top"
    local default_width, default_height
    if ( opt.location == "top" or opt.location == "bottom" ) then
        default_width = display.contentWidth
        default_height = display.contentHeight * 0.33
    else
        default_width = display.contentWidth * 0.33
        default_height = display.contentHeight
    end
    opt.width = customOptions.width or default_width
    opt.height = customOptions.height or default_height
    opt.speed = customOptions.speed or 500
    opt.inEasing = customOptions.inEasing or easing.linear
    opt.outEasing = customOptions.outEasing or easing.linear
    if ( customOptions.onComplete and type(customOptions.onComplete) == "function" ) then
        opt.listener = customOptions.onComplete
    else 
        opt.listener = nil
    end
    local container = display.newContainer( opt.width, opt.height )
    if ( opt.location == "left" ) then
        --container.anchorX = 0.5
        container.x = -(display.contentCenterX)
        --container.anchorY = 0.5
        container.y = display.contentCenterY
    elseif ( opt.location == "right" ) then
        container.anchorX = 0.0
        container.x = display.actualContentWidth
        container.anchorY = 0.5
        container.y = display.contentCenterY
    elseif ( opt.location == "top" ) then
        container.anchorX = 0.5
        container.x = display.contentCenterX
        container.anchorY = 1.0
        container.y = display.screenOriginY
    else
        container.anchorX = 0.5
        container.x = display.contentCenterX
        container.anchorY = 0.0
        container.y = display.actualContentHeight
    end
    function container:show()
        local options = {
            time = opt.speed,
            transition = opt.inEasing
        }
        if ( opt.listener ) then
            options.onComplete = opt.listener
            self.completeState = "shown"
        end
        if ( opt.location == "top" ) then
            options.y = display.screenOriginY + opt.height
        elseif ( opt.location == "bottom" ) then
            options.y = display.actualContentHeight - opt.height
        elseif ( opt.location == "left" ) then
            options.x = opt.width/2
        else
            options.x = display.actualContentWidth - opt.width
        end 
        transition.to( self, options )
    end
    function container:hide()
        local options = {
            time = opt.speed,
            transition = opt.outEasing
        }
        if ( opt.listener ) then
            options.onComplete = opt.listener
            self.completeState = "hidden"
        end
        if ( opt.location == "top" ) then
            options.y = display.screenOriginY
        elseif ( opt.location == "bottom" ) then
            options.y = display.actualContentHeight
        elseif ( opt.location == "left" ) then
            options.x = -(display.contentCenterX)
        else
            options.x = display.actualContentWidth
        end 
        transition.to( self, options )
    end
    return container
end


--widget for navigation bar

function widget.newNavigationBar( options )
    local customOptions = options or {}
    local opt = {}
    opt.left = customOptions.left or nil
    opt.top = customOptions.top or nil
    opt.width = customOptions.width or display.contentWidth
    opt.height = customOptions.height or 50
    if customOptions.includeStatusBar == nil then
        opt.includeStatusBar = true -- assume status bars for business apps
    else
        opt.includeStatusBar = customOptions.includeStatusBar
    end

    local statusBarPad = 0
    if opt.includeStatusBar then
        statusBarPad = display.topStatusBarContentHeight
    end

    opt.x = customOptions.x or display.contentCenterX
    opt.y = customOptions.y or (opt.height + statusBarPad) * 0.5
    opt.id = customOptions.id
    opt.isTransluscent = customOptions.isTransluscent or true
    opt.background = customOptions.background
    opt.backgroundColor = customOptions.backgroundColor
    opt.title = customOptions.title or ""
    opt.titleColor = customOptions.titleColor or { 0, 0, 0 }
    opt.font = customOptions.font or native.systemFontBold
    opt.fontSize = customOptions.fontSize or 18
    opt.leftButton = customOptions.leftButton or nil
    opt.rightButton = customOptions.rightButton or nil



    if opt.left then
        opt.x = opt.left + opt.width * 0.5
    end
    if opt.top then
        opt.y = opt.top + (opt.height + statusBarPad) * 0.5
    end

    local barContainer = display.newGroup()
    local background = display.newRect(barContainer, opt.x, opt.y, opt.width, opt.height + statusBarPad )
    background.strokeWidth = 1
    background:setFillColor( 0,.5,.3 )
    background:setStrokeColor(0,0,0)


    barTitle = display.newText(opt.title, background.x, background.y + statusBarPad * 0.5, opt.font, opt.fontSize)
    barTitle:setFillColor(unpack(opt.titleColor))
    barContainer:insert(barTitle)

    local leftButton
    if opt.leftButton then
        if opt.leftButton.defaultFile then -- construct an image button
            leftButton = widget.newButton({
                id = opt.leftButton.id,
                width = opt.leftButton.width,
                height = opt.leftButton.height,
                baseDir = opt.leftButton.baseDir,
                defaultFile = opt.leftButton.defaultFile,
                overFile = opt.leftButton.overFile
            })
        else -- construct a text button
            leftButton = widget.newButton({
                id = opt.leftButton.id,
                label = opt.leftButton.label,
                onEvent = opt.leftButton.onEvent,
                font = opt.leftButton.font or opt.font,
                fontSize = opt.leftButton.fontSize,
                labelColor = opt.leftButton.labelColor or { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
                labelAlign = "left",
                -- need to create a shape to be able to chance the background color
                shape = "rect",
                width = opt.leftButton.width,
                height = opt.leftButton.height,
                fillColor = { default = { 0,.5,.3 }, over = { 0, .5, .3 } },
            })
        end
        leftButton.x = 15 + leftButton.width * 0.5
        leftButton.y = barTitle.y
        barContainer:insert(leftButton)
    end

    local rightButton
    if opt.rightButton then
        if opt.rightButton.defaultFile then -- construct an image button
            rightButton = widget.newButton({
                id = opt.rightButton.id,
                width = opt.rightButton.width,
                height = opt.rightButton.height,
                baseDir = opt.rightButton.baseDir,
                defaultFile = opt.rightButton.defaultFile,
                overFile = opt.rightButton.overFile
            })
        else -- construct a text button
            rightButton = widget.newButton({
                id = opt.rightButton.id,
                label = opt.rightButton.label or "Default",
                onEvent = opt.rightButton.onEvent,
                font = opt.leftButton.font or opt.font,
                fontSize = opt.fontSize,
                labelColor = opt.rightButton.labelColor or { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
                labelAlign = "right",
            })
        end
        rightButton.x = display.contentWidth - (15 + rightButton.width * 0.5)
        rightButton.y = barTitle.y
        barContainer:insert(rightButton)
    end

    return barContainer
end
