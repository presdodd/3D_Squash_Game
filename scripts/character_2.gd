extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (gravity * delta)

	var direction = Vector3.ZERO
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# handle other inputs
	if Input.is_action_pressed("left_1"):
		direction.x -= 1
	if Input.is_action_pressed("right_1"):
		direction.x += 1
	if Input.is_action_pressed("down_1"):
		direction.z += 1
	if Input.is_action_pressed("up_1"):
		direction.z -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)
		
		
	# Ground Velocity
	target_velocity.x = direction.x * SPEED
	target_velocity.z = direction.z * SPEED
	
	
	velocity = target_velocity
	
	

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

	move_and_slide()
