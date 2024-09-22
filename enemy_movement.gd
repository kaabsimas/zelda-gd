extends CharacterBody2D
class_name enemy_movement

var current_state
var direction
enum enemy_states {RIGHT, LEFT, UP, DOWN}

@export var speed = 10

func _physics_process(delta):
	match current_state:
		enemy_states.RIGHT:
			move_right()
		enemy_states.LEFT:
			move_left()
		enemy_states.UP:
			move_up()
		enemy_states.DOWN:
			move_down()
	move_and_slide()
	
func random_generation():
	direction = randi() % 4 + 1
	random_direction()

func random_direction():
	match direction:
		0:
			current_state = enemy_states.RIGHT
		1:
			current_state = enemy_states.LEFT
		2:
			current_state = enemy_states.UP
		3: 
			current_state = enemy_states.DOWN

func move_right():
	velocity = Vector2.RIGHT * speed
	$AnimationPlayer.play('move_right')
	
func move_left():
	velocity = Vector2.LEFT * speed
	$AnimationPlayer.play('move_left')
	
func move_up():
	velocity = Vector2.UP * speed
	$AnimationPlayer.play('move_up')
	
func move_down():
	velocity = Vector2.DOWN * speed
	$AnimationPlayer.play('move_down')
