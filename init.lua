require "app-timer"
require "app-layout4"
-- require "app-mysql"
require "app-google-hangouts"
require "app-legpress"
require "app-sg"
require "app-cpu"



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




hs.hotkey.bind("0", "f14", function()
	hs.eventtap.keyStrokes("<p>")
end)
hs.hotkey.bind("0", "f15", function()
	hs.eventtap.keyStrokes("</p>")
end)

hs.hotkey.bind("0", "f19", function()
	hs.eventtap.keyStrokes("Aa123456#")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "=", function()
	local screen = hs.screen.mainScreen()
	-- screen:setMode(2560, 1440, 1.0)  // for iMac
	screen:setMode(2560, 1600, 1.0)
end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "-", function()
	local screen = hs.screen.mainScreen()
	-- screen:setMode(1600, 900, 1.0) // for iMac
	screen:setMode(1680, 1050, 1.0)
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
	-- closeAllFinderWindows()
	showWords()
	windowTwo()
end)


hs.hotkey.bind({"cmd", "alt"}, "left", function()

	
    

	local win = hs.window.focusedWindow()

	local screen = win:screen()
	local max = screen:frame()

	local frame = win:frame()
		
		
	frame.x = 0
	frame.y = 0
	frame.w = max.w/2
	frame.h = max.h
	
		
		
	win:setFrame(frame)
	
  end)

hs.hotkey.bind({"cmd", "alt"}, "right", function() 
	local win = hs.window.focusedWindow()

	local screen = win:screen()
	local max = screen:frame()
	
	local frame = win:frame()
		
		
	frame.x = max.w/2
	frame.y = 0
	frame.w = max.w/2
	frame.h = max.h
		
	win:setFrame(frame)

end)

--———————————————————————————————————————————————————————————————————————————————————————————————————————————————— full screen


function windowOne()

	local win = hs.window.focusedWindow()

	local screen = win:screen()
	local max = screen:frame()
	
	local frame = win:frame()
		
		
	frame.x = 0
	frame.y = 0
	frame.w = max.w
	frame.h = max.h
		
	win:setFrame(frame)

	
end


hs.hotkey.bind({"cmd", "alt"}, "f", function()
	showWords()
	windowOne()
end)



--————————————————————————————————————————————————————————————————————————————————————————————————————————————————For GluePrint toggle hidden/automatically focus
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "g", function()
	if hs.application.get("GluePrint"):isHidden() then
        hs.application.get("GluePrint"):unhide()
		hs.application.get("GluePrint"):activate()
    else
        hs.application.get("GluePrint"):hide()
	end
  end)

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
hs.hotkey.bind("0", "f18", function()
	
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
--run 'xcode-select --install' in terminal if this doesn't work normally  
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "9", function()

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


hs.hotkey.bind({"cmd", "alt", "ctrl"}, "5", function()

	local text = current_selection()
    local url = "https://translate.google.com/#en/zh-CN/" ..
                    encodeURI(text)

    local res = hs.urlevent.openURL(url)
	print(res)
	script = [[
		set selectedText to the clipboard
		say selectedText
	]]
	ok,result = hs.applescript(script)
	
end)

--———————————————————————————————————————————————————————————————————————————————————————————————————————————————— look up selected word vocabulary/google translate
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "6", function()

	local text = current_selection()
    local url = "https://www.vocabulary.com/dictionary/" ..
                    encodeURI(text)

    local res = hs.urlevent.openURL(url)
	script = [[
		set selectedText to the clipboard
		say selectedText
	]]
	ok,result = hs.applescript(script)
	
end)


--———————————————————————————————————————————————————————————————————————————————————————————————————————————————— look up selected word images.google.com
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "7", function()

	hs.eventtap.keyStroke({"cmd"}, "c")

  script = [[
	set selectedText to the clipboard
	say selectedText
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
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "8", function()

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







function toLowercase()
	sel = getTextSelection()
	newSel = ""
	if sel then hs.eventtap.keyStrokes(string.lower(sel)) end
end
function toUncamelCase()
	-- Scan for uppercase char, replace with a space and the lowercase of it
	sel = getTextSelection()
	if sel == nil then return end
	newSel = string.sub(sel, 2)
	FirstChar = string.sub(sel, 1, 1)
	newSel=FirstChar..string.lower(newSel)

	hs.eventtap.keyStrokes(newSel)
end

function getTextSelection()	-- returns text or nil while leaving pasteboard undisturbed.
	local oldText = hs.pasteboard.getContents()
	hs.eventtap.keyStroke({"cmd"}, "c")
	hs.timer.usleep(25000)
	local text = hs.pasteboard.getContents()	-- if nothing is selected this is unchanged
	hs.pasteboard.setContents(oldText)
	if text ~= oldText then 
	  return text
	else
	  return ""
	end
end
hs.hotkey.bind({"cmd", "alt", "ctrl"},  "f14", nil, function()  toUncamelCase()	end )


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




