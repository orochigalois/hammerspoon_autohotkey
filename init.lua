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
    open location "https://www.vocabulary.com/dictionary/" & selectedText
end tell
delay 1
tell application "Google Chrome"
		activate
		open location "https://translate.google.com/#en/zh-CN/"
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