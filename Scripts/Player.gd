extends CharacterBody2D

signal player_attack(area)
signal damage_taken()
signal healing()
signal player_death()
signal dash()
var dash_distance = 200
var SPEED = 400
var face_direction = Vector2()
var is_vulnerable
var max_health = 100
var current_health = max_health
var fireball_scene = preload("res://windslash.tscn")
var can_dash = true

func _ready():
	is_vulnerable = true
	
func _process(_delta):
	get_input(face_direction)
	set_velocity(velocity)
	move_and_slide()
	
	if Input.is_action_just_pressed("Dash") and can_dash:
		can_dash = false
		dash.emit()
		position += get_global_mouse_position().normalized() * dash_distance
		#position += get_global_mouse_position().normalized() * dash_distance
		$TImers/DashTimer.start()
		$PlayerAnimation/Dash.play()
	if Input.is_action_just_pressed("PrimaryAction"):
		$PlayerAnimation/Sword.play()
		var fireball = fireball_scene.instantiate().with_data($PlayerAnimation/Marker2D.global_position, get_global_mouse_position())
		$"../Projectiles".add_child(fireball)


func get_input(direction):
	direction = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
	velocity = direction * SPEED
	return direction != Vector2.ZERO

func heal(amount):
	current_health += amount
	healing.emit()
	if current_health > max_health:
		current_health = max_health

func take_damage(amount):
	$PlayerAnimation/OOF.play();
	current_health -= amount
	print("taking damage")
	damage_taken.emit()
	if current_health <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://game_death.tscn")

func _on_hit_timer_timeout():
	is_vulnerable = true
	
func _on_dash_timer_timeout():
	SPEED = 400
	can_dash = true
