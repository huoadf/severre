--!strict
-- Severe Naming Convention Benchmark (SNC Test Suite)
-- Tests Severe-specific custom features (Core Globals, Model Threading, Memory Engine, Dynamic Attachments, Luau Compiler)

type TestResult = {
    Name: string,
    Category: string,
    Passed: boolean,
    Error: string?,
}

local SNCTestSuite = {}
local Results: { TestResult } = {}

local function Test(category: string, name: string, callback: () -> ())
    local success, err = pcall(callback)
    table.insert(Results, {
        Name = name,
        Category = category,
        Passed = success,
        Error = if not success then tostring(err) else nil
    })
end

function SNCTestSuite.Run(): ({ TestResult }, number, number)
    Results = {}

    -- 1. Severe Core Globals
    Test("SevereCore", "isrbxactive", function()
        assert(typeof(isrbxactive) == "function", "isrbxactive missing")
        local res = isrbxactive()
        assert(typeof(res) == "boolean", "isrbxactive did not return boolean")
    end)

    Test("SevereCore", "send_notification", function()
        assert(typeof(send_notification) == "function", "send_notification missing")
        send_notification("SNC Test Notification")
    end)

    Test("SevereCore", "block_roblox_window", function()
        assert(typeof(block_roblox_window) == "function", "block_roblox_window missing")
        block_roblox_window(false)
    end)

    Test("SevereCore", "get_overlay_fps", function()
        assert(typeof(get_overlay_fps) == "function", "get_overlay_fps missing")
        local fps = get_overlay_fps()
        assert(typeof(fps) == "number", "get_overlay_fps did not return number")
    end)

    Test("SevereCore", "ismenuopened", function()
        assert(typeof(ismenuopened) == "function", "ismenuopened missing")
        local menuState = ismenuopened()
        assert(typeof(menuState) == "boolean", "ismenuopened did not return boolean")
    end)

    Test("SevereCore", "pointer_to_userdata", function()
        assert(typeof(pointer_to_userdata) == "function", "pointer_to_userdata missing")
    end)

    Test("SevereCore", "Setting Checks (forcefield, health, team)", function()
        assert(typeof(is_forcefield_check_active) == "function", "is_forcefield_check_active missing")
        assert(typeof(is_local_health_check_active) == "function", "is_local_health_check_active missing")
        assert(typeof(is_team_check_active) == "function", "is_team_check_active missing")
        local ff = is_forcefield_check_active()
        local hp = is_local_health_check_active()
        local tm = is_team_check_active()
        assert(typeof(ff) == "boolean" and typeof(hp) == "boolean" and typeof(tm) == "boolean", "Settings check returned invalid type")
    end)

    -- 2. Model Threading & Targeting API
    Test("ModelThreading", "add_model_data & edit_model_data & remove_model_data", function()
        assert(typeof(add_model_data) == "function", "add_model_data missing")
        assert(typeof(edit_model_data) == "function", "edit_model_data missing")
        assert(typeof(remove_model_data) == "function", "remove_model_data missing")
        assert(typeof(clear_model_data) == "function", "clear_model_data missing")
        
        local mockData = {
            Username = "TestTarget",
            Displayname = "TestTargetDisplay",
            Userid = 999999,
            Health = 100,
            MaxHealth = 100
        }
        
        local added = add_model_data(mockData, "snc_test_target")
        assert(typeof(added) == "boolean", "add_model_data failed")
        
        local edited = edit_model_data({ Health = 50 }, "snc_test_target")
        assert(typeof(edited) == "boolean", "edit_model_data failed")
        
        local removed = remove_model_data("snc_test_target")
        assert(typeof(removed) == "boolean", "remove_model_data failed")
    end)

    Test("ModelThreading", "override_local_data & clear_local_data", function()
        assert(typeof(override_local_data) == "function", "override_local_data missing")
        assert(typeof(clear_local_data) == "function", "clear_local_data missing")
    end)

    -- 3. Memory Library API
    Test("MemoryEngine", "memory.base", function()
        assert(typeof(memory) == "table", "memory table missing")
        assert(typeof(memory.base) == "number", "memory.base missing or invalid type")
        assert(memory.base > 0, "memory.base is non-positive")
    end)

    Test("MemoryEngine", "memory.read[type] signatures", function()
        assert(typeof(memory.readu8) == "function", "readu8 missing")
        assert(typeof(memory.readu32) == "function", "readu32 missing")
        assert(typeof(memory.readu64) == "function", "readu64 missing")
        assert(typeof(memory.readf32) == "function", "readf32 missing")
        assert(typeof(memory.readf64) == "function", "readf64 missing")
        assert(typeof(memory.readstring) == "function", "readstring missing")
        assert(typeof(memory.readvector) == "function", "readvector missing")
        assert(typeof(memory.readbuffer) == "function", "readbuffer missing")
    end)

    Test("MemoryEngine", "memory.rtti & memory.changed", function()
        assert(typeof(memory.rtti) == "function", "rtti missing")
        assert(typeof(memory.changed) == "function", "changed missing")
    end)

    -- 4. Dynamic 3D Attachment Engine
    Test("DynamicDrawing", "PointInstance & Point3D & Drawing.attach", function()
        assert(typeof(PointInstance) == "table", "PointInstance missing")
        assert(typeof(PointInstance.new) == "function", "PointInstance.new missing")
        assert(typeof(Point3D) == "table", "Point3D missing")
        assert(typeof(Point3D.new) == "function", "Point3D.new missing")
        assert(typeof(Drawing.attach) == "function", "Drawing.attach missing")

        local p3d = Point3D.new(Vector3.new(0, 10, 0))
        assert(p3d ~= nil, "Point3D creation failed")
        
        local box = Drawing.new("Square")
        box.Visible = true
        
        local cluster = Drawing.attach({
            [box] = {
                Link = p3d,
                Size = UDim2.fromScale(1, 1),
                AnchorPoint = Vector2.new(0.5, 0.5)
            }
        })
        
        assert(cluster ~= nil, "Drawing.attach failed")
        assert(typeof(cluster.Pause) == "function", "Cluster:Pause missing")
        assert(typeof(cluster.Resume) == "function", "Cluster:Resume missing")
        assert(typeof(cluster.Destroy) == "function", "Cluster:Destroy missing")
        
        cluster:Pause()
        cluster:Resume()
        cluster:Destroy()
        p3d:Destroy()
    end)

    -- 5. Severe Input Functions
    Test("SevereInput", "isleftpressed & isrightpressed & isleftclicked & isrightclicked", function()
        assert(typeof(isleftpressed) == "function", "isleftpressed missing")
        assert(typeof(isrightpressed) == "function", "isrightpressed missing")
        assert(typeof(isleftclicked) == "function", "isleftclicked missing")
        assert(typeof(isrightclicked) == "function", "isrightclicked missing")
        assert(typeof(mousescroll) == "function", "mousescroll missing")
    end)

    -- 6. Luau Compiler Library
    Test("LuauCompiler", "luau.compile & luau.load", function()
        assert(typeof(luau) == "table", "luau table missing")
        assert(typeof(luau.compile) == "function", "luau.compile missing")
        assert(typeof(luau.load) == "function", "luau.load missing")
        
        local bytecode = luau.compile("return 'SevereLuauCompilerPass'", { optimizationLevel = 2 })
        assert(typeof(bytecode) == "string" and #bytecode > 0, "luau.compile failed")
        
        local fn = luau.load(bytecode, "SNCLuauChunk")
        assert(typeof(fn) == "function", "luau.load failed")
        assert(fn() == "SevereLuauCompilerPass", "luau.load execution returned wrong value")
    end)

    -- Calculate Totals
    local passedCount = 0
    for _, result in ipairs(Results) do
        if result.Passed then
            passedCount += 1
        end
    end

    return Results, passedCount, #Results
end

return SNCTestSuite
