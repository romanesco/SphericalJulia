#define PI 3.14159265359
#define ONE float2(1,0)

// Stereographic projection from normal vector (more accurate)
float2 n2cpx(float3 n)
{
    n = normalize(n);
    float mag = 1/(1-n.y);
    return float2(n.x*mag, n.z*mag);
}

// Stereographic projection from UV coordinate
// Do not use this because UV coordinate on the sphere is not accurate (especially near poles)
float2 uv2cpx(float2 uv)
{
    float t = uv.y*PI;
    float s = uv.x*2.0*PI;
    return float2(cos(s),sin(s))*tan((PI-t)/2.0);
}

float2 norm(float2 z)
{
    return z.x*z.x+z.y*z.y;
}

float2 cpx_mult(float2 z, float2 w)
{
    return float2(z.x*w.x - z.y*w.y, z.x*w.y + z.y*w.x);
}

float2 cpx_conj(float2 z)
{
    return float2(z.x, -z.y);
}

float2 cpx_div(float2 z, float2 w)
{
    return cpx_mult(z,cpx_conj(w))/norm(w);
}
