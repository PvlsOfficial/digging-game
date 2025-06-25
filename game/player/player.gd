extends CharacterBody3D

@export var voxel_terrain: VoxelTerrain
@onready var voxel_tool = voxel_terrain.get_voxel_tool()
@onready var dig_cast: RayCast3D = $Camera3D/RayCast3D

const SPEED  = 5.0
const JUMP_VELOCITY = 4.5

func _ready():
	# SQLite Cache aktivieren
	var stream := voxel_terrain.stream
	if stream is VoxelStreamSQLite:
		stream.set_key_cache_enabled(true)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
	if Input.is_action_just_pressed("dig"):
		var dig_pos
		if dig_cast.is_colliding():
			var collider = dig_cast.get_collider()
			if collider.is_in_group("ore"):
				collider.pickup()
				return
			dig_pos = dig_cast.get_collision_point()
			voxel_tool.mode = VoxelTool.MODE_REMOVE
			voxel_tool.do_sphere(dig_pos * 5, 1 * Singleton.shovel_level)
			voxel_terrain.save_modified_blocks()

func _unhandled_input(event):
	if event.is_action_pressed("sell"):
		Singleton.sell()
