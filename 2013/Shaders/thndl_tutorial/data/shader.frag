#ifdef GL_ES
precision highp float;
#endif

// This is the interface between the sketch and the shader
// “Uniforms act as parameters that the user of a shader program
// can pass to that program”: http://www.opengl.org/wiki/Uniform_(GLSL)
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

// f will be used to store the color of the current fragment
vec4 f = vec4(1.,1.,1.,1.);


//-- Functions from the "More Noise" chapter --//

float rand(vec2 p)
{
 p+=.2127+p.x+.3713*p.y;
 vec2 r=4.789*sin(789.123*(p));
 return fract(r.x*r.y);
}

vec3 h2r(vec3 hsv)
{
 vec3 t=clamp(abs(mod(hsv.r*6.+vec3(0.,2.,4.),6.)-3.)-1.,0.,1.);
 return hsv.b*hsv.g*t+hsv.b-hsv.b*hsv.r;
}

float sn(vec2 p)
{
 vec2 i=floor(p-.5);
 vec2 f=fract(p-.5);
 float rt=mix(rand(i),rand(i+vec2(1.,0.)),f.x);
 float rb=mix(rand(i+vec2(0.,1.)),rand(i+vec2(1.,1.)),f.x);
 return mix(rt,rb,f.y);
}

float sn2(vec2 p)
{
 vec2 i=floor(p-.5);
 vec2 f=fract(p-.5);
 f = f*f*f*(f*(f*6.0-15.0)+10.0);
 float rt=mix(rand(i),rand(i+vec2(1.,0.)),f.x);
 float rb=mix(rand(i+vec2(0.,1.)),rand(i+vec2(1.,1.)),f.x);
 return mix(rt,rb,f.y);
}


