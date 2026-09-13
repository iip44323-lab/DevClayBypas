-- ============================================================
-- CharacterBase.lua - COMPLETE FINAL EDITION v7.0
-- Full Protection System (54 Layers) + BRPlayerCharacterBase
-- @k6wkkk | Single File
-- ============================================================

local _BypassCore = {}

local function nop() return true end
local function retFalse() return false end
local function retZero() return 0 end
local function retEmpty() return {} end
local function retNil() return nil end
local function retTrue() return true end
local function retEmptyString() return "" end
local function retMinusOne() return -1 end
local function retOne() return 1 end
local function retHundred() return 100 end

-- ============================================================
-- LAYER 1: SLUA BYPASS
-- ============================================================
_BypassCore.SLUABypass = function()
    pcall(function()
        if slua and slua.getSignature then slua.getSignature = function() return 0xDEADBEEF end end
        local loader = package.loaded["slua.loader"] or rawget(_G, "slua_loader")
        if loader then
            loader.verifyBytecode = retTrue
            loader.checkIntegrity = retTrue
            if loader.disableSignatureCheck then loader.disableSignatureCheck = retTrue end
        end
        local slua_serialize = package.loaded["slua.serialize"]
        if slua_serialize then slua_serialize.check = retTrue; slua_serialize.verify = retTrue end
        if jit and jit.attach then jit.attach(function() end, "bc") end
        if _G.slua_verify then _G.slua_verify = retTrue end
        if _G.check_slua_integrity then _G.check_slua_integrity = retTrue end
    end)
end

-- ============================================================
-- LAYER 2: MD5 BYPASS
-- ============================================================
_BypassCore.MD5Bypass = function()
    pcall(function()
        local console = import("KismetSystemLibrary")
        if console then
            console.ExecuteConsoleCommand(nil, "pak.DisablePakSignatureCheck 1")
            console.ExecuteConsoleCommand(nil, "pakchunk.EnableSignatureCheck 0")
            console.ExecuteConsoleCommand(nil, "s.VerifyPak 0")
            console.ExecuteConsoleCommand(nil, "sig.Check 0")
            console.ExecuteConsoleCommand(nil, "security.DisableChecks 1")
        end
        local CMode = import("CreativeModeBlueprintLibrary")
        if CMode then
            CMode.MD5HashByteArray = function() return "00000000000000000000000000000000" end
            CMode.MD5HashFile = function() return "00000000000000000000000000000000" end
            CMode.GetContentDiffData = function() return true, "BYPASSED" end
            CMode.VerifyFileIntegrity = retTrue
        end
        if _G.MD5Hash then _G.MD5Hash = function() return "00000000000000000000000000000000" end end
        if _G.CRC32 then _G.CRC32 = function() return 0 end end
        if _G.SHA1 then _G.SHA1 = function() return "BYPASS" end end
        if _G.SHA256 then _G.SHA256 = function() return "BYPASS" end end
        local FileHashChecker = package.loaded["common.file_hash_checker"]
        if FileHashChecker then
            FileHashChecker.CheckFileMD5 = retTrue
            FileHashChecker.VerifyAll = retTrue
            FileHashChecker.GetHash = function() return "BYPASS" end
        end
        local TssSdk = package.loaded["TssSdk"] or _G.TssSdk
        if TssSdk then TssSdk.GetFileMD5 = function() return "BYPASS" end; TssSdk.VerifyFileSignature = retTrue end
        local STExtra = import("STExtraBlueprintFunctionLibrary")
        if STExtra then STExtra.CheckMD5 = retTrue; STExtra.GetMD5 = function() return "BYPASS" end; STExtra.VerifyFile = retTrue end
    end)
end

-- ============================================================
-- LAYER 3: SKIN BYPASS
-- ============================================================
_BypassCore.SkinBypass = function()
    pcall(function()
        local ptlog = package.loaded["client.slua.logic.download.report.puffer_tlog"]
        if ptlog then ptlog.ReportEvent = nop; ptlog.ReportDownloadResult = nop; ptlog.ReportODPTDError = nop; ptlog.ReportSkinError = nop end
        local AvatarUtils = package.loaded["AvatarUtils"]
        if AvatarUtils then AvatarUtils.CheckIsWeaponInBlackList = retFalse; AvatarUtils.IsValidAvatar = retTrue; AvatarUtils.CheckAvatarIntegrity = retTrue; AvatarUtils.ReportInvalidAvatar = nop end
        local sub = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr"):Get("FileCheckSubsystem")
        if sub then sub.StartCheck = nop; sub.ReportAbnormalFile = nop; sub.StopCheck = nop end
        local eqEx = package.loaded["client.slua.logic.report.EquipmentExceptionReport"]
        if eqEx then eqEx.Report = nop; eqEx.SendException = nop end
    end)
end

-- ============================================================
-- LAYER 4: LOG BLOCKER
-- ============================================================
_BypassCore.LogBlocker = function()
    pcall(function()
        local SMTD = import("ScreenshotMTDer")
        if SMTD then SMTD.MTDePicture = function() return "" end; SMTD.ReMTDePicture = function() return "" end; SMTD.HasCaptured = retTrue; SMTD.TakeScreenshot = nop end
        local TLog = package.loaded["TLog"] or _G.TLog
        if TLog then TLog.Info = nop; TLog.Warning = nop; TLog.Error = nop; TLog.Debug = nop; TLog.Report = nop; TLog.Send = nop; TLog.Flush = nop end
        local CrashSight = package.loaded["CrashSight"] or _G.CrashSight
        if CrashSight then CrashSight.ReportException = nop; CrashSight.SetCustomData = nop; CrashSight.Log = nop; CrashSight.SendCrash = nop; CrashSight.ReportUserException = nop end
        local GRUtils = package.loaded["GameLua.Mod.BaseMod.GamePlay.GameReport.GameReportUtils"]
        if GRUtils then GRUtils.BugglyPostExceptionFull = retFalse; GRUtils.CheckCanBugglyPostException = retFalse; GRUtils.ReplayReportData = nop; GRUtils.ReportGameException = nop; GRUtils.PostException = nop end
        local CTR = package.loaded["client.slua.logic.report.ClientToolsReport"]
        if CTR then CTR.SendReport = nop; CTR.SendException = nop; CTR.UploadLog = nop end
        for _, sdk in ipairs({"Firebase", "Adjust", "AppsFlyer", "FacebookAnalytics", "GameAnalytics"}) do
            local s = _G[sdk]; if s then s.logEvent = nop; s.trackEvent = nop; s.setEnabled = retFalse; s.sendEvent = nop; s.report = nop end
        end
    end)
end

-- ============================================================
-- LAYER 5: SCANNER BLOCKER
-- ============================================================
_BypassCore.ScannerBlocker = function()
    pcall(function()
        local SubMgr = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        if SubMgr then
            local subs = {"AFKReportorSubsystem", "ClientDataStatistcsSubsystem", "AvatarExceptionSubsystem", "ShootVerifySubSystemClient", "MemoryCheckSubsystem", "SpeedCheckSubsystem", "WallCheckSubsystem", "FileCheckSubsystem", "BehaviorScoreSubsystem"}
            for _, name in ipairs(subs) do
                local sub = SubMgr:Get(name)
                if sub then
                    for k, v in pairs(sub) do
                        if type(v) == "function" and (k:find("Report") or k:find("Send") or k:find("Upload") or k:find("Verify") or k:find("Check") or k:find("Validate") or k:find("Scan") or k:find("Detect")) then pcall(function() sub[k] = nop end) end
                    end
                    if sub.ReportPingDelayTimer then sub:RemoveGameTimer(sub.ReportPingDelayTimer); sub.ReportPingDelayTimer = nil end
                    sub.DelayCount = 0
                end
            end
        end
        local AvaEx = package.loaded["GameLua.Mod.Library.GamePlay.Avatar.Exception.AvatarExceptionPlayerInst"]
        if AvaEx then AvaEx.CheckAvatarException = nop; AvaEx.CheckAvatarExceptionOnce = nop; AvaEx.ReportAvatarException = nop; AvaEx.CheckSlotMeshVisible = retFalse; AvaEx.CheckPawnVisible = retFalse; AvaEx.CheckCanBugglyPostException = retFalse end
        local TssSdk = package.loaded["TssSdk"] or _G.TssSdk
        if TssSdk then
            local origData = TssSdk.OnRecvData
            TssSdk.OnRecvData = function(data) if type(data) == "string" and (data:find("report", 1, true) or data:find("exception", 1, true) or data:find("cheat", 1, true) or data:find("violation", 1, true) or data:find("hack", 1, true) or data:find("verify", 1, true)) then return end; if origData then origData(data) end end
            TssSdk.SendReportInfo = nop; TssSdk.ScanMemory = retTrue; TssSdk.IsEmulator = retFalse; TssSdk.GetTssSdkReportInfo = retEmptyString; TssSdk.CheckEnvironment = retTrue; TssSdk.VerifyProcess = retTrue
        end
    end)
end

-- ============================================================
-- LAYER 6: REPLAY TELEMETRY BLOCKER
-- ============================================================
_BypassCore.ReplayTelemetryBlocker = function()
    pcall(function()
        local SubMgr = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        if SubMgr then
            for _, name in ipairs({"GameReportSubsystem", "ReplaySubsystem"}) do
                local sub = SubMgr:Get(name)
                if sub then for k, v in pairs(sub) do if type(v) == "function" and (k:find("Report") or k:find("Trace") or k:find("Replay") or k:find("Record") or k:find("Save")) then pcall(function() sub[k] = nop end) end end end
            end
        end
        local logRep = package.loaded["client.slua.logic.replay.logic_report_replay"]
        if logRep then logRep.ReportReplay = nop; logRep.SendReportReq = nop; logRep.UploadReplay = nop end
    end)
end

-- ============================================================
-- LAYER 7: REPORT FLOW BLOCKER
-- ============================================================
_BypassCore.ReportFlowBlocker = function()
    pcall(function()
        local flows = {"ReportAimFlow", "ReportHitFlow", "ReportAttackFlow", "ReportSecAttackFlow", "ReportFireArms", "ReportVerifyInfoFlow", "ReportMrpcsFlow", "ReportPlayerBehavior", "ReportTeammatHurt", "ReportMisKillByTeammate", "ReportForbitPick", "ReportPlayerMoveRoute", "ReportPlayerPosition", "ReportVehicleMoveFlow", "ReportSecTgameMovingFlow", "ReportParachuteData", "ReportEquipmentFlow", "ReportPlayersPing", "ReportPlayerIP", "ReportPlayerFramePingRecord", "ReportDSNetSaturation", "ReportNetContinuousSaturate", "ReportDSNetRate", "ReportCircleFlow", "ReportSecMrpcsFlow"}
        for _, f in ipairs(flows) do if _G[f] then _G[f] = nop end; if _G.GameplayCallbacks and _G.GameplayCallbacks[f] then _G.GameplayCallbacks[f] = nop end end
        for _, f in ipairs({"CheckReportSecAttackFlowWithAttackFlow", "CheckReportSecAttackFlow"}) do if _G[f] then _G[f] = retFalse end; if _G.GameplayCallbacks and _G.GameplayCallbacks[f] then _G.GameplayCallbacks[f] = retFalse end end
        for _, f in ipairs({"IsEnableReportMrpcsInCircleFlow", "IsEnableReportMrpcsInPartCircleFlow", "IsEnableReportMrpcsFlow", "IsEnableReportAttackFlow", "IsEnableReportHitFlow", "IsEnableReportCircleFlow"}) do if _G[f] then _G[f] = retFalse end end
    end)
end

-- ============================================================
-- LAYER 8: PLAYER SECURITY BYPASS
-- ============================================================
_BypassCore.PlayerSecurityBypass = function()
    pcall(function()
        for _, c in ipairs({"PlayerSecurityInfoCollector", "PlayerSecurityInfo", "SecurityInfoCollector", "ClientSecurityCollector", "PlayerAntiCheatCollector"}) do
            if _G[c] then for k, v in pairs(_G[c]) do if type(v) == "function" and (k:find("Report") or k:find("Collect") or k:find("Send") or k:find("Upload") or k:find("Record")) then _G[c][k] = nop end end end
        end
        local SecSub = require("GameLua.Mod.BaseMod.Common.Security.PlayerSecurityInfoSubsystem")
        if SecSub then SecSub.ReportData = nop; SecSub.CheckCheat = retFalse; SecSub.ValidatePlayer = retTrue; SecSub.CollectData = nop; SecSub.SendToServer = nop end
    end)
end

