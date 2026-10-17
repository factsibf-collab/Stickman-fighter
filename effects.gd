extends Node2D
class_name CombatEffects

var effects: Array[Dictionary] = []

func show_hit_effect(world_position: Vector2):
    effects.append({
        "position": world_position,
        "time": 0.25,
        "max_time": 0.25
    })

    queue_redraw()

func _process(delta):
    for i in range(effects.size() - 1, -1, -1):
        effects[i]["time"] -= delta

        if effects[i]["time"] <= 0.0:
            effects.remove_at(i)

    queue_redraw()

func _draw():
    for effect in effects:
        var remaining = effect["time"]
        var alpha = clampf(
            remaining / effect["max_time"],
            0.0,
            1.0
        )

        var pos: Vector2 = effect["position"]

        draw_circle(
            pos,
            18.0 * alpha,
            Color(1.0, 0.15, 0.1, alpha)
        )

        draw_circle(
            pos,
            7.0 * alpha,
            Color(1.0, 0.8, 0.2, alpha)
        )
