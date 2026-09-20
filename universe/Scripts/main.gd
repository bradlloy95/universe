extends Node2D

# load particle scene
var particle_scene = preload("res://Scenes/particle.tscn")

var centre_screen : Vector2

var flash = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	centre_screen = get_viewport().get_visible_rect().size/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	flash = true
	queue_redraw()
	$FlashTimer.start()
	$Button.queue_free()
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

func _draw() -> void:
	if flash:
		draw_circle(centre_screen, 30, Color.WHITE)


func _on_flash_timer_timeout() -> void:
	flash = false
	queue_redraw()
