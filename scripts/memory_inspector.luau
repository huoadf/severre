--!strict
-- Severe External Memory Inspector Utility
-- Demonstrates raw memory offset reading, RTTI inspection, pointer re-casting, and memory modification hooks

local Workspace = game:GetService("Workspace")

print("--------------------------------------------------")
print("Severe Memory Inspection Environment Initialized")
print("Roblox Base Address: 0x" .. string.format("%X", memory.base))
print("--------------------------------------------------")

-- 1. Reading RTTI (Run-Time Type Information) of Roblox Instances
local workspaceRTTI = memory.rtti(Workspace)
print("Workspace RTTI Name:", workspaceRTTI or "Unknown")

-- 2. Reading uint64 pointer offsets and casting back to userdata
local parentPointer = memory.readu64(Workspace, 0x50) -- Common offset for parent in C++ structure
print("Workspace Parent Raw Address: 0x" .. string.format("%X", parentPointer))

if parentPointer ~= 0 then
    local dataModel = pointer_to_userdata(parentPointer)
    if dataModel then
        print("Recast Pointer to Userdata:", tostring(dataModel))
        print("Matches game DataModel?", dataModel == game)
    end
end

-- 3. Monitoring real-time memory changes with callback hook
local targetHealthAddress = memory.base + 0x12345678 -- Example offset
print("Attaching memory change listener to 0x" .. string.format("%X", targetHealthAddress))

local changeHook = memory.changed(targetHealthAddress, "f32", function(self, newHealth, oldHealth)
    print(string.format("[MemoryHook] Health Changed: %.1f -> %.1f", oldHealth, newHealth))
end)

send_notification("Severe Memory Inspector Active (Check Console Output)")
