local composer = require( "composer" )
local json = require("json")
require("widgetExtension")
local widget = require("widget")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

function callNumber(event)

    system.openURL( phoneNumber )

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

        -- I'm trying to populate the page from a json file

        local lookingFor = clickedListLabel
        local lineNumber = -1
        local toDisplay = {}
        phoneNumber = ""
        local urlFlag = false

        local path = system.pathForFile("emergencyServices.json", system.ResourceDirectory )
        local fileContents = ""
        local fileItems = {}
        local file = io.open(path, "r")
        if file then
            fileContents = file:read("*a")
            fileItems = json.decode(fileContents)
        end
        io.close(file)

        for index = 1,#fileItems["emergency services"] do
            if fileItems["emergency services"][index]["name"] == lookingFor then
                -- I need to store all the stuff in this line to display
                lineNumber = index
                for attribute,value in pairs(fileItems["emergency services"][lineNumber]) do
                    toDisplay[#toDisplay + 1] = value
                    if attribute == "name" then
                        toDisplay[1] = value
                    elseif attribute == "phone" then
                        toDisplay[2] = value
                        phoneNumber = "tel:"..value
                    elseif attribute == "fax" then
                        toDisplay[3] = value
                    elseif attribute == "location" then
                        toDisplay[4] = value
                    elseif attribute == "hours" then
                        toDisplay[5] = value
                    elseif attribute == "url" then
                        toDisplay[2] = value
                        urlFlag = true
                    end
                end
                break
            end
        end

        if urlFlag then
            system.openURL(toDisplay[2])
        else
            scrollView = widget.newScrollView
            {
                x = width/2,
                y = (height/2) + (height*.1/2),
                width = width,
                height = height*.9,
                scrollWidth = width,
                scrollHeight = height*.9,
            }

            local textGroup = {}

            yPos = height *.1
            local titleOpts = {

                x = width/2,
                y = yPos,
                text = toDisplay[1],
                width = width,     --required for multi-line and alignment
                font = native.systemFontBold,   
                fontSize = width * .07,
                align = "center"  --new alignment parameter

            }

            local titleText = display.newText( titleOpts )
            titleText:setFillColor( 0,0,0 )

            yPos = yPos + 80

            local header = display.newLine( 0,yPos, width, yPos )
            header:setStrokeColor( 0,0,0 )
            header.strokeWidth = 8

            yPos = yPos + 100

            local locationOpts = {

                x = width/2,
                y = yPos,
                text = "Location: "..toDisplay[4],
                width = width,     --required for multi-line and alignment
                font = native.systemFontBold,
                fontSize = width * .05,
                align = "left"  --new alignment parameter
            }

            local locationText = display.newText( locationOpts )
            locationText:setFillColor( 0,0,0 )

            yPos = yPos + 100

            local phoneOpts = {

                x = width/2,
                y = yPos,
                text = "Phone: "..toDisplay[2],
                width = width,     --required for multi-line and alignment
                font = native.systemFontBold,
                fontSize = width * .05,
                align = "left"  --new alignment parameter
            }

            local phoneText = display.newText( phoneOpts )
            phoneText:setFillColor( 0,0,0 )

            yPos = yPos + height * .1
            local callOptions = 
            {
                id = "CallButton",
                defaultFile = "phoneButton.png",
                overFile = "phoneButtonClicked.png",
                x = width/4,
                y = yPos,
                width = width/2,
                height = height * .1,    
                onRelease = callNumber
            }
            local callButton = widget.newButton(callOptions)

            yPos = yPos + 100 + height * .075

            local faxOpts = {

                x = width/2,
                y = yPos,
                text = "Fax: "..toDisplay[3],
                width = width,     --required for multi-line and alignment
                font = native.systemFontBold,
                fontSize = width * .05,
                align = "left"  --new alignment parameter
            }

            local faxText = display.newText( faxOpts )
            faxText:setFillColor( 0,0,0 )


            yPos = yPos + 200
            local hoursOpts = {

                x = width/2,
                y = yPos,
                text = "Hours: \n"..toDisplay[5],
                width = width,     --required for multi-line and alignment
                font = native.systemFontBold,
                fontSize = width * .05,
                align = "left"  --new alignment parameter
            }

            local hoursText = display.newText( hoursOpts )
            hoursText:setFillColor( 0,0,0 )
            



            --insert into scrollView
            scrollView:insert(titleText)
            scrollView:insert(header)
            scrollView:insert(locationText)
            scrollView:insert(phoneText)
            scrollView:insert(callButton)
            scrollView:insert(faxText)
            scrollView:insert(hoursText)
        end

        

        sceneGroup:insert(background)
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