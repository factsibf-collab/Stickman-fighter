extends Node
class_name FightingAI

@export_range(1, 5) var difficulty: int = 1

var attack_timer: float = 0.0
var reaction_time: float = 1.2
var attack_range: float = 150.0

func _ready():
    update_difficulty()

func set_difficulty(level: int):
    difficulty = clampi(level, 1, 5)
    update_difficulty()

func update_difficulty():
    match difficulty:
        1:
            reaction_time = 1.5
        2:
            reaction_time = 1.2
        3:
            reaction_time = 0.9
        4:
            reaction_time = 0.6
        5:
            reaction_time = 0.35

func _process(delta):
    attack_timer = maxf(0.0, attack_timer - delta)

func should_attack(distance: float) -> bool:
    if attack_timer > 0.0:
        return false

    if distance > attack_range:
        return false

    if randf() < 0.15:
        return false

    attack_timer = reaction_time
    return true

func choose_attack() -> String:
    if difficulty >= 4 and randf() < 0.35:
        return "kick"

    if difficulty == 5 and randf() < 0.25:
        return "special"

    return "punch"