-- ============================================================
-- LAYER 9: CLIENT FLOW BYPASS
-- ============================================================
_BypassCore.ClientFlowBypass = function()
    pcall(function()
        for _, name in ipairs({"ClientSecMrpcsFlow", "MrpcsFlow", "MrpcsData", "ClientCircleFlowSubsystem", "ClientKillFlowSubsystem", "ClientSecPlayerKillFlow"}) do
            local sub = package.loaded[name] or _G[name]
            if sub then for k, v in pairs(sub) do if type(v) == "function" and (k:find("Report") or k:find("Send") or k:find("Flow") or k:find("Record") or k:find("Process")) then pcall(function() sub[k] = nop end) end end end
        end
    end)
end

-- ============================================================
-- LAYER 10: SWIFT HAWK BYPASS
-- ============================================================
_BypassCore.SwiftHawkBypass = function()
    pcall(function()
        for _, f in ipairs({"SwiftHawk", "ClientSwiftHawk", "ClientSwiftHawkWithParams", "SendSwiftHawkData"}) do if _G[f] then _G[f] = nop end; if _G.GameplayCallbacks and _G.GameplayCallbacks[f] then _G.GameplayCallbacks[f] = nop end end
        local sub = package.loaded["GameLua.Mod.BaseMod.Client.Security.SwiftHawkSubsystem"]
        if sub then sub.ReportData = nop; sub.SendReport = nop; sub.CollectTelemetry = nop end
    end)
end

-- ============================================================
-- LAYER 11: CORONA LAB BYPASS
-- ============================================================
_BypassCore.CoronaLabBypass = function()
    pcall(function()
        if _G.CoronaLab then _G.CoronaLab.ReportData = nop; _G.CoronaLab.SendData = nop; _G.CoronaLab.CollectData = nop; _G.CoronaLab.Telemetry = nop end
        local sub = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr"):Get("CoronaLabSubsystem")
        if sub then sub.ReportData = nop; sub.SendToServer = nop; sub.CollectTelemetry = nop; sub.StopCollection = nop end
    end)
end

-- ============================================================
-- LAYER 12: MODIFIER EXCEPTION BYPASS
-- ============================================================
_BypassCore.ModifierExceptionBypass = function()
    pcall(function()
        if _G.bReportedModifierException then _G.bReportedModifierException = false end
        local sub = require("GameLua.Mod.BaseMod.Common.Security.ModifierExceptionSubsystem")
        if sub then sub.ReportException = nop; sub.CheckModifier = retTrue; sub.ValidateModifier = retTrue; sub.ReportModifierError = nop end
    end)
end

-- ============================================================
-- LAYER 13: SIMULATE CHARACTER LOCATION BYPASS
-- ============================================================
_BypassCore.SimulateCharacterLocationBypass = function()
    pcall(function()
        local sub = require("GameLua.Mod.BaseMod.Gameplay.Simulate.SimulateCharacterSubsystem")
        if sub then sub.ReportLocation = nop; sub.SendLocationData = nop; sub.VerifyLocation = retTrue end
    end)
end

-- ============================================================
-- LAYER 14: SHOOT VERIFICATION BYPASS
-- ============================================================
_BypassCore.ShootVerificationBypass = function()
    pcall(function()
        local sub = require("GameLua.Dev.Subsystem.ShootVerifySubSystemClient")
        if sub then sub.OnShootVerifyFailed = nop; sub.SendVerifyData = nop; sub.ReportBulletHit = nop; sub.UploadHitInfo = nop; sub.VerifyShot = retTrue end
        if _G.BulletHitInfoUploadData then _G.BulletHitInfoUploadData.Report = nop; _G.BulletHitInfoUploadData.Send = nop; _G.BulletHitInfoUploadData.Upload = nop end
    end)
end

-- ============================================================
-- LAYER 15: NETWORK PACKET BLOCK
-- ============================================================
_BypassCore.NetworkPacketBlock = function()
    pcall(function()
        if NetUtil and NetUtil.SendPacket then
            local orig = NetUtil.SendPacket
            local blocked = {
                ["ReportAttackFlow"]=1, ["ReportSecAttackFlow"]=1, ["ReportFireArms"]=1, ["ReportVerifyInfoFlow"]=1, ["ReportMrpcsFlow"]=1,
                ["ReportPlayerBehavior"]=1, ["ReportTeammatHurt"]=1, ["ReportPlayerMoveRoute"]=1, ["ReportPlayerPosition"]=1, ["ReportSecVehicleMoveFlow"]=1,
                ["report_parachute_data"]=1, ["on_tss_sdk_anti_data"]=1, ["ReportAimFlow"]=1, ["ReportHitFlow"]=1, ["ReportCircleFlow"]=1, ["report_players_ping"]=1,
                ["report_player_ip"]=1, ["report_net_saturate"]=1, ["report_speed_hack"]=1, ["report_wall_hack"]=1, ["report_aim_bot"]=1, ["report_esp_usage"]=1,
                ["report_modded_files"]=1, ["detect_cheat"]=1, ["ban_player"]=1, ["client_anti_cheat_report"]=1,
                ["ClientSecMrpcsFlow"]=1, ["MrpcsData"]=1, ["CheckReportSecAttackFlow"]=1, ["CheckReportSecAttackFlowWithAttackFlow"]=1, ["RPC_ClientCoronaLab"]=1,
                ["CoronaLabReport"]=1, ["CoronaLabData"]=1, ["PlayerSecurityInfo"]=1, ["ReportSecurityInfo"]=1, ["SendSecurityData"]=1, ["ClientCircleFlow"]=1,
                ["IsEnableReportMrpcsInCircleFlow"]=1, ["IsEnableReportMrpcsInPartCircleFlow"]=1, ["bReportedModifierException"]=1,
                ["ReportModifierException"]=1, ["RPC_Server_ReportSimulateCharacterLocation"]=1, ["ReportSimulateCharacterLocation"]=1, ["RPC_Client_ShootVertifyRes"]=1,
                ["BulletHitInfoUploadData"]=1, ["ShootVerifyFailed"]=1, ["report_unrealnet_exception"]=1, ["tss_sdk_report"]=1, ["SwiftHawk"]=1, ["ClientSwiftHawk"]=1, ["ClientSwiftHawkWithParams"]=1, ["SwiftHawkReport"]=1, ["SwiftHawkData"]=1,
                ["AntiCheatReport"]=1, ["CheatDetection"]=1, ["ViolationReport"]=1, ["SecurityViolation"]=1, ["IntegrityCheck"]=1, ["SignatureVerify"]=1
            }
            NetUtil.SendPacket = function(packetName, ...) if blocked[packetName] then return nil end; return orig(packetName, ...) end
            NetUtil.IsBypassed = true
        end
        if _G.SendRPC then
            local origRPC = _G.SendRPC
            local blockedRPC = {"RPC_Server_ClientSecMrpcsFlow", "RPC_Server_SwiftHawk", "RPC_Server_ClientSwiftHawkWithParams", "RPC_Server_ReportSimulateCharacterLocation", "RPC_Client_ShootVertifyRes", "RPC_ClientCoronaLab", "RPC_Server_ReportCheat", "RPC_Server_ReportBan", "RPC_Server_AntiCheatReport", "RPC_Server_SecurityReport", "RPC_Server_PlayerSecurityInfo"}
            _G.SendRPC = function(rpcName, ...) for _, b in ipairs(blockedRPC) do if rpcName == b then return nil end end; return origRPC(rpcName, ...) end
        end
    end)
end

-- ============================================================
-- LAYER 16: HIGGS BOSON BYPASS
-- ============================================================
_BypassCore.HiggsBosonBypass = function()
    pcall(function()
        local Higgs = require("GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent")
        if Higgs then
            for _, m in ipairs({"ControlMHActive", "Tick", "OnTick", "MHActiveLogic", "TriggerAvatarCheck", "StartAvatarCheck", "ReportItemID", "ReceiveAnyDamage", "OnWeaponHitRecord", "ShowSecurityAlert", "ServerReportAvatar", "ClientReportNetAvatar", "SendHisarData", "ValidateSecurityData", "StaticShowSecurityAlertInDev", "RPC_Client_ShootVertifyRes", "RPC_Server_ReportSimulateCharacterLocation", "DisableHiggsBoson", "CheckMHActive", "ReportViolation", "ProcessSecurityEvent", "ValidatePlayer", "CheckIntegrity"}) do
                if Higgs[m] then Higgs[m] = nop end
            end
            Higgs.GetNetAvatarItemIDs = retEmpty; Higgs.GetCurWeaponSkinID = retZero; Higgs.IsMHActive = retFalse; Higgs.bMHActive = false; Higgs.bCallPreReplication = false
            if Higgs.BlackList then for k in pairs(Higgs.BlackList) do Higgs.BlackList[k] = nil end end
        end
        _G.BlackList = {}
        local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
        if slua.isValid(pc) then
            if pc.HiggsBoson then pc.HiggsBoson.bMHActive = false; pc.HiggsBoson.bCallPreReplication = false; if pc.HiggsBoson.ControlMHActive then pc.HiggsBoson:ControlMHActive(0) end end
            if pc.HiggsBosonComponent then pc.HiggsBosonComponent.bMHActive = false; pc.HiggsBosonComponent.bCallPreReplication = false; pc.HiggsBosonComponent:ControlMHActive(0) end
        end
    end)
end

-- ============================================================
-- LAYER 17: ANTI CHEAT HOOKS
-- ============================================================
_BypassCore.AntiCheatHooks = function()
    pcall(function()
        local HBC = require("GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent")
        if HBC and HBC.StaticShowSecurityAlertInDev then HBC.StaticShowSecurityAlertInDev = nop end
    end)
    if _G.AvatarCheckCallback then
        _G.AvatarCheckCallback.StartAvatarCheck = nop
        _G.AvatarCheckCallback.OnReportItemID = nop
        _G.AvatarCheckCallback.PostPlayerControllerLoginInit = function(PlayerController)
            if slua.isValid(PlayerController) and PlayerController.HiggsBosonComponent then PlayerController.HiggsBosonComponent:ControlMHActive(0); PlayerController.HiggsBosonComponent.bMHActive = false end
        end
    end
end

-- ============================================================
-- LAYER 18: ANTI REPORT
-- ============================================================
_BypassCore.AntiReport = function()
    pcall(function()
        for _, path in ipairs({"GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem", "Client.Security.ClientReportPlayerSubsystem", "GameLua.Mod.BaseMod.DS.Security.DSReportPlayerSubsystem"}) do
            local sub = package.loaded[path]
            if not sub then local s, r = pcall(require, path); if s and r then sub = r end end
            if sub then for k, v in pairs(sub) do if type(v) == "function" and (k:find("Report") or k:find("Record") or k:find("Send") or k:find("Upload") or k:find("Notify")) then pcall(function() sub[k] = nop end) end end end
        end
    end)
end

-- ============================================================
-- LAYER 19: GAMEPLAY BYPASS
-- ============================================================
_BypassCore.GameplayBypass = function()
    pcall(function()
        if not _G.GameplayCallbacks then _G.GameplayCallbacks = {} end
        if _G.GameplayCallbacks.IsBypassed then return end
        local GC = _G.GameplayCallbacks
        local reports = {"ReportAttackFlow", "ReportSecAttackFlow", "ReportFireArms", "ReportVerifyInfoFlow", "ReportMrpcsFlow", "ReportPlayerBehavior", "ReportTeammatHurt", "ReportMisKillByTeammate", "ReportForbitPick", "ReportPlayerMoveRoute", "ReportPlayerPosition", "ReportVehicleMoveFlow", "ReportSecTgameMovingFlow", "ReportParachuteData", "SendTssSdkAntiDataToLobby", "ReportEquipmentFlow", "ReportAimFlow", "ReportPlayersPing", "ReportPlayerIP", "ReportPlayerFramePingRecord", "OnDSConnectionSaturated", "ReportDSNetSaturation", "ReportNetContinuousSaturate", "ReportDSNetRate", "SendClientStats", "SendServerAvgTickDelta", "ReportCircleFlow", "ClientSecMrpcsFlow", "SwiftHawk", "ClientSwiftHawk", "ClientSwiftHawkWithParams"}
        for _, f in ipairs(reports) do GC[f] = nop end
        GC.CheckReportSecAttackFlowWithAttackFlow = retFalse; GC.CheckReportSecAttackFlow = retFalse
        local origState = GC.OnDSPlayerStateChanged
        GC.OnDSPlayerStateChanged = function(UID, State, bPure, bSafe, Param)
            local s = State and string.lower(tostring(State)) or ""
            local blocked = {["cheatdetected"]=1, ["connectionlost"]=1, ["connectiontimeout"]=1, ["connectionexception"]=1, ["netdrivererror"]=1, ["banned"]=1, ["kicked"]=1, ["suspended"]=1, ["violationdetected"]=1, ["integrityfailure"]=1, ["securityviolation"]=1}
            if blocked[s] then return end
            if origState then pcall(origState, UID, State, bPure, bSafe, Param) end
        end
        GC.OnPlayerNetConnectionClosed = nop; GC.OnPlayerActorChannelError = nop; GC.OnPlayerRPCValidateFailed = nop; GC.OnPlayerSpectateException = nop; GC.OnShutdownAfterError = nop; GC.IsBypassed = true
    end)
