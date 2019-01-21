import assign from "novacbn/lunarface/util"

export ComponentData = (data) ->
    return assign({
        base_panel = false

        engine_name = ""

        properties = {}
    }, assign)

export make_component = (data) ->
    component_data = ComponentData(data)

    return (properties={}) ->
        if component_data.base_panel
            children = {child for child in *properties}

