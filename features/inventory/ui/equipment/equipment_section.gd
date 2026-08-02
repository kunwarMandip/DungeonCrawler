extends VBoxContainer

@onready var weapon_slot: Panel = %WeaponSlot
@onready var armor_slot: Panel = %ArmorSlot

var inventory: Inventory = null

func setup(inv: Inventory) -> void:
	inventory = inv
	if not inventory.inventory_changed.is_connected(rebuild_ui):
		inventory.inventory_changed.connect(rebuild_ui)
	
	weapon_slot.gui_input.connect(func(e):_on_equip_clicked(e, "weapon"))