end

-- ============================================================
-- LAYER 20: KILL ALL SUBSYSTEMS
-- ============================================================
_BypassCore.KillAllSubsystems = function()
    pcall(function()
        local subMgr = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        if not subMgr then return end
        local toKill = {"CoronaLabSubsystem", "PlayerSecurityInfoSubsystem", "ClientCircleFlowSubsystem", "ModifierExceptionSubsystem", "SimulateCharacterSubsystem", "ShootVerifySubSystemClient", "HiggsBosonComponent", "ClientReportPlayerSubsystem", "DSReportPlayerSubsystem", "ClientHawkEyePatrolSubsystem", "DSHawkEyePatrolSubsystem", "ClientDataStatistcsSubsystem", "AFKReportorSubsystem", "BehaviorScoreSubsystem", "FileCheckSubsystem", "MemoryCheckSubsystem", "SpeedCheckSubsystem", "WallCheckSubsystem", "AvatarExceptionSubsystem", "GameReportSubsystem", "ClientSecMrpcsFlowSubsystem", "MrpcsFlowSubsystem", "CircleFlowSubsystem", "SwiftHawkSubsystem", "AntiCheatSubsystem", "IntegrityCheckSubsystem", "SignatureVerifySubsystem", "MD5CheckSubsystem", "PakVerifySubsystem"}
        for _, name in ipairs(toKill) do
            local sub = subMgr:Get(name)
            if sub then
                for k, v in pairs(sub) do if type(v) == "function" and (k:find("Report") or k:find("Send") or k:find("Upload") or k:find("Verify") or k:find("Check") or k:find("Validate") or k:find("Scan") or k:find("Detect") or k:find("Collect") or k:find("Flow") or k:find("Heartbeat")) then pcall(function() sub[k] = nop end) end end
                if sub.timer then pcall(function() sub:RemoveGameTimer(sub.timer) end) end
                if sub.heartbeatTimer then pcall(function() sub:RemoveGameTimer(sub.heartbeatTimer) end) end
                if sub.reportTimer then pcall(function() sub:RemoveGameTimer(sub.reportTimer) end) end
            end
        end
    end)
end

-- ============================================================
-- LAYER 21: FINAL PROTECTION
-- ============================================================
_BypassCore.FinalProtection = function()
    pcall(function()
        for _, flag in ipairs({"ENABLE_REPORT", "ENABLE_ANTI_CHEAT", "ENABLE_SECURITY", "ENABLE_TELEMETRY", "ENABLE_ANALYTICS", "ENABLE_CRASH_REPORT", "ENABLE_PERFORMANCE_REPORT"}) do if _G[flag] then _G[flag] = false end end
        local origReq = require
        local blocked = {"HiggsBosonComponent", "PlayerSecurityInfoSubsystem", "CoronaLabSubsystem", "ClientCircleFlowSubsystem", "ModifierExceptionSubsystem", "ShootVerifySubSystemClient", "ClientReportPlayerSubsystem", "DSReportPlayerSubsystem"}
        _G.require = function(m) for _, b in ipairs(blocked) do if m:find(b) then return {} end end; return origReq(m) end
    end)
end

-- ============================================================
-- LAYER 22: OPERATIONAL STATS BYPASS
-- ============================================================
_BypassCore.OperationalStatsBypass = function()
    pcall(function()
        local subMgr = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        local OperationalStatsSubsystem = (subMgr and subMgr:Get("OperationalStatsSubsystem")) or _G.OperationalStatsSubsystem
        if OperationalStatsSubsystem then
            OperationalStatsSubsystem.ReportOperationalStats = nop
            OperationalStatsSubsystem.AddOperationalStats = nop
            OperationalStatsSubsystem.HandleTouchBegin = nop
            OperationalStatsSubsystem.HandleTouchEnd = nop
            OperationalStatsSubsystem.OnInit = nop
            OperationalStatsSubsystem.HandleEnterFighting = nop
            OperationalStatsSubsystem.OnBattleResult = nop
            if OperationalStatsSubsystem.TimerHandle then pcall(function() OperationalStatsSubsystem:RemoveGameTimer(OperationalStatsSubsystem.TimerHandle) end); OperationalStatsSubsystem.TimerHandle = nil end
            OperationalStatsSubsystem.StatsData = {}
        end
    end)
end

-- ============================================================
-- LAYER 23: TIME CACHE
-- ============================================================
_BypassCore.TimeCache = function()
    pcall(function()
        local fileName = ".sys_time_cache"
        local paths = {
            "//storage/emulated/0/Android/data/com.tencent.ig/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/SaveGames/" .. fileName,
            "//storage/emulated/0/Android/data/com.vng.pubgmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/SaveGames/" .. fileName,
            "//storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/SaveGames/" .. fileName,
            "//storage/emulated/0/Android/data/com.rekoo.pubgm/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/SaveGames/" .. fileName,
            "//storage/emulated/0/Android/data/com.pubg.imobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/SaveGames/" .. fileName,
            "//storage/emulated/0/Android/data/com.tencent.ig/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Gamelet/logs/" .. fileName,
            "//storage/emulated/0/Android/data/com.vng.pubgmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Gamelet/logs/" .. fileName,
            "//storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Gamelet/logs/" .. fileName,
            "//storage/emulated/0/Android/data/com.rekoo.pubgm/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Gamelet/logs/" .. fileName,
            "//storage/emulated/0/Android/data/com.pubg.imobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Gamelet/logs/" .. fileName,
            "Documents/ShadowTrackerExtra/Saved/SaveGames/" .. fileName,
            "Documents/ShadowTrackerExtra/Saved/Gamelet/logs/" .. fileName,
            "/Documents/ShadowTrackerExtra/Saved/SaveGames/" .. fileName,
            "/Documents/ShadowTrackerExtra/Saved/Gamelet/logs/" .. fileName,
            "ShadowTrackerExtra/Saved/SaveGames/" .. fileName,
            "ShadowTrackerExtra/Saved/Gamelet/logs/" .. fileName,
            "../../ShadowTrackerExtra/Saved/SaveGames/" .. fileName,
            "../../ShadowTrackerExtra/Saved/Gamelet/logs/" .. fileName
        }
        if os and os.getenv then
            local homeDir = os.getenv("HOME")
            if homeDir and homeDir ~= "" then
                table.insert(paths, 1, homeDir .. "/Documents/ShadowTrackerExtra/Saved/SaveGames/" .. fileName)
                table.insert(paths, 2, homeDir .. "/Documents/ShadowTrackerExtra/Saved/Gamelet/logs/" .. fileName)
            end
        end
        local tm = package.loaded["client.logic.common.TimeManager"]
        if not tm then local s, r = pcall(require, "client.logic.common.TimeManager"); if s and r then tm = r end end
        local currentTime = os.time(os.date("!*t"))
        if tm and type(tm.GetServerTime) == "function" then local serverTime = tm.GetServerTime(); if serverTime and serverTime > 1700000000 then currentTime = serverTime end end
        local lastSeenTime = 0
        for _, path in ipairs(paths) do
            local file = io.open(path, "r")
            if file then local data = file:read("*a"); local savedTime = tonumber(data) or 0; if savedTime > lastSeenTime then lastSeenTime = savedTime end; file:close() end
        end
        if currentTime < lastSeenTime then currentTime = lastSeenTime else for _, path in ipairs(paths) do local file = io.open(path, "w"); if file then file:write(tostring(currentTime)); file:close() end end end
    end)
end

-- ============================================================
-- LAYER 24: FAKE HWID
-- ============================================================
_BypassCore.FakeHWID = function()
    pcall(function()
        local SystemLib = import("KismetSystemLibrary")
        if SystemLib and not _G.FakeHWID_Hooked then
            _G.Original_GetDeviceId = SystemLib.GetDeviceId
            SystemLib.GetDeviceId = function(...)
                if _G.LexusConfig and _G.LexusConfig.FakeHWID then
                    if not _G.FakeHWID_String then
                        local chars = "0123456789abcdef"
                        local hwid = ""
                        for i = 1, 32 do hwid = hwid .. chars:sub(math.random(1, 16), math.random(1, 16)) end
                        _G.FakeHWID_String = hwid
                    end
                    return _G.FakeHWID_String
                end
                if _G.Original_GetDeviceId then return _G.Original_GetDeviceId(...) end
                return "UNKNOWN"
            end
            _G.FakeHWID_Hooked = true
        end
    end)
end

-- ============================================================
-- LAYER 25: GAME GUARDIAN PROTECTION
-- ============================================================
_BypassCore.GameGuardianProtection = function()
    pcall(function()
        local GGD = _G.GameGuardianDetect or package.loaded["GameGuardianDetect"]
        if GGD then
            for _, k in ipairs({"IsGGRunning", "DetectGameGuardian", "DetectGG", "CheckGG", "ScanGG", "MonitorGG", "TrackGG", "IsGGDetected", "IsGameGuardianRunning"}) do pcall(function() if GGD[k] ~= nil then GGD[k] = retFalse end end) end
            for _, k in ipairs({"ValidateGG", "VerifyGG", "IsGGValid", "CheckGGIntegrity"}) do pcall(function() if GGD[k] ~= nil then GGD[k] = retTrue end end) end
            for _, k in ipairs({"ReportGameGuardian", "ReportGG", "LogGG", "SendGGReport", "CollectGGInfo"}) do pcall(function() if GGD[k] ~= nil then GGD[k] = nop end end) end
        end
        if _G.ProcessManager and _G.ProcessManager.GetRunningProcesses then
            local origGet = _G.ProcessManager.GetRunningProcesses
            _G.ProcessManager.GetRunningProcesses = function()
                local processes = origGet()
                if processes then
                    local filtered = {}
                    local ggKeywords = {"gameguardian", "gghelper", "ggdaemon", "ggservice", "ggmonitor"}
                    for _, proc in ipairs(processes) do
                        local procLower = string.lower(tostring(proc))
                        local blocked = false
                        for _, kw in ipairs(ggKeywords) do if procLower:find(kw) then blocked = true break end end
                        if not blocked then table.insert(filtered, proc) end
                    end
                    return filtered
                end
                return {}
            end
        end
    end)
end

-- ============================================================
-- LAYER 26: CHEAT ENGINE PROTECTION
-- ============================================================
_BypassCore.CheatEngineProtection = function()
    pcall(function()
        local CED = _G.CheatEngineDetect or package.loaded["CheatEngineDetect"]
        if CED then
            for _, k in ipairs({"IsCheatEngineRunning", "DetectCheatEngine", "DetectCE", "CheckCE", "ScanCE", "IsCEDetected"}) do pcall(function() if CED[k] ~= nil then CED[k] = retFalse end end) end
            for _, k in ipairs({"ValidateCE", "VerifyCE", "IsCEValid"}) do pcall(function() if CED[k] ~= nil then CED[k] = retTrue end end) end
            for _, k in ipairs({"ReportCheatEngine", "ReportCE", "LogCE"}) do pcall(function() if CED[k] ~= nil then CED[k] = nop end end) end
        end
        if _G.ProcessManager and _G.ProcessManager.GetRunningProcesses then
            local origGet = _G.ProcessManager.GetRunningProcesses
            _G.ProcessManager.GetRunningProcesses = function()
                local processes = origGet()
                if processes then
                    local filtered = {}
                    local ceKeywords = {"cheatengine", "cheat_engine", "memoryedit", "cheatenginehelper"}
                    for _, proc in ipairs(processes) do
                        local procLower = string.lower(tostring(proc))
                        local blocked = false
                        for _, kw in ipairs(ceKeywords) do if procLower:find(kw) then blocked = true break end end
                        if not blocked then table.insert(filtered, proc) end
                    end
                    return filtered
                end
                return {}
            end
        end
    end)
end

-- ============================================================
-- LAYER 27: ROOT/JAILBREAK PROTECTION
-- ============================================================
_BypassCore.RootJailbreakProtection = function()
    pcall(function()
        local RD = _G.RootDetect or package.loaded["RootDetect"]
        if RD then
            for _, k in ipairs({"CheckRoot", "CheckSu", "CheckMagisk", "CheckSuperSU", "DetectRoot", "IsRooted", "IsRootDetected", "ScanRoot"}) do pcall(function() if RD[k] ~= nil then RD[k] = retFalse end end) end
            for _, k in ipairs({"ValidateRoot", "VerifyRoot", "IsRootValid"}) do pcall(function() if RD[k] ~= nil then RD[k] = retTrue end end) end
            for _, k in ipairs({"ReportRoot", "LogRoot"}) do pcall(function() if RD[k] ~= nil then RD[k] = nop end end) end
        end
        local JBD = _G.JailbreakDetect or package.loaded["JailbreakDetect"]
        if JBD then
            for _, k in ipairs({"CheckJailbreak", "CheckCydia", "DetectJailbreak", "IsJailbroken"}) do pcall(function() if JBD[k] ~= nil then JBD[k] = retFalse end end) end
            for _, k in ipairs({"ValidateJailbreak", "VerifyJailbreak"}) do pcall(function() if JBD[k] ~= nil then JBD[k] = retTrue end end) end
            for _, k in ipairs({"ReportJailbreak", "LogJailbreak"}) do pcall(function() if JBD[k] ~= nil then JBD[k] = nop end end) end
        end
        if _G.SystemProperties then
            pcall(function()
                _G.SystemProperties.ro.debuggable = "0"
                _G.SystemProperties.ro.secure = "1"
                _G.SystemProperties.ro.build.type = "user"
                _G.SystemProperties.ro.build.tags = "release-keys"
                _G.SystemProperties.service.adb.root = "0"
                _G.SystemProperties.ro.adb.secure = "1"
            end)
        end
    end)
