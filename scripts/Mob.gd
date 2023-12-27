extends CharacterBody3D

# Minimum speed of the mob in meters per second.
@export var minSpeed = 10
# Maximum speed of the mob in meters per second.
@export var maxSpeed = 18

signal squashed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	move_and_slide()
	
func initialize(startPosition, playerPosition):
		# We position the mob by placing it at start_position
		# and rotate it towards player_position, so it looks at the player.
		look_at_from_position(startPosition, playerPosition, Vector3.UP)
		# Rotate this mob randomly within range of -45 and +45 degrees,
		# so that it doesn't move directly towards the player.
		rotate_y(randf_range(-PI / 4, PI / 4))
		
		# calculate a random speed
		var randomSpeed = randi_range(minSpeed, maxSpeed)
		# calculate a forward velocity that represents the speed
		velocity = Vector3.FORWARD * randomSpeed
		# calculate a foreward velocity based on the mob's Y rotation
		# in order to move in the direction the mob is looking
		velocity = velocity.rotated(Vector3.UP, rotation.y)
		
		$AnimationPlayer.speed_scale = randomSpeed / minSpeed
		
		

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
	
func squash():
	squashed.emit()
	queue_free()
