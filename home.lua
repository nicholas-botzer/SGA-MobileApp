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
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.


--Function declaration for the panel

    local function handleButtonEvent(event)
        if event.phase == "ended" then
            panel:hide()
        end
        return true
    end

    function handleLeftButton(event)
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
	
	function handleList(event)
		if event.phase =="ended" then
			composer.gotoScene("listSelection")
		end
	end

    function togglePanelButtons(event)
        if panelItems.alpha == 1 then
            panelItems.alpha = 0
        elseif panelItems.alpha == 0 then
            panelItems.alpha = 1
        end
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
        panel = widget.newPanel{
            location = "left",
            onComplete = panelTransDone,
            width = panelWidth,
            height = panelHeight,
            speed = 250,
            inEasing = easing.linear,
            outEasing = easing.linear,
            onComplete = togglePanelButtons
        }


        -- I'm trying to populate the side bar from a dat file
		local path = system.pathForFile("data\\panelItems.dat", system.ResourceDirectory )
        local panelPopLines = {}
        local panelPopItems = {}
        for item in io.lines(path) do
            panelPopLines[#panelPopLines + 1] = item
        end

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
                print(item)
            end
        end

        local options = 
        {
            left = 0,
            top = -500,
            id = "",
            label = "",
            labelAlign = "left",
            width = panel.width,
            height = 91,
			onEvent = handleList
        }

        local itemCount = 1
        for i = 1,#panelPopItems do
            for j = 1,#panelPopItems[i] do
                options.id = "panelItem" .. itemCount
                options.label = panelPopItems[i][j]
                local item = widget.newButton(options)
                item._view._label.size = 40
                panelItems:insert(item)
                options.top = options.top + 82
                itemCount = itemCount + 1
            end
        end

        panelItems.alpha = 0


        background = display.newRect(0, 0,display.contentWidth,display.contentHeight) -- the plus 100 needs looked at
        background.x = width/2
        background.y = height/2
        background:addEventListener( "touch", onBackgroundTouch )
        background:setFillColor( 1,1,1 )



        --The leftButton can be changed to be an image if desired
        leftButton = {
            label = "Menu",
            labelColor = { default =  {1, 1, 1}, over = { 0.5, 0.5, 0.5} },
            onEvent = handleLeftButton,
            font = "HelveticaNeue-Light",
            isBackButton = false,
            width = 60,
            height = 34,
        }

        navBar = widget.newNavigationBar({
        title = "Home",
        backgroundColor = { 0.96, 0.62, 0.34 },
		height = height * .1,
        titleColor = {1, 1, 1},
        font = "HelveticaNeue",
		fontSize = 36,
        leftButton = leftButton
        --includeStatusBar = true
         })


        panel.background = display.newRect(0,0,panel.width,panel.height)
        panel.background:setFillColor( 0.5)
        panel:insert(panel.background)

        --Adding all the buttons to change between scenes for the panel
        

        panel:insert(panelItems)
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