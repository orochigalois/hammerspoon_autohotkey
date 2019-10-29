--Install iStats first
function trim1(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function makeStatsMenu()
	if statsMenu == nil then
	  statsMenu = hs.menubar.new()
	end
	local shell_command = "iStats cpu temp --no-graphs | cut -c11- | sed 's/\\..*//'"
	temp =  hs.execute(shell_command,true)
	statsMenu:setTitle("CPU: "..trim1(temp).."°")
end
updateStatsInterval = 1
statsMenuTimer = hs.timer.new(updateStatsInterval, makeStatsMenu)
statsMenuTimer:start()