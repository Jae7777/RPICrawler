extends Area2D

signal damage_taken()
signal on_death()
const MOVE_SPEED = 300
var move_direction = Vector2()
var target = null
var max_health = 30
var current_health = max_health
var damage = 10
var can_attack
var heart_crystal_scene: PackedScene = preload("res://Scenes/heart_crystal.tscn")
var is_in_attack_range = false

func _ready():
	target = $"../../Player"
	can_attack = true

func with_data(size):
	match size:
		0:
			current_health = 10
			scale = Vector2(0.33, 0.33)
		1:
			current_health = 20
			scale =  Vector2(0.66, 0.66)
		2:
			current_health = 30
			scale =  Vector2(1, 1)
		_:
			current_health = 20
	return self
	
func _process(delta):
	var target_position = target.get_position()
	var velocity = (target_position - get_position()).normalized() * MOVE_SPEED
	position += velocity * delta
	if current_health <= 0:
		var heart_crystal = heart_crystal_scene.instantiate().with_data(position)
		$"../../Objects".add_child(heart_crystal)
		$"..".queue_free()
		
	if can_attack and is_in_attack_range:
		can_attack = false
		target.take_damage(damage)
		$Timers/DamageTimer.start()

func take_damage(amount):
	current_health -= amount
	damage_taken.emit()
	print(current_health)
	

func _on_body_entered(_body):
	is_in_attack_range = true
	print("entered")

func _on_body_exited(_body):
	is_in_attack_range = false


func _on_damage_timer_timeout():
	can_attack = true
