--
-- SuperManager是用来帮助debug的类，Assistant也一样
-- 不同是Assistant可以在SuperManager.addKeyboardEventListener后通过F5热更新
-- 在游戏过程中不重启更改逻辑
--

require("Cocos2d")
require("src/util/misc")

SuperManager = class("SuperManager")

local Assistant = require("runtime/SuperManager/Assistant")

local s_scheduler = cc.Director:getInstance():getScheduler()

-- hard coded数字的case是监听到的实际数值与cc.KeyCode enum值不一致
local keyboardEventSwitch = switch({
    --------------------- Function--------------------
    -- scale and move to default
    [cc.KeyCode.KEY_ESCAPE] = function(node) node:setPosition(0, 0) node:setScale(1.0) s_scheduler:setTimeScale(1.0) end,
    -- scale time
    [cc.KeyCode.KEY_F1] = function() s_scheduler:setTimeScale(s_scheduler:getTimeScale()*1.1) end,
    [cc.KeyCode.KEY_F2] = function() s_scheduler:setTimeScale(s_scheduler:getTimeScale()*0.9) end,
    -- refresh File
    [cc.KeyCode.KEY_F5] = function() Assistant.refreshFile() end,
    -- execute Code
    [cc.KeyCode.KEY_F6] = function() Assistant.executeCode() end,
    -- refresh Assistant File
    [cc.KeyCode.KEY_F7] = function() package.loaded["runtime/SuperManager/Assistant"] = nil Assistant = require("runtime/SuperManager/Assistant") end,
    
    -----------------------Number---------------------
    -- dispatch Event
    -- cc.KeyCode.KEY_0
    [48] = function(node) local GuideManager = require("base/GuideManager") GuideManager.close_cur_guide() end,
    -- cc.KeyCode.KEY_1
    [49] = function(node) Assistant.trigger() end,
    
    ------------------------Punctuation---------------
    -- scale
    --cc.KeyCode.KEY_MINUS
    [45] = function(node) node:setScale(node:getScale()*0.9) end,
    --cc.KeyCode.KEY_EQUAL
    [61] = function(node) node:setScale(node:getScale()*1.1) end,
    -- manager dialog
    [cc.KeyCode.KEY_BACKSPACE] = function(node) local UIMgr = require("ui/UIMgr"); UIMgr.closeAllDlg() end,
    [cc.KeyCode.KEY_DELETE] = function(node) local UIUtil = require("ui/UIUtil") UIUtil.unlockScreen() end,

    --------------------------ARROW-------------------
    -- move
    [cc.KeyCode.KEY_UP_ARROW]   = function(node) node:setPositionY(node:getPositionY() + 100) end,
    [cc.KeyCode.KEY_DOWN_ARROW] = function(node) node:setPositionY(node:getPositionY() - 100) end,
    [cc.KeyCode.KEY_LEFT_ARROW] = function(node) node:setPositionX(node:getPositionX() - 100) end,
    [cc.KeyCode.KEY_RIGHT_ARROW]= function(node) node:setPositionX(node:getPositionX() + 100) end,
})

function SuperManager.addKeyboardEventListener(node)
    if not node.keyboardEventListener then
        SuperManager.writeMsgToDesktop("addKeyboardEventListener")
        
        local function onKeyPressed(keyCode, event)
            print("----------------------------------------")
            print("onKeyPressed:", keyCode)

            keyboardEventSwitch:case(keyCode, node)
        end

        local listener = cc.EventListenerKeyboard:create()
        listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
        node:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, node)

        node.keyboardEventListener = listener
    end
end

function SuperManager.writeMsgToDesktop(msg, mode)
    mode = mode or 'a'
    local file = io.open("C:\\Users\\Administrator\\Desktop\\LUA_ERROR.txt", mode)
    if file then
        file:write("\n----------------------------------------\n")
        file:write(os.date("%X"), "\n")
        file:write(msg)
        file:write("\n----------------------------------------\n")
    else
        cclog("\n----------------unable to open file----------------\n")
    end
    file:close()
end

-- 清空消息，记录启动时间
SuperManager.writeMsgToDesktop("SuperManager.writeMsgToDesktop()", 'w')

-- overload the function __G__TRACKBACK__
local cclog = function(...)
    print("[main] "..string.format(...))
end

function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    local SweerController = require("ctrl/SweerController")
    SweerController.notify_exception("LUA ERROR: " .. tostring(msg) .. "\n" .. debug.traceback())

    if SuperManager then
        SuperManager.writeMsgToDesktop("LUA ERROR: " .. tostring(msg) .. "\n")
        SuperManager.writeMsgToDesktop(debug.traceback())
    end
end


