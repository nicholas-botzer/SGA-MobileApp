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
        local phoneNumber = ""

        local path = system.pathForFile("communication.json", system.ResourceDirectory )
        local fileContents = ""
        local fileItems = {}
        local file = io.open(path, "r")
        if file then
            fileContents = file:read("*a")
            fileItems = json.decode(fileContents)
        end
        io.close(file)

        local fbLink = {}
        local twLink = {}
        local fbCnt = 0 --Facebook link counter
        local twCnt = 0 --Twitter link counter

        local urlFlag = false --Set to true if we find a url in json

        --Loop to get display items from the json data
        --[[
            array indices:
            1: name
            2: url
        ]]--
        for index = 1,#fileItems["communication"] do
            if fileItems["communication"][index]["name"] == lookingFor then
                -- I need to store all the stuff in this line to display
                lineNumber = index
                for attribute,value in pairs(fileItems["communication"][lineNumber]) do
                    toDisplay[#toDisplay + 1] = value
                    if attribute == "name" then
                        toDisplay[1] = value
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