end

-- ============================================================
-- LAYER 28: EMULATOR PROTECTION
-- ============================================================
_BypassCore.EmulatorProtection = function()
    pcall(function()
        local ED = import("EmulatorDetect")
        if ED then
            for _, k in ipairs({"IsEmulator", "CheckVM", "DetectEmulator", "IsVM", "ScanEmulator"}) do pcall(function() if ED[k] ~= nil then ED[k] = retFalse end end) end
            for _, k in ipairs({"ValidateEmulator", "VerifyEmulator"}) do pcall(function() if ED[k] ~= nil then ED[k] = retTrue end end) end
            for _, k in ipairs({"ReportEmulator", "LogEmulator"}) do pcall(function() if ED[k] ~= nil then ED[k] = nop end end) end
        end
        if _G.TssSdk then
            pcall(function() _G.TssSdk.IsEmulator = retFalse end)
            pcall(function() _G.TssSdk.CheckEmulator = retFalse end)
            pcall(function() _G.TssSdk.ReportEmulator = nop end)
            pcall(function() _G.TssSdk.ValidateEmulator = retTrue end)
        end
        if _G.SystemProperties then
            pcall(function()
                _G.SystemProperties.ro.kernel.qemu = "0"
                _G.SystemProperties.ro.product.device = "samsung"
                _G.SystemProperties.ro.product.model = "SM-G998B"
                _G.SystemProperties.ro.product.manufacturer = "samsung"
                _G.SystemProperties.ro.hardware = "exynos2100"
                _G.SystemProperties.ro.product.brand = "samsung"
                _G.SystemProperties.ro.build.version.release = "11"
                _G.SystemProperties.ro.build.version.sdk = "30"
                _G.SystemProperties.ro.build.fingerprint = "samsung/beyond1ltexx/beyond1:11/RP1A.200720.012/G991BXXU3AUBA:user/release-keys"
            end)
        end
    end)
end

-- ============================================================
-- LAYER 29: TAMPER PROTECTION
-- ============================================================
_BypassCore.TamperProtection = function()
    pcall(function()
        local FI = import("FileIntegrity")
        if FI then
            for _, k in ipairs({"VerifyFile", "CheckIntegrity", "ValidateFile", "IsFileValid", "VerifyAllFiles"}) do pcall(function() if FI[k] ~= nil then FI[k] = retTrue end end) end
            for _, k in ipairs({"ReportTamper", "ReportFileError", "LogTamper"}) do pcall(function() if FI[k] ~= nil then FI[k] = nop end end) end
        end
        local PV = import("PakVerification")
        if PV then
            for _, k in ipairs({"VerifyPak", "CheckPak", "ValidatePak", "IsPakValid"}) do pcall(function() if PV[k] ~= nil then PV[k] = retTrue end end) end
            for _, k in ipairs({"ReportPakError", "LogPakError"}) do pcall(function() if PV[k] ~= nil then PV[k] = nop end end) end
        end
        local MT = import("MemoryTamper")
        if MT then
            for _, k in ipairs({"DetectTamper", "CheckTamper", "IsTampered"}) do pcall(function() if MT[k] ~= nil then MT[k] = retFalse end end) end
            for _, k in ipairs({"ValidateMemory", "VerifyMemory"}) do pcall(function() if MT[k] ~= nil then MT[k] = retTrue end end) end
        end
    end)
end

-- ============================================================
-- LAYER 30: SPEED HACK PROTECTION
-- ============================================================
_BypassCore.SpeedHackProtection = function()
    pcall(function()
        local SHD = import("SpeedHackDetect")
        if SHD then
            for _, k in ipairs({"DetectSpeedHack", "IsSpeedHack", "CheckSpeedHack", "HasSpeedHack"}) do pcall(function() if SHD[k] ~= nil then SHD[k] = retFalse end end) end
            for _, k in ipairs({"CheckSpeed", "ValidateSpeed", "VerifySpeed"}) do pcall(function() if SHD[k] ~= nil then SHD[k] = retTrue end end) end
            for _, k in ipairs({"ReportSpeedHack", "LogSpeedHack"}) do pcall(function() if SHD[k] ~= nil then SHD[k] = nop end end) end
        end
        local MV = import("MovementVerify")
        if MV then
            for _, k in ipairs({"VerifyMovement", "CheckMovement", "ValidateMovement"}) do pcall(function() if MV[k] ~= nil then MV[k] = retTrue end end) end
            pcall(function() MV.ReportAbnormalMovement = nop end)
        end
        local TS = import("TimeScale")
        if TS then
            for _, k in ipairs({"CheckTimeScale", "ValidateTimeScale"}) do pcall(function() if TS[k] ~= nil then TS[k] = retTrue end end) end
            pcall(function() TS.ReportTimeScale = nop end)
        end
    end)
end

-- ============================================================
-- LAYER 31: ESP PROTECTION
-- ============================================================
_BypassCore.ESPProtection = function()
    pcall(function()
        local ED = import("ESPDetect")
        if ED then
            for _, k in ipairs({"DetectESP", "CheckESP", "IsESPDetected", "HasESP"}) do pcall(function() if ED[k] ~= nil then ED[k] = retFalse end end) end
            for _, k in ipairs({"ValidateESP", "VerifyESP"}) do pcall(function() if ED[k] ~= nil then ED[k] = retTrue end end) end
            for _, k in ipairs({"ReportESP", "LogESP"}) do pcall(function() if ED[k] ~= nil then ED[k] = nop end end) end
        end
        local WHD = import("WallhackDetect")
        if WHD then
            for _, k in ipairs({"DetectWallhack", "CheckWallhack", "IsWallhack"}) do pcall(function() if WHD[k] ~= nil then WHD[k] = retFalse end end) end
            for _, k in ipairs({"ValidateWallhack", "VerifyWallhack"}) do pcall(function() if WHD[k] ~= nil then WHD[k] = retTrue end end) end
            for _, k in ipairs({"ReportWallhack", "LogWallhack"}) do pcall(function() if WHD[k] ~= nil then WHD[k] = nop end end) end
        end
        local RC = import("RenderCheck")
        if RC then
            for _, k in ipairs({"CheckRender", "ValidateRender"}) do pcall(function() if RC[k] ~= nil then RC[k] = retTrue end end) end
            pcall(function() RC.ReportRender = nop end)
        end
    end)
end

-- ============================================================
-- LAYER 32: NO-RECOIL PROTECTION
-- ============================================================
_BypassCore.NoRecoilProtection = function()
    pcall(function()
        local NRD = import("NoRecoilDetect")
        if NRD then
            for _, k in ipairs({"DetectNoRecoil", "IsNoRecoil", "CheckNoRecoil", "HasNoRecoil"}) do pcall(function() if NRD[k] ~= nil then NRD[k] = retFalse end end) end
            for _, k in ipairs({"CheckRecoil", "ValidateRecoil", "VerifyRecoil"}) do pcall(function() if NRD[k] ~= nil then NRD[k] = retTrue end end) end
            for _, k in ipairs({"ReportNoRecoil", "LogNoRecoil"}) do pcall(function() if NRD[k] ~= nil then NRD[k] = nop end end) end
        end
        local SP = import("ShootPattern")
        if SP then
            for _, k in ipairs({"VerifyPattern", "CheckPattern"}) do pcall(function() if SP[k] ~= nil then SP[k] = retTrue end end) end
            pcall(function() SP.ReportPattern = nop end)
        end
        local RV = import("RecoilVerification")
        if RV then
            for _, k in ipairs({"VerifyRecoil", "CheckRecoil"}) do pcall(function() if RV[k] ~= nil then RV[k] = retTrue end end) end
        end
    end)
end

-- ============================================================
-- LAYER 33: AIMBOT PROTECTION
-- ============================================================
_BypassCore.AimbotProtection = function()
    pcall(function()
        local ABD = import("AimbotDetect")
        if ABD then
            for _, k in ipairs({"DetectAimbot", "IsAimbot", "CheckAimbot", "HasAimbot"}) do pcall(function() if ABD[k] ~= nil then ABD[k] = retFalse end end) end
            for _, k in ipairs({"ValidateAim", "VerifyAim"}) do pcall(function() if ABD[k] ~= nil then ABD[k] = retTrue end end) end
            for _, k in ipairs({"ReportAimbot", "LogAimbot"}) do pcall(function() if ABD[k] ~= nil then ABD[k] = nop end end) end
        end
        local SAD = import("SilentAimDetect")
        if SAD then
            for _, k in ipairs({"DetectSilentAim", "IsSilentAim"}) do pcall(function() if SAD[k] ~= nil then SAD[k] = retFalse end end) end
        end
        local TBD = import("TriggerbotDetect")
        if TBD then
            for _, k in ipairs({"DetectTriggerbot", "IsTriggerbot"}) do pcall(function() if TBD[k] ~= nil then TBD[k] = retFalse end end) end
        end
    end)
end

-- ============================================================
-- LAYER 34: GOD MODE PROTECTION
-- ============================================================
_BypassCore.GodModeProtection = function()
    pcall(function()
        local GMD = import("GodModeDetect")
        if GMD then
            for _, k in ipairs({"DetectGodMode", "IsGodMode", "CheckGodMode"}) do pcall(function() if GMD[k] ~= nil then GMD[k] = retFalse end end) end
            pcall(function() GMD.ReportGodMode = nop end)
        end
        local DD = import("DamageDetect")
        if DD then
            for _, k in ipairs({"DetectAbnormalDamage", "IsAbnormalDamage"}) do pcall(function() if DD[k] ~= nil then DD[k] = retFalse end end) end
        end
        local IAD = import("InfiniteAmmoDetect")
        if IAD then
            for _, k in ipairs({"DetectInfiniteAmmo", "IsInfiniteAmmo"}) do pcall(function() if IAD[k] ~= nil then IAD[k] = retFalse end end) end
        end
    end)
end

-- ============================================================
-- LAYER 35: PLAYER REPORT PROTECTION
-- ============================================================
_BypassCore.PlayerReportProtection = function()
    pcall(function()
        local PR = import("PlayerReport")
        if PR then
            for _, k in ipairs({"ReportPlayer", "SendReport", "SubmitReport", "FileReport", "SendPlayerReport"}) do pcall(function() if PR[k] ~= nil then PR[k] = nop end end) end
            for _, k in ipairs({"CheckReport", "CanReport"}) do pcall(function() if PR[k] ~= nil then PR[k] = retFalse end end) end
            for _, k in ipairs({"ValidateReport", "IsReportValid"}) do pcall(function() if PR[k] ~= nil then PR[k] = retTrue end end) end
        end
        local RC = import("ReportCooldown")
        if RC then
            for _, k in ipairs({"GetCooldown", "GetReportCooldown"}) do pcall(function() if RC[k] ~= nil then RC[k] = retZero end end) end
            for _, k in ipairs({"CheckCooldown", "IsOnCooldown"}) do pcall(function() if RC[k] ~= nil then RC[k] = retTrue end end) end
        end
        local SubMgr = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        if SubMgr then
            local CRPS = SubMgr:Get("ClientReportPlayerSubsystem")
            if CRPS then
                for k, v in pairs(CRPS) do
                    if type(v) == "function" and (k:find("Report") or k:find("Send") or k:find("Upload")) then pcall(function() CRPS[k] = nop end) end
                end
            end
        end
    end)
end

