import ipairs, pairs, tostring from _G

export any_keys = (table, keys) ->
    for key in *keys
        return true if table[key] ~= nil

    return false

export assign = (table, source) ->
    table = clone(table)
    table[key] = value for key, value in pairs(source)

    return table

export clone = (table) ->
    return {key, value for key, value in pairs(table)}

export extend = (target, source, name="MoonScriptClass") ->
    cls = class extends source
    cls.__name = cls

    return cls

export index_of = (table, search) ->
    for index, value in ipairs(table)
        return index if value == search

    return nil

export noop = () ->