-- ~/.config/yazi/init.lua
local function isSameDay(timestamp1, timestamp2)
    local t1 = os.date("*t", timestamp1)
    local t2 = os.date("*t", timestamp2)
    return t1.year == t2.year and t1.month == t2.month and t1.day == t2.day
end

function Linemode:line_mode()
	local time = math.floor(self._file.cha.mtime or 0)
    local local_time = os.time()
	if time == 0 then
		time = ""
    elseif isSameDay(time, local_time) then
		time = os.date("%H:%M", time)
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "", time)
end