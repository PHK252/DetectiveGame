shader_type spatial;
render_mode unshaded;

uniform sampler2D noise_tex;
uniform sampler2D displ_tex;
uniform vec4 top_light_color : source_color;
uniform vec4 top_dark_color : source_color;
uniform vec4 bot_light_color : source_color;
uniform vec4 bot_dark_color : source_color;
uniform float displ_amount : hint_range(0.0, 0.1) = 0.02;
uniform float bottom_foam_threshold : hint_range(0.0, 1.0) = 0.48;
uniform float speed : hint_range(0.0, 1.0) = 0.25;

void fragment() {
    // Calculate displacement
    vec2 displ = texture(displ_tex, UV - vec2(TIME * speed / 8.0)).xy;
    displ = ((displ * 2.0) - 1.0) * displ_amount;

    // Get noise value and quantize it
    float noise = texture(noise_tex, vec2(UV.x, UV.y / 3.0 - TIME * speed / 4.0) + displ).x;
    noise = floor(noise * 4.0) / 4.0;

    // Interpolate colors based on UV and noise
    vec4 top_color = mix(top_dark_color, top_light_color, noise);
    vec4 bottom_color = mix(bot_dark_color, bot_light_color, noise);
    vec4 col = mix(top_color, bottom_color, UV.y);

    // Add foam effect
    col = mix(vec4(1.0, 1.0, 1.0, 1.0), col, step(UV.y + displ.y, bottom_foam_threshold));

    // Output color
    ALBEDO = col.rgb;
    ALPHA = col.a;
}
