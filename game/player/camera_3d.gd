extends Camera3D

@export var mouse_sensitivity := 0.002
var rotation_x := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# Vertical rotation (pitch) on the camera
		rotation_x = clamp(rotation_x - event.relative.y * mouse_sensitivity, deg_to_rad(-89), deg_to_rad(89))
		rotation.x = rotation_x

		# Horizontal rotation (yaw) on the parent (CharacterBody3D)
		if get_parent() is CharacterBody3D:
			get_parent().rotate_y(-event.relative.x * mouse_sensitivity)

func _input(event):
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