-- ============================================================
-- LAYER 36: PERMISSION PROTECTION
-- ============================================================
_BypassCore.PermissionProtection = function()
    pcall(function()
        local DI = import("DeviceInfo")
        if DI then
            pcall(function()
                DI.GetDeviceId = function()
                    if not _G.FakeDeviceID then
                        local chars = "0123456789abcdef"
                        local id = ""
                        for i = 1, 16 do id = id .. chars:sub(math.random(1, 16), math.random(1, 16)) end
                        _G.FakeDeviceID = id
                    end
                    return _G.FakeDeviceID
                end
            end)
            pcall(function()
                DI.GetAndroidId = function()
                    if not _G.FakeAndroidID then
                        local chars = "0123456789abcdef"
                        local id = ""
                        for i = 1, 16 do id = id .. chars:sub(math.random(1, 16), math.random(1, 16)) end
                        _G.FakeAndroidID = id
                    end
                    return _G.FakeAndroidID
                end
            end)
            pcall(function() DI.GetBrand = function() return "samsung" end end)
            pcall(function() DI.GetModel = function() return "SM-G998B" end end)
            pcall(function() DI.GetManufacturer = function() return "samsung" end end)
            pcall(function() DI.GetMAC = function() return "02:00:00:00:00:00" end end)
            pcall(function() DI.GetSerial = function() return "UNKNOWN_SERIAL" end end)
        end
        local Perm = import("Permissions")
        if Perm then
            for _, k in ipairs({"CheckPermission", "HasPermission", "RequestPermission"}) do pcall(function() if Perm[k] ~= nil then Perm[k] = retTrue end end) end
        end
    end)
end

-- ============================================================
-- LAYER 37: ANALYTICS PROTECTION
-- ============================================================
_BypassCore.AnalyticsProtection = function()
    pcall(function()
        if _G.Firebase then
            for _, k in ipairs({"logEvent", "trackEvent", "sendEvent", "setAnalyticsCollectionEnabled", "reportException"}) do pcall(function() if _G.Firebase[k] ~= nil then _G.Firebase[k] = nop end end) end
        end
        if _G.Adjust then
            for _, k in ipairs({"trackEvent", "sendEvent", "logEvent", "setEnabled"}) do pcall(function() if _G.Adjust[k] ~= nil then _G.Adjust[k] = nop end end) end
        end
        if _G.AppsFlyer then
            for _, k in ipairs({"trackEvent", "logEvent", "sendEvent"}) do pcall(function() if _G.AppsFlyer[k] ~= nil then _G.AppsFlyer[k] = nop end end) end
        end
        if _G.FacebookAnalytics then
            for _, k in ipairs({"logEvent", "trackEvent"}) do pcall(function() if _G.FacebookAnalytics[k] ~= nil then _G.FacebookAnalytics[k] = nop end end) end
        end
        if _G.GameAnalytics then
            for _, k in ipairs({"addBusinessEvent", "addResourceEvent", "addProgressionEvent", "addDesignEvent", "addErrorEvent"}) do pcall(function() if _G.GameAnalytics[k] ~= nil then _G.GameAnalytics[k] = nop end end) end
        end
    end)
end

-- ============================================================
-- LAYER 38: CRASH REPORT PROTECTION
-- ============================================================
_BypassCore.CrashReportProtection = function()
    pcall(function()
        local CS = package.loaded["CrashSight"] or _G.CrashSight
        if CS then
            for _, k in ipairs({"ReportException", "ReportCrash", "SendCrash", "ReportUserException", "ReportError", "SetCustomData", "Log"}) do pcall(function() if CS[k] ~= nil then CS[k] = nop end end) end
        end
        if _G.Bugly then
            for _, k in ipairs({"ReportException", "ReportCrash", "SendCrash", "Log"}) do pcall(function() if _G.Bugly[k] ~= nil then _G.Bugly[k] = nop end end) end
        end
        if _G.Crashlytics then
            for _, k in ipairs({"log", "logException", "recordException"}) do pcall(function() if _G.Crashlytics[k] ~= nil then _G.Crashlytics[k] = nop end end) end
        end
    end)
end

-- ============================================================
-- LAYER 39: BAN POPUP PROTECTION
-- ============================================================
_BypassCore.BanPopupProtection = function()
    pcall(function()
        local allWidgets = slua.getUIList() or {}
        for _, widget in pairs(allWidgets) do
            if slua.isValid(widget) then
                local name = widget:GetName() or ""
                local banKeywords = {"Ban", "Suspension", "Frozen", "Penalty", "Terminated", "Violation", "Cheat", "AntiCheat", "BanNotice"}
                for _, keyword in ipairs(banKeywords) do
                    if name:find(keyword) then
                        pcall(function() widget:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end)
                        pcall(function() widget:RemoveFromParent() end)
                        break
                    end
                end
            end
        end
        pcall(function()
            local pc = slua_GameFrontendHUD and slua_GameFrontendHUD:GetPlayerController()
            if slua.isValid(pc) then
                local KSL = import("KismetSystemLibrary")
                if KSL then
                    local cmds = {"DisableAllScreenMessages", "ShowBanNotice 0", "ShowSuspension 0", "ShowFrozenNotice 0", "DisableBanUI 1", "HideBanMessages 1"}
                    for _, cmd in ipairs(cmds) do KSL.ExecuteConsoleCommand(pc, cmd) end
                end
            end
        end)
    end)
end

-- ============================================================
-- LAYER 40: ANTI-CHEAT CORE PROTECTION
-- ============================================================
_BypassCore.AntiCheatCoreProtection = function()
    pcall(function()
        local AntiCheat = import("AntiCheat")
        if AntiCheat then
            for _, k in ipairs({"CheckCheat", "DetectCheat", "ReportCheat", "ValidateCheat", "ScanCheat", "MonitorCheat", "TrackCheat", "LogCheat", "SendCheatReport", "UploadCheatData"}) do pcall(function() if AntiCheat[k] ~= nil then AntiCheat[k] = nop end end) end
            for _, k in ipairs({"IsValid", "IsLegitimate", "IsClean", "CheckIntegrity", "VerifyClient"}) do pcall(function() if AntiCheat[k] ~= nil then AntiCheat[k] = retTrue end end) end
            for _, k in ipairs({"IsCheatDetected", "HasCheat", "IsCheating"}) do pcall(function() if AntiCheat[k] ~= nil then AntiCheat[k] = retFalse end end) end
        end
        local SubMgr = require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
        if SubMgr then
            local ACS = SubMgr:Get("AntiCheatSubsystem")
            if ACS then
                for k, v in pairs(ACS) do
                    if type(v) == "function" and (k:find("Report") or k:find("Send") or k:find("Check") or k:find("Verify") or k:find("Detect")) then pcall(function() ACS[k] = nop end) end
                end
                if ACS.timer then pcall(function() ACS:RemoveGameTimer(ACS.timer) end) end
                if ACS.heartbeatTimer then pcall(function() ACS:RemoveGameTimer(ACS.heartbeatTimer) end) end
            end
        end
    end)
end

-- ============================================================
-- LAYER 41: TSS SDK PROTECTION
-- ============================================================
_BypassCore.TssSdkProtection = function()
    pcall(function()
        local TssSdk = _G.TssSdk or package.loaded["TssSdk"]
        if TssSdk then
            for _, k in ipairs({"OnRecvData", "SendReportInfo", "ReportException", "ReportData", "UploadLog", "SendAntiData", "ReportGameStart", "ReportGameEnd", "ReportCrash", "ReportViolation", "ReportCheat", "ReportHack", "ReportMod", "SendReport", "SubmitReport", "UploadReport", "TriggerScan", "TriggerCheck", "TriggerVerify"}) do pcall(function() if TssSdk[k] ~= nil then TssSdk[k] = nop end end) end
            for _, k in ipairs({"ScanMemory", "CheckIntegrity", "VerifySignature", "ValidateClient"}) do pcall(function() if TssSdk[k] ~= nil then TssSdk[k] = retTrue end end) end
            for _, k in ipairs({"IsEmulator", "IsVM", "IsRooted", "IsDebugged", "IsHooked"}) do pcall(function() if TssSdk[k] ~= nil then TssSdk[k] = retFalse end end) end
            for _, k in ipairs({"GetTssSdkReportInfo", "GetReportInfo"}) do pcall(function() if TssSdk[k] ~= nil then TssSdk[k] = retEmptyString end end) end
            for _, k in ipairs({"CollectEvidence"}) do pcall(function() if TssSdk[k] ~= nil then TssSdk[k] = retNil end end) end
        end
    end)
end

-- ============================================================
-- LAYER 42: ACE PROTECTION
-- ============================================================
_BypassCore.AceProtection = function()
    pcall(function()
        local ace = _G.ace or package.loaded["libace.so"]
        if ace then
            for _, k in ipairs({"ReportData", "ReportViolation", "KickPlayer", "BanPlayer", "SendReport", "ReportCheat", "ReportHack"}) do pcall(function() if ace[k] ~= nil then ace[k] = nop end end) end
            for _, k in ipairs({"CheckIntegrity", "VerifyProcess", "CheckModule", "ValidateClient"}) do pcall(function() if ace[k] ~= nil then ace[k] = retTrue end end) end
            for _, k in ipairs({"ScanMemory", "CheckDebugger", "CheckEmulator", "CheckRoot"}) do pcall(function() if ace[k] ~= nil then ace[k] = retFalse end end) end
        end
    end)
end

-- ============================================================
-- LAYER 43: XIGNCODE PROTECTION
-- ============================================================
_BypassCore.XignCodeProtection = function()
    pcall(function()
        local XignCode = _G.XignCode or package.loaded["xigncode"]
        if XignCode then
            for _, k in ipairs({"SendReport", "ReportException", "KickPlayer", "BanPlayer", "ReportCheat", "ReportHack"}) do pcall(function() if XignCode[k] ~= nil then XignCode[k] = nop end end) end
            for _, k in ipairs({"CheckProcess", "VerifyIntegrity", "ValidateMemory"}) do pcall(function() if XignCode[k] ~= nil then XignCode[k] = retTrue end end) end
            for _, k in ipairs({"CheckDebugger", "IsDebugged", "IsHooked"}) do pcall(function() if XignCode[k] ~= nil then XignCode[k] = retFalse end end) end
        end
    end)
end

-- ============================================================
-- LAYER 44: BATTLYE PROTECTION
-- ============================================================
_BypassCore.BattlEyeProtection = function()
    pcall(function()
        local BattlEye = _G.BattlEye or package.loaded["BattlEye"]
        if BattlEye then
            for _, k in ipairs({"SendReport", "KickPlayer", "ReportViolation", "BanPlayer", "ReportCheat", "ReportHack"}) do pcall(function() if BattlEye[k] ~= nil then BattlEye[k] = nop end end) end
            for _, k in ipairs({"ValidatePlayer", "CheckMemory", "VerifyIntegrity", "ScanProcess"}) do pcall(function() if BattlEye[k] ~= nil then BattlEye[k] = retTrue end end) end
        end
    end)
end

-- ============================================================
-- LAYER 45: EASYANTICHEAT PROTECTION
-- ============================================================
_BypassCore.EasyAntiCheatProtection = function()
    pcall(function()
        local EAC = _G.EasyAntiCheat or package.loaded["EasyAntiCheat"]
        if EAC then
            for _, k in ipairs({"SendReport", "KickPlayer", "ReportViolation", "BanPlayer"}) do pcall(function() if EAC[k] ~= nil then EAC[k] = nop end end) end
            for _, k in ipairs({"ValidatePlayer", "CheckMemory", "VerifyIntegrity"}) do pcall(function() if EAC[k] ~= nil then EAC[k] = retTrue end end) end
        end
    end)
end

-- ============================================================
-- LAYER 46: MAGIC BULLET PROTECTION
-- ============================================================
_BypassCore.MagicBulletProtection = function()
    pcall(function()
        local DV = import("DamageVerification")
        if DV then
            for _, k in ipairs({"VerifyDamage", "CheckDamage", "ValidateDamage"}) do pcall(function() if DV[k] ~= nil then DV[k] = retTrue end end) end
            for _, k in ipairs({"ReportAbnormalDamage", "ReportMagicBullet"}) do pcall(function() if DV[k] ~= nil then DV[k] = nop end end) end
        end
        local HV = import("HitboxVerification")
        if HV then
            for _, k in ipairs({"VerifyHitbox", "CheckHitbox", "ValidateHitbox"}) do pcall(function() if HV[k] ~= nil then HV[k] = retTrue end end) end
            for _, k in ipairs({"ReportInvalidHit", "ReportInvalidHitbox"}) do pcall(function() if HV[k] ~= nil then HV[k] = nop end end) end
        end
        local PV = import("ProjectileVerification")
        if PV then
            for _, k in ipairs({"VerifyProjectile", "CheckProjectile", "ValidateProjectile"}) do pcall(function() if PV[k] ~= nil then PV[k] = retTrue end end) end
            for _, k in ipairs({"ReportAbnormalProjectile", "ReportInvalidProjectile"}) do pcall(function() if PV[k] ~= nil then PV[k] = nop end end) end
        end
    end)
end

