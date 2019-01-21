import type, setmetatable from _G
import insert, remove from table

import index_of, noop from "novacbn/reactive-moon/util"

STORE_TYPE = {"Store"}

export StoreMetatable = (store, data, dynamics) ->
    __index = (key) =>
        if dynamic[key] and dynamic[key].get
            return dynamic[key].get()

        return data[key]

    __newindex = (key, value) =>
        changed = {[key]: true}
        store.dispatch("state", changed)

        if dynamic[key] and dynamic[key].set
            dynamic[key].set(value)

        else
            data[key] = value

        store.dispatch("update", changed)

    return setmetatable(store, {:__index, :__newindex})

export Store = (data={}, callbacks) ->
    local store, subscribe
    dynamics = {}
    subscribers = {}

    computed: (name, dependencies, compute) ->
        pending = [false for _ in *dependencies]
        values = [nil for _ in *dependencies]

        is_pending = () ->
            for awaiting in *pending
                return true unless awaiting

            return false

        return subscribe("update", (changed) ->
            if pending
                for index, dependency in *dependencies
                    if changed[dependency]
                        pending[index] = true
                        values[index] = data[dependency]

                if is_pending() then return
                else pending = nil
                    
            value = compute(values)
            store[name] = value if data[name] ~= value
        )

    dynamic: (name, get, set) ->
        dynamics[name] = {:get, :set}

    dispatch = (event, ...) ->
        for subscriber in *subscribers
            if subscriber.event ~= event
                continue

            break if subscriber.callback(store, ...)

        return callbacks[event](store, ...) if callbacks and callbacks[event]

    subscribe = (event, callback) ->
        subscriber = {:callback, :event}
        insert(subscribers, subscriber)

        return () ->
            index = index_of(subscribers, subscriber)
            remove(subscribers, index) if index

    store = StoreMetatable({:STORE_TYPE, :computed, :dispatch, :dynamic, :subscribe}, data, dynamics)
    return store

export is_store = (value) ->
    return type(value) == "table" and value.STORE_TYPE == STORE_TYPE