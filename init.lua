------------------
-- layout the top 4 windows equally --
------------------
function windowFuzzySearch()
	windows = hs.window.filter.default:getWindows(hs.window.filter.sortByFocusedLast)
	-- windows = hs.window.orderedWindows()
	for i,win in pairs(windows) do
		local f = win:frame()
		if i == 1 then
			f.x = 0
			f.y = 0
			f.w = 1280
			f.h = 720-40
		end

		if i == 2 then
			f.x = 1280
			f.y = 0
			f.w = 1280
			f.h = 720-40
		end

		if i == 3 then
			f.x = 0
			f.y = 720-16
			f.w = 1280
			f.h = 720-40
		end
		if i == 4 then
			f.x = 1280
			f.y = 720-16
			f.w = 1280
			f.h = 720-40
		end
		
		
		win:setFrame(f)
		print(i)
	end
	
end

hs.hotkey.bind("0", "escape", function()
	windowFuzzySearch()
end)








------------------
-- screen shot --
------------------
hs.hotkey.bind({"cmd"}, "escape", function()
	
	hs.eventtap.keyStroke({"ctrl","cmd","shift"}, "4")

  end)

------------------
-- mobile view --
------------------

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


------------------
-- Add to Englishbox --
------------------
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

------------------
-- look up www.vocabulary.com --
------------------
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


------------------
-- look up images.google.com --
------------------
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


------------------
-- pause youtube --
------------------
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




------------------------------------------------------------------------
-- For dev --
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