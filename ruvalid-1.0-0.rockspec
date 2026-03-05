package = "ruvalid"
version = "1.0-0"
source = {
   url = "git+https://www.github.com/code-nuage/ruvalid"
}
description = {
   homepage = "https://www.github.com/code-nuage/ruvalid",
   license = "MIT"
}
dependencies = {
   "lua >= 5.1",
}
build = {
   type = "builtin",
   modules = {
      ["ruvalid"] = "src/ruvalid.lua"
   }
}

