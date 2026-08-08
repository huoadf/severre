--!strict
-- Severe UNC & SNC Combined Test Suite Orchestrator & File Logger
-- Sandboxed output file target: C:\v2\workspace\severe_test_results.txt & severe_test_results.json

local UNCTestSuite = require(script.Parent:FindFirstChild("severe_unc_test") or "scripts/severe_unc_test.luau")
local SNCTestSuite = require(script.Parent:FindFirstChild("severe_snc_test") or "scripts/severe_snc_test.luau")

send_notification("Executing Severe UNC & SNC Environment Test Suites...")

-- Execute Test Suites safely
local uncResults, uncPassed, uncTotal = UNCTestSuite.Run()
local sncResults, sncPassed, sncTotal = SNCTestSuite.Run()

local grandTotal = uncTotal + sncTotal
local grandPassed = uncPassed + sncPassed
local grandPassRate = math.floor((grandPassed / (if grandTotal == 0 then 1 else grandTotal)) * 100)

-- Format Text Report
local lines = {}
table.insert(lines, "================================================================================")
table.insert(lines, "                       SEVERE LUAU VM BENCHMARK REPORT                          ")
table.insert(lines, "================================================================================")
table.insert(lines, string.format("Overall Summary: %d / %d Tests Passed (%d%% Pass Rate)", grandPassed, grandTotal, grandPassRate))
table.insert(lines, string.format("UNC Standard Suite: %d / %d Passed (%d%%)", uncPassed, uncTotal, math.floor((uncPassed / uncTotal) * 100)))
table.insert(lines, string.format("SNC Severe Engine Suite: %d / %d Passed (%d%%)", sncPassed, sncTotal, math.floor((sncPassed / sncTotal) * 100)))
table.insert(lines, "--------------------------------------------------------------------------------")
table.insert(lines, "")

table.insert(lines, "[ UNC TEST RESULTS ]")
for _, r in ipairs(uncResults) do
    local status = if r.Passed then "[PASS]" else "[FAIL]"
    local errInfo = if r.Error then " -> Error: " .. r.Error else ""
    table.insert(lines, string.format("  %-6s [%-12s] %s%s", status, r.Category, r.Name, errInfo))
end

table.insert(lines, "")
table.insert(lines, "[ SNC TEST RESULTS ]")
for _, r in ipairs(sncResults) do
    local status = if r.Passed then "[PASS]" else "[FAIL]"
    local errInfo = if r.Error then " -> Error: " .. r.Error else ""
    table.insert(lines, string.format("  %-6s [%-12s] %s%s", status, r.Category, r.Name, errInfo))
end

table.insert(lines, "")
table.insert(lines, "================================================================================")

local textReport = table.concat(lines, "\n")

-- Write Formatted Text Log File to Sandbox (C:\v2\workspace\severe_test_results.txt)
if typeof(writefile) == "function" then
    writefile("severe_test_results.txt", textReport)
    
    -- Format JSON Summary Data
    local jsonSummary = {
        Timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        TotalTests = grandTotal,
        PassedTests = grandPassed,
        PassRatePercent = grandPassRate,
        UNCSummary = { Passed = uncPassed, Total = uncTotal },
        SNCSummary = { Passed = sncPassed, Total = sncTotal },
        UNCDetails = uncResults,
        SNCDetails = sncResults,
    }
    
    if typeof(crypt) == "table" and typeof(crypt.json) == "table" and typeof(crypt.json.encode) == "function" then
        writefile("severe_test_results.json", crypt.json.encode(jsonSummary))
    end
end

-- Output to Console & Overlay Notification
print(textReport)
send_notification(string.format("Severe Benchmark Complete! Pass Rate: %d%% (%d/%d)", grandPassRate, grandPassed, grandTotal))
