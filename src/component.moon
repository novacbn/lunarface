import pairs, type from _G

import Store from "novacbn/reactive-moon/exports"

import assign, clone from "novacbn/lunarface/util"

COMPONENT_TYPE = {"Component"}

get_props_split = (properties) ->
    children = properties["children"] or {}
    props = {key, value for key, value in pairs(properties) when type(key) == "string" and key ~= "children"}

    return children, props

export Component = (func) ->
    data = {}
    callbacks = func(data) or {}

    make_computed = callbacks.computed or () -> {}
    make_data = callbacks.data or () -> {}
    make_methods = callbacks.methods or () -> {}

    return (properties) ->
        local component, fragment
        children, props = get_props_split(properties)

        __mount = (parent) ->
            fragment = component.__render(parent)

            component.dispatch("mount")
            return fragment

        __render = (parent) ->
            fragment = component.dispatch("render", component, children)
            fragment.__mount(parent)

            return fragment

        __unmount = () ->
            if fragment
                fragment.__unmount()
                fragment = nil

            component.dispatch("unmount")

        destroy = () ->
            __unmount()

        computed = make_computed()
        data = assign(make_data(), props)
        methods = assign({:__mount, :__render, :__unmount, :destroy}, make_methods())

        component = Store(data, callbacks)
        component = assign(component, methods, false)

        for name, dependencies in pairs(computed)
            compute = remove(dependencies, #dependencies)

            component.computed(name, dependencies, compute)

        component.dispatch("create")
        return component

export is_component = () -> false