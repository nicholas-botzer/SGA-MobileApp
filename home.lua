local composer = require( "composer" )
local display = require("display")
local widget = require("widget")
require("widgetExtension")

local scene = composer.newScene()

height = display.contentHeight
width = display.contentWidth
panelWidth = width * .65
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.


--Function declaration for the panel

    local function handleButtonEvent(event)
        if event.phase == "ended" then
            panel:hide()
        end
        return true
    end

    local function handleLeftButton(event)
        if event.phase == "ended" then
            panel:show()
        end
        return true
    end

    local function onBackgroundTouch( event )
    if event.phase == "began" then
        panel:hide()
    end
    return true
end


-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

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
        
        --display.setDefault( "anchorX", 0 )
        --display.setDefault( "anchorY", 0 )

        panel = widget.newPanel{
            location = "left",
            onComplete = panelTransDone,
            width = panelWidth,
            height = display.contentHeight,
            speed = 250,
            inEasing = easing.outBack,
            outEasing = easing.outCubic
        }
        local background = display.newRect(0, 0,display.contentWidth,display.contentHeight) -- the plus 100 needs looked at
        --background.anchorX = 0.0
        --background.anchorY = 0.0
        background.x = width/2
        background.y = height/2
        background:addEventListener( "touch", onBackgroundTouch )
        background:setFillColor( 1,1,1 )

        local footerBar = display.newRect(0,height,width,50)
        footerBar.anchorX = 0.0
        footerBar.anchorY = 0.0
        footerBar.strokeWidth = 1
        footerBar:setFillColor(0,0.5,0)
        footerBar:setStrokeColor(0,0,0) 


        --The leftButton can be changed to be an image if desired
        local leftButton = {
            label = "Menu",
            labelColor = { default =  {1, 1, 1}, over = { 0.5, 0.5, 0.5} },
            onEvent = handleLeftButton,
            font = "HelveticaNeue-Light",
            isBackButton = false,
            width = 60,
            height = 34,
        }

        local navBar = widget.newNavigationBar({
        title = "Home",
        backgroundColor = { 0.96, 0.62, 0.34 },
        titleColor = {1, 1, 1},
        font = "HelveticaNeue",
        leftButton = leftButton
        --includeStatusBar = true
         })


        panel.background = display.newRect(0,0,panel.width,panel.height)
        panel.background:setFillColor( 0.5)
        panel:insert(panel.background)

        --Adding all the buttons to change between scenes for the panel
        
        local happyBusButton = widget.newButton{
            label="Happy Bus",
            --onEvent= handleButtonEvent,
            shape="Rect",
            width=panelWidth,
            height=height*.15,
            x = 0,
            y = 0,
            fillColor={ default={1,0,0} }

        }
        happyBusButton.anchorX = 0.0
        happyBusButton.anchorY = 0.0
        happyBusButton.x = -(panelWidth/2)
        happyBusButton.y = -(height/2)

        panel:insert(happyBusButton)
        --Add all the objects in the scene at the end

        sceneGroup:insert(background)
        sceneGroup:insert(panel)--panel needs to be the last thing inserted!!! Do not insert it earlier!!!
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