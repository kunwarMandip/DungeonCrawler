extends Panel

var inventory: Inventory = null
var selected_slot: int = -1
var slot_nodes: Array = []

@onready var slot_grid: GridContainer = %SlotGrid
@onready var armor_slot_panel: Panel = %ArmorSlot
@onready var weapon_slot_panel: Panel = %WeaponSlot
@onready var tooltip: Panel = get_parent().get_node("Tooltip")

func setup(inv: Inventory) -> void:
	inventory = inv
	inventory.inventory_changed.connect(_rebuild_ui)
	
	slot_nodes = slot_grid.get_children()
	for i in slot_nodes.size():
		var slot = slot_nodes[i]
		var index := i
		slot.gui_input.connect(func(event): _on_slot_clicked(event, index))
		slot.mouse_entered.connect(func(): _show_tooltip(index))
		slot.mouse_exited.connect(_hide_tooltip)
	
	weapon_slot_panel.gui_input.connect(func(event): _on_equip_clicked(event, "weapon"))
	armor_slot_panel.gui_input.connect(func(event): _on_equip_clicked(event, "armor"))
	_rebuild_ui()
	
func _rebuild_ui() -> void:
	_update_bag_slots()
	#_update_equip_slots(weapon_slot_panel, inventory.weapon_slot_panel)
	#_update_equip_slots(armor_slot_panel, inventory.armor_slot)

func _update_bag_slots() -> void:
	for i in slot_nodes.size():
		var slot: Panel = slot_nodes[i]
		#var stack: ItemStack = inventory.slots[i]
		#var icon: ColorRect = slot.get_node("SlotIcon")
		#var qty: Label = slot.get_node("QuantityLabel")
		#if stack.is_empty():
			#icon.color = Color(0.08, 0.08, 0.12)
			#qty.text = ""
		#else:
			#icon.color = stack.item.color
			#qty.text = str(stack.quantity) if stack.quantity > 1 else ""
		var style := StyleBoxFlat.new()
		style.bg_color = Color(0.06, 0.06, 0.12)
		style.set_border_width_all(1)
		style.border_color = Color(0.78, 0.66, 0.32) \
			if i == selected_slot else Color(0.16, 0.16, 0.29)
		style.set_corner_radius_all(2)
		slot.add_theme_stylebox_override("panel", style)

func _update_equip_slots(slot_panel: Panel, item_stack: ItemStack) -> void:
	var icon: ColorRect = slot_panel.get_node("HBoxContainer/SlotIcon")
	var name_label: Label = slot_panel.get_node("HBoxContainer/Info/NameLabel")
	var stat_label: Label = slot_panel.get_node("HBoxContainer/Info/StatLabel")
	
	if item_stack.is_empty():
		name_label.text = "Empty"
		stat_label.text = ""
	else:
		icon.color = item_stack.item.color
		name_label.text = item_stack.item.display_name
		if item_stack.item.item_type == Item.Type.WEAPON:
			stat_label.text = "ATK +" + str(item_stack.item.attack_bonus)
		else:
			stat_label.text = "DEF +" + str(item_stack.item.defense_bonus)

func _on_slot_clicked(event: InputEvent, slot_index: int) -> void:
	if not event is InputEventMouseButton or not event.pressed:
		return
		
	if event.button_index == MOUSE_BUTTON_LEFT:
		if selected_slot == -1:
			if not inventory.slots[slot_index].is_empty():
				selected_slot = slot_index
		elif selected_slot == slot_index:
			selected_slot = -1
		else:
			inventory.swap_slots(selected_slot, slot_index)
			selected_slot = -1
		_rebuild_ui()
	elif event.button_index == MOUSE_BUTTON_RIGHT:
		if not inventory.slots[slot_index].is_empty():
			inventory.equip_from_bag(slot_index)
			selected_slot = -1
	
func _on_equip_clicked(event: InputEvent, slot_type: String) -> void:
	if not event is InputEventMouseButton or not event.pressed:
		return
	if event.button_index == MOUSE_BUTTON_RIGHT:
		var equip_stack := inventory.weapon_slot \
			if slot_type == "weapon" else inventory.armor_slot
		inventory.unequip_to_bag(equip_stack)

func _show_tooltip(slot_index: int) -> void:
	var stack := inventory.slots[slot_index]
	if stack.is_empty():
		return
	tooltip.get_node("TooltipMargin/TooltipContent/NameLabel").text = \
		stack.item.display_name
	tooltip.get_node("TooltipMargin/TooltipContent/DescLabel").text = \
		stack.item.description
	var stat := ""
	if stack.item.attack_bonus > 0:
		stat = "ATK +" + str(stack.item.attack_bonus)
	elif stack.item.defense_bonus > 0:
		stat = "DEF +" + str(stack.item.defense_bonus)
	tooltip.get_node("TooltipMargin/TooltipContent/StatLabel").text = stat
	tooltip.visible = true

func _hide_tooltip() -> void:
	tooltip.visible = false

func _process(_delta: float) -> void:
	if tooltip.visible:
		tooltip.global_position = \
			get_viewport().get_mouse_position() + Vector2(14, 14)
