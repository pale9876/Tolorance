extends Sprite2D


var surface_image: Image = Image.new()
var particle_img: Image = Image.new()

var surface_texture: ImageTexture = ImageTexture.new()

var particle_sz: Vector2


func _ready() -> void:
	
	surface_image = Image.create(2000, 2000, false, Image.FORMAT_RGBA8)
	surface_image.fill(Color(0, 0, 0, 0))
	
	particle_img.load("res://SampleSplatterSystem/Blood.png")
	particle_img.convert(Image.FORMAT_RGBA8)
	particle_sz = particle_img.get_size()


func _physics_process(delta: float) -> void:
	texture = ImageTexture.create_from_image(surface_image)


func draw_blood(draw_pos: Vector2):
	surface_image.blit_rect(particle_img, Rect2i(Vector2(0, 0), particle_sz), draw_pos)
