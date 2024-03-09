extends StaticBody2D


func _ready():
	if randf() > 0.95:
		$Sprite/Mask/Crash.visible = true
		$Sprite/Mask/Sky.visible = false
