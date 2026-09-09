class_name WeaponData
extends Resource

## Data-only definition of a weapon's stats. Assign an instance of this
## resource to a Weapon node's `weapon_data` export to configure it.

enum FireMode {
	SEMI_AUTO,
	AUTOMATIC,
}

## Display name of the weapon.
@export var weapon_name: String = "Weapon"
## Damage dealt to a player per hit.
@export var damage: int = 1
## Shots fired per second while the trigger is engaged.
@export var fire_rate: float = 2.5
## Rounds held in the magazine. -1 means unlimited ammo.
@export var magazine_size: int = -1
## Starting rounds held in reserve, restored to the magazine on reload.
## -1 means unlimited reserve ammo.
@export var reserve_ammo: int = -1
## Ceiling on reserve ammo (e.g. from future ammo pickups). -1 means unlimited.
@export var max_reserve_ammo: int = -1
## Seconds a reload takes to complete.
@export var reload_time: float = 0.0
## Maximum hitscan distance, in meters.
@export var max_range: float = 50.0
## Recoil strength applied when firing. Reserved for future weapons.
@export var recoil: float = 0.0
## Whether the weapon fires once per trigger pull or continuously.
@export var fire_mode: FireMode = FireMode.SEMI_AUTO
