extends Node2D

export var force: float
export var torque: float

func _ready() -> void:
	call_deferred("start")

func start() -> void:
	randomize()
	print("HEY")
	var random_angle = rand_range(0.0, 2.0 * PI)
	print("BANANA", random_angle)
	var random_dir = Vector2.UP.rotated(random_angle)
	
	#$Rock1s1.linear_velocity = random_dir * force
	#$Rock1s1.angular_velocity = torque
	$Rock1s1.connect("body_entered", self, "_collide")
	$Rock1s2.connect("body_entered", self, "_collide")
	$Rock1s1.add_to_group("rock")
	$Rock1s2.add_to_group("rock")

func _crack():
	$Rock1s1/PinJoint2D.queue_free()
	$Rock1s1/PinJoint2D2.queue_free()
	$Rock1s1.disconnect("body_entered", self, "_collide")
	$Rock1s2.disconnect("body_entered", self, "_collide")

func _collide(body: Node) -> void:
	_crack()
