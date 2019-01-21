import pairs from _G

import Create from vgui

import Component from "novacbn/lunarface/component"
import assign from "novacbn/lunarface/util"

export PANEL_COMMON_EVENTS = {
    "cursor_entered":   "OnCursorEntered"
    "cursor_exited":    "OnCursorExited"
    "cursor_moved":     "OnCursorMoved"
    "init":             "Init"
    "unmount":          "OnRemove"
}

export PANEL_COMMON_PROPERTIES = {
    "height":   {"GetTall", "SetHeight"}
    "width":    {"GetWide", "SetWidth"}
}

export EngineData = (data) ->
    return {
        engine_name: data.engine_name or "Panel"

        events: assign(PANEL_COMMON_EVENTS, data.events or {})

        properties: assign(PANEL_COMMON_PROPERTIES, data.properties or {})
    }

export EngineComponent = (data) ->
    engine_data = EngineData(data)

    _EngineComponent = Component {
        render: (props, children) =>
            local panel

            __mount: (parent) ->
                panel = Create(engine_data.engine_name, parent)

                for event, hook in pairs(engine_data.events)
                    panel[hook] = (...) -> @dispatch(event, ...)

                for property, dynamics in pairs(engine_data.properties)
                    {:get, :set} = dynamics

                    if get
                        method = panel[get]
                        get = () -> method(panel)

                    if set
                        method = panel[set]
                        set = (value) -> method(panel, value)

                    @dynamic(property, get, set)

                child.__mount(self) for child in *children

            __unmount: () ->
                if panel
                    panel\Remove()
                    panel = nil

            destroy: () ->
                __unmount()

            return {:__mount, :__unmount, :destroy}
    }

    return _EngineComponent
