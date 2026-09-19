local _, ns = ...

-- Latin American Spanish clients use these strings too.
local locale = GetLocale()
if locale ~= "esES" and locale ~= "esMX" then
    return
end

-- Machine translation. Corrections are welcome.
local L = ns.L

L["Target text"] = "Texto del objetivo"
L["The text above your target: damage you deal, heals, misses, and similar. Lift it when nameplates hide it."] =
    "El texto sobre tu objetivo: daño infligido, sanaciones, fallos y similares. Súbelo cuando las placas de nombre lo tapen."
L["Target height"] = "Altura en el objetivo"
L["Lower"] = "Más bajo"
L["Higher"] = "Más alto"
L["Left"] = "Izquierda"
L["Right"] = "Derecha"
L["Reset position"] = "Restablecer posición"
L["This game client does not have the settings that move target text."] =
    "Este cliente del juego no tiene los ajustes que mueven el texto del objetivo."
L["Self text"] = "Texto propio"
L["The text that scrolls near your character: damage you take, heals you receive, and similar."] =
    "El texto que se desplaza cerca de tu personaje: daño recibido, sanaciones recibidas y similares."
L["Self text is off in the game options."] = "El texto propio está desactivado en las opciones del juego."
L["Use separate self text settings for this character"] = "Usar ajustes de texto propio distintos para este personaje"
L["Show self text above other UI elements"] = "Mostrar el texto propio por encima de otros elementos de la interfaz"
L["Horizontal"] = "Horizontal"
L["Vertical"] = "Vertical"
L["Move"] = "Mover"
L["Self text starts here"] = "El texto propio empieza aquí"
L["/sctm opens the options, and /sctm move lets you drag the self text."] =
    "/sctm abre las opciones, y /sctm move te permite arrastrar el texto propio."
