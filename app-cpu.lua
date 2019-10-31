--Install iStats first
function trim1(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function makeStatsMenu()
	if cpuMenu == nil then
		cpuMenu = hs.menubar.new()
	end
	local shell_command = "iStats cpu temp --no-graphs | cut -c11- | sed 's/\\..*//'"
	temp =  hs.execute(shell_command,true)
	cpuMenu:setTitle("CPU: "..trim1(temp).."°")

	if fanMenu == nil then
		fanMenu = hs.menubar.new()
	end
	local shell_command = "istats fan speed --value-only"
	fan =  hs.execute(shell_command,true)
	fanMenu:setTitle("FAN: "..trim1(fan).."RPM")
end
updateStatsInterval = 1
statsMenuTimer = hs.timer.new(updateStatsInterval, makeStatsMenu)
statsMenuTimer:start()