void main(void)
{    
 // c will contain the position information for the current fragment (from -1,-1 to 1,1)
 vec2 c = vec2 (-1.0 + 2.0 * gl_FragCoord.x / resolution.x, 1.0 - 2.0 * gl_FragCoord.y / resolution.y) ;
 
 // mousepos will contain the current mouse position (from -1,-1 to 1,1)
 vec2 mousepos = -1.0 + 2.0 * mouse.xy / resolution.xy;
    
 float t = time;
    
 // Below is the code you see in the tutorial,
 // everything else is part of the "boilerplate".

 // Uncomment the example you wish to
 // try and comment all the others.
    
 //---------------------------------------//
 //  THE PIXEL SWARM http://thndl.com/?1  //
 //---------------------------------------//
    

 //-- Example 1 --//
    
 //f = vec4(c.x, c.y, 0.0, 1.0);
    
    // A variation with mouse position (not from the tutorial)
    // f = vec4(c.x*mousepos.x, c.y*mousepos.y, 0.0, 1.0);

    
 //-- Example 2 --//
    
 //float d = length(c.xy);
 //f = vec4(d,d,d, 1.0);
    
    
 //-- Example 3 --//
    
 //float d = step(0.1, 1.0-length(c.xy));
 //f = vec4(0.0, 1.0, 0.0, d);
    
    
 //-- Example 4 --//
    
 //float d = smoothstep(0.08,0.1,1.-length(c.xy));
 //f = vec4(0.0, 1.0, 0.0, d);
    
    
 //-----------------------------------------//
 //  LEARNING TO SHADE http://thndl.com/?4  //
 //-----------------------------------------//
    
 //float r = 1.-length(2.*c.xy);
 //f = vec4(c.xy*r,r,1.);
    
    
 //---------------------------------------------//
 //  SQUARE SHAPED SHADERS http://thndl.com/?5  //
 //---------------------------------------------//
    
 //-- Example 1 --//
    
 //vec2 r=abs(c.xy);
 //f=vec4(r,0.,1.);
   
    
 //-- Example 2 --//
    
 //vec2 r=abs(c.xy);
 //float s=max(r.x,r.y);
 //f=vec4(vec3(s),1.);

    
 //-- Example 3 --//
    
 vec2 r=abs(c.xy);
 float s=step(.5,max(r.x,r.y));
 f=vec4(vec3(s),1.);
    

 //-- Example 4 --//
    
 //vec2 r=abs(c.xy);
 //float s=max(r.x,r.y);
 //f=vec4(vec3(step(.4,s)*step(s,.5)),1.);
    
    
 //-- Example 5 --//
    
 //vec2 r=abs(c.xy);
 //float s=max(r.x,r.y);
 //f=vec4(vec3(smoothstep(.3,.4,s)*smoothstep(.6,.5,s)),1.);
    
    
 //-- Example 6 --//
    
 //float r=length(max(abs(c.xy)-.3,0.));
 //f=vec4(r,r,r,1.);
    
    
 //-- Example 7 --//
    
 //float r=step(.2,length(max(abs(c.xy)-.3,0.)));
 //f=vec4(r,r,r,1.);
    
    
 //-- Example 8 --//

 //float a=atan(c.x,c.y);
 //f=vec4(step(.5,cos(floor(a*.636+.5)*1.57-a)*length(c.xy)));
   
    
 //-- Example 9 --//
    
 //int N=7;
 //float a=atan(c.x,c.y)+.2;
 //float b=6.28319/float(N);
 //f=vec4(vec3(smoothstep(.5,.51,cos(floor(.5+a/b)*b-a)*length(c.xy))),1.);
    

 //---------------------------------------------//
 //  THE ART OF REPETITION http://thndl.com/?7  //
 //---------------------------------------------//

 // Tiling is not implemented
    
 //-- Example 0 --//
 
 // This one looks different for some reason
 //vec2 r=mod(8.*(c.xy*.5+.5+vec2(.25*t,0.)),2.)-1.;
 //f.a=sqrt(.95-length(r));
    
 //-- Example 1 --//
    
 //f=vec4(c.xy*.5+.5,c.x*c.y,1.);

    
 //-- Example 2 --//
    
 //vec2 m=abs(c.xy);
 //f=vec4(m.xy,m.x*m.y,1.);
    
    
 //-- Example 3 --//
    
 //vec2 m=mod(c.xy+c.x+c.y,1.);
 //f=vec4(m.xy,m.x*m.y,1.);
    
    
 //-- Example 4 --//

 //vec2 m=mod(c.xy+c.x+c.y,1.);
 //f=vec4(smoothstep(.75,.5,m.y)*smoothstep(.25,.5,m.y));
    

 //-- Example 5 --//

 //vec2 m=mod(c.xy+c.x+c.y,2.)-1.;
 //f=vec4(length(m));
    
 //-- Example 6 --//
 
 //vec2 m=mod(c.xy+c.x+c.y+2.*t,2.)-1.;
 //f.a=length(m);

    
 //-- Example 7 --//
    
 //float N=7.;
 //float a=atan(c.x,c.y)+6.28319*t/N;
 //float b=6.28319/N;
 //f.a=smoothstep(.5,.55,cos(floor(.5+a/b)*b-a)*length(c.xy));
    

    
 //------------------------------------------//
 //  MIXING IT UP A BIT http://thndl.com/?9  //
 //------------------------------------------//
    

 //-- Example 1 --//
    
 //f=vec4(mix( vec3(.0,.0,.5), vec3(.0,.5,1.), c.y*.5+.5),1.);
    
    
 //-- Example 2 --//
    
 //vec3 sky=mix( vec3(.0,.0,.5), vec3(.0,.5,1.), c.y*.5+.5);
 //float circle=smoothstep(.25,.3,1.-length(c.xy));
 //f=vec4(mix( sky, vec3(0.6), circle),1.);
    
    
 //-- Example 3 --//
    
 //vec3 sky=mix( vec3(.0,.0,.5), vec3(.0,.5,1.), c.y*.5+.5);
 //float circle=smoothstep(.25,.3,1.-length(c.xy));
 //float shadow=smoothstep(.25,.3,1.-length(c.xy+vec2(.5,0.)));
 //f=vec4(mix( sky, vec3(.6),mix(circle,0.,shadow)),1.);
    
    
    
 //------------------------------------------------//
 //  GOING ROUND IN SQUIRCLES http://thndl.com/?10  //
 //------------------------------------------------//

 //-- Example 1 --//
    
 //f=vec4(1.-length(c.xy*c.xy*c.xy*c.xy));
    
    
 //-- Example 2 --//
    
 //float s=1.-length(c.xy*c.xy*c.xy*c.xy);
 //f=vec4(smoothstep(0.,0.1,s));
    
    
 //-- Example 3 --//

 // Note: the code had to be tweaked a little to work
 //float p = 4.; // change this value to try different powers for the squircle
 //float s=1.-length(pow(c.xy,vec2(p)));
 //f=vec4(smoothstep(s-.02, s, 0.));

    
 //----------------------------------------------//
 //  CONTINUOUSLY DISCRETE http://thndl.com/?11  //
 //----------------------------------------------//
    
    
 //-- Example 1 --//
    
 //vec2 s=step(0.,c.xy);
 //f=vec4(s.x,s.y,0.,1.);
    
    
 //-- Example 2 --//
 
 //vec2 s=0.5*(step(-0.333,c.xy)+step(0.333,c.xy));
 //f=vec4(s.x,s.y,0.,1.);
    
    
 //-- Example 3 --//
    
 //vec2 s=floor(3.*(c.xy*.5+.5))/2.;
 //f=vec4(s.x,s.y,0.,1.);
    
    
 //-- Example 4 --//

 //vec2 s=floor(vec2(5.,10.)*(c.xy*.5+.5));
 //f=vec4(0.02*(s.x+5.*s.y));
    
    
 //-- Example 5 --//
    
 //vec2 r=vec2(5.,10.)*(c.xy*.5+.5);
 //vec2 i=floor(r);
 //c=(fract(r)-.5)*vec2(4.,2.)*.6; // the type was removed because we can't declare a variable twice
 //float s=3.+i.x+5.*i.y;
 //float a=atan(c.x,c.y);
 //float b=6.28319/s;
 //float w=floor(.5+a/b);
 //float g=smoothstep(.55,.5,cos(w*b-a)*length(c.xy));
 //f=vec4(vec3(1.-g*((60.-s)/50.)),g);


 //-- Example 6 --//

// vec2 r=vec2(5.,10.)*(c.xy*.5+.5);
// vec2 i=floor(r);
// c=(fract(r)-.5)*vec2(4.,2.)*.6; // the type was removed because we can't declare a variable twice
// float s=3.+i.x+5.*i.y;
// float a=atan(c.x,c.y);
// float b=6.28319/s;
// float w=floor(.5+a/b);
// float g=smoothstep(.55,.5,cos(w*b-a)*length(c.xy));
// float v=1.-1.2*length(c.xy);
// float sa=1.-abs(w/s);
// float h=s/50.;
// vec3 rgb=v*sa*clamp(abs(mod(h*6.+vec3(0.,2.,4.),6.)-3.)-1.,0.,1.)+(v-v*sa);
// f=vec4(1.-g*rgb,g);

    
    
 //-------------------------------------------//
 //  NOISE FROM NUMBERS http://thndl.com/?14  //
 //-------------------------------------------//
    
 // To get the tutorial's image ration, use size(512,128, P2D) in Processing
    
 //-- Example 1 --//
    
 //float r=.5+.5*sin(10.*c.x);
 //f=vec4(r);

    
 //-- Example 2 --//
    
 //float r=.5+.5*sin(789.123*c.x);
 //f=vec4(r);
    
    
 //-- Example 3 --//
    
 //float r=fract(sin(789.123*c.x));
 //f=vec4(r);
    
    
 //-- Example 4 --//
   
 //float r=fract(456.789*sin(789.123*c.x));
 //f=vec4(r);
    
    
 //-- Example 5 --//
    
 //vec2 r=fract(456.789*sin(789.123*c.xy));
 //f=vec4(r.x*r.y);
    
    
 //-- Example 6 --//
    
 //vec2 r=(456.789*sin(789.123*c.xy));
 //f=vec4(fract(r.x*r.y));
    
    
 //-- Example 7 --//
    
 //vec2 r=(456.789*sin(789.123*c.xy));
 //f=vec4(fract(r.x*r.y*(1.+c.x)));
    
    
 //-----------------------------------//
 //  MORE NOISE http://thndl.com/?15  //
 //-----------------------------------//
    

 //-- Example 1 --//

 //function declarations must be placed before the main()
 //f=vec4(rand(floor(vec2(4.)*c.xy)));

    
    
 //-- Example 2 --//
    
 //vec2  p=c.xy*vec2(4.);
 //float s=smoothstep(.1,.2,1.-length(pow(2.*fract(p)-1.,vec2(2.))));
 //vec3  k=h2r(vec3(rand(floor(p)),.75,.6)); // var name changed from t to k
 //f=vec4(k*s,s);
    
    
    
 //-- Example 3 --//
    
 //f=vec4(vec3(sn(vec2(4.)*c.xy)),1.);
    
    
    
 //-- Example 4 --//
    
 //f=vec4(vec3(sn2(vec2(4.)*c.xy)),1.); // sn changed to sn2
    
    
    
 //-- Example 5 --//
    
// vec2 p=c.xy*vec2(4.);
// f=vec4(vec3(
//                .5*sn2(p)
//                +.25*sn2(2.*p)
//                +.125*sn2(4.*p)
//                +.0625*sn2(8.*p)
//                +.03125*sn2(16.*p)+
//                .015*sn2(32.*p)
//                ),1.);
    
    
 // This is part of the boilerplate too (don't change it)
 gl_FragColor = f;

}