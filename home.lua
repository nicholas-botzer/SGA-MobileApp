local composer = require( "composer" )
local display = require("display")
local widget = require("widget")
require("widgetExtension")
widget.setTheme( "widget_theme_android" )
local scene = composer.newScene()

height = display.contentHeight
width = display.contentWidth
panelWidth = width * .65
panelHeight = height
panelItems = display.newGroup()
panelOpen = 0
clickedButtonLabel = ""
panel = widget.newPanel{
            location = "left",
            onComplete = panelTransDone,
            width = panelWidth,
            height = panelHeight,
            speed = 250,
            inEasing = easing.linear,
            outEasing = easing.linear
        }

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.


--Function declaration for the panel
    function scrollListener(event)
        local phase = event.phase
        if ( phase == "moved" ) then
            local dy = math.abs( ( event.y - event.yStart ) )
        -- If the touch on the button has moved more than 10 pixels,
        -- pass focus back to the scroll view so it can continue scrolling
            if ( dy > 10 ) then
                panelScrollView:takeFocus( event )
            end
        end
    end
    function handleButtonEvent(event)
        if event.phase == "ended" then
            panel:hide()
            panelOpen = 0
        end
        return true
    end

    function handleLeftButton(event)
        if event.phase == "ended" then
            if panelOpen == 0 then
                panel:show()
                panelOpen = 1
            else
                panel:hide()
                panelOpen = 0
            end
        end

        return true
    end

	
	local function handleList(event)

        clickedButtonLabel = event.target:getLabel()
        barTitle.text = clickedButtonLabel
        if event.phase == "ended" then
            if clickedButtonLabel == "Home" then
                local sceneName = composer.getSceneName( "current" )
                if sceneName == "home" then
                    panel:hide()
                    panelOpen = 0
                else
                    composer.gotoScene("home")
                    panel:hide()
                    panelOpen = 0
                end
            else
                composer.gotoScene("listSelection")
                panel:hide()
                panelOpen = 0
            end
        end
        panelOpen = 0
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
        
        -- I'm trying to populate the side bar from a txt file

		local path = system.pathForFile("panelItems.txt", system.ResourceDirectory )
        local panelPopFile = io.open(path, "r")
        local panelPopLines = {}
        local panelPopItems = {}
        for item in panelPopFile:lines() do
            panelPopLines[#panelPopLines + 1] = item
        end
        io.close( panelPopFile )

        for i = 1,#panelPopLines do
            panelPopItems[i] = {}
            local j = 1
            for item in string.gmatch(panelPopLines[i], "([^"..":::".."]+)") do
                local temp = ""
                if j == 1 then
                    temp = item
                elseif j~= 1 then
                    temp = "    " .. item
                end
                    panelPopItems[i][j] = temp
                j = j - 1
            end
        end

        local options = 
        {
            x = 0,
            y = -(height/2 - height*.15),
            id = "",
            label = "",
            labelAlign = "center",
            width = panel.width,
            height = panel.height / #panelPopLines - 10,
			onEvent = handleList
        }

        --[[panelScrollView = widget.newScrollView
        {
            top = panel.height/2,
            left = panel.width * .6,
            width = panel.width,
            height = panel.height,
            scrollWidth = panel.width,
            scrollHeight = panel.height,
            listener = scrollListener
        }]]--

        local itemCount = 1
        for i = 1,#panelPopItems do
            for j = 1,#panelPopItems[i] do
                options.id = "panelItem" .. itemCount
                options.label = panelPopItems[i][j]
                local item = widget.newButton(options)
                item._view._label.size = 34
                --panelScrollView:insert(item)
                panelItems:insert(item)
                options.y = options.y + panel.height *.1
                itemCount = itemCount + 1
            end
        end


        background = display.newRect(0, 0,display.contentWidth,display.contentHeight)
        background.x = width/2
        background.y = height/2
        background:setFillColor( 1,1,1 )



        --The leftButton can be changed to be an image if desired
        leftButton = {
            label = "Menu",
            labelColor = { default =  {1, 1, 1}, over = { 0.5, 0.5, 0.5} },
            onEvent = handleLeftButton,
            --font = "HelveticaNeue-Light",
            isBackButton = false,
            width = width * .10,
            height = height * .1,
            fontSize = height * .03
        }

        navBar = widget.newNavigationBar({
        title = "Home",
        backgroundColor = { 0.96, 0.62, 0.34 },
		height = height * .1,
        titleColor = {1, 1, 1},
        font = "HelveticaNeue",
		fontSize = width * .05,
        leftButton = leftButton,
        includeStatusBar = true
         })


        panel.background = display.newRect(0,0,panel.width,panel.height)
        panel.background:setFillColor( 0.5)
        panel:insert(panel.background)

        --Adding all the buttons to change between scenes for the panel
        

        panel:insert(panelItems)
        --panel:insert(panelScrollView)
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