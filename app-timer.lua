--————————————————————————————————————————————————————————————————————————————————————————————————————————————————20 mins timer
-- http://github.com/dbmrq/dotfiles/

-- Cherry tomato (a tiny Pomodoro)


-----------------------------
--  Customization Options  --
-----------------------------

-- Set these variables to whatever you prefer

-- The keyboard shortcut to start the timer is composed of the `super`
-- modifiers + the `hotkey` value.

local super = {"ctrl", "alt", "cmd"}
local hotkey = "C"

local duration = 20 -- timer duration in minutes

-- set this to true to always show the menu bar item
-- (making the keyboard shortcut superfluous):
local alwaysShow = true


-------------------------------------------------------------------
--  Don't mess with this part unless you know what you're doing  --
-------------------------------------------------------------------

-- Setup {{{1

local updateTimer, updateMenu, start, pause, reset, stop

local menu
local isActive = false

local timeLeft = duration * 60

local timer = hs.timer.new(1, function() updateTimer() end)

local drawHandle

-- }}}1

updateTimer = function()-- {{{1
    if not isActive then return end
    timeLeft = timeLeft - 1
    updateMenu()


    if timeLeft <= 10 then
		
		script = [[
					say "five"
				]]
        ok,result = hs.applescript(script)
    end
    if timeLeft <= 8 then
		
		script = [[
					say "four"
				]]
        ok,result = hs.applescript(script)
    end
    if timeLeft <= 6 then
		
		script = [[
					say "three"
				]]
        ok,result = hs.applescript(script)
    end
    if timeLeft <= 4 then
		
		script = [[
					say "two"
				]]
        ok,result = hs.applescript(script)
    end

    if timeLeft <= 2 then
		
		script = [[
					say "one"
				]]
        ok,result = hs.applescript(script)
    end
    if timeLeft <= 0 then
        stop()
		
		script = [[
					say "Time up"
				]]
        ok,result = hs.applescript(script)
        local win = hs.window.focusedWindow()
        local screen = win:screen()
        local max = screen:frame()
        drawHandle=hs.drawing.rectangle{x=0, y=23, w=max.w, h=max.h}
			:setRoundedRectRadii(0,0):setStroke(true):setStrokeWidth(0)
            :setFill(true):setFillColor{red=0, blue=0, green = 0, alpha = 1}:show()
        drawHandle:hide(60)

    end
end-- }}}1

updateMenu = function()-- {{{1
    if not menu then
        menu = hs.menubar.new()
        menu:setTooltip("Cherry")
    end
    menu:returnToMenuBar()
    local minutes = math.floor(timeLeft / 60)
    local seconds = timeLeft - (minutes * 60)
    local string = string.format("%02d:%02d 🍒", minutes, seconds)
    menu:setTitle(string)

    local items = {
			{title = "Stop", fn = function() stop() end},
			{title = "5:00", fn = function() min5() end},
			{title = "10:00", fn = function() min10() end},
			{title = "20:00", fn = function() min20() end},
        }
    if isActive then
        table.insert(items, 1, {title = "Pause", fn = function() pause() end})
    else
        table.insert(items, 1, {title = "Start", fn = function() start() end})
    end
    menu:setMenu(items)
end-- }}}1

start = function()-- {{{1
    if isActive then return end
    timer:start()

    isActive = true
end-- }}}1


min5 = function()-- {{{1
	if isActive then return end
	duration=5
	timeLeft = duration * 60
    timer:start()
    isActive = true
end-- }}}1

min10 = function()-- {{{1
	if isActive then return end
	duration=10
	timeLeft = duration * 60
    timer:start()
    isActive = true
end-- }}}1

min20 = function()-- {{{1
	if isActive then return end
	duration=20
	timeLeft = duration * 60
    timer:start()
    isActive = true
end-- }}}1


pause = function()-- {{{1
    if not isActive then return end
    timer:stop()
    isActive = false
    updateMenu()
end-- }}}1

stop = function()-- {{{1
    
    pause()
    timeLeft = duration * 60
    if not alwaysShow then
        menu:delete()
    else
        updateMenu()
    end
end-- }}}1

reset = function()-- {{{1
    timeLeft = duration * 60
    updateMenu()
end-- }}}1

hs.hotkey.bind(super, hotkey, function() start() end)
hs.hotkey.bind(super, "D", function() stop() end)

if alwaysShow then updateMenu() end