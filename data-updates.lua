
-- Load the Py adaptation only with PyAlienLife and
-- Pyanodons Post Processing installed.

if mods["pyalienlife"] and mods["pypostprocessing"] then
    require("compatibility.py")
end
