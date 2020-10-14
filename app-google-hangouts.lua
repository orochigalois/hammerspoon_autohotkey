--————————————————————————————————————————————————————————————————————————————————————————————————————————————————For Google Hangout to print "cool thanks!"
-- eventtapMiddleMouseDown = hs.eventtap.new({ hs.eventtap.event.types.middleMouseDown }, function(event)


-- 	local win = hs.window.focusedWindow()
-- 	local title = win:title()
-- 	print (title)

-- 	if string.match(title, "Google Hangouts") then
-- 		hs.eventtap.keyStrokes("Cool,thanks! :)")
-- 		hs.eventtap.keyStroke({}, "return")
-- 	end 
	
-- end)
-- eventtapMiddleMouseDown:start()


hs.hotkey.bind("0", "padenter", function()
	local win = hs.window.focusedWindow()
	local title = win:title()
	print (title)

	if string.match(title, "Slack") then
		hs.eventtap.keyStrokes(" :)")
		hs.eventtap.keyStroke({}, "return")

	else
		hs.eventtap.keyStroke({}, "return")
	end 
end)


hs.hotkey.bind("0", "f19", function()
	local win = hs.window.focusedWindow()
	local title = win:title()
	print (title)

	if string.match(title, "Slack") then
		hs.eventtap.keyStrokes("Cool,thanks! :)")
		hs.eventtap.keyStroke({}, "return")
	end 
end)



hs.hotkey.bind({"cmd"}, "f19", function()
	
	local win = hs.window.focusedWindow()
	local title = win:title()
	print (title)

	if string.match(title, "Slack") then
		hs.eventtap.keyStrokes("No worries :)")
		hs.eventtap.keyStroke({}, "return")
	end 

end)


hs.hotkey.bind({"ctrl"}, "f19", function()
	
	hs.eventtap.keyStrokes("Thanks so much :) :8")

end)