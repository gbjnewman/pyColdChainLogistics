
-- Py storage capacity compatibility.
--
-- Read the storage capacities from the existing prototypes,
-- rather than maintaining separate values for Pyanodons.
--
-- PyHardMode modifies the original chest and warehouse
-- prototypes. We inherit their final capacities here.
--
-- Without Pyanodons, Fridge keeps its original settings.

if not (mods["pyalienlife"] and mods["pypostprocessing"]) then
    return
end

-- Copy a storage capacity from one entity to another.
local function inherit_capacity(target_type, target_name,
                                source_type, source_name,
                                field)

    field = field or "inventory_size"

    local target = data.raw[target_type]
        and data.raw[target_type][target_name]

    local source = data.raw[source_type]
        and data.raw[source_type][source_name]

    assert(target, "Fridge: missing target " .. target_name)
    assert(source, "Fridge: missing source " .. source_name)

    assert(
        type(source[field]) == "number",
        "Fridge: missing capacity field on " .. source_name
    )

    target[field] = source[field]
end

-- Basic refrigerator: match the steel chest.
inherit_capacity(
    "container", "refrigerater",
    "container", "steel-chest"
)

-- Logistic refrigerators: match their equivalent chests.
inherit_capacity(
    "logistic-container", "logistic-refrigerater-passive-provider",
    "logistic-container", "passive-provider-chest"
)

inherit_capacity(
    "logistic-container", "logistic-refrigerater-requester",
    "logistic-container", "requester-chest"
)

inherit_capacity(
    "logistic-container", "logistic-refrigerater-buffer",
    "logistic-container", "buffer-chest"
)

-- Freezing warehouse: match the Pyanodons warehouse.
-- Only present when PyIndustry is installed.
if mods["pyindustry"] then
    inherit_capacity(
        "container", "preservation-warehouse",
        "container", "py-warehouse-basic"
    )
end

-- Preservation wagon: match the normal cargo wagon.
inherit_capacity(
    "cargo-wagon", "preservation-wagon",
    "cargo-wagon", "cargo-wagon"
)

-- Space platform storage uses inventory_size_bonus instead.
-- These prototypes are only created with Space Age.
if mods["space-age"] then
    inherit_capacity(
        "cargo-bay", "preservation-platform-warehouse",
        "cargo-bay", "cargo-bay",
        "inventory_size_bonus"
    )

    -- The unloading bay is optional in the upstream mod.
    local bays = data.raw["cargo-bay"]

    if bays and bays["preservation-platform-unloading-bay"] then
        inherit_capacity(
            "cargo-bay", "preservation-platform-unloading-bay",
            "cargo-bay", "landing-pad-unloading-bay",
            "inventory_size_bonus"
        )
    end
end
