

// STATE OF THE ART
// Based on https://www.shadertoy.com/view/lsl3zN by xeron_iris

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

// ------- Below is the unmodified Shadertoy code ----------

void main(void)
{
	float i, j;
	vec2 circ1, circ2;
	
	circ1.x = gl_FragCoord.x-((sin(iGlobalTime)*iResolution.x)/4.0 + iResolution.x/2.0);
	circ1.y = gl_FragCoord.y-((cos(iGlobalTime)*iResolution.x)/4.0 + iResolution.y/2.0);

	circ2.x = gl_FragCoord.x-((sin(iGlobalTime*0.92+1.2)*iResolution.x)/4.0 + iResolution.x/2.0);
	circ2.y = gl_FragCoord.y-((cos(iGlobalTime*0.43+0.3)*iResolution.x)/4.0 + iResolution.y/2.0);
	
	circ1.xy /= 16.0;
	circ2.xy /= 16.0;
	
	i = mod(sqrt(circ1.x*circ1.x+circ1.y*circ1.y),2.0) < 1.0 ? 0.0 : 1.0;
	j = mod(sqrt(circ2.x*circ2.x+circ2.y*circ2.y),2.0) < 1.0 ? 0.0 : 1.0;

	gl_FragColor = vec4(j,i,0.0,1.0);
}