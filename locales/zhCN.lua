local _, ns = ...

if GetLocale() ~= "zhCN" then
    return
end

-- Machine translation. Corrections are welcome.
local L = ns.L

L["Target text"] = "目标文字"
L["The text above your target: damage you deal, heals, misses, and similar. Lift it when nameplates hide it."] =
    "目标上方的文字：你造成的伤害、治疗、未命中等。当姓名板遮住它时，把它调高。"
L["Target height"] = "目标高度"
L["Lower"] = "更低"
L["Higher"] = "更高"
L["Left"] = "左"
L["Right"] = "右"
L["Reset position"] = "重置位置"
L["This game client does not have the settings that move target text."] = "此游戏客户端没有用于移动目标文字的设置。"
L["Self text"] = "自身文字"
L["The text that scrolls near your character: damage you take, heals you receive, and similar."] =
    "在你角色附近滚动的文字：你受到的伤害、获得的治疗等。"
L["Self text is off in the game options."] = "游戏选项中已关闭自身文字。"
L["Use separate self text settings for this character"] = "为此角色使用单独的自身文字设置"
L["Show self text above other UI elements"] = "在其他界面元素上方显示自身文字"
L["Horizontal"] = "水平"
L["Vertical"] = "垂直"
L["Move"] = "移动"
L["Self text starts here"] = "自身文字从这里开始"
L["/sctm opens the options, and /sctm move lets you drag the self text."] = "/sctm 打开选项，/sctm move 可以拖动自身文字。"
