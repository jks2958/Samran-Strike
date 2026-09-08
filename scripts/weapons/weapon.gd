class_name Weapon
extends Node3D

## Reusable weapon behavior: fire-rate cooldown, ammo/reload tracking, and
## fire effects. Weapon-specific stats live in `weapon_data` (a WeaponData
## resource) instead of being hard-coded here, so future weapons can reuse
## this same script with a different resource.
##
## All mutable state (ammo, cooldown, reload progress) lives on this node,
## not on `weapon_data`. WeaponData resources are shared/cached by Godot
## across every scene instance that references the same .tres path, so
## storing per-player state there would leak between players; keeping it
## here keeps each player's weapon state independent.

enum State {
	READY,
	FIRE_COOLDOWN,
	RELOADING,
}

@export var weapon_data: WeaponData

@onready var muzzle_flash: GPUParticles3D = $GPUParticles3D
@onready var gunshot_sound: AudioStreamPlayer3D = $GunshotSound

var _current_ammo: int = -1
var _reserve_ammo: int = -1
var _cooldown_remaining: float = 0.0
var _reload_remaining: float = 0.0

func _ready() -> void:
	if weapon_data:
		_current_ammo = weapon_data.magazine_size
		_reserve_ammo = weapon_data.reserve_ammo

func _process(delta: float) -> void:
	if _cooldown_remaining > 0.0:
		_cooldown_remaining -= delta
	if _reload_remaining > 0.0:
		_reload_remaining -= delta
		if _reload_remaining <= 0.0:
			_finish_reload()

func get_weapon_name() -> String:
	return weapon_data.weapon_name if weapon_data else ""

func get_damage() -> int:
	return weapon_data.damage if weapon_data else 0

func get_range() -> float:
	return weapon_data.range if weapon_data else 0.0

func get_state() -> State:
	if _reload_remaining > 0.0:
		return State.RELOADING
	if _cooldown_remaining > 0.0:
		return State.FIRE_COOLDOWN
	return State.READY

func is_reloading() -> bool:
	return _reload_remaining > 0.0

## -1 signals an unlimited magazine (no HUD number to show).
func get_current_ammo() -> int:
	return _current_ammo

func get_magazine_size() -> int:
	return weapon_data.magazine_size if weapon_data else -1

## -1 signals unlimited reserve ammo.
func get_reserve_ammo() -> int:
	return _reserve_ammo

func get_max_reserve_ammo() -> int:
	return weapon_data.max_reserve_ammo if weapon_data else -1

func has_ammo() -> bool:
	return weapon_data == null or weapon_data.magazine_size < 0 or _current_ammo > 0

func can_fire() -> bool:
	return _cooldown_remaining <= 0.0 and not is_reloading() and has_ammo()

## Returns true if the given input state should attempt a shot, based on
## this weapon's fire mode (semi-auto fires once per press, automatic fires
## for as long as the trigger is held).
func wants_to_fire(is_pressed: bool, just_pressed: bool) -> bool:
	if weapon_data and weapon_data.fire_mode == WeaponData.FireMode.AUTOMATIC:
		return is_pressed
	return just_pressed

## Attempts to fire: applies the fire-rate cooldown and consumes ammo (if
## the weapon has a finite magazine). Returns true if the shot is allowed;
## returns false (a clean dry-fire, no state change) if on cooldown, out of
## ammo, or reloading.
func try_fire() -> bool:
	if not can_fire():
		return false
	if weapon_data:
		if weapon_data.fire_rate > 0.0:
			_cooldown_remaining = 1.0 / weapon_data.fire_rate
		if weapon_data.magazine_size >= 0:
			_current_ammo -= 1
	return true

func can_reload() -> bool:
	if weapon_data == null or weapon_data.magazine_size < 0:
		return false
	if is_reloading():
		return false
	if _current_ammo >= weapon_data.magazine_size:
		return false
	if weapon_data.reserve_ammo >= 0 and _reserve_ammo <= 0:
		return false
	return true

## Starts a reload if allowed. A magazine already full, an in-progress
## reload, or empty reserve ammo are all no-ops (returns false), which
## also prevents spamming the input to duplicate ammo. Blocks firing for
## `weapon_data.reload_time` seconds via `can_fire()`/`get_state()`.
func start_reload() -> bool:
	if not can_reload():
		return false
	_reload_remaining = max(weapon_data.reload_time, 0.0)
	if _reload_remaining <= 0.0:
		_finish_reload()
	return true

func _finish_reload() -> void:
	_reload_remaining = 0.0
	var needed: int = weapon_data.magazine_size - _current_ammo
	if weapon_data.reserve_ammo < 0:
		_current_ammo = weapon_data.magazine_size
	else:
		var take: int = min(needed, _reserve_ammo)
		_current_ammo += take
		_reserve_ammo -= take

## Adds ammo to reserve, capped at `max_reserve_ammo`. Not called by any
## gameplay system yet (there are no ammo pickups); provided so the
## architecture supports them without further changes to Weapon.
func add_reserve_ammo(amount: int) -> void:
	if weapon_data == null or weapon_data.reserve_ammo < 0 or amount <= 0:
		return
	_reserve_ammo += amount
	if weapon_data.max_reserve_ammo >= 0:
		_reserve_ammo = min(_reserve_ammo, weapon_data.max_reserve_ammo)

func play_muzzle_flash() -> void:
	muzzle_flash.restart()
	muzzle_flash.emitting = true

func play_fire_sound() -> void:
	gunshot_sound.play()
