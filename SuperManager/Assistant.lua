--
--
--
--
--

local Assistant = class("Assistant")

local ModuleNames = require("runtime/SuperManager/ModuleNames")

function Assistant.refreshFile()

    local moduleNames = {
        -- base
        "base/AlertManager",
        "base/defines",
        "base/MultiLang",
        
        -- ui
        "ui/ActivityAboutUI",
        "ui/AttackFormUI",
        "ui/ActivityRankUI",
    }
    
    for _, moduleName in ipairs(moduleNames) do
        package.loaded[moduleName] = nil
    end
    
    print("=============ChallengeResultUI============")
    
    
    require("base/MultiLang")
    require("base/defines")
end

function Assistant.print()
    print("--------refresh Assistant file--------")
end

function Assistant.trigger()
    Event.Trigger(EventName.ON_SACRED_WEAPON_COMPOSE_SUCCESS)
end

function Assistant.executeCode()
    print("-------executeCode---------")
    
    
    local function victoryPoseFinish()
        local ChallengeResultUI = require("ui/ChallengeResultUI")
        local param = {}
        -- 模式
        param.resultType = ChallengeResultUI.ResultType.WIN_OR_LOSE
        -- 结果
        param.result = 1
        -- 描述
        local desc = {}
        param.desc = desc
        -- 标题 
        desc.title = MultiLang["mars.get_points"]
        -- 内容
        desc.content = 1
        local rewardItem = {}
        rewardItem.goods_id = 0
        rewardItem.type = RewardType.eCoin
        rewardItem.num = 100
        param.rewardItems = {rewardItem}
        ChallengeResultUI.showDlg(param)
    end
    
    local Game = require("base/Game")
    Game.getMainRole():victory(victoryPoseFinish)
end

Assistant.print()

return Assistant


