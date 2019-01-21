import type from _G
import insert, remove from table

import index_of from "novacbn/reactive-moon/util"

EVENT_TYPE = {"Event"}

export Event = (callback) ->
    subscribers = {}

    dispatch = (data={}) ->
        for subscriber in *subscribers
            break if subscriber(data)

        callback(data) if callback
        return data

    subscribe = (subscriber) ->
        insert(subscribers, subscriber)

        return () ->
            index = index_of(subscribers, callback)
            remove(subscribers, index) if index

    return {:EVENT_TYPE, :dispatch, :subscribe}

export is_event = (value) ->
    return type(value) == "table" and value.EVENT_TYPE == EVENT_TYPE