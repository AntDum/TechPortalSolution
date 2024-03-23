shader_type canvas_item;

uniform float dissolve_speed : hint_range(0.0, 1.0) = 0.5;
uniform float dissolve_threshold : hint_range(0.0, 1.0) = 0.5;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D noise_texture;
uniform float dissolve_step : hint_range(0.0, 1.0) = 0.1;

void fragment() {
	float dissolve_time = dissolve_speed;
	// Use a noise function to create a dissolve effect
	float noise_value = textureLod(noise_texture, SCREEN_UV, 0.0).r;
	float dissolve_factor = smoothstep(dissolve_threshold, dissolve_threshold + dissolve_speed, noise_value);
	// Apply the dissolve factor to the alpha channel
	COLOR.a = dissolve_factor * dissolve_step;
}
