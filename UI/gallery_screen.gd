extends Control



func _on_visibility_changed():
		$ClosePics/Buttons/RightHover.visible = visible
		$ClosePics/Buttons/LeftHover.visible = visible
