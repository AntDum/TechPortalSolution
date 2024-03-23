shader_type canvas_item;

uniform float speed_factor : hint_range(1.0, 100.0) = 10.0;

group_uniforms fog_1;
uniform sampler2D noise_texture_1: repeat_enable, filter_nearest_mipmap;
uniform float density_1 : hint_range(0.0, 1.0) = 0.5;
uniform vec2 speed_1 = vec2(1.0, 1.0);
uniform vec4 base_color_1 : source_color;

group_uniforms fog_2;
uniform sampler2D noise_texture_2: repeat_enable, filter_nearest_mipmap;
uniform float density_2 : hint_range(0.0, 1.0) = 0.5;
uniform vec2 speed_2 = vec2(1.0, 1.0);
uniform vec4 base_color_2 : source_color;

group_uniforms fog_3;
uniform sampler2D noise_texture_3: repeat_enable, filter_nearest_mipmap;
uniform float density_3 : hint_range(0.0, 1.0) = 0.5;
uniform vec2 speed_3 = vec2(1.0, 1.0);
uniform vec4 base_color_3 : source_color;

group_uniforms fog_4;
uniform sampler2D noise_texture_4: repeat_enable, filter_nearest_mipmap;
uniform float density_4 : hint_range(0.0, 1.0) = 0.5;
uniform vec2 speed_4 = vec2(1.0, 1.0);
uniform vec4 base_color_4 : source_color;

group_uniforms fog_5;
uniform sampler2D noise_texture_5: repeat_enable, filter_nearest_mipmap;
uniform float density_5 : hint_range(0.0, 1.0) = 0.5;
uniform vec2 speed_5 = vec2(1.0, 1.0);
uniform vec4 base_color_5 : source_color;


void fragment() {
	vec3 final_color = COLOR.rbg;
	float total_fog = 0.0;
	vec2 uv;

	uv = UV + TIME * speed_1 / speed_factor;
	float noise_1 = texture(noise_texture_1, uv).r;
	float fog_1 = clamp(noise_1 * 2.0 - 1.0, 0.0, 1.0);
	final_color = mix(final_color, base_color_1.rgb, fog_1 * density_1);
	total_fog += fog_1 * density_1;

	uv = UV + TIME * speed_2 / speed_factor;
	float noise_2 = texture(noise_texture_2, uv).r;
	float fog_2 = clamp(noise_2 * 2.0 - 1.0, 0.0, 1.0);
	final_color = mix(final_color, base_color_2.rgb, fog_2 * density_2);
	total_fog += fog_2 * density_2;

	uv = UV + TIME * speed_3 / speed_factor;
	float noise_3 = texture(noise_texture_3, uv).r;
	float fog_3 = clamp(noise_3 * 2.0 - 1.0, 0.0, 1.0);
	final_color = mix(final_color, base_color_3.rgb, fog_3 * density_3);
	total_fog += fog_3 * density_3;

	uv = UV + TIME * speed_4 / speed_factor;
	float noise_4 = texture(noise_texture_4, uv).r;
	float fog_4 = clamp(noise_4 * 2.0 - 1.0, 0.0, 1.0);
	final_color = mix(final_color, base_color_4.rgb, fog_4 * density_4);
	total_fog += fog_4 * density_4;

	uv = UV + TIME * speed_5 / speed_factor;
	float noise_5 = texture(noise_texture_5, uv).r;
	float fog_5 = clamp(noise_5 * 2.0 - 1.0, 0.0, 1.0);
	final_color = mix(final_color, base_color_5.rgb, fog_5 * density_5);
	total_fog += fog_5 * density_5;

	COLOR.a = total_fog;
	COLOR.rgb = final_color;
}
