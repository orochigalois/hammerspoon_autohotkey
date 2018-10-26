--————————————————————————————————————————————————————————————————————————————————————————————————————————————————readme begin
--1.{"cmd", "alt", "ctrl"}, C         start 20mins timer
--2.`     						      layout the top 4 windows equally
--3.{"cmd"}, "5"                      layout the top 2 windows equally
--4.{"cmd"}, "escape"                 screen shot
--5.F19                               resize window to fit mobile view
--6.{"cmd", "alt", "ctrl"}, "f19"     Add selected word/sentence to Englishbox
--7."cmd", "alt", "ctrl"}, "f16"      look up selected word vocabulary/google translate
--8."cmd", "alt", "ctrl"}, "f17"      look up selected word images.google.com
--9."cmd", "alt", "ctrl"}, "f18"      pause youtube
--————————————————————————————————————————————————————————————————————————————————————————————————————————————————readme end



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

-- }}}1

updateTimer = function()-- {{{1
    if not isActive then return end
    timeLeft = timeLeft - 1
    updateMenu()
    if timeLeft <= 0 then
        stop()
		
		script = [[
					say "Time up, Get up, Alex"
				]]
		ok,result = hs.applescript(script)
		hs.alert.show("🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺")
		-- duration=20
		-- timeLeft = duration * 60
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

if alwaysShow then updateMenu() end

--————————————————————————————————————————————————————————————————————————————————————————————————————————————————layout the top 4 windows equally


-- see if the file exists
function file_exists(file)
	local f = io.open(file, "rb")
	if f then f:close() end
	return f ~= nil
end
  
-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file)
	if not file_exists(file) then return {} end
	lines = {}
	for line in io.lines(file) do 
		lines[#lines + 1] = line
	end
	return lines
end
  
  

function showWords()
	-- tests the functions above
	local file = '/Users/alex/EnglishBox/daily.txt'
	local lines = lines_from(file)

	-- print all line numbers and their contents
	for k,v in pairs(lines) do
		print('line[' .. k .. ']', v)
		hs.alert.show(v)
	end
end


function closeAllFinderWindows()

	-- loop over all finder window and close
	local running = hs.application.runningApplications()
	for i, app in ipairs(running) do


		if app:name() == 'Finder' then
			for i,win in ipairs(app:visibleWindows()) do
				win:close()
			end

		end
	end
end

function windowFour()
	windows = hs.window.filter.default:getWindows(hs.window.filter.sortByFocusedLast)

	local win = hs.window.focusedWindow()
    local screen = win:screen()
	local max = screen:frame()


	for i,win in pairs(windows) do
		local f = win:frame()
		if i == 1 then
			f.x = 0
			f.y = 0
			f.w = max.w/2
			f.h = max.h/2
		end

		

		if i == 2 then
			f.x = 0
			f.y = max.h/2
			f.w = max.w/2	
			f.h = max.h/2
		end

		if i == 3 then
			f.x = max.w/2
			f.y = 0
			f.w = max.w/2
			f.h = max.h/2
		end

		if i == 4 then
			f.x = max.w/2
			f.y = max.h/2
			f.w = max.w/2
			f.h = max.h/2
		end
		
		
		win:setFrame(f)
		print(i)
	end
	
end
hs.hotkey.bind("0", 50, function()--50 is the ` raw keycode
	closeAllFinderWindows()
	showWords()
	windowFour()
end)


--————————————————————————————————————————————————————————————————————————————————————————————————————————————————layout the top 2 windows equally
function windowTwo()
	windows = hs.window.filter.default:getWindows(hs.window.filter.sortByFocusedLast)
	-- windows = hs.window.orderedWindows()

	local win = hs.window.focusedWindow()
    local screen = win:screen()
	local max = screen:frame()

	for i,win in pairs(windows) do
		local f = win:frame()
		
		if i == 1 then
			f.x = 0
			f.y = 0
			f.w = max.w/2
			f.h = max.h
		end

		

		if i == 2 then
			f.x = max.w/2
			f.y = 0
			f.w = max.w/2
			f.h = max.h
		end

		
		
		
		win:setFrame(f)
		print(i)
	end
	
