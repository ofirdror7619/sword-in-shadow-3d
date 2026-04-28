shader_type spatial;

uniform vec4 primary_color : source_color = vec4(0.12, 0.12, 0.12, 1.0);
uniform vec4 secondary_color : source_color = vec4(0.05, 0.05, 0.05, 1.0);
uniform sampler2D checker_texture;
uniform sampler2D roughness_texture;
uniform sampler2D normal_texture;

void fragment() {
	vec2 tile = floor(UV * 20.0);
	float checker = mod(tile.x + tile.y, 2.0);
	ALBEDO = mix(primary_color.rgb, secondary_color.rgb, checker);
	ROUGHNESS = texture(roughness_texture, UV).r;
	NORMAL_MAP = texture(normal_texture, UV).rgb;
}
