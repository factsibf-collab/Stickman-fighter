extends Node
class_name WeaponSystem

var weapons = {
    "None": {
        "damage": 0.0,
        "price": 0
    },
    "Pixel Sword": {
        "damage": 20.0,
        "price": 100
    },
    "Crimson Blade": {
        "damage": 35.0,
        "price": 300
    },
    "Shadow Blade": {
        "damage": 50.0,
        "price": 600
    }
}

var equipped_weapon: String = "None"

func equip_weapon(weapon_name: String) -> bool:
    if not weapons.has(weapon_name):
        return false

    equipped_weapon = weapon_name
    return true

func get_weapon_damage() -> float:
    return weapons[equipped_weapon]["damage"]

func get_weapon_price(weapon_name: String) -> int:
    if not weapons.has(weapon_name):
        return -1

    return weapons[weapon_name]["price"]

func attack_with_weapon(target):
    if target == null:
        return

    var damage = get_weapon_damage()

    if damage > 0.0:
        target.take_damage(damage)
