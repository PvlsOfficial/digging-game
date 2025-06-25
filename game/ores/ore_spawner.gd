extends Area3D

@onready var spawn_area = $CollisionShape3D
@export var amount = 1000

func _ready():
	#spawn_ores_v1(amount)
	spawn_ores_v2(amount, Singleton.seed) # zum Testen

func spawn_ores_v1(count):
	var ore_scenes = {
		"stone" : "res://ores/stone.tscn",
		"iron" : "res://ores/iron.tscn",
		"gold" : "res://ores/gold.tscn"
		}
	var shape = spawn_area.shape
	if shape is BoxShape3D:
		var extents = shape.size * 0.5
		var area_transform = spawn_area.global_transform
		for i in range(count):
			var ore_scene_path = ore_scenes.values().pick_random()
			var ore_scene = load(ore_scene_path)
			var instance = ore_scene.instantiate()
			var local_rand_pos = Vector3(
				randf_range(-extents.x, extents.x),
				randf_range(-extents.y, extents.y),
				randf_range(-extents.z, extents.z)
			)
			instance.position = area_transform.origin + local_rand_pos
			add_child(instance)

func spawn_ores_v2(count, seed = null):
	var rng = RandomNumberGenerator.new()
	if seed != null:
		rng.seed = seed
	else:
		rng.randomize()
	
	var ore_scene_paths = [
		"res://ores/stone.tscn",
		"res://ores/iron.tscn",
		"res://ores/gold.tscn"
	]
	var ores = []
	for path in ore_scene_paths:
		var ore_scene = load(path)
		var temp_inst = ore_scene.instantiate()
		var resource = temp_inst.ore_resource
		if resource:
			ores.append({
				"scene": ore_scene,
				"resource": resource
			})
		temp_inst.queue_free()

	var shape = spawn_area.shape
	if shape is BoxShape3D:
		var extents = shape.size * 0.5
		var area_transform = spawn_area.global_transform

		var total_rarity = 0.0
		for ore in ores:
			total_rarity += ore.resource.rarity

		for i in range(count):
			var rnd = rng.randf() * total_rarity
			var accum = 0.0
			var chosen = ores[0]
			for ore in ores:
				accum += ore.resource.rarity
				if rnd <= accum:
					chosen = ore
					break

			var min_y = chosen.resource.min_y
			var max_y = chosen.resource.max_y

			var local_rand_pos = Vector3(
				rng.randf_range(-extents.x, extents.x),
				rng.randf_range(
					clamp(min_y, -extents.y, extents.y),
					clamp(max_y, -extents.y, extents.y)
				),
				rng.randf_range(-extents.z, extents.z)
			)
			var instance = chosen.scene.instantiate()
			instance.position = area_transform.origin + local_rand_pos
			add_child(instance)
