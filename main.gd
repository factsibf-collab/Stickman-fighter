extends Node2D

var player_health := 100.0
var enemy_health := 100.0

var coins := 100
var player_damage := 10.0
var enemy_damage := 8.0

var player_x := 850.0
var enemy_x := 400.0

var player_y := 0.0
var enemy_y := 0.0

var player_velocity_y := 0.0
var enemy_velocity_y := 0.0

var gravity := 1500.0
var jump_power := -600.0

var player_attacking := false
var enemy_attacking := false

var player_attack_cooldown := 0.0
var enemy_attack_cooldown := 0.0

var difficulty := 1
var game_over := false
var result_text := ""

var equipped_weapon := "None"
var equipped_gloves := "Rookie Gloves"
var equipped_shoes := "Street Runner Shoes"

var ai_timer := 0.0
var attack_flash := 0.0

var arena_width := 1280.0
var arena_height := 720.0

var touch_left := false
var touch_right := false
var touch_block := false

var controls := {}
var menu_buttons := {}

func _ready():
    get_viewport().size_changed.connect(_on_resize)
    setup_game()

func setup_game():
    player_health = 100.0
    enemy_health = 100.0

    player_x = get_viewport_rect().size.x * 0.70
    enemy_x = get_viewport_rect().size.x * 0.30

    player_y = 0.0
    enemy_y = 0.0

    player_velocity_y = 0.0
    enemy_velocity_y = 0.0

    game_over = false
    result_text = ""

    player_attacking = false
    enemy_attacking = false

    player_attack_cooldown = 0.0
    enemy_attack_cooldown = 0.0

    ai_timer = 0.5

    queue_redraw()

func _on_resize():
    queue_redraw()

func _process(delta):
    if game_over:
        queue_redraw()
        return

    player_attack_cooldown = maxf(
        0.0,
        player_attack_cooldown - delta
    )

    enemy_attack_cooldown = maxf(
        0.0,
        enemy_attack_cooldown - delta
    )

    attack_flash = maxf(0.0, attack_flash - delta)

    update_player(delta)
    update_enemy(delta)

    queue_redraw()

func update_player(delta):
    var move_direction := 0.0

    if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
        move_direction -= 1.0

    if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
        move_direction += 1.0

    if touch_left:
        move_direction -= 1.0

    if touch_right:
        move_direction += 1.0

    player_x += move_direction * 360.0 * delta

    player_x = clampf(
        player_x,
        60.0,
        get_viewport_rect().size.x - 60.0
    )

    if Input.is_key_pressed(KEY_SPACE) and player_y == 0.0:
        player_velocity_y = jump_power

    player_velocity_y += gravity * delta
    player_y += player_velocity_y * delta

    if player_y > 0.0:
        player_y = 0.0
        player_velocity_y = 0.0

    if Input.is_key_pressed(KEY_J):
        punch()

    if Input.is_key_pressed(KEY_K):
        kick()

func update_enemy(delta):
    ai_timer -= delta

    var distance := absf(player_x - enemy_x)
    var direction := signf(player_x - enemy_x)

    if distance > 100.0:
        enemy_x += direction * (100.0 + difficulty * 30.0) * delta

    if ai_timer <= 0.0:
        ai_timer = randf_range(
            0.35,
            maxf(0.45, 1.5 - difficulty * 0.15)
        )

        if distance < 150.0 and enemy_attack_cooldown <= 0.0:
            enemy_attack()

    enemy_velocity_y += gravity * delta
    enemy_y += enemy_velocity_y * delta

    if enemy_y > 0.0:
        enemy_y = 0.0
        enemy_velocity_y = 0.0

func punch():
    if player_attack_cooldown > 0.0 or game_over:
        return

    player_attacking = true
    player_attack_cooldown = 0.35

    var distance := absf(player_x - enemy_x)

    if distance < 145.0:
        enemy_health -= player_damage
        attack_flash = 0.12

    check_result()

func kick():
    if player_attack_cooldown > 0.0 or game_over:
        return

    player_attacking = true
    player_attack_cooldown = 0.55

    var distance := absf(player_x - enemy_x)

    if distance < 170.0:
        enemy_health -= player_damage * 1.5
        attack_flash = 0.18

    check_result()

func enemy_attack():
    if game_over or enemy_attack_cooldown > 0.0:
        return

    enemy_attacking = true
    enemy_attack_cooldown = maxf(
        0.35,
        1.3 - difficulty * 0.12
    )

    if absf(player_x - enemy_x) < 150.0:
        player_health -= enemy_damage
        attack_flash = 0.12

    check_result()

