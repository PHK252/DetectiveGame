shader_type canvas_item;

uniform vec4 tail_color : source_color = vec4(1.0,1.0,1.0,1.0);
uniform float pixel_blocks : hint_range(8.0, 256.0, 1.0) = 32.0; // how many blocks across UV

void fragment() {
    vec2 snapped_uv = floor(UV * pixel_blocks) / pixel_blocks;
    COLOR = tail_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
