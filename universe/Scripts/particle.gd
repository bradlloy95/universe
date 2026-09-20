extends Node2D

var velocity = Vector2.ZERO
var mass := 1.0
var touching = false
var merging = false
@export var temperature := 1000.0
@export var radius := 4.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()
	
func _process(delta: float) -> void:
	position += velocity * delta
	temperature -= 15.0 * delta / mass
	queue_redraw()
	

func _draw() -> void:
	var heat = clamp(temperature / 1000.0, 0.0, 1.0)
	
	var particle_color : Color
	
	if heat > 0.75:
		particle_color = Color(1.0,1.0,1.0).lerp(Color(1.0,0.5,0.0), (1.0 - heat) / 0.25)
	elif heat > 0.5:
		particle_color = Color(1.0,0.5,0.0).lerp(Color(1.0,0.0,0.0), (0.75 - heat) / 0.25)
	elif heat > 0.25:
		particle_color = Color(1.0,0.0,0.0).lerp(Color(0.4,0.0,0.0), (0.5 - heat) / 0.25)
	else:
		particle_color = Color(0.4,0.0,0.0).lerp(Color(0.05,0.05,0.05), (0.25 - heat) / 0.25)
		
		
	var size = radius 
	
	if touching:
		print("touching")
		size = radius * 1.5
	draw_circle(Vector2.ZERO, size, particle_color)

func apply_force(force: Vector2):
	velocity += force