func check_result():
    if enemy_health <= 0.0:
        enemy_health = 0.0
        game_over = true
        result_text = "VICTORY!"
        coins += 10

    elif player_health <= 0.0:
        player_health = 0.0
        game_over = true
        result_text = "DEFEAT!"
        coins = maxi(0, coins - 5)

func _draw():
    var screen := get_viewport_rect().size
    var w := screen.x
    var h := screen.y

    # Dark sky
    draw_rect(
        Rect2(Vector2.ZERO, screen),
        Color("#100711")
    )

    # Blood Moon
    var moon_center := Vector2(w * 0.5, h * 0.25)
    var moon_radius := minf(w, h) * 0.19

    draw_circle(
        moon_center,
        moon_radius + 14.0,
        Color(0.45, 0.015, 0.035, 0.25)
    )

    draw_circle(
        moon_center,
        moon_radius,
        Color("#a90020")
    )

    draw_circle(
        moon_center + Vector2(-moon_radius * 0.25, -moon_radius * 0.2),
        moon_radius * 0.7,
        Color("#c51c36")
    )

    # Moon craters
    draw_circle(
        moon_center + Vector2(30, -25),
        moon_radius * 0.12,
        Color("#861326")
    )

    draw_circle(
        moon_center + Vector2(-35, 35),
        moon_radius * 0.16,
        Color("#861326")
    )

    # Ground
    draw_rect(
        Rect2(0, h * 0.78, w, h * 0.22),
        Color("#07180c")
    )

    # Green fighting platform
    draw_rect(
        Rect2(0, h * 0.76, w, h * 0.025),
        Color("#20ff65")
    )

    draw_rect(
        Rect2(0, h * 0.785, w, h * 0.018),
        Color("#087a32")
    )

    # Fighters
    draw_fighter(
        Vector2(enemy_x, h * 0.76 + enemy_y),
        false,
        enemy_attacking,
        Color("#eeeeee")
    )

    draw_fighter(
        Vector2(player_x, h * 0.76 + player_y),
        true,
        player_attacking,
        Color("#52ff86")
    )

    # Health bars
    draw_health_bar(
        Vector2(35, 35),
        w * 0.32,
        22,
        enemy_health,
        Color("#ff3333"),
        "AI FIGHTER"
    )

    draw_health_bar(
        Vector2(w * 0.63, 35),
        w * 0.32,
        22,
        player_health,
        Color("#21ff68"),
        "PLAYER"
    )

    # Coins and equipment
    draw_string(
        ThemeDB.fallback_font,
        Vector2(35, 90),
        "COINS: " + str(coins),
        HORIZONTAL_ALIGNMENT_LEFT,
        -1,
        22,
        Color("#ffe45c")
    )

    draw_string(
        ThemeDB.fallback_font,
        Vector2(35, 120),
        "AI LEVEL: " + str(difficulty),
        HORIZONTAL_ALIGNMENT_LEFT,
        -1,
        18,
        Color.WHITE
    )

    draw_string(
        ThemeDB.fallback_font,
        Vector2(35, 150),
        equipped_gloves,
        HORIZONTAL_ALIGNMENT_LEFT,
        -1,
        16,
        Color("#cccccc")
    )

    # Combat controls
    draw_controls(w, h)

    if game_over:
        draw_rect(
            Rect2(Vector2.ZERO, screen),
            Color(0, 0, 0, 0.7)
        )

        draw_string(
            ThemeDB.fallback_font,
            Vector2(w * 0.5 - 130, h * 0.4),
            result_text,
            HORIZONTAL_ALIGNMENT_LEFT,
            -1,
            48,
            Color("#ff3655")
        )

        draw_string(
            ThemeDB.fallback_font,
            Vector2(w * 0.5 - 100, h * 0.5),
            "Tap to Rematch",
            HORIZONTAL_ALIGNMENT_LEFT,
            -1,
            24,
            Color.WHITE
        )

