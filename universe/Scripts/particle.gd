extends Node2D

var velocity = Vector2.ZERO
var mass := 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()
func _process(delta: float) -> void:
	position += velocity * delta

func _draw() -> void:
	draw_circle(Vector2.ZERO, 4, Color.WHITE)

func apply_force(force: Vector2):
	velocity += force
