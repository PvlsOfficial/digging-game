extends Area3D
class_name Ore

signal picked_up

@export var ore_resource : OreResource

func _ready():
	picked_up.connect(get_tree().get_first_node_in_group("ui").update_inventory_ui)

func pickup():
	if not Singleton.is_inventory_full():
		Singleton.add_to_inventory(ore_resource)
		picked_up.emit()
		queue_free()
