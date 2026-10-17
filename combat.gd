extends Node
class_name CombatSystem

var combo_count: int = 0
var combo_timer: float = 0.0
var combo_timeout: float = 1.5

func _process(delta):
    combo_timer = maxf(0.0, combo_timer - delta)

    if combo_timer == 0.0:
        combo_count = 0

func perform_attack(
    attacker,
    target,
    attack_type: String
) -> float:
    if attacker == null or target == null:
        return 0.0

    var damage: float = 0.0

    match attack_type:
        "punch":
            damage = 10.0

        "heavy_punch":
            damage = 18.0

        "kick":
            damage = 15.0

        "jump_kick":
            damage = 22.0

        "special":
            damage = 30.0

        _:
            return 0.0

    if combo_timer > 0.0:
        combo_count += 1
    else:
        combo_count = 1

    combo_timer = combo_timeout

    if combo_count >= 3:
        damage *= 1.5

    target.take_damage(damage)

    return damage
