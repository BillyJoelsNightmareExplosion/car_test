extends Area

var rng = RandomNumberGenerator.new()

onready var car_collision = $car/body_col

export(PackedScene) var passenger_scene

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_passenger()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawn_passenger():
	
	var passenger = passenger_scene.instance()
	
	passenger.car_collision = car_collision
	
	var rng = RandomNumberGenerator.new()
	
	rng.randomize()
	print(rng.randf_range(-10.0, 10.0))
	
	passenger.pickup_pos = Vector3(rng.randf_range(-50.0, 50.0), -15, rng.randf_range(-50.0, 50.0))
	passenger.dropoff_pos = Vector3(rng.randf_range(-50.0, 50.0), -15, rng.randf_range(-50.0, 50.0))

	passenger.place()
	
	add_child(passenger)
