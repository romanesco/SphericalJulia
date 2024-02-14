// Quadratic rational maps with period 3 critical point 0 -> ∞ (critical) -> 1 -> 0
// (z-c)*(z-1)/z^2
Shader "Custom/Spherical/QuadraticRational-S_3_Julia"
{
    Properties
    {
        _X("Real(c)", float) = 4.3
        _Y("Imag(c)", float) = 0
        _PreIteration("PreIteration", Int) = 30
        _MaxPreIteration("Max PreIteration bound", Int) = 100
        _Iteration("Iteration", Int) = 20
        _MaxIteration("Max Iteration bound", Int) = 100
        _Gradient("Texture", 2D) = "red" {}
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Tags {"LightMode"="ForwardBase"}
            CGPROGRAM

            #include "RationalJulia1.cginc"

            float2 f(float2 z, float2 c)
            {
                float2 z2 = cpx_mult(z,z);
                z = cpx_mult(z-c,z-float2(1,0));
                return cpx_div(z,z2);
            }

            // f'(z) = (cz-2c+z)/z^3
            float2 df(float2 z, float2 c)
            {
                float2 num = cpx_mult(c+float2(1,0),z)-2*c;
                return cpx_div(num, cpx_mult(z,cpx_mult(z,z)));
            }

            #include "RationalJulia2.cginc"

            ENDCG
        }
    }
}
