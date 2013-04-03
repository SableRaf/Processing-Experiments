// SIN GRADIENT SHADER
// Based on the minimal shader from Shadertoy https://www.shadertoy.com

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

// ------- Below is the unmodified Shadertoy code ----------


void main(void)
{
	//vec2 uv = gl_FragCoord.xy / iResolution.xy;
	vec2 uv = gl_FragCoord.xy / iMouse.xy;
	gl_FragColor = vec4(uv,0.5+0.5*sin(iGlobalTime),1.0);
}