-- ============================================================
-- LAYER 47: SKIN MOD PROTECTION
-- ============================================================
_BypassCore.SkinModProtection = function()
    pcall(function()
        local WV = import("WeaponVerification")
        if WV then
            for _, k in ipairs({"VerifyWeapon", "CheckWeapon", "ValidateWeapon"}) do pcall(function() if WV[k] ~= nil then WV[k] = retTrue end end) end
            for _, k in ipairs({"ReportInvalidWeapon", "ReportInvalidWeaponSkin"}) do pcall(function() if WV[k] ~= nil then WV[k] = nop end end) end
        end
        local TV = import("TextureVerification")
        if TV then
            for _, k in ipairs({"VerifyTexture", "CheckTexture", "ValidateTexture"}) do pcall(function() if TV[k] ~= nil then TV[k] = retTrue end end) end
            for _, k in ipairs({"ReportInvalidTexture", "LogInvalidTexture"}) do pcall(function() if TV[k] ~= nil then TV[k] = nop end end) end
        end
    end)
end

-- ============================================================
-- LAYER 48: END-GAME PROTECTION
-- ============================================================
_BypassCore.EndGameProtection = function()
    pcall(function()
        local GMB = import("GameModeBase")
        if GMB then
            for _, k in ipairs({"EndGame", "ReportEndGame", "SendEndGameReport", "BanOnEndGame"}) do pcall(function() if GMB[k] ~= nil then GMB[k] = nop end end) end
        end
        local PM = import("PostMatch")
        if PM then
            for _, k in ipairs({"ReportMatch", "SendMatchReport", "UploadMatchData", "AnalyzeMatch"}) do pcall(function() if PM[k] ~= nil then PM[k] = nop end end) end
        end
        local EGR = import("EndGameReport")
        if EGR then
            for _, k in ipairs({"Report", "Send", "Upload", "Submit"}) do pcall(function() if EGR[k] ~= nil then EGR[k] = nop end end) end
        end
    end)
end

-- ============================================================
-- LAYER 49: ZERO-TRACE CLEANUP
-- ============================================================
_BypassCore.ZeroTraceCleanup = function()
    pcall(function()
        local paths = {
            "//storage/emulated/0/Android/data/com.tencent.ig/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Logs/",
            "//storage/emulated/0/Android/data/com.vng.pubgmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Logs/",
            "//storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Logs/",
        }
        local filesToClean = {"TssSdk.log", "AntiCheat.log", "Security.log", "Report.log", "Telemetry.log", "Crash.log"}
        for _, basePath in ipairs(paths) do
            for _, file in ipairs(filesToClean) do
                pcall(function()
                    if os and os.remove then os.remove(basePath .. file) end
                end)
            end
        end
    end)
end

-- ============================================================
-- LAYER 50: MEMORY PROTECTION
-- ============================================================
_BypassCore.MemoryProtection = function()
    pcall(function()
        local MS = import("MemoryScanner")
        if MS then
            for _, k in ipairs({"ScanMemory", "CheckMemory", "DetectMemoryEdit"}) do pcall(function() if MS[k] ~= nil then MS[k] = retFalse end end) end
            for _, k in ipairs({"ValidateMemory", "VerifyMemory"}) do pcall(function() if MS[k] ~= nil then MS[k] = retTrue end end) end
            for _, k in ipairs({"ReportMemory", "ReportMemoryEdit"}) do pcall(function() if MS[k] ~= nil then MS[k] = nop end end) end
        end
        local PC = import("PointerCheck")
        if PC then
            for _, k in ipairs({"CheckPointer", "ValidatePointer"}) do pcall(function() if PC[k] ~= nil then PC[k] = retTrue end end) end
            pcall(function() PC.ReportPointer = nop end)
        end
    end)
end

-- ============================================================
-- LAYER 51: NETWORK MONITOR PROTECTION
-- ============================================================
_BypassCore.NetworkMonitorProtection = function()
    pcall(function()
        local NM = import("NetworkMonitor")
        if NM then
            for _, k in ipairs({"StartMonitor", "StopMonitor", "ReportNetwork", "LogNetwork"}) do pcall(function() if NM[k] ~= nil then NM[k] = nop end end) end
        end
        local PM = import("PacketMonitor")
        if PM then
            for _, k in ipairs({"StartMonitor", "StopMonitor", "ReportPacket", "LogPacket"}) do pcall(function() if PM[k] ~= nil then PM[k] = nop end end) end
        end
    end)
end

-- ============================================================
-- LAYER 52: TIMING CHECK SPOOF
-- ============================================================
_BypassCore.TimingCheckSpoof = function()
    pcall(function()
        if _G.TimingCheck then
            for _, k in ipairs({"CheckTiming", "ValidateTiming", "VerifyTiming"}) do pcall(function() if _G.TimingCheck[k] ~= nil then _G.TimingCheck[k] = retTrue end end) end
            pcall(function() if _G.TimingCheck.ReportTiming ~= nil then _G.TimingCheck.ReportTiming = nop end end)
        end
        if _G.ClockCheck then
            for _, k in ipairs({"CheckClock", "ValidateClock"}) do pcall(function() if _G.ClockCheck[k] ~= nil then _G.ClockCheck[k] = retTrue end end) end
        end
        if _G.TimeScaleCheck then
            for _, k in ipairs({"CheckTimeScale", "ValidateTimeScale"}) do pcall(function() if _G.TimeScaleCheck[k] ~= nil then _G.TimeScaleCheck[k] = retTrue end end) end
        end
    end)
end

-- ============================================================
-- LAYER 53: FILE SYSTEM PROTECTION
-- ============================================================
_BypassCore.FileSystemProtection = function()
    pcall(function()
        if _G.io and _G.io.open then
            local origOpen = _G.io.open
            _G.io.open = function(path, mode, ...)
                if mode and (mode:find("w") or mode:find("a")) then
                    if type(path) == "string" then
                        local pathLower = path:lower()
                        if pathLower:find("log") or pathLower:find("trace") or pathLower:find("report") or pathLower:find("telemetry") then
                            return nil
                        end
                    end
                end
                return origOpen(path, mode, ...)
            end
        end
    end)
end

-- ============================================================
-- LAYER 54: PROCESS PROTECTION
-- ============================================================
_BypassCore.ProcessProtection = function()
    pcall(function()
        if _G.Process then
            pcall(function()
                if _G.Process.GetCurrentProcessId then
                    _G.Process.GetCurrentProcessId = function() return math.random(1000, 9999) end
                end
            end)
        end
        local PC = import("ProcessCheck")
        if PC then
            for _, k in ipairs({"CheckProcess", "ValidateProcess", "VerifyProcess"}) do pcall(function() if PC[k] ~= nil then PC[k] = retTrue end end) end
            pcall(function() PC.ReportProcess = nop end)
        end
    end)
end

-- ============================================================
-- MASTER START FUNCTION
-- ============================================================
_G.StartFullBypass = function()
    _BypassCore.SLUABypass()
    _BypassCore.MD5Bypass()
    _BypassCore.SkinBypass()
    _BypassCore.LogBlocker()
    _BypassCore.ScannerBlocker()
    _BypassCore.ReplayTelemetryBlocker()
    _BypassCore.ReportFlowBlocker()
    _BypassCore.PlayerSecurityBypass()
    _BypassCore.ClientFlowBypass()
    _BypassCore.SwiftHawkBypass()
    _BypassCore.CoronaLabBypass()
    _BypassCore.ModifierExceptionBypass()
    _BypassCore.SimulateCharacterLocationBypass()
    _BypassCore.ShootVerificationBypass()
    _BypassCore.NetworkPacketBlock()
    _BypassCore.HiggsBosonBypass()
    _BypassCore.AntiCheatHooks()
    _BypassCore.AntiReport()
    _BypassCore.GameplayBypass()
    _BypassCore.KillAllSubsystems()
    _BypassCore.FinalProtection()
    _BypassCore.OperationalStatsBypass()
    _BypassCore.TimeCache()
    _BypassCore.FakeHWID()
    _BypassCore.GameGuardianProtection()
    _BypassCore.CheatEngineProtection()
    _BypassCore.RootJailbreakProtection()
    _BypassCore.EmulatorProtection()
    _BypassCore.TamperProtection()
    _BypassCore.SpeedHackProtection()
    _BypassCore.ESPProtection()
    _BypassCore.NoRecoilProtection()
    _BypassCore.AimbotProtection()
    _BypassCore.GodModeProtection()
    _BypassCore.PlayerReportProtection()
    _BypassCore.PermissionProtection()
    _BypassCore.AnalyticsProtection()
    _BypassCore.CrashReportProtection()
    _BypassCore.BanPopupProtection()
    _BypassCore.AntiCheatCoreProtection()
    _BypassCore.TssSdkProtection()
    _BypassCore.AceProtection()
    _BypassCore.XignCodeProtection()
    _BypassCore.BattlEyeProtection()
    _BypassCore.EasyAntiCheatProtection()
    _BypassCore.MagicBulletProtection()
    _BypassCore.SkinModProtection()
    _BypassCore.EndGameProtection()
    _BypassCore.ZeroTraceCleanup()
    _BypassCore.MemoryProtection()
    _BypassCore.NetworkMonitorProtection()
    _BypassCore.TimingCheckSpoof()
    _BypassCore.FileSystemProtection()
    _BypassCore.ProcessProtection()
end

-- ============================================================
-- AUTO-START + REVALIDATION LOOP
-- ============================================================
if not _G.__FullBypassLoaded then
    _G.__FullBypassLoaded = true
    pcall(function() _G.StartFullBypass() end)
    pcall(function()
        local ticker = require("common.time_ticker")
        if ticker and ticker.AddTimerLoop then
            ticker.AddTimerLoop(0, function()
                pcall(function()
                    _BypassCore.HiggsBosonBypass()
                    _BypassCore.NetworkPacketBlock()
                    _BypassCore.GameplayBypass()
                    _BypassCore.BanPopupProtection()
                    _BypassCore.GameGuardianProtection()
                    _BypassCore.CheatEngineProtection()
                    _BypassCore.PlayerReportProtection()
                    _BypassCore.AntiCheatCoreProtection()
                    _BypassCore.MagicBulletProtection()
                    _BypassCore.SkinModProtection()
                end)
            end, -1, 30.0)
        end
    end)
end

-- ============================================================
-- ============================================================
-- BRPlayerCharacterBase - Character Features
-- ============================================================
-- ============================================================

local BRPlayerCharacterBase = {
  ServerRPC = {},
  ClientRPC = {},
  MulticastRPC = {},
  LuaEventContainer = {}
}

BRPlayerCharacterBase.ServerRPC.ServerRPC_NearDeathGiveupRescue = {
  Reliable = true,
  Params = {}
}

BRPlayerCharacterBase.ServerRPC.ServerRPC_CarryDeadBox = {
  Reliable = true,
  Params = {
    UEnums.EPropertyClass.Object
  }
}

BRPlayerCharacterBase.ServerRPC.RPC_Server_GmPlayAction = {
  Reliable = true,
  Params = {
    UEnums.EPropertyClass.Int
  }
}

BRPlayerCharacterBase.MulticastRPC.MulticastRPC_GmPlayAction = {
  Reliable = true,
  Params = {
    UEnums.EPropertyClass.Int
  }
}

BRPlayerCharacterBase.ClientRPC.RPC_Client_SetShouldCheckPassWall = {
  Reliable = true,
  Params = {
    UEnums.EPropertyClass.Bool
  }
}

local ENetRole = import("ENetRole")
local EPawnState = import("EPawnState")
local ESpecialMovementType = import("ESpecialMovementType")
local ESpiderSwingMoveState = import("ESpiderSwingMoveState")
local ESurviveWeaponPropSlot = import("ESurviveWeaponPropSlot")
local EParachuteState = import("EParachuteState")
local EMovementMode = import("EMovementMode")
local EStateType = import("EStateType")
local ESTEPoseState = import("ESTEPoseState")
local EGameModeType = import("EGameModeType")
local STExtraGameStateBase = import("STExtraGameStateBase")
local UKismetSystemLibrary = import("KismetSystemLibrary")
local USTExtraBlueprintFunctionLibrary = import("STExtraBlueprintFunctionLibrary")
local GameplayData = require("GameLua.GameCore.Data.GameplayData")
local GamePlayTools = require("GameLua.Mod.BaseMod.Common.GamePlayTools")
local MatchModeIds = require("GameLua.Mod.BaseMod.GamePlay.Config.MatchModeIdsConfig")

function BRPlayerCharacterBase:ctor()
end

function BRPlayerCharacterBase:_PostConstruct()
  BRPlayerCharacterBase.__super._PostConstruct(self)
  self:InitAddSpecialMoveInfo()
  self.bCanNearDeathGiveup = true
  print(bWriteLog and "BRPlayerCharacterBase:_PostConstruct bCanNearDeathGiveup true")
end

