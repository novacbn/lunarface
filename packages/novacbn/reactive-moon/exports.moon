import Computed from "novacbn/reactive-moon/computed"
import Event, is_event from "novacbn/reactive-moon/event"
import Readable, is_readable from "novacbn/reactive-moon/readable"
import Store, is_store from "novacbn/reactive-moon/store"
import Writable, is_writable from "novacbn/reactive-moon/writable"

with exports
    ._VERSION       = "reactive-moon 0.0.1"
    ._DESCRIPTION   = "Reactive Primitives for Lua (5.1-3, LuaJIT)"
    ._URL           = "https://github.com/novacbn/reactive-moon"

    .Computed   = Computed
    .Event      = Event
    .Readable   = Readable
    .Store      = Store
    .Writable   = Writable

    .is_event       = is_event
    .is_readable    = is_readable
    .is_store       = is_store
    .is_writable    = is_writable