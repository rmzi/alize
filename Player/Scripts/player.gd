class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

const DEADZONE : float = 0.2
const DIAGONAL_THRESHOLD : float = 0.4

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine

func _ready():
	state_machine.Initialize(self)
	pass

func _process(delta):
	
	direction = Vector2(
		Input.get_axis("left","right"),
		Input.get_axis("up","down")
	).normalized()
	
	pass
	
func _physics_process(delta):
	move_and_slide()

func SetDirection() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	var new_dir : Vector2
	var is_horizontal = abs(direction.x) > DIAGONAL_THRESHOLD
	var is_vertical = abs(direction.y) > DIAGONAL_THRESHOLD
	
	if is_horizontal and is_vertical:
		new_dir = Vector2(sign(direction.x), sign(direction.y))
	elif is_horizontal:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif is_vertical:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	else:
		return false
	
	if new_dir == cardinal_direction:
		return false
		
	cardinal_direction = new_dir
	sprite.scale.x = -1 if cardinal_direction.x < 0 else 1
	return true

func UpdateAnimation( state: String) -> void:
	animation_player.play(state + "_" + AnimDirection())

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	elif cardinal_direction.x != 0 and cardinal_direction.y == 0:
		return "side"
	elif cardinal_direction.y < 0:
		return "up_side"
	else:
		return "down_side"
