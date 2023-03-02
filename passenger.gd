extends Area

var car_collision

var pickup_pos
var dropoff_pos
var time

signal picked_up
signal dropped_off

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("created")
	$Pickup.disabled = false
	$Pickup/MeshInstance.visible = true
	print(car_collision)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func place():
	print(pickup_pos)
	$Pickup.translate(pickup_pos)
	$Dropoff.translate(dropoff_pos)
	set_time()

func set_time():
	time = (pickup_pos - dropoff_pos).length() 

# https://docs.godotengine.org/en/3.5/classes/class_area.html?

func _on_Passenger_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print(self.shape_owner_get_owner(local_shape_index))
	if body.shape_owner_get_owner(body_shape_index) == car_collision:

		if self.shape_owner_get_owner(local_shape_index) == $Pickup:
			print("pickup")
			$Pickup.disabled = true
			$Pickup/MeshInstance.visible = false
			$Dropoff.disabled = false
			$Dropoff/MeshInstance.visible = true
			emit_signal("picked_up")
			
		if self.shape_owner_get_owner(local_shape_index) == $Pickup:
			print("dropoff")
			$Dropoff.disabled = true
			$Dropoff/MeshInstance.visible = false
			emit_signal("dropped_off")
