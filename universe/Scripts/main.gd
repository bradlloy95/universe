extends Node2D

# load particle scene
var particle_scene = preload("res://Scenes/particle.tscn")
@export var particles_created := 150

var centre_screen := Vector2(576, 324)

var flash = false

@export var gravity_strength = 500.0
@export var minimum_gravity_distance = 100.0
@export var collision_temperature := 950.0
@export var collision_heat := 50.0


var collision_detection_enabled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#centre_screen = get_viewport().get_visible_rect().size/2
	print(gravity_strength)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var particles = $Particles.get_children()
	if particles.size() > 0:
		var centre_of_mass = get_centre_of_mass(particles)
		$Camera2D.position = $Camera2D.position.lerp(centre_of_mass, 2.0 * delta)
	
	for i in range(particles.size()):
		for j in range(i + 1, particles.size()):
			calculate_gravity(particles[i], particles[j])
			
			if particles[i].merging or particles[j].merging:
				continue
			
			if particles_are_touching(particles[i],particles[j]):
				if particles[i].temperature < collision_temperature and particles[j].temperature < collision_temperature:
					particles[i].merging = true
					particles[j].merging = true 
					
					merge_particles(particles[i], particles[j])
				


func _on_button_pressed() -> void:
	flash = true
	queue_redraw()
	$FlashTimer.start()
	$Button.queue_free()
	for i in range(particles_created):
		
		var particle = particle_scene.instantiate()
		particle.position = get_start_position()
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

func get_start_position():
	return centre_screen + Vector2.from_angle(randf() * TAU) * randf_range(0.0, 100.0)
func _draw() -> void:
	if flash:
		draw_circle(centre_screen, 50, Color.WHITE)

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

func particles_are_touching(particle_a, particle_b):
	var distance = particle_a.position.distance_to(particle_b.position)
	
	return distance < particle_a.radius + particle_b.radius

func merge_particles(particle_A, particle_B):
	var new_particle = particle_scene.instantiate()
	new_particle.position = (particle_A.position + particle_B.position)/ 2.0
	new_particle.mass = particle_A.mass + particle_B.mass
	new_particle.temperature = (particle_A.temperature + particle_B.temperature) / 2.0 + collision_heat
	#new_particle.radius = sqrt(new_particle.mass) * 4.0
	new_particle.velocity = (
		particle_A.velocity * particle_A.mass + 
		particle_B.velocity * particle_B.mass) / new_particle.mass
	$Particles.add_child(new_particle)
	
	particle_A.queue_free()
	particle_B.queue_free()
	
func get_centre_of_mass(particles):
	var total_mass = 0.0
	var weightrd_position = Vector2.ZERO
	
	for particle in particles:
		total_mass += particle.mass
		weightrd_position += particle.position * particle.mass
		
	
	if total_mass == 0:
		return Vector2.ZERO
	
	return weightrd_position / total_mass
