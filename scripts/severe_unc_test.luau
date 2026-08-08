--!strict
-- Severe Universal Environment Benchmark (UNC Test Suite)
-- Tests standard Luau executor environment globals, functions, libraries, and file operations

type TestResult = {
    Name: string,
    Category: string,
    Passed: boolean,
    Error: string?,
}

local UNCTestSuite = {}
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

function UNCTestSuite.Run(): ({ TestResult }, number, number)
    Results = {}

    -- 1. File System Sandboxed Tests
    Test("FileSystem", "writefile & readfile", function()
        assert(typeof(writefile) == "function", "writefile missing")
        assert(typeof(readfile) == "function", "readfile missing")
        writefile("unc_test_temp.txt", "UNC Test String 123")
        local content = readfile("unc_test_temp.txt")
        assert(content == "UNC Test String 123", "Content mismatch: " .. tostring(content))
    end)

    Test("FileSystem", "isfile & isfolder", function()
        assert(typeof(isfile) == "function", "isfile missing")
        assert(typeof(isfolder) == "function", "isfolder missing")
        assert(isfile("unc_test_temp.txt") == true, "isfile failed")
    end)

    Test("FileSystem", "makefolder & listfiles & delfolder", function()
        assert(typeof(makefolder) == "function", "makefolder missing")
        assert(typeof(listfiles) == "function", "listfiles missing")
        makefolder("unc_test_folder")
        assert(isfolder("unc_test_folder") == true, "isfolder check failed")
        local files = listfiles("")
        assert(typeof(files) == "table", "listfiles did not return table")
        if typeof(delfolder) == "function" then
            delfolder("unc_test_folder")
        end
    end)

    Test("FileSystem", "loadfile & dofile", function()
        assert(typeof(loadfile) == "function", "loadfile missing")
        assert(typeof(dofile) == "function", "dofile missing")
        writefile("unc_script.luau", "return 42")
        local fn = loadfile("unc_script.luau")
        assert(typeof(fn) == "function", "loadfile failed to return function")
        assert(fn() == 42, "loadfile returned wrong value")
        assert(dofile("unc_script.luau") == 42, "dofile returned wrong value")
    end)

    -- 2. Input Simulation Tests
    Test("Input", "mousemoverel & mousemoveabs", function()
        assert(typeof(mousemoverel) == "function", "mousemoverel missing")
        assert(typeof(mousemoveabs) == "function", "mousemoveabs missing")
        mousemoverel(0, 0)
    end)

    Test("Input", "mouse1click & mouse2click", function()
        assert(typeof(mouse1click) == "function", "mouse1click missing")
        assert(typeof(mouse2click) == "function", "mouse2click missing")
    end)

    Test("Input", "keypress & keyrelease", function()
        assert(typeof(keypress) == "function", "keypress missing")
        assert(typeof(keyrelease) == "function", "keyrelease missing")
    end)

    Test("Input", "getpressedkeys", function()
        assert(typeof(getpressedkeys) == "function", "getpressedkeys missing")
        local keys = getpressedkeys()
        assert(typeof(keys) == "table", "getpressedkeys did not return table")
    end)

    -- 3. Clipboard API
    Test("Clipboard", "setclipboard", function()
        assert(typeof(setclipboard) == "function", "setclipboard missing")
        setclipboard("UNC Clipboard Test")
    end)

    -- 4. Drawing Library Tests
    Test("Drawing", "Drawing.new Primitive Creation", function()
        assert(typeof(Drawing) == "table", "Drawing table missing")
        assert(typeof(Drawing.new) == "function", "Drawing.new missing")
        
        local square = Drawing.new("Square")
        assert(square ~= nil, "Failed to create Square")
        square.Visible = false
        if typeof(square.Remove) == "function" then
            square:Remove()
        elseif typeof(square.Destroy) == "function" then
            square:Destroy()
        end
    end)

    -- 5. Cryptography Library Tests
    Test("Crypt", "crypt.base64", function()
        assert(typeof(crypt) == "table", "crypt table missing")
        assert(typeof(crypt.base64) == "table", "crypt.base64 missing")
        assert(typeof(crypt.base64.encode) == "function", "encode missing")
        assert(typeof(crypt.base64.decode) == "function", "decode missing")
        local encoded = crypt.base64.encode("SevereUNC")
        assert(encoded == "U2V2ZXJlVU5D", "Base64 encoding mismatch: " .. tostring(encoded))
        local decoded = crypt.base64.decode(encoded)
        assert(decoded == "SevereUNC", "Base64 decoding mismatch")
    end)

    Test("Crypt", "crypt.hash.sha256", function()
        assert(typeof(crypt.hash) == "table", "crypt.hash missing")
        assert(typeof(crypt.hash.sha256) == "function", "sha256 missing")
        local hash = crypt.hash.sha256("test")
        assert(typeof(hash) == "string" and #hash > 0, "sha256 failed")
    end)

    Test("Crypt", "crypt.random", function()
        assert(typeof(crypt.random) == "function", "crypt.random missing")
        local rnd = crypt.random("16")
        assert(typeof(rnd) == "string", "random failed")
    end)

    -- 6. Task Library Tests
    Test("Task", "task.spawn & task.wait", function()
        assert(typeof(task) == "table", "task table missing")
        assert(typeof(task.spawn) == "function", "task.spawn missing")
        assert(typeof(task.wait) == "function", "task.wait missing")
        local ran = false
        task.spawn(function()
            ran = true
        end)
        task.wait(0.05)
        assert(ran == true, "task.spawn did not execute")
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

return UNCTestSuite
