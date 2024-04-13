extends AnimatedSprite2D

var animation_timer = null
var can_attack

func _ready():
	animation_timer = $"../../TImers/AttackTimer"
	can_attack = true
	
func _process(_delta):
	if Input.is_action_just_pressed("PrimaryAction") and can_attack:
		animation_timer.start()
		can_attack = false
		play("Swing")


func _on_timer_timeout():
	can_attack = true
	stop()
