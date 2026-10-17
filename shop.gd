extends Node
class_name GameShop

signal coins_changed(amount)
signal item_purchased(item_name)

var coins: int = 100
var owned_items = [
    "Rookie Gloves",
    "Street Runner Shoes"
]

func can_afford(price: int) -> bool:
    return coins >= price

func purchase_item(item_name: String, price: int) -> bool:
    if owned_items.has(item_name):
        return false

    if price < 0 or not can_afford(price):
        return false

    coins -= price
    owned_items.append(item_name)

    coins_changed.emit(coins)
    item_purchased.emit(item_name)

    return true

func reward_victory():
    coins += 10
    coins_changed.emit(coins)

func apply_defeat_penalty():
    coins = maxi(0, coins - 5)
    coins_changed.emit(coins)

func owns_item(item_name: String) -> bool:
    return owned_items.has(item_name)
