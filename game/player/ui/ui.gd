extends Control

@onready var inventory = $Inventory
@onready var label_container = $Inventory/Panel/MarginContainer/Inventory/Inventory2/VBoxContainer
@onready var total_value_label = $Inventory/Panel/MarginContainer/Inventory/TotalValue
@onready var inventory_slots_label = $Inventory/Panel/MarginContainer/Inventory/InventorySlots
@onready var money = $MarginContainer/VBoxContainer/Money
@onready var shovel_level = $MarginContainer/VBoxContainer/ShovelLevel
@onready var max_inventory_size = $MarginContainer/VBoxContainer/MaxInventorySize

func _ready():
	inventory.hide()
	update_inventory_slots()
	update_total_value()
	update_money()

func _unhandled_input(event):
	if event.is_action_pressed("inventory"):
		inventory.show()
	if event.is_action_released("inventory"):
		inventory.hide()

func update_inventory_ui():
	for i in label_container.get_children():
		i.queue_free()
	for i in Singleton.inventory:
		var label = Label.new()
		label.text = i.ore_name + " " + str(i.ore_value) + " $"
		label_container.add_child(label)
	update_inventory_slots()
	update_total_value()
	update_money()

func update_inventory_slots():
	inventory_slots_label.text = str(Singleton.inventory.size()) + " / " + str(Singleton.max_inventory_size)

func update_total_value():
	var total_value = 0
	for i in Singleton.inventory:
		total_value += i.ore_value
	total_value_label.text = "Total Value: " + str(total_value)

func update_money():
	money.text = "Money: " + str(Singleton.money) + " $"
	shovel_level.text = "Shovel Level: " + str(Singleton.shovel_level)
	max_inventory_size.text = "Max inventory size: " + str(Singleton.max_inventory_size)
