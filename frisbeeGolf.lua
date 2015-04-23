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
         local background = display.newRect( width/2, height/2, width, height )
        background:setFillColor( 1,1,1 )

        local options = 
        {
            --parent = textGroup,
            text = "The McFarland Recreational Sports Complex now includes a 18 hole Disc Golf Course.".. 
            "The original nine holes opened at the start of the 2010 fall semester."..
            "The course is available to students, faculty/staff, alumni and the general public."..
            "Visitor parking passes are available at the Parking Office located in the University Union."..
            "Passes are required weekdays from 8 a.m.-4 p.m."..
            "SRU will host the 2015 World Disc Golf Championships in August of 2015.",     
            x = width/2,
            y = height * .2,
            width = width,     --required for multi-line and alignment
            font = native.systemFontBold,   
            fontSize = width * .04,
            align = "left"  --new alignment parameter
        }

        local frisbeeInfo = display.newText(options)
        frisbeeInfo:setFillColor(0,0,0)

        --begin populating holes data

        local lookingFor = clickedListLabel
        local lineNumber = -1
        local toDisplay = {}
        local phoneNumber = ""

        local path = system.pathForFile("frisbee.json", system.ResourceDirectory )
        local fileContents = ""
        local fileItems = {}
        local file = io.open(path, "r")
        if file then
            fileContents = file:read("*a")
            fileItems = json.decode(fileContents)
        end
        io.close(file)

        print(fileItems["frisbee"])
        for index = 1,#fileItems["frisbee"] do
                -- I need to store all the stuff in this line to display
                lineNumber = index
                for attribute,value in pairs(fileItems["frisbee"][lineNumber]) do
                    toDisplay[#toDisplay + 1] = value
                end
        end

        local scrollView = widget.newScrollView
        {
            x = width/2,
            y = (height/2) + (height*.1/2),
            width = width,
            height = height*.9,
            scrollWidth = width,
            scrollHeight = height*.9,
            backgroundColor = {1.0,1.0,1.0},
            horizontalScrollDisabled = true
        }
        yPos = height *.4
        leftX = -(width/2)
        rightX = width
        scrollView:insert(frisbeeInfo)
        for x=1,#fileItems["frisbee"] do

           local line = display.newLine(leftX,yPos,rightX,yPos)
           line:setStrokeColor( 0,0,0 )
           line.strokeWidth = 8
           scrollView:insert(line)

           yPos = yPos + 50
           local options = {
                text = "Hole: ".. fileItems["frisbee"][x]["hole"] .."  Tee: ".. fileItems["frisbee"][x]["tees"] ,
                x = width/2,
                y = yPos,
                width = width,     --required for multi-line and alignment
                font = native.systemFontBold,   
                fontSize = width * .04,
                align = "left"  --new alignment parameter
           }
           local hole = display.newText( options )
           hole:setFillColor(0.0,0.0,0.0)
           scrollView:insert(hole)
           yPos = yPos + 90
           local options = {
                text = "Par: ".. fileItems["frisbee"][x]["par"] .."  Basket: ".. fileItems["frisbee"][x]["basket"] ,
                x = width/2,
                y = yPos,
                width = width,     --required for multi-line and alignment
                font = native.systemFontBold,   
                fontSize = width * .04,
                align = "left"  --new alignment parameter
           }
           local par = display.newText(options)
           par:setFillColor( 0.0 )
           scrollView:insert(par)

           yPos = yPos + 30
        end

        yPos = yPos + 30
        local line = display.newLine(leftX,yPos,rightX,yPos)
           line:setStrokeColor( 0,0,0 )
           line.strokeWidth = 8
           scrollView:insert(line)


        scrollView:setScrollHeight(height + 1000)  --this is realy fucking everything up and needed to be done

        sceneGroup:insert(background)
        sceneGroup:insert(scrollView)
        --sceneGroup:insert(frisbeeInfo)
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