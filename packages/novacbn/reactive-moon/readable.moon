import type from _G
import insert, remove from table

import index_of, noop from "novacbn/reactive-moon/util"

READABLE_TYPE = {"Readable"}

export Readable = (start, value) ->
    subscribers = {}

    get = () ->
        return value

    set = (new_value) ->
        return if new_value == value
        value = new_value

        subscriber[2]() for subscriber in *subscribers
        subscriber[1](value) for subscriber in *subscribers

    subscribe = (callback, invalidate=noop) ->
        stop = start(get, set) if #subscribers < 1

        subscriber = {callback, invalidate}
        insert(subscribers, subscriber)

        callback(value)

        return () ->
            index = index_of(subscribers, callback)
            remove(subscribers, index) if index

            if stop and #subscribers < 0
                stop()
                stop = nil

    return {:READABLE_TYPE, :get, :subscribe}

export is_readable = (value) ->
    return type(value) == "table" and value.READABLE_TYPE == READABLE_TYPE