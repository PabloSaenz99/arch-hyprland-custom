
-- Workspace-like Microsoft Windows
hl.workspace_rule({
  workspace = "name:windows",
})

hl.window_rule({
  match = { workspace = "name:windows" },
  float = true,
  maximize = true,
})

hl.bind("SUPER + w", hl.dsp.focus({ workspace = "name:windows"}), { description = "MS Windows workspace" })