end

-- eventtapMiddleMouseDown = hs.eventtap.new({ hs.eventtap.event.types.middleMouseDown }, function(event)
-- 	showWords()
-- 	windowTwo()	
-- end)
-- eventtapMiddleMouseDown:start()

hs.hotkey.bind({"alt"}, "a", function()   
	closeAllFinderWindows()
	showWords()
	windowTwo()
end)


--————————————————————————————————————————————————————————————————————————————————————————————————————————————————For GluePrint toggle hidden/automatically focus
hs.hotkey.bind("0", "f16", function()
	if hs.application.get("GluePrint"):isHidden() then
        hs.application.get("GluePrint"):unhide()
		hs.application.get("GluePrint"):activate()
    else
        hs.application.get("GluePrint"):hide()
	end
  end)

--————————————————————————————————————————————————————————————————————————————————————————————————————————————————easy screenshot to clipboard
hs.hotkey.bind({"cmd"}, "escape", function()
	
	hs.eventtap.keyStroke({"ctrl","cmd","shift"}, "4")

  end)


--————————————————————————————————————————————————————————————————————————————————————————————————————————————————focus on messages
--   hs.hotkey.bind({"cmd"}, "5", function()
	
   
-- 	hs.application.launchOrFocus("Messages")
--   end)


--————————————————————————————————————————————————————————————————————————————————————————————————————————————————resize window to fit mobile view
hs.hotkey.bind("0", "f19", function()
	
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
  
    f.x = max.x
    f.y = max.y
    f.w = 320
    f.h = max.h/2
    win:setFrame(f)


  end)


--———————————————————————————————————————————————————————————————————————————————————————————————————————————————— Add selected word/sentence to Englishbox
  hs.hotkey.bind({"cmd", "alt", "ctrl"}, "f19", function()

  hs.eventtap.keyStroke({"cmd"}, "c")
  script = [[
	set selectedText to the clipboard
	my WriteLog("
**********
")
	my WriteLog(selectedText)
	say selectedText
	display notification selectedText
	do shell script "bash /Users/alex/EnglishBox/commit.sh"


on WriteLog(the_text)
	set this_story to the_text
	set this_file to ("/Users/alex/EnglishBox/EnglishBox.txt")
	set this_file to POSIX file this_file
	my write_to_file(this_story, this_file, true)
end WriteLog

on write_to_file(this_data, target_file, append_data) -- (string, file path as string, boolean)
	try
		set the target_file to the target_file as text
		set the open_target_file to ¬
			open for access file target_file with write permission
		if append_data is false then ¬
			set eof of the open_target_file to 0
		write this_data to the open_target_file starting at eof
		close access the open_target_file
		return true
	on error
		try
			close access file target_file
		end try
		return false
	end try
end write_to_file
]]
  ok,result = hs.applescript(script)
  -- print(result)
  -- print(hs.inspect(result))
  -- hs.alert.show(ok)
end)


--———————————————————————————————————————————————————————————————————————————————————————————————————————————————— look up selected word vocabulary/google translate
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "f16", function()

  hs.eventtap.keyStroke({"cmd"}, "c")


  script = [[
	set selectedText to the clipboard
	say selectedText
	tell application "/Applications/Google Chrome.app"
    make new window
    activate
    open location "https://translate.google.com/#en/zh-CN/" & selectedText
end tell
delay 1
tell application "Google Chrome"
		activate
		open location "https://www.vocabulary.com/dictionary/"
		tell application "System Events"
			delay 1
			keystroke selectedText
		end tell
	end tell
		
]]
  ok,result = hs.applescript(script)
  -- print(result)
  -- print(hs.inspect(result))
  -- hs.alert.show(ok)
end)


