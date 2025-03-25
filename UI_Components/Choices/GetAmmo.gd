extends Choice

var ammo_handler: AmmoHandler

func _ready() -> void:
	id = 0
	ammo_handler = get_tree().get_first_node_in_group("ammo_handler")

func _on_pressed() -> void:
	ammo_handler.ammo_storage[ammo_handler.ammo_type.BULLET] += 20
	ammo_handler.ammo_storage[ammo_handler.ammo_type.SMALL_BULLET] += 50
	super._on_pressed()
