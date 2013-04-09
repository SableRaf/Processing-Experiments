// STRETCH
// Based on "wowwow" https://www.shadertoy.com/view/4slGR8 by dawik

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

uniform vec2 mousePressed; // (0.0,0.0) no click, (1.0,1.0) left mouse button pressed
vec4 iMouse = vec4(mouse.xy,mousePressed.xy);

uniform sampler2D iChannel0;

// ------- Below is the unmodified Shadertoy code ----------

const float pi  = 3.14159265359;
void main(void)
{
	
	vec2 coords = gl_FragCoord.xy;
	
	vec2 uv = gl_FragCoord.xy / iResolution.xy;
	
	uv *= vec2(sin(iGlobalTime) / 6.0,1);
	gl_FragColor = vec4(uv,0.5+0.5*sin(iGlobalTime),1.0);
	gl_FragColor = texture2D(iChannel0,uv);
	gl_FragColor.r = sin(iGlobalTime);
	
}