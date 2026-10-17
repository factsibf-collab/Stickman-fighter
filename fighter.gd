extends Node2D
class_name Fighter

signal health_changed(value)
signal fighter_defeated

@export var max_health: float = 100.0
@export var move_speed: float = 360.0
@export var jump_power: float = -600.0

var health: float = 100.0
var velocity_y: float = 0.0
var gravity: float = 1500.0
var attack_damage: float = 10.0
var kick_damage: float = 15.0
var is_blocking: bool = false

func _ready():
    health = max_health

func move_fighter(direction: float, delta: float):
    position.x += direction * move_speed * delta

func jump():
    if is_on_ground():
        velocity_y = jump_power

func apply_gravity(delta: float):
    velocity_y += gravity * delta
    position.y += velocity_y * delta

    if position.y > 0.0:
        position.y = 0.0
        velocity_y = 0.0

func is_on_ground() -> bool:
    return position.y >= 0.0

func punch(target):
    if target == null:
        return

    if position.distance_to(target.position) < 145.0:
        target.take_damage(attack_damage)

func kick(target):
    if target == null:
        return

    if position.distance_to(target.position) < 170.0:
        target.take_damage(kick_damage)

func take_damage(amount: float):
    if is_blocking:
        amount *= 0.25

    health = maxf(0.0, health - amount)
    health_changed.emit(health)

    if health <= 0.0:
        fighter_defeated.emit()
