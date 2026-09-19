local _, ns = ...

if GetLocale() ~= "ruRU" then
    return
end

-- Machine translation. Corrections are welcome.
local L = ns.L

L["Target text"] = "Текст над целью"
L["The text above your target: damage you deal, heals, misses, and similar. Lift it when nameplates hide it."] =
    "Текст над вашей целью: нанесённый урон, исцеление, промахи и тому подобное. Поднимите его, если его закрывают индикаторы здоровья."
L["Target height"] = "Высота над целью"
L["Lower"] = "Ниже"
L["Higher"] = "Выше"
L["Left"] = "Влево"
L["Right"] = "Вправо"
L["Reset position"] = "Сбросить положение"
L["This game client does not have the settings that move target text."] =
    "В этом клиенте игры нет настроек, которые перемещают текст над целью."
L["Self text"] = "Свой текст"
L["The text that scrolls near your character: damage you take, heals you receive, and similar."] =
    "Текст, который прокручивается рядом с вашим персонажем: полученный урон, полученное исцеление и тому подобное."
L["Self text is off in the game options."] = "Свой текст отключён в настройках игры."
L["Use separate self text settings for this character"] = "Отдельные настройки своего текста для этого персонажа"
L["Show self text above other UI elements"] = "Показывать свой текст поверх других элементов интерфейса"
L["Horizontal"] = "По горизонтали"
L["Vertical"] = "По вертикали"
L["Move"] = "Переместить"
L["Self text starts here"] = "Свой текст начинается здесь"
L["/sctm opens the options, and /sctm move lets you drag the self text."] =
    "/sctm открывает настройки, а /sctm move позволяет перетащить свой текст."
