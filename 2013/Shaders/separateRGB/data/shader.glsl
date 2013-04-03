// SEPARATE RGB
// Based on https://www.shadertoy.com/view/XdXGz4 by ushiostarfish

#ifdef GL_ES
precision highp float;
#endif

// Type of shader expected by Processing
#define PROCESSING_COLOR_SHADER

// Processing specific input
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

// Layer between Processing and Shadertoy uniforms
vec3 iResolution = vec3(resolution,0.0);
float iGlobalTime = time;
vec4 iMouse = vec4(mouse,0.0,0.0); // zw would normally be the click status

uniform sampler2D iChannel0;

// ------- Below is the Shadertoy code ----------
// Modifications: added vertical mirroring


float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0 + 113.0*p.z;

    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                        mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
                    mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                        mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
    return res;
}

void main(void)
{
	vec2 uv = gl_FragCoord.xy / iResolution.xy;
	
	uv.y = 1.0 - uv.y; // mirroring y-axis
	
	float blurx = noise(vec3(iGlobalTime * 10.0, 0.0, 0.0)) * 2.0 - 1.0;
	float offsetx = blurx * 0.025;
	
	float blury = noise(vec3(iGlobalTime * 10.0, 1.0, 0.0)) * 2.0 - 1.0;
	float offsety = blury * 0.01;
	
		
	vec2 ruv = uv + vec2(offsetx, offsety);
	vec2 guv = uv + vec2(-offsetx, -offsety);
	vec2 buv = uv + vec2(0.00, 0.0);
	
	float r = texture2D(iChannel0, ruv).r;
	float g = texture2D(iChannel0, guv).g;
	float b = texture2D(iChannel0, buv).b;
	
	gl_FragColor = vec4(r, g, b, 1.0);
}