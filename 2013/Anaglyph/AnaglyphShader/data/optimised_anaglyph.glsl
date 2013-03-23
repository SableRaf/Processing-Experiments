
//	Core Image filter for anaglyph compositing
//	Anachrome (red/cyan glasses)
//	John Einselen – iaian7.com – vectorform.com

// Adapted for Processing by Raphaël de Courville 
// Twitter: @sableRaph


#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform sampler2D Left;
uniform sampler2D Right;

// uniform float time;
// uniform vec2 resolution;
// uniform vec2 mouse;

uniform float Contrast;
uniform float Deghost;
uniform vec2 Stereo;

vec2 stereo;
vec4 accum;
vec4 fragment;
float contrast;
float l1;
float l2;
float r1;
float r2;
float deghost;

void main(void){
	stereo = Stereo * 50.0;
	accum;
	fragment = vec4(1.0,1.0,1.0,1.0);
	contrast = (Contrast*0.5)+0.5;
	l1 = contrast*0.45;
	l2 = (1.0-l1)*0.5;
	r1 = contrast;
	r2 = 1.0-r1;
	deghost = Deghost*0.1;

	accum = clamp(texture2D(Left, vertTexCoord.st+stereo)*vec4(l1,l2,l2,1.0),0.0,1.0);
	fragment.r = pow(accum.r+accum.g+accum.b, 1.00);
	fragment.a = accum.a;

	accum = clamp(texture2D(Right, vertTexCoord.st-stereo)*vec4(r2,r1,0.0,1.0),0.0,1.0);
	fragment.g = pow(accum.r+accum.g+accum.b, 1.15);
	fragment.a = fragment.a+accum.a;

	accum = clamp(texture2D(Right, vertTexCoord.st-stereo)*vec4(r2,0.0,r1,1.0),0.0,1.0);
	fragment.b = pow(accum.r+accum.g+accum.b, 1.15);
	fragment.a = (fragment.a+accum.a)/3.0;

	accum = fragment;
	fragment.r = (accum.r+(accum.r*(deghost))+(accum.g*(deghost*-0.5))+(accum.b*(deghost*-0.5)));
	fragment.g = (accum.g+(accum.r*(deghost*-0.25))+(accum.g*(deghost*0.5))+(accum.b*(deghost*-0.25)));
	fragment.b = (accum.b+(accum.r*(deghost*-0.25))+(accum.g*(deghost*-0.25))+(accum.b*(deghost*0.5)));

	gl_FragColor =  fragment;
}