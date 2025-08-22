extends MeshInstance3D

@export var tile_x_num : int
@export var tile_y_num : int

@onready var light = $SpotLight3D
var override_material = get_surface_override_material(0)
var status = 0
signal tile_change(tile_x_num, tile_y_num, status)

func _ready():
	set_surface_override_material(0, null)


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		if status == 0:
			set_surface_override_material(0, override_material)
			status = 1
			light.show()
			emit_signal("tile_change", tile_x_num, tile_y_num, status)
		else:
			set_surface_override_material(0, null)
			status = 0
			light.hide()
			emit_signal("tile_change", tile_x_num, tile_y_num, status)
