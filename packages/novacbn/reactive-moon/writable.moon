import type from _G
import insert, remove from table

import index_of, noop from "novacbn/reactive-moon/util"

WRITABLE_TYPE = {"Writable"}

export Writable = (value) ->
    subscribers = {}

    get = () ->
        return value

    set = (new_value) ->
        return if new_value == value
        value = new_value

        subscriber[2]() for subscriber in *subscribers
        subscriber[1](value) for subscriber in *subscribers

    update = (func) ->
        set(func(value))

    subscribe = (callback, invalidate=noop) ->
        subscriber = {callback, invalidate}
        insert(subscribers, subscriber)

        callback(value)

        return () ->
            index = index_of(subscribers, callback)
            remove(subscribers, index) if index

    return {:WRITABLE_TYPE, :get, :set, :subscribe, :update}

export is_writable = (value) ->
    return type(value) == "table" and value.WRITABLE_TYPE == WRITABLE_TYPE