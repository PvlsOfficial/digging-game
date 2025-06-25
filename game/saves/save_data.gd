# SaveData.gd
extends Resource
class_name SaveData

@export var shovel_level: int = 1
@export var max_inventory_size: int = 5
@export var inventory: Array[OreResource] = []
@export var money: int = 0
