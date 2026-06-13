
-- Workspace-like Microsoft Windows
hl.workspace_rule({
  workspace = "name:windows",
  layout = "windows",
})

hl.layout.register("windows", {
    recalculate = function(ctx)
        -- called when a window is mapped
        on_map = function(layout, window)
            -- fuerza flotante
            hl.window.set_float(window, true)

            -- centra ventana
            hl.window.center(window)

            -- maximiza (fullscreen real o pseudo según preferencia)
            hl.window.set_fullscreen(window, true)
            -- hl.window.set_pseudo(window, true) -- alternativa
        end
    end
})


hl.bind("SUPER + w", hl.dsp.focus({ workspace = "name:windows"}), { description = "MS Windows workspace" })