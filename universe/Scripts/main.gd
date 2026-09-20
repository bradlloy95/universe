extends Node2D

var particle_scene = preload("res://Scenes/particle.tscn")
var centre_screen : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	centre_screen = get_viewport().get_visible_rect().size/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	print(centre_screen)
	for i in range(100):
		
		var particle = particle_scene.instantiate()
		particle.position = centre_screen
		particle.velocity = Vector2(
			get_x_velocity(),
			get_y_velocity()
		)
		add_child(particle)

func get_x_velocity():
	return randf_range(-100.0, 100.0)

func get_y_velocity():
	return randf_range(-100.0, 100.0)
