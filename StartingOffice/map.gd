extends MeshInstance3D

@onready var map  = $MapUI
@onready var button  = $"SubViewportContainer/SubViewport/StartingOffice/corkboard_001/MapUI/firsthouse_button"

var is_open: bool = false
	
	
func open() -> void:
	print("Opening map UI")
	map.visible = !map.visible
	
func change_scene() -> void:
	print("scenechanged")
	
func add_highlight() -> void:
	pass
	
func remove_highlight() -> void:
	pass
	
func _on_interactable_focused(interactor) -> void:
	if not is_open:
		add_highlight()
		
func _on_interactable_interacted(interactor) -> void:
	if not is_open:
		remove_highlight()
		$Interactable.queue_free()
		open()

func _on_interactable_unfocused(interactor) -> void:
	if not is_open:
		remove_highlight()
