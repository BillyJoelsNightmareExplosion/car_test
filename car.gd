extends VehicleBody

export var engine_power = 400
export var turn_sensitivity = 0.05
export var turn_limit = 0.75

var rear_wheels_rpm = 0
var turn_input = 0
var engine_output = 0

var rotation_last = Vector3(0,0,0)
var last_quat = Quat(0,0,0,0)

var camera_turn_rot = Vector3(0,0,0)
var camera_follow_quat = Quat(0,0,0,1)
var change_quat = Quat(0,0,0,1)

export var camera_sensitivity = 0.003

var reset_pivot = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rear_wheels_rpm = $wheel_DR.get_rpm() + $wheel_PR.get_rpm()
	
	brake = 0
	engine_force = 0
	turn_input = 0
	
	engine_output = engine_power
	
	if Input.is_action_pressed("forward"):
		if rear_wheels_rpm < 0:
			engine_force = 0
			brake = 2
		else:
			engine_force = engine_output

	if Input.is_action_pressed("backward"):
		if rear_wheels_rpm > 0:
			engine_force = 0
			brake = 2
		else:
			engine_force = engine_output * -1
		
		# print(String($wheel_DR.get_rpm()) + " " + String($wheel_PR.get_rpm()))

	if Input.is_action_pressed("turn_left"):
		turn_input += 1
	if Input.is_action_pressed("turn_right"):
		turn_input -= 1

	if turn_input != 0:
		steering = clamp(steering + turn_input * turn_sensitivity, -1 * turn_limit, turn_limit)
	else:
		steering /= 2

	camera_follow_quat = camera_follow_quat.slerp(Quat(0,0,0,1), 0.3)
	camera_follow_quat *= Quat(transform.basis) * last_quat.inverse()
	last_quat = Quat(transform.basis)

	if reset_pivot: 
		camera_turn_rot *= lerp( 1, 0.9, clamp(rear_wheels_rpm / 1000, 0, 1))
		if camera_turn_rot == Vector3(0,0,0):
			reset_pivot = false

	$camera_pivot.transform = Transform(Quat(camera_turn_rot) * camera_follow_quat)

func _input(event):
	if event is InputEventMouseMotion:
		reset_pivot = false
		camera_turn_rot.x = clamp(camera_turn_rot.x - event.relative.y * camera_sensitivity, -0.2, 1)
		camera_turn_rot.y = (event.relative.x * camera_sensitivity) * -1 + camera_turn_rot.y
		
		$camera_pivot/reset_pivot.start()
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_ESCAPE:
			get_tree().quit()
	
	if event.is_action_pressed("handbrake"): 
		$wheel_DR.wheel_friction_slip = 5
		$wheel_PR.wheel_friction_slip = 5
	if event.is_action_released("handbrake"): 
		$wheel_DR.wheel_friction_slip = 10.5
		$wheel_PR.wheel_friction_slip = 10.5

func _on_reset_pivot_timeout():
	reset_pivot = true
