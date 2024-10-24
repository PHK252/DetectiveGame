extends MeshInstance3D

var is_open: bool = false

func open() -> void:
	pass

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
