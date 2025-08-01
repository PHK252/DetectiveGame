// NOTE: Shader automatically converted from Godot Engine 4.3.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_add, depth_draw_opaque, cull_disabled, diffuse_burley, specular_schlick_ggx, sss_mode_skin;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform float point_size : hint_range(0.1, 128.0, 0.1);

uniform float roughness : hint_range(0.0, 1.0);
uniform sampler2D texture_metallic : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r, filter_linear_mipmap, repeat_enable;

uniform float specular : hint_range(0.0, 1.0, 0.01);
uniform float metallic : hint_range(0.0, 1.0, 0.01);

uniform float rim : hint_range(0.0, 1.0, 0.01);
uniform float rim_tint : hint_range(0.0, 1.0, 0.01);
uniform sampler2D texture_rim : hint_default_white, filter_linear_mipmap, repeat_enable;

uniform float subsurface_scattering_strength : hint_range(0.0, 1.0, 0.01);
uniform sampler2D texture_subsurface_scattering : hint_default_white, filter_linear_mipmap, repeat_enable;

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;
	if ((VERTEX.y > 0.9 && NORMAL.y > 0.5) || (VERTEX.y > 0.0 && NORMAL.y < 0.5)) { // Apply wave effect only to the top face of the cube
        float wave_strength = 0.05; // Adjust for stronger or weaker effect
        float wave_speed = 0.8;      // Speed of the wave motion
        float wave_frequency = 10.0; // Controls the number of waves
        VERTEX.y += sin(TIME * wave_speed + VERTEX.x * wave_frequency) * wave_strength;
		}
}

void fragment() {
	vec2 base_uv = UV;

	vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;

	float metallic_tex = dot(texture(texture_metallic, base_uv), metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	SPECULAR = specular;

	vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
	float roughness_tex = dot(texture(texture_roughness, base_uv), roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	ALPHA *= albedo.a * albedo_tex.a;

	// Rim: Enabled
	vec2 rim_tex = texture(texture_rim, base_uv).xy;
	RIM = rim * rim_tex.x;
	RIM_TINT = rim_tint * rim_tex.y;

	// Subsurface Scattering: Enabled
	float sss_tex = texture(texture_subsurface_scattering, base_uv).r;
	SSS_STRENGTH = subsurface_scattering_strength * sss_tex;
}
