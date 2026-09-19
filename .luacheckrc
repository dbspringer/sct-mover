std = "lua51"
max_line_length = 120
self = false

exclude_files = { ".release/", "libs/" }

globals = {
  "SLASH_SCTMOVER1",
  "SLASH_SCTMOVER2",
  "SlashCmdList",
}

read_globals = {
  "C_AddOns",
  "C_CVar",
  "CreateFrame",
  "CreateMinimalSliderFormatter",
  "MinimalSliderWithSteppersMixin",
  "RESET_TO_DEFAULT",
  "Settings",
}

files["spec"] = { std = "+busted" }
