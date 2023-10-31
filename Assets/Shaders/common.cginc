#define PI 3.14159265

float2 uv2cpx(float2 uv)
{
    float t = uv.y*PI;
    float s = uv.x*2*PI;
    return float2(cos(s),sin(s))*tan((PI-t)/2);
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
