// COLOR ZEBRA
// Based on https://www.shadertoy.com/view/Xsl3z8 by gtoledo3

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

// ------- Below is the Shadertoy code ----------
// Modifications: added vertical mirroring

void main(void)
{
	float phase=iGlobalTime*.5;//sin(iGlobalTime);
	float levels=8.;
	vec2 xy = gl_FragCoord.xy / iResolution.xy;
    xy.y = 1.0 - xy.y; // mirroring y-axis
	vec4 tx = texture2D(iChannel0, xy);
	
	//float x = (pix.r + pix.g + pix.b) / 3.0;//use this for BW effect.
	vec4 x=tx;
	
	x = mod(x + phase, 1.);
	x = floor(x*levels);
	x = mod(x,2.);
	
	gl_FragColor= vec4(vec3(x), tx.a);
}