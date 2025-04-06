#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

// From Processing 2.1 and up, this line is optional
#define PROCESSING_COLOR_SHADER

// if you are using the filter() function, replace the above with
// #define PROCESSING_TEXTURE_SHADER

// ----------------------
//  SHADERTOY UNIFORMS  -
// ----------------------

uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iTime;                 // shader playback time (in seconds) (replaces iGlobalTime which is now obsolete)
uniform float     iTimeDelta;            // render time (in seconds)
uniform int       iFrame;                // shader playback frame

uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
uniform vec4      iDate;                 // (year, month, day, time in seconds)

//uniform float     iChannelTime[2];
//uniform vec3      iChannelResolution[2];


// Channels can be either 2D maps or Cubemaps.
// Pick the ones you need and uncomment them.


// uniform float     iChannelTime[1..4];       // channel playback time (in seconds)
// uniform vec3      iChannelResolution[1..4]; // channel resolution (in pixels)

/*
uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;

uniform samplerCube iChannel0;
uniform samplerCube iChannel1;
uniform samplerCube iChannel2;
uniform samplerCube iChannel3;

uniform vec3  iChannelResolution[4]; // channel resolution (in pixels)

uniform float iChannelTime[4]; // Channel playback time (in seconds)
*/

vec4 fragColor;
vec2 fragCoord = gl_FragCoord.xy;

// ------------------------------
//  SHADERTOY CODE BEGINS HERE  -
// ------------------------------


// Old watch (IBL). Created by Reinder Nijhoff 2018
// @reindernijhoff
//
// https://www.shadertoy.com/view/lscBW4
//
// This shader uses Image Based Lighting (IBL) to render an old watch. The
// materials of the objects have physically-based properties.
//
// A material is defined by its albedo and roughness value and it can be a
// metal or a non-metal.
//
// I have used the IBL technique as explained in the article 'Real Shading in
// Unreal Engine 4' by Brian Karis of Epic Games.[1] According to this article,
// the lighting of a material is the sum of two components:
//
// 1. Diffuse: a look-up (using the normal vector) in a pre-computed environment map.
// 2. Specular: a look-up (based on the reflection vector and the roughness of the
//       material) in a pre-computed environment map, combined with a look-up in a
//       pre-calculated BRDF integration map (Buf B).
//
// Note that I do NOT (pre)compute the environment maps needed in this shader. Instead,
// I use (the lod levels of) a Shadertoy cubemap that I have remapped using a random
// function to get something HDR-ish. This is not correct and not how it is described
// in the article, but I think that for this scene the result is good enough.
//
// [1] http://blog.selfshadow.com/publications/s2013-shading-course/karis/s2013_pbs_epic_notes_v2.pdf
//

#define MAX_LOD 8.
#define DIFFUSE_LOD 6.75
#define AA 2
// #define P_MALIN_AO

vec3 getSpecularLightColor( vec3 N, float roughness ) {
    // This is not correct. You need to do a look up in a correctly pre-computed HDR environment map.
    return pow(textureLod(iChannel0, N, roughness * MAX_LOD).rgb, vec3(4.5)) * 6.5;
}

vec3 getDiffuseLightColor( vec3 N ) {
    // This is not correct. You need to do a look up in a correctly pre-computed HDR environment map.
    return .25 +pow(textureLod(iChannel0, N, DIFFUSE_LOD).rgb, vec3(3.)) * 1.;
}

//
// Modified FrenelSchlick: https://seblagarde.wordpress.com/2011/08/17/hello-world/
//
vec3 FresnelSchlickRoughness(float cosTheta, vec3 F0, float roughness) {
    return F0 + (max(vec3(1.0 - roughness), F0) - F0) * pow(1.0 - cosTheta, 5.0);
}

//
// Image based lighting
//

