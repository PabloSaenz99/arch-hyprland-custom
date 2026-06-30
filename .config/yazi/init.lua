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
		time = os.date("Today %H:%M", time)
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%Y %b %d", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "", time)
end

--Show user/group of files in status bar
Status:children_add(function()
	local h = cx.active.current.hovered
	if not h or ya.target_family() ~= "unix" then
		return ""
	end

	return ui.Line {
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		":",
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		" ",
	}
end, 500, Status.RIGHT)

--Show symlink in status bar
Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)