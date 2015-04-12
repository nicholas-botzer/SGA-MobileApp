local composer = require( "composer" )
local widget = require("widget")
local scene = composer.newScene()

buttonList = display.newGroup();

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
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
		
        barTitle.text = clickedButtonLabel
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

        local testButton = widget.newButton({
            x = 100,
            y = 100,
            id = "testButton",
            label = "Just a test",
            labelAlign = "center",
            width = display.contentWidth,
            height = 100,
            labelColor = { default = {0, 0, 0}, over = {.25, .25, .25} },
            onEvent = print("Button Clicked")
        })



        sceneGroup:insert(background)

        for i = 2, #sublistItems do
            local options =
            {
                id = "ButtonList"..i,
                label = sublistItems[i],
                labelAlign = "center",
                x = width/2,
                y = (height * .15) * (i -1),
                width = width,
                height = height * .15,
                shape = "rect",
                fontSize = height * .05,
                fillColor = { default={ 1, 0.9, 1.0, 0.9 }, over={ 1, 0.2, 0.5, 1 } },
                strokeColor = { default={ 0, 0, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
                strokeWidth = 4
            }
            local button = widget.newButton(options)
            sceneGroup:insert(button)
        end

        
        sceneGroup:insert(testButton)
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