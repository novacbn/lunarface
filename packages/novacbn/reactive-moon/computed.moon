import ipairs, type from _G
import insert, remove from table

import Readable, is_readable from "novacbn/reactive-moon/readable"
import is_writable from "novacbn/reactive-moon/writable"
import index_of, noop from "novacbn/reactive-moon/util"

export Computed = (streams, compute, auto=true) ->
    return Readable((get, set) ->
        initialized = false

        pending = [false for _ in *streams]
        values = [nil for _ in *streams]

        is_pending = () ->
            for awaiting in *pending
                return true unless awaiting

            return false

        sync = () ->
            return if is_pending()

            value = compute(values, get, set)
            set(value) if auto and get() ~= value

        subscribe = (stream, index) ->
            if is_readable(stream) or is_writable(stream)
                stream.subscribe(
                    (value) ->
                        values[index] = value
                        pending[index] = true

                        sync() if initialized

                    () ->
                        pending[index] = false
                )

            else
                values[index] = value
                pending[index] = true

                sync() if initialized

        unsubscribers = [subscribe(stream, index) for index, stream in ipairs(streams)]

        initialized = true
        sync()

        return () ->
            unsubscriber() for unsubscriber in *unsubscribers
    )