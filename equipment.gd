extends Node
class_name EquipmentSystem

var gloves = {
    "Rookie Gloves": {
        "price": 0,
        "punch_bonus": 0.0
    },
    "Iron Fist Gloves": {
        "price": 100,
        "punch_bonus": 5.0
    },
    "Shadow Strike Gloves": {
        "price": 300,
        "punch_bonus": 12.0
    },
    "Crimson Rage Gloves": {
        "price": 600,
        "punch_bonus": 20.0
    }
}

var shoes = {
    "Street Runner Shoes": {
        "price": 0,
        "kick_bonus": 0.0
    },
    "Iron Kick Boots": {
        "price": 100,
        "kick_bonus": 5.0
    },
    "Shadow Step Shoes": {
        "price": 300,
        "kick_bonus": 12.0
    },
    "Blood Moon Phantom Shoes": {
        "price": 600,
        "kick_bonus": 20.0
    }
}

var equipped_gloves = "Rookie Gloves"
var equipped_shoes = "Street Runner Shoes"

func equip_gloves(item_name: String) -> bool:
    if not gloves.has(item_name):
        return false

    equipped_gloves = item_name
    return true

func equip_shoes(item_name: String) -> bool:
    if not shoes.has(item_name):
        return false

    equipped_shoes = item_name
    return true

func get_punch_bonus() -> float:
    return gloves[equipped_gloves]["punch_bonus"]

func get_kick_bonus() -> float:
    return shoes[equipped_shoes]["kick_bonus"]