--———————————————————————————————————————————————————————————————————————————————————————————————————————————————— look up selected word images.google.com
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "f17", function()

	hs.eventtap.keyStroke({"cmd"}, "c")

  script = [[
	set selectedText to the clipboard
	tell application "Google Chrome"
		activate
		open location "https://images.google.com/"
		tell application "System Events"
			delay 2
			keystroke selectedText
			delay 1
			keystroke return
		end tell
	end tell
		
]]
  ok,result = hs.applescript(script)
  -- print(result)
  -- print(hs.inspect(result))
  -- hs.alert.show(ok)
end)


--———————————————————————————————————————————————————————————————————————————————————————————————————————————————— pause youtube
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "f18", function()

  script = [[
		to clickClassName(theClassName, elementnum)
			tell application "Google Chrome" to (tabs of window 1 whose URL contains "youtube")
				set youtubeTabs to item 1 of the result
				tell application "Google Chrome"
				execute youtubeTabs javascript "document.getElementsByClassName('" & theClassName & "')[" & elementnum & "].click();"
			end tell
		end clickClassName
		clickClassName("ytp-play-button ytp-button", 0)
		
]]
  ok,result = hs.applescript(script)
  -- print(result)
  -- print(hs.inspect(result))
  -- hs.alert.show(ok)
end)



--———————————————————————————————————————————————————————————————————————————————————————————————————————————————— full screen


function windowOne()
	windows = hs.window.filter.default:getWindows(hs.window.filter.sortByFocusedLast)

	local win = hs.window.focusedWindow()
    local screen = win:screen()
	local max = screen:frame()

	for i,win in pairs(windows) do
		local f = win:frame()
		
		if i == 1 then
			f.x = 0
			f.y = 0
			f.w = max.w
			f.h = max.h
		end

		win:setFrame(f)
	end
	
end


hs.hotkey.bind({"cmd", "alt"}, "f", function()
	showWords()
	windowOne()
end)





------------------------------------------------------------------------
-- CBD--
------------------------------------------------------------------------
------------------
-- screen color picker not working--
------------------
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "f13", function()



  script = [[
		property my_color : {0, 32896, 65535}

		set my_color to choose color default color my_color
		
		set red to round (first item of my_color) / 257
		set green to round (second item of my_color) / 257
		set blue to round (third item of my_color) / 257
		
		set red_web to dec_to_hex(red)
		set green_web to dec_to_hex(green)
		set blue_web to dec_to_hex(blue)
		
		set red_web to normalize(red_web, 2)
		set green_web to normalize(green_web, 2)
		set blue_web to normalize(blue_web, 2)
		
		set red to normalize(red, 3)
		set green to normalize(green, 3)
		set blue to normalize(blue, 3)
		
		set decimal_text to "R: " & red & " G: " & green & " B: " & blue
		set web_text to "#" & red_web & green_web & blue_web
		
		set dialog_text to decimal_text & return & "Web: " & web_text
		
		set d to display dialog dialog_text with icon 1 buttons {"Cancel", "Copy as Decimal", "Copy for Web"} default button 3
		
		if button returned of d is "Copy as Decimal" then
				set the clipboard to decimal_text
		else if button returned of d is "Copy for Web" then
				set the clipboard to web_text
		end if
		
		on dec_to_hex(the_number)
				if the_number is 0 then
						return "0"
				end if
		
				set hex_list to {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"}
				set the_result to ""
		
				set the_quotient to the_number
		
				repeat until the_quotient is 0
						set the_quotient to the_number div 16
						set the_result to (item (the_number mod 16 + 1) of hex_list) & the_result
						set the_number to the_quotient
				end repeat
		
				return the_result
		
		end dec_to_hex
		
		on normalize(the_number, the_length)
				set the_number to the_number as string
		
				if length of the_number ? the_length then
						return the_number
				end if
		
				repeat until length of the_number is equal to the_length
						set the_number to "0" & the_number
				end repeat
		
				return the_number
		end normalize
		
]]
  ok,result = hs.applescript(script)
  -- print(result)
  -- print(hs.inspect(result))
  -- hs.alert.show(ok)
end)




