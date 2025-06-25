extends Node

var seed = 123
var shovel_level = 1
var max_inventory_size = 5


var inventory : Array[OreResource] = []
var money : int = 0

signal sold

func _ready():
	sold.connect(get_tree().get_first_node_in_group("ui").update_inventory_ui)
	load_game()

func update_money(amount):
	money += amount

func sell():
	if not inventory.is_empty():
		for ore_resource in inventory:
			update_money(ore_resource.ore_value)
		inventory.clear()
		sold.emit()
		save_game()

func add_to_inventory(ore_resource : OreResource):
	inventory.append(ore_resource)
	print(inventory)

func is_inventory_full():
	if inventory.size() >= max_inventory_size:
		return true
	return false

# "user://save.tres"
func save_game(path: String = "res://saves/save.tres"):
	var save_data = SaveData.new()
	save_data.shovel_level = shovel_level
	save_data.max_inventory_size = max_inventory_size
	save_data.inventory = inventory.duplicate(true) # Deep copy
	save_data.money = money
	ResourceSaver.save(save_data, path)

func load_game(path: String = "res://saves/save.tres"):
	if not ResourceLoader.exists(path):
		return # No save file
	var save_data = ResourceLoader.load(path)
	if save_data:
		shovel_level = save_data.shovel_level
		max_inventory_size = save_data.max_inventory_size
		inventory = save_data.inventory.duplicate(true)
		money = save_data.money
