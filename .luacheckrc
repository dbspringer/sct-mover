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
  "CreateFrame",
  "CreateMinimalSliderFormatter",
  "ERR_NOT_IN_COMBAT",
  "InCombatLockdown",
  "MinimalSliderWithSteppersMixin",
  "Settings",
  "UIErrorsFrame",
  "WorldFrame",
  "nop",
}

files["spec"] = { std = "+busted" }
