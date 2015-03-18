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
		
		local myRectangle = display.newRect( width/2, height/2, width, height )
		myRectangle.strokeWidth = 3
		myRectangle:setFillColor(1.0,0.0,0.0 )
		myRectangle:setStrokeColor( 1, 0, 0 )

	
	

       
        local matchedLine
        for item in io.lines("C:/Users/Aaron/Documents/GitHub/SGA-MobileApp/data/panelItems.dat") do
            if ( item:match(event.params.label) ) then
                matchedLine = item
            end
        end

        local sublistItems = {}
        for item in string.gmatch(matchedLine, "([^"..":::".."]+)") do
                sublistItems[#sublistItems + 1] = item
        end

        local options = {
            left = 0,
            top = 0,
            id = "Button",
            label = sublistItems[2],
            width = display.contentWidth,
            height = display.contentHeight
        }

        local button = widget.newButton(options)
        buttonList:insert(button)
        
        --myRectangle:insert(buttonList)
        sceneGroup:insert(myRectangle)


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