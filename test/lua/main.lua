local ruvalid = require("ruvalid")

local data1 = {
   email = "john@doe.com",
   password = "12345678",
   firstname = "John",
   lastname = "Doe",
   age = 42
}

local data2 = {
   -- email = "john@doe.com",
   password = "1234567",
   firstname = 32,
   lastname = {},
   age = "42"
}

local pattern = {
   email = "required|is_email",
   password = "required|min:8|is_string",
   firstname = "required|is_string",
   lastname = "required|is_string",
   age = "is_number"
}

print(ruvalid(data1, pattern))
print(ruvalid(data2, pattern))