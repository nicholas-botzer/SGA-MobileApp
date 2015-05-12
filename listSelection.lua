local composer = require( "composer" )
local widget = require("widget")
local scene = composer.newScene()

buttonList = display.newGroup();

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

    function handleListChoice(event)

        local phase = event.phase
        if ( phase == "moved" ) then
            local dy = math.abs( ( event.y - event.yStart ) )
        -- If the touch on the button has moved more than 10 pixels,
        -- pass focus back to the scroll view so it can continue scrolling
            if ( dy > 10 ) then
                scrollView:takeFocus( event )
            end
        end

        clickedListLabel = event.target:getLabel()

        
        if phase == "ended" then
            if clickedListLabel == "Happy Bus/SGA Shuttle" then
                composer.gotoScene("happyBus")
            elseif clickedListLabel == "Finals Schedule" then
                composer.gotoScene("finals")
            elseif clickedListLabel == "2HourDelay" then
               composer.gotoScene("2hourDelay")
            elseif clickedListLabel == "Frisbee Golf Course" then
                composer.gotoScene("frisbeeGolf")
            elseif clickedButtonLabel == "Academics" then
                composer.gotoScene("academicsPage")
            elseif clickedButtonLabel == "Departments and Offices" then
                composer.gotoScene("departmentsPage")
            elseif clickedButtonLabel == "Emergency Services" then
                composer.gotoScene("emergencyServices")
            elseif clickedButtonLabel == "Communication" then
                composer.gotoScene("communication")
            elseif clickedListLabel == "On-Campus" then
                composer.gotoScene("dining")
			elseif clickedListLabel == "Off-Campus" then
                composer.gotoScene("dining")
            elseif clickedButtonLabel == "Events" then
               -- composer.gotoScene("")
            elseif clickedButtonLabel == "Health and Safety" then
                composer.gotoScene("healthAndSafety")
            elseif clickedButtonLabel == "Residence Life" then
                composer.gotoScene("residenceLife")
            elseif clickedButtonLabel == "Recreation" then
                composer.gotoScene("recreation")
            elseif clickedButtonLabel == "About" then
                composer.gotoScene("about")
            elseif clickedButtonLabel == "SGA Feedback" then
               composer.gotoScene("feedback")
            end
             panel:hide()
            panelOpen = 0
        end

    end

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

        local matchedCategory = ""
        for item in panelPopFile:lines() do

            local cnt = 1
            for i in string.gmatch(item,  "([^"..":::".."]+)") do
                --store only the first string in a line to prevent accidental matching
                if cnt == 1 then
                    matchedCategory = i
                end
                cnt = cnt + 1
            end

            if ( matchedCategory:match(clickedButtonLabel) ) then
                matchedLine = item
            end
        end
        io.close( panelPopFile )

        local sublistItems = {}
        for item in string.gmatch(matchedLine, "([^"..":::".."]+)") do
                sublistItems[#sublistItems + 1] = string.gsub(item, "\n", "")
        end

        scrollView = widget.newScrollView
        {
            x = width/2,
            y = (height/2) + (height*.1/2),
            width = width,
            height = height*.9,
            scrollHeight = height*.9,
            horizontalScrollDisabled = true
        }



        sceneGroup:insert(background)

        for i = 2, #sublistItems do
            local options =
            {
                id = "ButtonList"..i,
                label = sublistItems[i],
                labelAlign = "center",
                x = width/2,
                y = (height * .15) * (i -2) + (height * .085),
                width = width,
                height = height * .15,
                shape = "rect",
                fontSize = width * .05,
                fillColor = { default={ 0, 0.55, 0, 0.2 }, over={ 0, 1, 0, 0 } },
                strokeColor = { default={ 0, 0.5, 0.3, 1 }, over={ 0.8, 0.8, 1, 1 } },
                strokeWidth = 10,
                onEvent = handleListChoice
            }
            local button = widget.newButton(options)
            scrollView:insert(button)
        end

        sceneGroup:insert(scrollView)
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
