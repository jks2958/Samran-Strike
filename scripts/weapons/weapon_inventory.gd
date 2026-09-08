class_name WeaponInventory
extends RefCounted

## Tracks which Weapon is equipped in which slot and which slot is active.
## This composes with the Weapon/WeaponData architecture from Phase 2
## rather than replacing it: this class never stores weapon stats or ammo
## itself, only references to Weapon nodes and which slot is selected.
##
## Only PRIMARY is populated for now (the pistol). SECONDARY and MELEE
## exist so a future weapon can be equipped into them without any changes
## to this class or to how the player queries its current weapon.

enum Slot {
	PRIMARY,
	SECONDARY,
	MELEE,
}

var _weapons: Dictionary = {}
var _current_slot: int = -1

func equip_weapon(slot: Slot, weapon: Weapon) -> void:
	_weapons[slot] = weapon
	if _current_slot == -1:
		_current_slot = slot

func unequip_weapon(slot: Slot) -> void:
	_weapons.erase(slot)
	if _current_slot == slot:
		_current_slot = -1

## Switches to the given slot if it holds a weapon. Returns false (and
## leaves the current weapon equipped) if the slot is empty, or if the
## current weapon is mid-reload -- the architecture doesn't yet support
## safely cancelling a reload in progress.
func switch_weapon(slot: Slot) -> bool:
	if not _weapons.has(slot):
		return false
	var current: Weapon = get_current_weapon()
	if current and current.is_reloading():
		return false
	_current_slot = slot
	return true

func get_current_weapon() -> Weapon:
	if _current_slot == -1:
		return null
	return _weapons.get(_current_slot)

func get_current_slot() -> int:
	return _current_slot

func has_weapon(slot: Slot) -> bool:
	return _weapons.has(slot)