vec3 lighting(in vec3 ro, in vec3 pos, in vec3 N, in vec3 albedo, in float ao, in float roughness, in float metallic ) {
    vec3 V = normalize(ro - pos);
    vec3 R = reflect(-V, N);
    float NdotV = max(0.0, dot(N, V));

    vec3 F0 = vec3(0.04);
    F0 = mix(F0, albedo, metallic);

    vec3 F = FresnelSchlickRoughness(NdotV, F0, roughness);

    vec3 kS = F;

    vec3 prefilteredColor = getSpecularLightColor(R, roughness);
    vec2 envBRDF = texture(iChannel3, vec2(NdotV, roughness)).rg;
    vec3 specular = prefilteredColor * (F * envBRDF.x + envBRDF.y);

    vec3 kD = vec3(1.0) - kS;

    kD *= 1.0 - metallic;

    vec3 irradiance = getDiffuseLightColor(N);

    vec3 diffuse  = albedo * irradiance;

#ifdef P_MALIN_AO
    vec3 color = kD * diffuse * ao + specular * calcAO(pos, R);
#else
    vec3 color = (kD * diffuse + specular) * ao;
#endif

    return color;
}

//
// main
//

vec3 render( const in vec3 ro, const in vec3 rd ) {
    vec3 col = vec3(0);
    vec2 res = castRay( ro, rd );

    if (res.x > 0.) {
        vec3 pos = ro + rd * res.x;
        vec3 N, albedo;
        float roughness, metallic, ao;

        getMaterialProperties(pos, res.y, N, albedo, ao, roughness, metallic, iChannel1, iChannel2, iChannel3);

        col = lighting(ro, pos, N, albedo, ao, roughness, metallic);
        col *= max(0.0, min(1.1, 10./dot(pos,pos)) - .1);
    }

    // Glass.
    float glass = castRayGlass( ro, rd );
    if (glass > 0. && (glass < res.x || res.x < 0.)) {
        vec3 N = calcNormalGlass(ro+rd*glass);
        vec3 pos = ro + rd * glass;

        vec3 V = normalize(ro - pos);
        vec3 R = reflect(-V, N);
        float NdotV = max(0.0, dot(N, V));

        float roughness = texture(iChannel2, pos.xz*.5 + .5).g;

        vec3 F = FresnelSchlickRoughness(NdotV, vec3(.15), roughness);
        vec3 prefilteredColor = getSpecularLightColor(R, roughness);
        vec2 envBRDF = texture(iChannel3, vec2(NdotV, roughness)).rg;
        vec3 specular = prefilteredColor * (F * envBRDF.x + envBRDF.y);

        col = col * (1.0 -  (F * envBRDF.x + envBRDF.y) ) + specular;
    }

    // gamma correction
    col = max( vec3(0), col - 0.004);
    col = (col*(6.2*col + .5)) / (col*(6.2*col+1.7) + 0.06);

    return col;
}

// FOR PROCESSING: REPLACE 'void mainImage(...)' WITH 'void main(void)'
// void mainImage( out vec4 fragColor, in vec2 fragCoord )
void main(void){
    vec2 uv = fragCoord/iResolution.xy;
    vec2 mo = iMouse.xy/iResolution.xy - .5;
    if(iMouse.w <= 0.) {
        mo = vec2(.2*sin(-iTime*.1+.3)+.045,.1-.2*sin(-iTime*.1+.3));
    }
    float a = 5.05;
    vec3 ro = vec3( 0.5 + 2.*cos(6.0*mo.x+a), 2. + 2. * mo.y, 2.0*sin(6.0*mo.x+a) );
    vec3 ta = vec3( 0.5, .5, 0.0 );
    mat3 ca = setCamera( ro, ta );

    vec3 colT = vec3(0);

    for (int x=0; x<AA; x++) {
        for(int y=0; y<AA; y++) {
		    vec2 p = (-iResolution.xy + 2.0*(fragCoord + vec2(x,y)/float(AA) - .5))/iResolution.y;
   			vec3 rd = ca * normalize( vec3(p.xy,1.6) );
            colT += render( ro, rd);
        }
    }

    colT /= float(AA*AA);

    fragColor = vec4(colT, 1.0);

    // FOR PROCESSING: ADD THIS LINE AT THE END OF THE mainImage() FUNCTION
    gl_FragColor = fragColor;
}

void mainVR( out vec4 fragColor, in vec2 fragCoord, in vec3 ro, in vec3 rd ) {
	MAX_T = 1000.;
    vec2 s = vec2(1,-1);
    fragColor = vec4(render(ro * 30. * s.yxy + vec3(0.5,4.,-1.5), rd * s.yxy), 1.);
}

// ----------------------------
//  SHADERTOY CODE ENDS HERE  -
// ----------------------------
