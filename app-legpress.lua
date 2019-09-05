-- ————————————————————————————————————————————————————————————————————————————————————————————————————————————————For Google Hangout to print "cool thanks!"
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
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "3", function()
    hs.eventtap.keyStrokes(
        "git clone https://alexyinxin@bitbucket.org/legroomteam/legpress-wp-base-install.git")
    hs.eventtap.keyStroke({}, "return")
end)
