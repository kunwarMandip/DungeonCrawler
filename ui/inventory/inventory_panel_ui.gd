extends Panel

var slot_nodes: Array = []
var inventory: Inventory = null
var equip_panels: Dictionary[Item.Type, Panel] = {}

@onready var slot_grid: GridContainer = %SlotGrid
@onready var armor_slot_panel: Panel = %ArmorSlot
@onready var weapon_slot_panel: Panel = %WeaponSlot
@onready var tooltip: Panel = get_parent().get_node("Tooltip")

func setup(inv: Inventory) -> void:
	inventory = inv
	inventory.inventory_changed.connect(rebuild_ui)	
	
	slot_nodes = slot_grid.get_children()
	for i in slot_nodes.size():
		var slot = slot_nodes[i]
		var index := i
		slot.mouse_entered.connect(func(): _show_tooltip(index))
		slot.mouse_exited.connect(_hide_tooltip)
		slot.set_drag_forwarding(
			func(pos): return _get_slot_drag_data(index, pos),
			func(pos, data): return _can_drop_slot_data(index, pos, data),
			func(pos, data): _drop_slot_data(index, pos, data)
		)
	
	equip_panels = {
		Item.Type.WEAPON: weapon_slot_panel,
		Item.Type.ARMOR: armor_slot_panel
	}
	
	for equip_type in equip_panels:
		var panel := equip_panels[equip_type]
		panel.gui_input.connect(func(event):_on_equip_clicked(event, equip_type))
		
	rebuild_ui()
		
	#weapon_slot_panel.gui_input.connect(func(event): _on_equip_clicked(event, "weapon"))
	#armor_slot_panel.gui_input.connect(func(event): _on_equip_clicked(event, "armor"))

func _get_slot_drag_data(slot_index: int, _at_position: Vector2) -> Variant:
	var item: Item = inventory.slots[slot_index]
	if item.is_empty():
		return null
	
	var preview := ColorRect.new()
	preview.color = item.color
	preview.custom_minimum_size = Vector2(32, 32)
	set_drag_preview(preview)
	
	return {"slot_index": slot_index}
	
func _can_drop_slot_data(_slot_index: int, _at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("slot_index")

func _drop_slot_data(slot_index: int, _at_position: Vector2, data: Variant) -> void:
	inventory.swap_slots(data["slot_index"], slot_index)

	
func rebuild_ui() -> void:
	_update_bag_slots()
	for equip_type in equip_panels:
		_update_equip_slots(
			equip_panels[equip_type], inventory.equipped[equip_type]
		)
	#_update_equip_slots(weapon_slot_panel, inventory.weapon_slot)
	#_update_equip_slots(armor_slot_panel, inventory.armor_slot)

func _update_bag_slots() -> void:
	for i in slot_nodes.size():
		var slot: Panel = slot_nodes[i]
		
		var item: Item = inventory.slots[i]
		var icon: ColorRect = slot.get_node("MarginContainer/SlotIcon")
		if item.is_empty():
			icon.color = Color(0.08, 0.08, 0.12)
		else:
			icon.color = item.color
			#qty.text = str(item.quantity) if stack.quantity > 1 else ""
			
		var style := StyleBoxFlat.new()
		style.bg_color = Color(0.06, 0.06, 0.12)
		style.set_border_width_all(1)
		#style.border_color = Color(0.78, 0.66, 0.32) \
			#if i == selected_slot else Color(0.16, 0.16, 0.29)
		style.set_corner_radius_all(2)
		slot.add_theme_stylebox_override("panel", style)
		
func _update_equip_slots(slot_panel: Panel, item: Item) -> void:
	print("here")
	var slot_icon: ColorRect = slot_panel.get_node("MarginContainer/HBoxContainer/SlotIcon")
	var name_label: Label = slot_panel.get_node("MarginContainer/HBoxContainer/Info/NameLabel")
	var stat_label: Label = slot_panel.get_node("MarginContainer/HBoxContainer/Info/StatLabel")
	
	if item.is_empty():
		name_label.text = "Empty"
		stat_label.text = ""
	
	slot_icon.color = item.color
	name_label.text = item.display_name
	if item.item_type == Item.Type.WEAPON:
		stat_label.text = "ATK +" + str(item.attack_bonus)
		return

	
func _on_equip_clicked(event: InputEvent, equip_type: Item.Type) -> void:
	if not event is InputEventMouseButton or not event.pressed:
		return
		
	if event.button_index == MOUSE_BUTTON_RIGHT:
		inventory.equip_from_bag(equip_type)

func _show_tooltip(slot_index: int) -> void:
	var item := inventory.slots[slot_index]
	if item.is_empty():
		return
		
	tooltip.get_node("MarginContainer/VBoxContainer/NameLabel").text = item.display_name
	tooltip.get_node("MarginContainer/VBoxContainer/DescLabel").text = item.description
	var stat := ""
	if item.attack_bonus > 0:
		stat = "ATK +" + str(item.attack_bonus)
	elif item.defense_bonus > 0:
		stat = "DEF +" + str(item.defense_bonus)
	tooltip.get_node("MarginContainer/VBoxContainer/StatLabel").text = stat
	tooltip.visible = true
	
func _hide_tooltip() -> void:
	tooltip.visible = false

func _process(_delta: float) -> void:
	if tooltip.visible:
		tooltip.global_position = get_viewport().get_mouse_position() + Vector2(14, 14)
