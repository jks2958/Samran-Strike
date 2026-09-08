class_name Weapon
extends Node3D

## Reusable weapon behavior: fire-rate cooldown, ammo tracking, and fire
## effects. Weapon-specific stats live in `weapon_data` (a WeaponData
## resource) instead of being hard-coded here, so future weapons can reuse
## this same script with a different resource.

@export var weapon_data: WeaponData

@onready var muzzle_flash: GPUParticles3D = $GPUParticles3D
@onready var gunshot_sound: AudioStreamPlayer3D = $GunshotSound

var _current_ammo: int = -1
var _reserve_ammo: int = -1
var _cooldown_remaining: float = 0.0

func _ready() -> void:
	if weapon_data:
		_current_ammo = weapon_data.magazine_size
		_reserve_ammo = weapon_data.reserve_ammo

func _process(delta: float) -> void:
	if _cooldown_remaining > 0.0:
		_cooldown_remaining -= delta

func get_weapon_name() -> String:
	return weapon_data.weapon_name if weapon_data else ""

func get_damage() -> int:
	return weapon_data.damage if weapon_data else 0

func get_range() -> float:
	return weapon_data.range if weapon_data else 0.0

func has_ammo() -> bool:
	return weapon_data == null or weapon_data.magazine_size < 0 or _current_ammo > 0

func can_fire() -> bool:
	return _cooldown_remaining <= 0.0 and has_ammo()

## Returns true if the given input state should attempt a shot, based on
## this weapon's fire mode (semi-auto fires once per press, automatic fires
## for as long as the trigger is held).
func wants_to_fire(is_pressed: bool, just_pressed: bool) -> bool:
	if weapon_data and weapon_data.fire_mode == WeaponData.FireMode.AUTOMATIC:
		return is_pressed
	return just_pressed

## Attempts to fire: applies the fire-rate cooldown and consumes ammo (if
## the weapon has a finite magazine). Returns true if the shot is allowed.
func try_fire() -> bool:
	if not can_fire():
		return false
	if weapon_data:
		if weapon_data.fire_rate > 0.0:
			_cooldown_remaining = 1.0 / weapon_data.fire_rate
		if weapon_data.magazine_size >= 0:
			_current_ammo -= 1
	return true

## Restores the magazine from reserve ammo. Not wired to any input yet;
## provided so the architecture supports reloading for future weapons.
func reload() -> void:
	if weapon_data == null or weapon_data.magazine_size < 0:
		return
	_current_ammo = weapon_data.magazine_size

func play_muzzle_flash() -> void:
	muzzle_flash.restart()
	muzzle_flash.emitting = true

func play_fire_sound() -> void:
	gunshot_sound.play()