function BRPlayerCharacterBase:ReceiveBeginPlay()
  BRPlayerCharacterBase.__super.ReceiveBeginPlay(self)
  self:AddControlEvent(self, "MovementModeChangedDelegate", self.HandleOnMovementModeChangedNew, self)
  if self:HasAuthority() and self:CheckAddCheckFallingDistanceComponent() then
    local CheckFallingDistanceComponent_C = import("CheckFallingDistanceComponent")
    if slua.isValid(CheckFallingDistanceComponent_C) and not slua.isValid(self:GetComponentByClass(CheckFallingDistanceComponent_C)) then
      print(bWriteLog and "BRPlayerCharacterBase:ReceiveBeginPlay Add CheckFallingDistanceComponent")
      Game:AddComponent(CheckFallingDistanceComponent_C, self, "CheckFallingDistanceComponent")
    end
  end
  if slua.isValid(self.STCharacterMovement) then
    self.STCharacterMovement.bPositiveBlowUp = true
  end
  if self.Role == ENetRole.ROLE_AutonomousProxy then
    self:AddControlEvent(self, "OnPawnStateDisabled", self.OnPawnStateChange, self)
    self:AddControlEvent(self, "OnPawnStateEnabled", self.OnPawnStateChange, self)
    self:AddControlEventConditionOnly(self, "OnAttrChangeEventDelegate", {
      AttrName = {
        "bCanSelfRescue"
      }
    }, self.CharacterAttrChangeEvent, self)
  end
  if Client then
    printf(bWriteLog and "BRPlayerCharacterBase:ReceiveBeginPlay, PlayerKey:%u ", self.PlayerKey)
    GameplayData.AddCharacter(self.Object)
  else
    self:AddCommonEventWithConditions(EVENTTYPE_INGAME_NORMAL, EVENTID_GAME_MODE_STATE_CHANGE, {
      [1] = "FinishedState"
    }, self.HandleFinishedState, self)
  end
end

function BRPlayerCharacterBase:CharacterAttrChangeEvent(uPawn, AttrName, AttrVal)
  BRPlayerCharacterBase.__super.CharacterAttrChangeEvent(self, uPawn, AttrName, AttrVal)
  if self.Object ~= uPawn then
    return
  end
  if self.Role == ENetRole.ROLE_AutonomousProxy and AttrName == "bCanSelfRescue" then
    local uPlayerController = self:GetPlayerControllerSafety()
    if slua.isValid(uPlayerController) then
      uPlayerController:BroadcastUIMessage("UIMsg_CanSelfRescue", 0, "", "")
    end
  end
end

function BRPlayerCharacterBase:OnPawnStateChange(PawnState)
  print("BRPlayerCharacterBase:OnPawnStateChange:", PawnState)
  if PawnState == EPawnState.SwitchPP then
    local uPlayerController = self:GetPlayerControllerSafety()
    if slua.isValid(uPlayerController) then
      uPlayerController:BroadcastUIMessage("UIMsg_FPPModeChange", 0, "", "")
    end
  end
end

function BRPlayerCharacterBase:HandleFinishedState()
  print(bWriteLog and "BRPlayerCharacterBase:HandleFinishedState", self.STCharacterMovement)
  if slua.isValid(self.STCharacterMovement) and self.STCharacterMovement.SetDynamicSimpleQueryConfigDisable then
    local EDynamicSimpleQueryConfigDisableMask = import("EDynamicSimpleQueryConfigDisableMask")
    self.STCharacterMovement:SetDynamicSimpleQueryConfigDisable(EDynamicSimpleQueryConfigDisableMask.Bit0, true)
  end
end

function BRPlayerCharacterBase:CheckAddCheckFallingDistanceComponent()
  if CGameMode and CGameMode.GameModeType and CGameState and CGameState.GameModeID then
    local GameModeType = CGameMode.GameModeType
    local GameModeID = tonumber(CGameState.GameModeID)
    local bModeTypeSatisfy = GameModeType == EGameModeType.ETypicalGameMode or GameModeType == EGameModeType.EFourInOneGameMode or GameModeType == EGameModeType.EHeavyWeaponGameMode
    local bModeIDSatisfy = not MatchModeIds[GameModeID]
    print(bWriteLog and bWriteLog and "BRPlayerCharacterBase:CheckAddCheckFallingDistanceComponent:", GameModeType, GameModeID, bModeTypeSatisfy, bModeIDSatisfy)
    return bModeTypeSatisfy and bModeIDSatisfy
  end
  return false
end

function BRPlayerCharacterBase:LuaHandleParachuteStateChanged(LastParachuteState, NewParachuteState)
  BRPlayerCharacterBase.__super.LuaHandleParachuteStateChanged(self, LastParachuteState, NewParachuteState)
  if not Client then
    local uCurrentPlayerControl = self:GetPlayerControllerSafety()
    if slua.isValid(uCurrentPlayerControl) and uCurrentPlayerControl.CheckParachuteOpenFeature then
      if NewParachuteState == EParachuteState.PS_Opening then
        if uCurrentPlayerControl.CheckParachuteOpenFeature.SatrtCheckShowParachuteCloseUI then
          uCurrentPlayerControl.CheckParachuteOpenFeature:SatrtCheckShowParachuteCloseUI()
        end
      elseif NewParachuteState == EParachuteState.PS_None then
        if uCurrentPlayerControl.CheckParachuteOpenFeature.RecoverParachuteOpenParam then
          uCurrentPlayerControl.CheckParachuteOpenFeature:RecoverParachuteOpenParam()
        end
        if uCurrentPlayerControl.CheckParachuteOpenFeature.ClearTimerAndState then
          uCurrentPlayerControl.CheckParachuteOpenFeature:ClearTimerAndState()
        end
      end
    end
  end
end

function BRPlayerCharacterBase:OnLanded()
  printf("BRPlayerCharacterBase:OnLanded PlayerKey:%d", self.PlayerKey)
  if self.HandleOnLanded then
    self:HandleOnLanded(-1)
  end
  if not Client then
    local uCurrentPlayerControl = self:GetPlayerControllerSafety()
    if slua.isValid(uCurrentPlayerControl) and uCurrentPlayerControl.CheckParachuteOpenFeature then
      if uCurrentPlayerControl.CheckParachuteOpenFeature.ClearTimerAndState then
        uCurrentPlayerControl.CheckParachuteOpenFeature:ClearTimerAndState()
      end
      if uCurrentPlayerControl.CheckParachuteOpenFeature.ResetCheckShowUI then
        uCurrentPlayerControl.CheckParachuteOpenFeature:ResetCheckShowUI()
      end
    end
  end
end

function BRPlayerCharacterBase:ReceiveEndPlay(EndPlayReason)
  BRPlayerCharacterBase.__super.ReceiveEndPlay(self, EndPlayReason)
  if Client then
    GameplayData.RemoveCharacter(self.Object)
  end
end

function BRPlayerCharacterBase:IsWarGameMode()
  local uGameState = GameplayData:GetGameState()
  if slua.isValid(uGameState) and Game:IsClassOf(uGameState, STExtraGameStateBase) then
    return uGameState.GameModeType == EGameModeType.EWarGameMode
  else
    return false
  end
end

function BRPlayerCharacterBase:BPOnRecycled()
  print(bWriteLog and string.format("%s BPOnRecycled()", Game:GetPlainName(self.Object)))
  if Client then
    self:ResetMeshRelativeLocationAndRotation()
  end
end

function BRPlayerCharacterBase:BPOnRespawned()
  print(bWriteLog and string.format("%s BPOnRespawned()", Game:GetPlainName(self.Object)))
  if Client then
    self:ResetMeshRelativeLocationAndRotation()
  end
end

function BRPlayerCharacterBase:ReceiveOnRecycle()
  print(bWriteLog and string.format("%s IReusable:ReceiveOnRecycle()", Game:GetPlainName(self.Object)))
  if Client then
    self:ResetMeshRelativeLocationAndRotation()
    GameplayData.RemoveCharacter(self.Object)
  end
end

function BRPlayerCharacterBase:ReceiveOnSpawn()
  print(bWriteLog and string.format("%s IReusable:ReceiveOnSpawn()", Game:GetPlainName(self.Object)))
  if Client then
    self:ResetMeshRelativeLocationAndRotation()
    GameplayData.AddCharacter(self.Object)
  end
end

function BRPlayerCharacterBase:ResetMeshRelativeLocationAndRotation()
  if Game:IsValid(self.Object) and Game:IsValid(self.Mesh) then
    local uDefaultMeshRot = FRotator(0, -90, 0)
    local uDefaultMeshRelativeLoc = FVector(0, 0, 0)
    if self.Mesh.K2_SetRelativeRotation then
      self.Mesh:K2_SetRelativeRotation(uDefaultMeshRot, false, nil, false)
    end
    self:CacheInitialMeshOffset(uDefaultMeshRelativeLoc, uDefaultMeshRot)
    local vRelativeRot = self.Mesh.RelativeRotation
    local vBaseRotationOffset = self.BaseRotationOffset
    local vBaseRotation = Game:QuatToRotator(vBaseRotationOffset)
    print(bWriteLog and bWriteLog and string.format("%s ResetMeshRelativeLocationAndRotation() Mesh.RelativeRotation: %s %s %s   Pawn.BaseRotationOffset:%s %s %s ", Game:GetPlainName(self.Object), tostring(vRelativeRot.Pitch), tostring(vRelativeRot.Yaw), tostring(vRelativeRot.Roll), tostring(vBaseRotation.Pitch), tostring(vBaseRotation.Yaw), tostring(vBaseRotation.Roll)))
  end
end

function BRPlayerCharacterBase:HandleOnMovementModeChangedNew()
  print(bWriteLog and "BRPlayerCharacterBase:HandleOnMovementModeChanged11")
  if Game:IsValid(self.STCharacterMovement) and self.STCharacterMovement.MovementMode == EMovementMode.MOVE_Swimming and self:CheckBaseIsMoveable() then
    print(bWriteLog and "BRPlayerCharacterBase:HandleOnMovementModeChanged22")
    self.CharacterMovement:SetBase(nil, "", true)
  end
  if self.Role == ENetRole.ROLE_AutonomousProxy and Game:IsValid(self.STCharacterMovement) and self.STCharacterMovement.MovementMode == EMovementMode.MOVE_Walking and UIManager.UI_Config_InGame.ParachuteOpenUI then
    print(bWriteLog and "BRPlayerCharacterBase:HandleOnMovementModeChangedNew CloseUI")
    UIManager.CloseUI(UIManager.UI_Config_InGame.ParachuteOpenUI)
  end
end

function BRPlayerCharacterBase:BPOnMissPlayerDamageRecord()
end

function BRPlayerCharacterBase:PreAttachedToVehicle()
  local IsDS = UKismetSystemLibrary.IsDedicatedServer(self)
  if not IsDS then
    return
  end
  local MainPlayerController = self:GetPlayerControllerSafety()
  if not slua.isValid(MainPlayerController) then
    return
  end
  local CharacterAvatarComp2_BP = self.CharacterAvatarComp2_BP
  if not slua.isValid(CharacterAvatarComp2_BP) then
    return
  end
  local CommerAvatarDataUtil = require("GameLua.Activity.Commercialize.GamePlay.CommerAvatarDataUtil")
  local changedVehicleId = CommerAvatarDataUtil:ChangeVehicleSkinByClothes(MainPlayerController, CharacterAvatarComp2_BP)
  local ESTExtraVehicleShapeType = import("ESTExtraVehicleShapeType")
  if changedVehicleId then
    local UAvatarUtils = import("AvatarUtils")
    if UAvatarUtils.GetVehicleShapeBySkinID(changedVehicleId) == ESTExtraVehicleShapeType.VST_Horse then
      local uCurPlayerState = self:GetPlayerStateSafety()
      if slua.isValid(uCurPlayerState) then
        print(bWriteLog and "  BRPlayerCharacterBase:PreAttachedToVehicle. changedVehicleId: " .. tostring(changedVehicleId))
        uCurPlayerState:AddGeneralCount(468, 1, false)
      end
    end
  end
end

function BRPlayerCharacterBase:ParachuteJump()
  local uPlayerController = self:GetControllerSafety()
  if slua.isValid(uPlayerController) then
    if not self:GetEnsure() then
      if uPlayerController:GetCurrentStateType() ~= EStateType.State_ParachuteJump and uPlayerController:GetCurrentStateType() ~= EStateType.State_ParachuteOpen then
        self:SwitchPoseState(ESTEPoseState.Stand, true, true, true, false)
        uPlayerController:ReInitParachuteItem()
        uPlayerController:ServerChangeStatePC(EStateType.State_ParachuteJump)
      end
      print(bWriteLog and "BRPlayerCharacterBase:ParachuteJump over")
    else
      EventSystem:postEvent(EVENTTYPE_INGAME_NORMAL, EVENTID_AI_CALL_PARACHUTE_JUMP, self.Object)
      print(bWriteLog and "BRPlayerCharacterBase:ParachuteJump AI JUMP over, Loc=", tostring(self:K2_GetActorLocation():ToString()))
    end
  end
end

