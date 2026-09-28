---------------------------------------------------------------------------------------
local TaskService = {}
---------------------------------------------------------------------------------------
export type TaskService = {
    --
    Type: "TaskService",
    Spawn: (self: TaskService, func: (...any)->(), ...any) -> thread,
    Defer: (self: TaskService, func: (...any)->(), ...any) -> thread,
    Delay: (self: TaskService, duration: number, func: (...any)->(), ...any) -> thread,
    --
}
---------------------------------------------------------------------------------------
local Call, Thread
local threads = {} :: {thread}
---------------------------------------------------------------------------------------
TaskService.Type = "TaskService"
--
function TaskService:Spawn(func,...)
    return task.spawn(table.remove(threads) or task.spawn(Thread), func, ...)
end
--
function TaskService:Defer(func,...)
    return task.defer(table.remove(threads) or task.spawn(Thread), func, ...)
end
--
function TaskService:Delay(duration,func,...)
    return task.delay(duration, table.remove(threads) or task.spawn(Thread), func, ...)
end
---------------------------------------------------------------------------------------
function Call(func: (...any)->(), ...)
    func(...)
    table.insert(threads, coroutine.running())
end
--
function Thread()
    while true do
        Call(coroutine.yield())
    end
end
---------------------------------------------------------------------------------------
return TaskService
---------------------------------------------------------------------------------------