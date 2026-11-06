-- See https://wiki.hypr.land/Configuring/Workspace-Rules/ for workspace rules

for workspace = 1, 6 do
  hl.workspace_rule({
    workspace = tostring(workspace),
    monitor = "HDMI-A-1",
  })
end
