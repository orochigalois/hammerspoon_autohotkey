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