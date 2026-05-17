shader_type canvas_item;

uniform float cold_meter : hint_range(0.0, 100.0) = 100.0; 
uniform vec4 hot_color : source_color = vec4(1.0, 0.0, 0.5, 1.0);
uniform vec4 cold_color : source_color = vec4(0.0, 0.2, 1.0, 1.0);
uniform float vignette_intensity = 0.6; 

void fragment() {
    vec2 uv = UV;
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(uv, center);
    
    float vignette = smoothstep(0.3, 0.8, dist) * vignette_intensity;
    
    float t = cold_meter / 100.0;
    vec4 current_color = mix(cold_color, hot_color, t);
    
    COLOR = current_color;
    COLOR.a = vignette;
}