func draw_fighter(
    pos: Vector2,
    is_player: bool,
    attacking: bool,
    fighter_color: Color
):
    var direction := -1.0 if is_player else 1.0

    var head := pos + Vector2(0, -125)
    var shoulder := pos + Vector2(0, -95)
    var hip := pos + Vector2(0, -45)

    var arm_length := 42.0
    var leg_length := 48.0

    var hand_end := shoulder + Vector2(
        direction * (arm_length + (30.0 if attacking else 0.0)),
        15.0 if attacking else 35.0
    )

    # Shadow
    draw_ellipse(
        pos + Vector2(0, -3),
        Vector2(35, 7),
        Color(0, 0, 0, 0.45)
    )

    # Head
    draw_circle(head, 18.0, fighter_color)

    # Body
    draw_line(
        shoulder,
        hip,
        fighter_color,
        7.0,
        true
    )

    # Arms
    draw_line(
        shoulder,
        shoulder + Vector2(-arm_length, 25),
        fighter_color,
        6.0,
        true
    )

    draw_line(
        shoulder,
        hand_end,
        fighter_color,
        7.0,
        true
    )

    # Legs
    draw_line(
        hip,
        hip + Vector2(-25, leg_length),
        fighter_color,
        7.0,
        true
    )

    draw_line(
        hip,
        hip + Vector2(25, leg_length),
        fighter_color,
        7.0,
        true
    )

    # Gloves
    draw_circle(
        hand_end,
        9.0,
        Color("#ff3333") if is_player else Color("#dddddd")
    )

    # Shoes
    draw_line(
        hip + Vector2(-25, leg_length),
        hip + Vector2(-38, leg_length),
        Color("#39ff79"),
        9.0,
        true
    )

    draw_line(
        hip + Vector2(25, leg_length),
        hip + Vector2(38, leg_length),
        Color("#39ff79"),
        9.0,
        true
    )

func draw_ellipse(
    center: Vector2,
    radius: Vector2,
    color: Color
):
    var points := PackedVector2Array()

    for i in range(25):
        var angle := TAU * float(i) / 24.0

        points.append(
            center + Vector2(
                cos(angle) * radius.x,
                sin(angle) * radius.y
            )
        )

    draw_colored_polygon(points, color)

func draw_health_bar(
    pos: Vector2,
    width: float,
    height: float,
    health: float,
    bar_color: Color,
    label: String
):
    draw_string(
        ThemeDB.fallback_font,
        pos + Vector2(0, -7),
        label,
        HORIZONTAL_ALIGNMENT_LEFT,
        -1,
        16,
        Color.WHITE
    )

    draw_rect(
        Rect2(pos, Vector2(width, height)),
        Color("#444444")
    )

    draw_rect(
        Rect2(pos, Vector2(width * health / 100.0, height)),
        bar_color
    )

    draw_rect(
        Rect2(pos, Vector2(width, height)),
        Color.WHITE,
        false,
        2.0
    )

func draw_controls(w: float, h: float):
    var button_radius := 36.0

    # Movement
    draw_circle(
        Vector2(65, h - 75),
        button_radius,
        Color(0.1, 0.8, 0.3, 0.8)
    )

    draw_circle(
        Vector2(150, h - 75),
        button_radius,
        Color(0.1, 0.8, 0.3, 0.8)
    )

    draw_string(
        ThemeDB.fallback_font,
        Vector2(50, h - 65),
        "<",
        HORIZONTAL_ALIGNMENT_LEFT,
        -1,
        28,
        Color.WHITE
    )

    draw_string(
        ThemeDB.fallback_font,
        Vector2(135, h - 65),
        ">",
        HORIZONTAL_ALIGNMENT_LEFT,
        -1,
        28,
        Color.WHITE
    )

    # Combat
    var attack_positions := [
        Vector2(w - 230, h - 75),
        Vector2(w - 145, h - 75),
        Vector2(w - 60, h - 75)
    ]

    var attack_labels := ["PUNCH", "KICK", "JUMP"]

    for i in range(attack_positions.size()):
        draw_circle(
            attack_positions[i],
            button_radius,
            Color(0.75, 0.08, 0.15, 0.9)
        )

        draw_string(
            ThemeDB.fallback_font,
            attack_positions[i] + Vector2(-30, 6),
            attack_labels[i],
            HORIZONTAL_ALIGNMENT_LEFT,
            -1,
            13,
            Color.WHITE
        )

func _input(event):
    if event is InputEventKey and event.pressed:
        if event.keycode == KEY_J:
            punch()

        elif event.keycode == KEY_K:
            kick()

    if event is InputEventScreenTouch:
        if event.pressed:
            if game_over:
                setup_game()
                return

            handle_touch(event.position)

        else:
            touch_left = false
            touch_right = false
            touch_block = false

    if event is InputEventScreenDrag:
        handle_touch(event.position)

func handle_touch(pos: Vector2):
    var screen := get_viewport_rect().size

    if pos.x < 100 and pos.y > screen.y * 0.75:
        touch_left = true
        touch_right = false

    elif pos.x < 190 and pos.y > screen.y * 0.75:
        touch_right = true
        touch_left = false

    elif pos.x > screen.x - 275 and pos.y > screen.y * 0.75:
        var relative_x := pos.x - (screen.x - 275)

        if relative_x < 90:
            punch()

        elif relative_x < 180:
            kick()

        else:
            if player_y == 0.0:
                player_velocity_y = jump_power
