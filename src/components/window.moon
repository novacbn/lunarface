import EngineComponent from "novacbn/lunarface/components/engine-component"

export Window = EngineComponent {
    engine_name: "DFrame"

    properties: {
        sizable: {"GetSizable", "SetSizable"}
        title: {"GetTitle", "SetTitle"}
    }
}