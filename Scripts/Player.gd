extends CharacterBody2D

@onready var animtree = $AnimationTree
@onready var animationState = animtree.get("parameters/playback")

enum player_states {MOVE, SWORD, JUMP, DEAD}
var current_states = player_states.MOVE

var input_movement = Vector2.ZERO
var speed = 70
var health = PlayerData.health

func _ready():
	$Sword/CollisionShape2D.disabled = true

func _physics_process(delta):
	match current_states:
		player_states.MOVE:
			move()
		player_states.SWORD:
			sword()
		player_states.JUMP:
			jump()
		player_states.DEAD:
			dead()

func move():
	input_movement = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')
	
	if input_movement != Vector2.ZERO:
		animtree.set("parameters/Idle/blend_position", input_movement)
		animtree.set("parameters/Walk/blend_position", input_movement)
		animtree.set("parameters/Sword/blend_position", input_movement)
		animtree.set("parameters/Jump/blend_position", input_movement)
		animationState.travel('Walk')
		velocity = input_movement * speed
	
	if input_movement == Vector2.ZERO:
		animationState.travel('Idle')
		velocity = Vector2.ZERO
		
	if Input.is_action_just_pressed("sword"):
		current_states = player_states.SWORD
	
	if Input.is_action_just_pressed("jump"):
		current_states = player_states.JUMP
	
	if PlayerData.health <= 0:
		current_states = player_states.DEAD
			
	move_and_slide()

func sword():
	animationState.travel("Sword")
	
func on_states_reset():
	current_states = player_states.MOVE

func jump():
	animationState.travel("Jump")
	velocity = input_movement * speed
	move_and_slide()
	
func dead():
	animationState.travel("Dead")
	await get_tree().create_timer(0.45).timeout
	PlayerData.health = 4
	get_tree().reload_current_scene()

func clear_collision():
	$CollisionShape2D.disabled = true
	
func create_collision():
	$CollisionShape2D.disabled = false
