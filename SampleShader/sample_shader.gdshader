shader_type canvas_item;

vec2 v2_rand(vec2 uv)
{
	uv = vec2( dot(uv, vec2(127.1, 311.7)), dot(uv, vec2(269.5, 183.3)) );

	return - 1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise( vec2 uv ) {
	vec2 uv_index = floor(uv);
	vec2 uv_fract = fract(uv);

	vec2 blur = smoothstep(0.0, 1.0, uv_fract);

	return mix( mix( dot(v2_rand(uv_index + vec2(0.0, 0.0)), uv_fract - vec2(0.0, 0.0)), dot(v2_rand(uv_index + vec2(1.0, 0.0)), uv_fract - vec2(1.0, 0.0)), blur.x), mix( dot(v2_rand(uv_index + vec2(0.0, 1.0)), uv_fract - vec2(0.0, 1.0)), dot(v2_rand(uv_index + vec2(1.0, 1.0)), uv_fract - vec2(1.0, 1.0)), blur.x ), blur.y ) + sin(1.0 - TIME);
}

void fragment() {
	vec3 n = vec3(noise(UV));
	COLOR = vec4(n, 1.0);
}