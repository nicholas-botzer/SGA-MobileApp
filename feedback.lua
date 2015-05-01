local composer = require( "composer" )
local widget = require("widget")
require("widgetExtension")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


local function textListener( event )

    if ( event.phase == "began" ) then
        -- user begins editing defaultField

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- do something with defaultField text

    elseif ( event.phase == "editing" ) then
        
        name = event.text
        if name == nil then
            name = "Anonymous"
        end
    end
end

local function inputListener( event )
    if event.phase == "began" then
        -- user begins editing textBox


    elseif event.phase == "ended" then
        -- do something with textBox text


    elseif event.phase == "editing" then

        feedback = event.text
        if feedback == nil then
            feedback = "Hmmm. They didn't seem to write any feedback."
        end

    end
end

local function handleButtonEvent(event)


    if ( "ended" == event.phase ) then
        local options =
        {
            to = "nab1001@sru.edu",
            subject = "SGA Feedback",
            body = "Hello SGA this is "..name..", \n"..feedback,
        }
        native.showPopup("mail", options)
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

        local feedbackView = widget.newScrollView
        {
            x = width/2,
            y = (height/2) + (height*.1/2),
            width = width,
            height = height*.9,
            scrollHeight = height*.9,
            horizontalScrollDisabled = true
        }

        local options = {
            x = width/2,
            y = height *.25,
            text = "Welcome to the SGA Feedback Page. Down below you will find a form you can fill out to send SGA improvements you would"..
            "like to see on the campus. We appreciate all feedback and strive to make the campus better for all students. Please note when"..
            "you press send it will open up your e-mail application and require you to send it from there.",
            width = width,     --required for multi-line and alignment
            font = native.systemFontBold,   
            fontSize = width * .05,
            align = "left"  --new alignment parameter
        }

        local text = display.newText(options)
        text:setFillColor( 0,0,0 )
        local nameOpts = {
            x = width/2,
            y = height *.45,
            text = "Name",
            width = width,     --required for multi-line and alignment
            font = native.systemFontBold,   
            fontSize = width * .05,
            align = "left"  --new alignment parameter
        }
        local name = display.newText(nameOpts)
        name:setFillColor( 0,0,0 )

        local nameField = native.newTextField( width/2, height *.55, width, height *.10 )
        nameField:addEventListener( "userInput", textListener )

        local feedbackOpts = {
            x = width/2,
            y = height *.65,
            text = "Feedback",
            width = width,     --required for multi-line and alignment
            font = native.systemFontBold,   
            fontSize = width * .05,
            align = "left"  --new alignment parameter
        }

        local feedback = display.newText( feedbackOpts )
        feedback:setFillColor( 0,0,0 )

        local feedbackBox = native.newTextBox( width/2, height * .80, width, height * .2 )
        feedbackBox.text = "Enter your comment here!"
        feedbackBox.isEditable = true
        feedbackBox:addEventListener( "userInput", inputListener )

        local sendOpts = {
            x = width/2,
            y = height,
            label = "Send E-mail",
            fontSize = width * .05,
            onEvent = handleButtonEvent,
            --properties for a rounded rectangle button...
            shape="roundedRect",
            width = width/2,
            height = height * .15,
            cornerRadius = 2,
            fillColor = { default={ 0, 1, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
            strokeColor = { default={ 0, 0, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
            strokeWidth = 4,
            onEvent = handleButtonEvent
        }
        local sendButton = widget.newButton( sendOpts )

        feedbackView:setScrollHeight( height + 250)  --this is realy fucking everything up and needed to be done

        --insert scene members
        feedbackView:insert(background)
        feedbackView:insert(text)
        feedbackView:insert(name)
        feedbackView:insert(nameField)
        feedbackView:insert(feedback)
        feedbackView:insert(feedbackBox)
        feedbackView:insert(sendButton)

        sceneGroup:insert(feedbackView)
        sceneGroup:insert(panel)



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