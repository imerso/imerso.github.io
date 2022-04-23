// 3d noise on object
// by imerso

in vec3 position;
in vec3 normal;
uniform vec3 offset;
uniform mat4 worldViewProjection;

out vec3 f_pos;
out vec3 f_normal;

// -------------------------------------------------------------
// noise support functions
// noise3d was shamelessly stolen from shadertoy, as it was
// better than mine.

float hash(vec3 p)
{
    return fract(sin(dot(p,vec3(127.1,311.7, 74.7)))*43758.5453123);
}

float noise3d(vec3 x)
{
	// https://iquilezles.org/articles/gradientnoise
    vec3 p = floor(x);
    vec3 w = fract(x);
    
    vec3 u = w*w*w*(w*(w*6.0-15.0)+10.0);
    vec3 du = 30.0*w*w*(w*(w-2.0)+1.0);

    float a = hash( p+vec3(0,0,0) );
    float b = hash( p+vec3(1,0,0) );
    float c = hash( p+vec3(0,1,0) );
    float d = hash( p+vec3(1,1,0) );
    float e = hash( p+vec3(0,0,1) );
    float f = hash( p+vec3(1,0,1) );
    float g = hash( p+vec3(0,1,1) );
    float h = hash( p+vec3(1,1,1) );

    float k0 =   a;
    float k1 =   b - a;
    float k2 =   c - a;
    float k3 =   e - a;
    float k4 =   a - b - c + d;
    float k5 =   a - c - e + g;
    float k6 =   a - b - e + f;
    float k7 = - a + b + c - d + e - f - g + h;
    return -1.0+2.0*(k0 + k1*u.x + k2*u.y + k3*u.z + k4*u.x*u.y + k5*u.y*u.z + k6*u.z*u.x + k7*u.x*u.y*u.z);
}
// -------------------------------------------------------------

// -------------------------------------------------------------
// noise types

float fBm(vec3 pos, float frequency, int octaves, float persistency, float lacunarity)
{
    float sum = 0.;
    float freq = frequency;
    float amp = 1.;

    for (int i = 0; i < octaves; i++)
    {
        sum += noise3d(pos * freq) * amp;
        amp *= persistency;
        freq *= lacunarity;
    }

    return sum;
}


void main()
{
    float noise = fBm(position+offset, .4, 9, .42, 2.);
    f_pos =  vec3(position.x, position.y + noise, position.z);
    f_normal = normal;
    gl_Position = worldViewProjection * vec4(f_pos, 1.);
}
