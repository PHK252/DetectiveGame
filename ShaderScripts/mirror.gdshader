shader_type spatial;

render_mode unshaded, cull_disabled;

uniform sampler2D refl_tx;
uniform float exposure = 0.5; // Add an exposure control (default 1.0)

void fragment() {
    vec2 refl_uv = vec2(1.0 - SCREEN_UV.x, SCREEN_UV.y);

    // Sample the viewport texture
    vec4 refl_color = texture(refl_tx, refl_uv);

    // Adjust exposure (lower values reduce brightness)
    refl_color.rgb *= exposure;

    // Output the adjusted reflection
    ALBEDO = refl_color.rgb;
}
