shader_type canvas_item;

uniform sampler2D deformation_sampler : filter_nearest, repeat_enable;
uniform float radius : hint_range(1.0, 200.0, 0.01) = 25.0;
uniform vec2 box_size = vec2(100.0, 100.0);
uniform float box_padding = 15.0;
uniform float wobble_amount : hint_range(0.0, 1.0, 0.01) = 0.2;
uniform float wobble_speed : hint_range(0.0, 10.0, 0.01) = 1.0;
uniform float wobble_detail : hint_range(0.01, 1.0, 0.01) = 0.5;
uniform float pixel_density : hint_range(4.0, 512.0, 1.0) = 64.0;

vec2 snap_to_grid(vec2 uv, float density) {
    return floor(uv * density) / density;
}

void fragment() {
    // Snap UVs to pixel grid
    vec2 pixUV = snap_to_grid(UV, pixel_density);

    float adjusted_radius = min(min(radius, box_size.x/2.0), box_size.y/2.0);

    // Sample deformation with pixelated UV
    vec2 deformation_sample = texture(
        deformation_sampler,
        snap_to_grid(pixUV * wobble_detail + TIME * wobble_speed * 0.05, pixel_density)
    ).xy * (vec2(box_padding) / box_size) * 0.9;

    vec2 deformed_UV = pixUV + ((deformation_sample) - vec2(0.5) * vec2(box_padding) / box_size) * wobble_amount;

    // Compute pixelated rounded rectangle
    vec2 snapped_coords = snap_to_grid(deformed_UV * (box_size + vec2(box_padding)), pixel_density);

    float rounded_box = length(
        max(
            abs(snapped_coords - vec2(0.5) * (box_size + vec2(box_padding)))
            + adjusted_radius - vec2(0.5) * box_size,
            0.0
        )
    ) - adjusted_radius;

    COLOR.a = 1.0 - smoothstep(0.0, 1.0 / pixel_density, rounded_box);
}

//shader_type canvas_item;
//
//uniform int amount = 40;
//
//void fragment()
//{
	//vec2 grid_uv = round(UV * float(amount)) / float(amount);
	//
	//vec4 text = texture(TEXTURE, grid_uv);
	//
	//COLOR = text;
//}