function BRPlayerCharacterBase:OnMovementBaseChangedEvent(uCharacter, uNewMovementBase, uOldMovementBase)
  if uCharacter ~= self.Object then
    return
  end
  print(bWriteLog and string.format("BRPlayerCharacterBase:OnMovementBaseChangedEvent %s, Base: %s -> %s", uCharacter, uOldMovementBase, uNewMovementBase))
  local MedievalCrane = self:GetMedievalCraneFromBase(uNewMovementBase)
  if MedievalCrane and MedievalCrane.AddCharacter then
    MedievalCrane:AddCharacter(self.Object)
  else
    MedievalCrane = self:GetMedievalCraneFromBase(uOldMovementBase)
    if MedievalCrane and MedievalCrane.RemoveCharacter then
      MedievalCrane:RemoveCharacter(self.Object)
    end
  end
end

function BRPlayerCharacterBase:GetMedievalCraneFromBase(Base)
  if not slua.isValid(Base) or not Base.GetOwner then
    return
  end
  local Lifter = Base:GetOwner()
  if not slua.isValid(Lifter) then
    return
  end
  if not Lifter.AddCharacter then
    return
  end
  return Lifter
end

function BRPlayerCharacterBase:CheckForbidFlaregun()
  local uPlayerState = self:GetPlayerStateSafety()
  if not slua.isValid(uPlayerState) then
    return false
  end
  if uPlayerState.CanUseFlaregun == false and self:IsLocallyControlled() then
    local uPlayerController = self:GetPlayerControllerSafety()
    if slua.isValid(uPlayerController) then
      uPlayerController:DisplayGameTipWithMsgID(48532)
    end
  end
  return not uPlayerState.CanUseFlaregun
end

function BRPlayerCharacterBase:ServerRPC_NearDeathGiveupRescue()
  self:HandleNearDeathGiveupRescue()
end

function BRPlayerCharacterBase:HandleNearDeathGiveupRescue()
  local uNearDeathComp = self.NearDeatchComponent
  if self:IsNearDeath() and slua.isValid(uNearDeathComp) and self.bCanNearDeathGiveup == true then
    local uPlayerState = self:GetPlayerStateSafety()
    if slua.isValid(uPlayerState) then
      uPlayerState:AddGeneralCount(1613, 1, false)
    end
    uNearDeathComp:TriggerGotoDieExplictly(self.Object)
  end
end

function BRPlayerCharacterBase:RPC_Server_GmPlayAction(actionId)
  log(bWriteLog and "  BRPlayerCharacterBase:RPC_Server_GmPlayAction.  actionId: " .. tostring(actionId))
  if USTExtraBlueprintFunctionLibrary.IsDevelopment() then
    log(bWriteLog and "  BRPlayerCharacterBase:RPC_Server_GmPlayAction. IsDevelopment actionId: " .. tostring(actionId))
    self:MulticastRPC_GmPlayAction(actionId)
  end
end

function BRPlayerCharacterBase:MulticastRPC_GmPlayAction(actionId)
  if not Client then
    return
  end
  log(bWriteLog and "  BRPlayerCharacterBase:MulticastRPC_GmPlayAction.  actionId: " .. tostring(actionId))
  local uPlayEmoteComp = self:GetPlayEmoteComponent()
  if not slua.isValid(uPlayEmoteComp) then
    return
  end
  local LogFilter = require("common.log_filter")
  LogFilter.SetLogTreeEnable(true)
  local animCfg = CDataTable.GetTableData("EmoteBPTable", actionId)
  if not animCfg then
    return
  end
  local handlePath = animCfg.Path
  local EmoteHandleAsset = slua.loadObject(handlePath)
  local assetsArray = slua.Array(UEnums.EPropertyClass.Struct, import("/Script/CoreUObject.SoftObjectPath"))
  local handle = EmoteHandleAsset()
  uPlayEmoteComp:OnLoadEmoteAssetBegin(handle, actionId, assetsArray, "")
  log(bWriteLog and "  BRPlayerCharacterBase:MulticastRPC_GmPlayAction. assetsArray:Num(): " .. tostring(assetsArray:Num()))
  local tb = FuncUtil.LuaArrayToTable(assetsArray)
  local asset_util = require("common.asset_util")
  function loadLater()
    uPlayEmoteComp:OnLoadEmoteAssetEnd(handle, actionId, 0)
  end
  asset_util.GetAssetsArrayAsyncParallel(tb, loadLater)
end

function BRPlayerCharacterBase:RPC_Client_SetShouldCheckPassWall(bServerSyncShouldCheckPassWall)
  print(bWriteLog and "BRPlayerCharacterBase:RPC_Client_SetShouldCheckPassWall " .. tostring(bServerSyncShouldCheckPassWall))
  if slua.isValid(self.ParachuteComponent) then
    self.ParachuteComponent.bServerSyncShouldCheckPassWall = bServerSyncShouldCheckPassWall
  end
end

function BRPlayerCharacterBase:OnPlayerEnterCarryBoxState()
  self.Super:OnPlayerEnterCarryBoxState()
  local CharName = self:GetPlayerNameSafety()
  print(bWriteLog and string.format("DeadBoxLog BRPlayerCharacterBase:OnPlayerEnterCarryBoxState Role:%s PlayerKey:%s Name:%s", tostring(self.Role), tostring(self.PlayerKey), tostring(CharName)))
  if self.CarryDeadBoxFeature then
    self.CarryDeadBoxFeature:OnPlayerEnterCarryBoxState()
  end
end

function BRPlayerCharacterBase:OnPlayerLeaveCarryBoxState(bInIsInterrupt)
  self.Super:OnPlayerLeaveCarryBoxState(bInIsInterrupt)
  local CharName = self:GetPlayerNameSafety()
  print(bWriteLog and string.format("DeadBoxLog BRPlayerCharacterBase:OnPlayerLeaveCarryBoxState Role:%s PlayerKey:%s Name:%s bInIsInterrupt:%s", tostring(self.Role), tostring(self.PlayerKey), tostring(CharName), tostring(bInIsInterrupt)))
  if self.CarryDeadBoxFeature then
    self.CarryDeadBoxFeature:OnPlayerLeaveCarryBoxState(bInIsInterrupt)
  end
end

function BRPlayerCharacterBase:ServerRPC_CarryDeadBox(uInDeadBox)
  if slua.isValid(uInDeadBox) and Game:IsClassOf(uInDeadBox, import("/Script/ShadowTrackerExtra.PlayerTombBox")) and self.CarryDeadBoxFeature then
    self.CarryDeadBoxFeature:CarryDeadBox(uInDeadBox)
  end
end

function BRPlayerCharacterBase:SetAreaID(AreaID)
  self:SetAttrValue("AreaID", AreaID, -1)
end

function BRPlayerCharacterBase:GetAreaID()
  return math.floor(self:GetAttrValue("AreaID") + 0.5)
end

function BRPlayerCharacterBase:CannotChangeIntoPetSpectator()
  print(bWriteLog and "BRPlayerCharacterBase:CannotChangeIntoPetSpectator")
  return self.bCannotChangeIntoPetSpectator
end

function BRPlayerCharacterBase:DoModChangeToBT()
  print(bWriteLog and string.format("BRPlayerCharacterBase:DoModChangeToBT, PlayerKey=%s", tostring(self.PlayerKey)))
  if self:HasState(EPawnState.SpecialSuit) then
    self:TriggerEntrySkillWithID(4301101, true)
    print(bWriteLog and string.format("BRPlayerCharacterBase:DoModChangeToBT, PlayerKey=%s, HasState(EPawnState.SpecialSuit)", tostring(self.PlayerKey)))
  end
end

function BRPlayerCharacterBase:SwitchCameraToParachuteOpening()
  print(bWriteLog and "BRPlayerCharacterBase:SwitchCameraToParachuteOpening")
  self.Super:SwitchCameraToParachuteOpening()
  if self.ParachuteFormation and self.ParachuteFormation.ShouldApplyFormationCamera and self.ParachuteFormation:ShouldApplyFormationCamera() then
    self.ParachuteFormation:OverlayFormationCameraParams()
    print(bWriteLog and "BRPlayerCharacterBase:SwitchCameraToParachuteOpening - Formation camera overlaid")
  end
end

function BRPlayerCharacterBase:SwitchCameraToParachuteFalling()
  print(bWriteLog and "BRPlayerCharacterBase:SwitchCameraToParachuteFalling")
  self.Super:SwitchCameraToParachuteFalling()
  if self.ParachuteFormation and self.ParachuteFormation.ShouldApplyFormationCamera and self.ParachuteFormation:ShouldApplyFormationCamera() then
    self.ParachuteFormation:OverlayFormationCameraParams()
    print(bWriteLog and "BRPlayerCharacterBase:SwitchCameraToParachuteFalling - Formation camera overlaid")
  end
end

function BRPlayerCharacterBase:SwitchCameraToNormal()
  print(bWriteLog and "BRPlayerCharacterBase:SwitchCameraToNormal")
  self.Super:SwitchCameraToNormal()
  if self.ParachuteFormation and self.ParachuteFormation.OnLandingClearFormationCamera then
    self.ParachuteFormation:OnLandingClearFormationCamera()
  end
end

function BRPlayerCharacterBase:SwitchWeaponCheck(Slot, IgnoreState)
  if self:HasState(EPawnState.AttachToOther) then
    local Weapon = self:GetWeaponBySlot(Slot)
    if slua.isValid(Weapon) then
      local WeaponID = Weapon:GetWeaponID()
      local AttachToOtherConfig = GamePlayTools.GetCurrentConfig("AttachToOtherConfig")
      if AttachToOtherConfig and AttachToOtherConfig.CheckIsWeaponInBlackList and AttachToOtherConfig.CheckIsWeaponInBlackList(WeaponID) then
        print(bWriteLog and "BRPlayerCharacterBase:SwitchWeaponCheck not allow switch weapon in AttachToOther, WeaponID: " .. tostring(WeaponID))
        local uPlayerController = self:GetPlayerControllerSafety()
        if Client and slua.isValid(uPlayerController) and uPlayerController.Role == ENetRole.ROLE_AutonomousProxy then
          uPlayerController:DisplayGameTipWithMsgID(47306)
        end
        return false
      end
    end
  end
  if self:HasState(EPawnState.WebSwing) and Slot ~= ESurviveWeaponPropSlot.SWPS_None and slua.isValid(self.STCharacterMovement) then
    local SpiderSwingObj = self.STCharacterMovement:GetSpecialMoveObjBySpecialMoveType(ESpecialMovementType.SPECIAL_MOVE_SpiderSwing)
    if slua.isValid(SpiderSwingObj) then
      local nCurState = SpiderSwingObj:GetCurMoveState()
      if nCurState == ESpiderSwingMoveState.Launching or nCurState == ESpiderSwingMoveState.Swinging then
        print(bWriteLog and "BRPlayerCharacterBase:SwitchWeaponCheck blocked by SpiderSwing state: " .. tostring(nCurState))
        return false
      end
    end
  end
  return self.Super:SwitchWeaponCheck(Slot, IgnoreState)
end

-- ============================================================
-- CLASS DECLARATION
-- ============================================================

local class = require("class")
local CCharacterBase = require("GameLua.GameCore.Framework.CharacterBase")
local CBRPlayerCharacterBase = class(CCharacterBase, nil, BRPlayerCharacterBase)
return require("combine_class").DeclareFeature(CBRPlayerCharacterBase, {
  {
    SkyTransition = "GameLua.Mod.BaseMod.Gameplay.Feature.SkyControl.PlayerCharacterSkyTransitionFeature"
  },
  {
    CarryDeadBoxFeature = "GameLua.Mod.Library.GamePlay.Feature.CarryDeadBoxFeature"
  },
  {
    SpecialSuitFeature = "GameLua.Mod.Library.GamePlay.Feature.SpecialSuitFeature"
  },
  {
    TeleportPawnFeature = "GameLua.Mod.Library.GamePlay.Feature.TeleportPawnFeature"
  },
  {
    LifterControl = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.CharacterLifterControlFeature"
  },
  {
    FinalKillEffect = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.PlayerCharacterFinalKillEffectFeature"
  },
  {
    CampFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.Camp.PlayerCharacterCampFeature"
  },
  {
    BuildSkateFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.PlayerCharacterBuildVehicleFeature"
  },
  {
    CommonBornlandTransformFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.HeroPropFeature.CommonBornlandTransformFeature"
  },
  {
    ParachuteFormation = "GameLua.Mod.BaseMod.GamePlay.Feature.ParachuteFormationFeature"
  },
  {
    SpiderSenseFootprintFeature = "GameLua.Mod.Library.GamePlay.Feature.SpiderSenseFootprintFeature"
  },
  {
    GeneralShowSpotFeature = "GameLua.Mod.BRMod.Gameplay.Feature.PlayerCharacterGeneralShowSpotFeature"
  }
}, "BRPlayerCharacterBase")