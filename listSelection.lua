local composer = require( "composer" )
local widget = require("widget")
local scene = composer.newScene()

buttonList = display.newGroup();

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

function onBackgroundTouch(event)
    if event.phase == "began" then
        panel:hide()
        panelItems.alpha = 0
    end
    return true
end

function handleButtonEvent(event)
    if event.phase == "ended" then
        panel:hide()
        panelItems.alpha = 0
    end
    return true
end

function handleLeftButton(event)
    if event.phase == "ended" then
        panel:show()
        panelItems.alpha = 1
    end

    return true
end

function handleList(event)
        --local buttonLabel = { label = event.target:getLabel() }
        clickedButtonLabel = event.target:getLabel()
        print(clickedButtonLabel)
        if event.phase == "ended" then
            if clickedButtonLabel == "Home" then
                composer.gotoScene("home")
                panel:hide()
            end
        else
            composer.gotoScene("listSelection")
            panel:hide()
        end
    end



-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
		       
        local matchedLine
        local path = system.pathForFile("panelItems.txt", system.ResourceDirectory )
        local panelPopFile = io.open(path, "r")
        for item in panelPopFile:lines() do
            if ( item:match(clickedButtonLabel) ) then
                matchedLine = item
            end
        end
        io.close( panelPopFile )

        local sublistItems = {}
        for item in string.gmatch(matchedLine, "([^"..":::".."]+)") do
                sublistItems[#sublistItems + 1] = item
        end

        background = display.newRect(0, 0,display.contentWidth,display.contentHeight) -- the plus 100 needs looked at
        background.x = width/2
        background.y = height/2
        background:addEventListener( "touch", onBackgroundTouch )
        background:setFillColor( 1,1,1 )

        local navBar = widget.newNavigationBar({
        title = sublistItems[1],
        backgroundColor = { 0.96, 0.62, 0.34 },
        height = height * .1,
        titleColor = {1, 1, 1},
        font = "HelveticaNeue",
        fontSize = 36,
        leftButton = leftButton,
        includeStatusBar = true
         })

        local text = display.newText( "Test string", 100, 200, native.systemFont, 16)
        text:setFillColor( 1, 0, 0 )

        sceneGroup:insert(background)
        sceneGroup:insert(text)
        sceneGroup:insert(panel)--panel needs to be the last thing inserted!!! Do not insert it earlier!!!


        --[[for i = 2, #sublistItems do
            options.id = "ButtonList"..i
            options.label = sublistItems[i]
            local button = widget.newButton(options)

        end]]--

    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene