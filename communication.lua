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
                    elseif attribute == "facebook" then
                        --This loop will let us have multiple fb accounts
                        for name,link in pairs(value) do
                            fbCnt = fbCnt + 1
                            fbLink[fbCnt] = {}
                            fbLink[fbCnt].name = name
                            fbLink[fbCnt].link = link
                        end
                    elseif attribute == "twitter" then
                        --This loop will let us have multiple twitter accounts
                        for name,link in pairs(value) do
                            twCnt = twCnt + 1
                            twLink[twCnt] = {}
                            twLink[twCnt].name = name
                            twLink[twCnt].link = link
                        end
                    elseif attribute == "other" then
                    end
                end
                break
            end
        end

        if urlFlag then
            populateButtons()
            system.openURL(toDisplay[2])
        else
            populateSocial()
        end

        sceneGroup:insert(background)
        sceneGroup:insert(scrollView)
        sceneGroup:insert(panel)--panel needs to be the last thing inserted!!! Do not insert it earlier!!!
    end
end

function populateButtons()
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
            sublistItems[#sublistItems + 1] = item
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

    for i = 2, #sublistItems do
        local options =
        {
            id = "ButtonList"..i,
            label = sublistItems[i],
            labelAlign = "center",
            x = width/2,
            y = (height * .15) * (i -2) + (height * .095),
            width = width,
            height = height * .15,
            shape = "rect",
            fontSize = width * .05,
            fillColor = { default={ 1, 0.9, 1.0, 0.9 }, over={ 1, 0.2, 0.5, 1 } },
            strokeColor = { default={ 0, 0, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
            strokeWidth = 4,
            onEvent = handleListChoice
        }
        local button = widget.newButton(options)
        scrollView:insert(button)
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