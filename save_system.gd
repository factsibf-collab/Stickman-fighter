extends Node
class_name GameSaveSystem

const SAVE_PATH = "user://red_moon_save.json"

func save_game(data: Dictionary) -> bool:
    var file = FileAccess.open(
        SAVE_PATH,
        FileAccess.WRITE
    )

    if file == null:
        return false

    file.store_string(
        JSON.stringify(data, "\t")
    )

    file.close()
    return true

func load_game() -> Dictionary:
    if not FileAccess.file_exists(SAVE_PATH):
        return {}

    var file = FileAccess.open(
        SAVE_PATH,
        FileAccess.READ
    )

    if file == null:
        return {}

    var text_data = file.get_as_text()
    file.close()

    var json = JSON.new()
    var error = json.parse(text_data)

    if error != OK:
        return {}

    if typeof(json.data) != TYPE_DICTIONARY:
        return {}

    return json.data
