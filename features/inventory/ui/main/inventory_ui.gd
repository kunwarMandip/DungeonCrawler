extends Panel

@onready var equipment_section: VBoxContainer = %EquipmentSection
@onready var bag_section: VBoxContainer = %BagSection

var inventory: Inventory = null

func setup(inv: Inventory) -> void:
	inventory = inv
	equipment_section.setup(inv)
	bag_section.setup(inv)
