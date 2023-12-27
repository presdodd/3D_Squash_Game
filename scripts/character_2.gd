extends CharacterBody3D

signal hit

const SPEED = 14.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = 75
var target_velocity = Vector3.ZERO

# meters per second
@export var jump_impulse = 20
@export var squash_impulse = 16

func _physics_process(delta):
	
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (gravity * delta)

	var direction = Vector3.ZERO
	
	# handle inputs
	if Input.is_action_pressed("left_1"):
		direction.x -= 1
	if Input.is_action_pressed("right_1"):
		direction.x += 1
	if Input.is_action_pressed("down_1"):
		direction.z += 1
	if Input.is_action_pressed("up_1"):
		direction.z -= 1
	
	# Prevent diagonal moving fast af
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1
		
		
	# Ground Velocity
	target_velocity.x = direction.x * SPEED
	target_velocity.z = direction.z * SPEED
	
	if is_on_floor() and Input.is_action_just_pressed("jump_1"):
		target_velocity.y = jump_impulse
		
	# Iterate through all collisions that occurred this frame
	for i in range(get_slide_collision_count()):
		# get one of the collisions with the player
		var collision = get_slide_collision(i)
		
		# If collision is with the ground
		if collision.get_collider() == null:
			continue
		
		# if collider is with a mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# check that we are hitting it from above
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# Squash and bounce
				mob.squash()
				target_velocity.y = squash_impulse
				break

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("left_1", "right_1", "up_1", "down_1")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction.x > 0:
		#rotate_z(direction.z * 0.1)
		#rotate_y(direction.y * 0.1)
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#rotation.x = move_toward(rotation.x, 0, 0.1)
		#rotation.z = move_toward(rotation.z, 0, 0.1)
		#rotation.y = move_toward(rotation.y, 0, 0.1)
		#
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)

	velocity = target_velocity
	move_and_slide()
	# Jump arc animation
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

func die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(body):
	die()
