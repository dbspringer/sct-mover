local _, ns = ...

if GetLocale() ~= "koKR" then
    return
end

-- Machine translation. Corrections are welcome.
local L = ns.L

L["Target text"] = "대상 텍스트"
L["The text above your target: damage you deal, heals, misses, and similar. Lift it when nameplates hide it."] =
    "대상 위에 표시되는 텍스트: 입힌 피해, 치유, 빗나감 등. 이름표에 가려질 때 위로 올리세요."
L["Target height"] = "대상 높이"
L["Lower"] = "아래로"
L["Higher"] = "위로"
L["Left"] = "왼쪽"
L["Right"] = "오른쪽"
L["Reset position"] = "위치 초기화"
L["This game client does not have the settings that move target text."] = "이 게임 클라이언트에는 대상 텍스트를 옮기는 설정이 없습니다."
L["Self text"] = "자신 텍스트"
L["The text that scrolls near your character: damage you take, heals you receive, and similar."] =
    "캐릭터 근처에서 흐르는 텍스트: 받은 피해, 받은 치유 등."
L["Self text is off in the game options."] = "게임 설정에서 자신 텍스트가 꺼져 있습니다."
L["Use separate self text settings for this character"] = "이 캐릭터에 별도의 자신 텍스트 설정 사용"
L["Show self text above other UI elements"] = "자신 텍스트를 다른 UI 요소 위에 표시"
L["Horizontal"] = "가로"
L["Vertical"] = "세로"
L["Move"] = "이동"
L["Self text starts here"] = "자신 텍스트가 여기서 시작됩니다"
L["/sctm opens the options, and /sctm move lets you drag the self text."] =
    "/sctm 은 설정을 열고, /sctm move 로 자신 텍스트를 끌어서 옮길 수 있습니다."
L["Version %s | Locale: %s"] = "버전 %s | 언어: %s"
