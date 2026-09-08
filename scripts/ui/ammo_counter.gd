extends Label

## Minimal debug ammo readout: "magazine / reserve". Only shown for the
## local authoritative player -- every spawned player has this node, but
## only the one the local client controls should draw a HUD.

@onready var player: CharacterBody3D = get_parent()

func _ready() -> void:
	visible = player.is_multiplayer_authority()

func _process(_delta: float) -> void:
	if not visible:
		return
	var current_weapon: Weapon = player.inventory.get_current_weapon()
	if current_weapon == null or current_weapon.get_magazine_size() < 0:
		text = ""
		return
	text = "%d / %d" % [current_weapon.get_current_ammo(), current_weapon.get_reserve_ammo()]
