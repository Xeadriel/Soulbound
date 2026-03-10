shader_type canvas_item;

uniform vec4 color : source_color;
uniform int OCTAVES = 4;

// Visual pixelation (optional)
uniform bool enable_pixelation = true;
uniform int pixelation_amount = 300;

// Mask
uniform sampler2D fog_mask; // optionally set to a white texture if unused

// Motion controls
uniform vec2 fog_direction = vec2(1.0, 1.0); // direction of the baseline drift
uniform bool scroll_noise_tex = false;
uniform vec2 noise_scroll_direction = vec2(1.0, 0.0);

// New: make time bounded and add stable motion controls
uniform float loop_seconds = 90.0;        // how long one cycle takes
uniform float base_scroll_speed = 0.25;   // baseline drift speed (guarantees motion)
uniform float warp_amp = 0.75;            // strength of the domain warp
uniform bool pixelate_visual_only = true; // pixelate the output, not the noise coords

float rand(vec2 coord){
    return fract(sin(dot(coord, vec2(56.0, 78.0)) * 1000.0) * 1000.0);
}

float noise(vec2 coord){
    vec2 i = floor(coord);
    vec2 f = fract(coord);

    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));

    vec2 cubic = f * f * (3.0 - 2.0 * f);
    return mix(a, b, cubic.x) +
           (c - a) * cubic.y * (1.0 - cubic.x) +
           (d - b) * cubic.x * cubic.y;
}

float fbm(vec2 coord){
    float value = 1.2;
    float scale = 0.5;
    for (int i = 0; i < OCTAVES; i++) {
        value += noise(coord) * scale;
        coord *= 2.0;
        scale *= 1.2;
    }
    return value;
}

void fragment() {
    vec2 uv = UV;

    // Visual pixelation (doesn't affect noise sampling if pixelate_visual_only = true)
    vec2 vis_uv = uv;
    if (enable_pixelation && !pixelate_visual_only) {
        vis_uv = round(uv * float(pixelation_amount)) / float(pixelation_amount);
    }

    // Always use bounded time everywhere
    float t = sin(mod(TIME, 4.0*PI) / 2.0) / 2.0;

    // Use NON-pixelated coordinates for the noise itself to avoid temporal stutter
    vec2 coord = uv * 20.0;

    if (scroll_noise_tex) {
        coord += noise_scroll_direction * t;
    }

    // 2D, de-correlated domain warp to avoid flat-gradient lockups
    vec2 warp = vec2(
        fbm(coord + vec2(t * 1.11,  -t * 1.73)),
        fbm(coord + vec2(-t * 0.97, -t * 1.37))
    ) * warp_amp;

    // Guaranteed baseline drift so motion never stalls
    vec2 base = fog_direction * (t * base_scroll_speed);

    float final = fbm(coord + warp + base);

    // Sample mask using visual UV (optionally pixelated if you want that look)
    float mask_value = texture(fog_mask, vis_uv).r;
    final *= mask_value;

    COLOR = vec4(color.rgb, final * color.a * 0.5);
}
