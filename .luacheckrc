std = "lua51"
max_line_length = 120
self = false

exclude_files = { ".release/", "libs/" }

globals = {
  "SCTMoverDB",
  "SLASH_SCTMOVER1",
  "SLASH_SCTMOVER2",
  "SlashCmdList",
}

read_globals = {
  "C_AddOns",
  "C_CVar",
  "CombatText",
  "CombatTextFont",
  "CreateFrame",
  "CreateMinimalSliderFormatter",
  "DONE",
  "ERR_NOT_IN_COMBAT",
  "HideUIPanel",
  "InCombatLockdown",
  "MinimalSliderWithSteppersMixin",
  "Settings",
  "SettingsPanel",
  "UIErrorsFrame",
  "UIParent",
  "WorldFrame",
  "nop",
}

files["spec"] = { std = "+busted" }
