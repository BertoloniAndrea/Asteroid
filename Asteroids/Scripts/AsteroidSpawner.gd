extends Node
class_name AsteroidSpawner


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var safe_margin = 100.0
export (float, 0, 180) var distance_factor = 15
var asteroid_scene := preload("res://Scenes/AsteroidScene.tscn")
var asteroid_textures_locations := [
						"res://Assets/Asteroid/Asteroid1.png",
						"res://Assets/Asteroid/Asteroid2.png",
						"res://Assets/Asteroid/Asteroid3.png"
						]
var asteroid_textures := []
var viewport
var rng = RandomNumberGenerator.new()

const Utils = preload("res://Scripts/Utils/AsteroidSize.gd")


# Called when the node enters the scene tree for the first time.
func _ready():
	viewport = get_viewport().size
	for texture_location in asteroid_textures_locations:
		asteroid_textures.append(load(texture_location))
	for i in range(10):
		generate_random_asteroid()

func generate_random_asteroid():
	var asteroid = asteroid_scene.instance() as Asteroid
	while true:
		#var player_position = get_tree().root.get_node("Player").position
		var x = rng.randi_range(0, viewport.x)
		var y = rng.randi_range(0, viewport.y)
		var asteroid_position = Vector2(x, y)
		
		if (true):#asteroid_position.distance_to(player_position) > safe_margin):
			spawn_asteroid(AsteroidSize.AsteroidSize.NORMAL, asteroid_position, get_random_rotation(), get_random_texture(asteroid_textures))
			#asteroid.set_texture(asteroid_texture)
			#add_child(asteroid)
			break
			
func get_random_texture(textures) -> Texture:
	var asteroid_texture_index = rng.randi() % asteroid_textures.size()
	var asteroid_texture = asteroid_textures[asteroid_texture_index]
	return asteroid_texture
	
func get_random_rotation() -> float:
	return randf() * 60

func spawn_asteroid(size, position: Vector2, rotation, texture: Texture):
	var asteroid = asteroid_scene.instance() as Asteroid
	var asteroid_sprite = asteroid.get_node("Sprite")
	var scale_value = size + 1.0
	asteroid.position = position
	asteroid.rotation = randf() * 2 * PI
	asteroid.rotation_factor = randf() * 60
	asteroid.set_texture(texture)
	asteroid.scale_value = size
	asteroid.connect("on_asteroid_destroyed", self, "on_asteroid_destroyed")
	#asteroid.get_node("Sprite").scale = Vector2(, )
	add_child(asteroid)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func on_asteroid_destroyed(size, position: Vector2, rotation):
	spawn_asteroid(size, position, rotation + (distance_factor * PI / 180), get_random_texture(asteroid_textures))
	spawn_asteroid(size, position, rotation - (distance_factor * PI / 180), get_random_texture(asteroid_textures))
	pass