extends Area2D

var speed = 10
var direction = Vector2.ZERO
var is_in_attack_range = false
var damage = 10
@onready var target = $"../Player"

func _process(_delta):
	
	if is_in_attack_range:
		target.take_damage(damage)


func _physics_process(_delta):
	position += direction * speed

func _on_area_2d_body_entered(_body):
	is_in_attack_range = true
	
func _on_area_2d_body_exited(_body):
	is_in_attack_range = false
