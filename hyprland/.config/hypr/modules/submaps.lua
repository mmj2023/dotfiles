require("modules.submap_movetoworkspace")
require("modules.submap_resize")

for i = 1, 10 do
	require("modules.submap_workspaceset" .. i)
end
