
// FIREBALL
// Based on https://www.shadertoy.com/view/4ssGzn by simesgreen

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

const int _VolumeSteps = 32;
const float _StepSize = 0.1; 
const float _Density = 0.2;

const float _SphereRadius = 2.0;
const float _NoiseFreq = 1.0;
const float _NoiseAmp = 3.0;
const vec3 _NoiseAnim = vec3(0, -1.0, 0);

// iq's nice integer-less noise function

// matrix to rotate the noise octaves
mat3 m = mat3( 0.00,  0.80,  0.60,
              -0.80,  0.36, -0.48,
              -0.60, -0.48,  0.64 );

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

float fbm( vec3 p )
{
    float f;
    f = 0.5000*noise( p ); p = m*p*2.02;
    f += 0.2500*noise( p ); p = m*p*2.03;
    f += 0.1250*noise( p ); p = m*p*2.01;
    f += 0.0625*noise( p );
    //p = m*p*2.02; f += 0.03125*abs(noise( p ));	
    return f;
}

// returns signed distance to surface
float distanceFunc(vec3 p)
{	
	float d = length(p) - _SphereRadius;	// distance to sphere
	
	// offset distance with pyroclastic noise
	//p = normalize(p) * _SphereRadius;	// project noise point to sphere surface
	d += fbm(p*_NoiseFreq + _NoiseAnim*iGlobalTime) * _NoiseAmp;
	return d;
}

// color gradient 
// this should be in a 1D texture really
vec4 gradient(float x)
{
	// no constant array initializers allowed in GLES SL!
	const vec4 c0 = vec4(2, 2, 1, 1);	// yellow
	const vec4 c1 = vec4(1, 0, 0, 1);	// red
	const vec4 c2 = vec4(0, 0, 0, 0); 	// black
	const vec4 c3 = vec4(0, 0.5, 1, 0.5); 	// blue
	const vec4 c4 = vec4(0, 0, 0, 0); 	// black
	
	x = clamp(x, 0.0, 0.999);
	float t = fract(x*4.0);
	vec4 c;
	if (x < 0.25) {
		c =  mix(c0, c1, t);
	} else if (x < 0.5) {
		c = mix(c1, c2, t);
	} else if (x < 0.75) {
		c = mix(c2, c3, t);
	} else {
		c = mix(c3, c4, t);		
	}
	//return vec4(x);
	//return vec4(t);
	return c;
}

// shade a point based on distance
vec4 shade(float d)
{	
	// lookup in color gradient
	return gradient(d);
	//return mix(vec4(1, 1, 1, 1), vec4(0, 0, 0, 0), smoothstep(1.0, 1.1, d));
}

// procedural volume
// maps position to color
vec4 volumeFunc(vec3 p)
{
	float d = distanceFunc(p);
	return shade(d);
}

// ray march volume from front to back
// returns color
vec4 rayMarch(vec3 rayOrigin, vec3 rayStep, out vec3 pos)
{
	vec4 sum = vec4(0, 0, 0, 0);
	pos = rayOrigin;
	for(int i=0; i<_VolumeSteps; i++) {
		vec4 col = volumeFunc(pos);
		col.a *= _Density;
		//col.a = min(col.a, 1.0);
		
		// pre-multiply alpha
		col.rgb *= col.a;
		sum = sum + col*(1.0 - sum.a);	
#if 0
		// exit early if opaque
        	if (sum.a > _OpacityThreshold)
            		break;
#endif		
		pos += rayStep;
	}
	return sum;
}

void main(void)
{
    vec2 p = (gl_FragCoord.xy / iResolution.xy)*2.0-1.0;
    p.x *= iResolution.x/ iResolution.y;
	
    float rotx = (iMouse.y / iResolution.y)*4.0;
    float roty = -(iMouse.x / iResolution.x)*4.0;

    float zoom = 4.0;

    // camera
    vec3 ro = zoom*normalize(vec3(cos(roty), cos(rotx), sin(roty)));
    vec3 ww = normalize(vec3(0.0,0.0,0.0) - ro);
    vec3 uu = normalize(cross( vec3(0.0,1.0,0.0), ww ));
    vec3 vv = normalize(cross(ww,uu));
    vec3 rd = normalize( p.x*uu + p.y*vv + 1.5*ww );

    ro += rd*2.0;
	
    // volume render
    vec3 hitPos;
    vec4 col = rayMarch(ro, rd*_StepSize, hitPos);
    //vec4 col = gradient(p.x);
	    
    gl_FragColor = col;
}
