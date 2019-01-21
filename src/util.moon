import ipairs, pairs from _G

export assign = (target, source, clone=true) ->
    target = clone(target) if clone

    for key, value in pairs(source)
        target[key] = value

    return target

export clone = (table) ->
    return {key, value for key, value in pairs(table)}

export index_of = (table, search) ->
    for index, value in ipairs(table)
        return index if value == search

    return nil

export make_truth_map = (table) ->
    return {key, true for key, value in pairs(table)}