---@meta

Citizen = {}

---Creates a new thread, All code inside the handler will be executed asynchronously.
---@param handler function The thread handler function.
function Citizen.CreateThread(handler) end

---This will execute the specified function after the specified amount of milliseconds.
---@param milliseconds integer The amount of milliseconds to pause the current thread.
---@param callback function The function to run after the timer completes.
function Citizen.SetTimeout(milliseconds, callback) end

---Pauses the current coroutine (such as `CreateThread`) for the specified time
---@param milliseconds integer The amount of milliseconds to pause the current thread. This value determines how long the script will wait before continuing execution.
function Citizen.Wait(milliseconds) end

Wait = Citizen.Wait