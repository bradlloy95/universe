extends Node2D

# load particle scene
var particle_scene = preload("res://Scenes/particle.tscn")
@export var particles_created := 100

var centre_screen : Vector2

var flash = false

@export var gravity_strength = 1000.0
@export var minimum_gravity_distance = 100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	centre_screen = get_viewport().get_visible_rect().size/2
	print(gravity_strength)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var particles = $Particles.get_children()
	
	for i in range(particles.size()):
		for j in range(i + 1, particles.size()):
			calculate_gravity(particles[i], particles[j])


func _on_button_pressed() -> void:
	flash = true
	queue_redraw()
	$FlashTimer.start()
	$Button.queue_free()
	for i in range(particles_created):
		
		var particle = particle_scene.instantiate()
		particle.position = centre_screen
		particle.velocity = get_velocity()
		particle.mass = get_rand_mass()
		$Particles.add_child(particle)


#=============== particle functions =====================
func get_velocity():
	return Vector2(
		randf_range(-100.0, 100.0),
		randf_range(-100.0, 100.0)
	)

func get_rand_mass():
	return randf_range(0.5, 2.0)

func _draw() -> void:
	if flash:
		draw_circle(centre_screen, 30, Color.WHITE)

func _on_flash_timer_timeout() -> void:
	flash = false
	queue_redraw()

# ===================== PhYSICS ========================

func calculate_gravity(particle_a, particle_b):
	var direction = particle_b.position - particle_a.position
	var distance = direction.length()
	
	# if too close do nothing as will be too strong
	if distance < minimum_gravity_distance:
		return 
	
	# bigger masses = stronger gravity
	# greater distamce  = weaker gravity
	var force = gravity_strength * particle_a.mass * particle_b.mass / (distance* distance)
	
	# direction.normalized() gives vector pointing towards b with len of exact 1
	var gravity_force = direction.normalized() * force
	
	# we divide by A's mass because:
	# force = mass x acceleration
	# therefore:
	#acceleration = force / mass
	particle_a.apply_force(gravity_force / particle_a.mass)
	# we add minus so its pulled towards A
	particle_b.apply_force(-gravity_force / particle_b.mass)
