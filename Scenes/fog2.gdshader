shader_type canvas_item;

uniform float speed : hint_range(0.0, 5.0) = 0.5;
uniform float scale : hint_range(0.1, 100.0) = 2.0;
uniform float opacity : hint_range(0.0, 1.0) = 0.5;
uniform vec2 direction = vec2(0.5, 0.2);

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(41.0, 289.0))) * 45758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f*f*(3.0-2.0*f);

    float a = hash(i);
    float b = hash(i + vec2(1.0,0.0));
    float c = hash(i + vec2(0.0,1.0));
    float d = hash(i + vec2(1.0,1.0));

    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    for (int i = 0; i < 5; i++) {
        v += a * noise(p);
        p *= 2.0;
        a *= 0.5;
    }
    return v;
}

void fragment() {
    vec2 uv = UV * scale;
    uv += TIME * speed * direction;

    float n = fbm(uv);
    n = smoothstep(0.3, 0.7, n);

    // Fog is black, alpha is based on noise * opacity
    COLOR = vec4(0.0, 0.0, 0.0, n * opacity);
}
