// Quadratic rational maps with period 4 critical point 0 -> ∞ (critical) -> 1 -> c -> 0
// (z-c)*(z-r)/z^2 with r=(1-2c)/(1-c)
Shader "Custom/Spherical/QuadraticRational-S_4_Julia"
{
    Properties
    {
        _X("Real(c)", float) = -8
        _Y("Imag(c)", float) = 8
        _PreIteration("PreIteration", Int) = 30
        _MaxPreIteration("Max PreIteration bound", Int) = 100
        _Iteration("Iteration", Int) = 20
        _MaxIteration("Max Iteration bound", Int) = 100
        [MainTexture] _Gradient("Texture", 2D) = "red" {}
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
                // r = (1-2c)/(1-c)
                float2 r = cpx_div(ONE-2*c, ONE-c);
                float2 num = cpx_mult(z-c,z-r);
                float2 z2 = cpx_mult(z,z);
                return cpx_div(num,z2);
            }

            // f'(z) = ((c^2+c-1)z + 2c(1-2c))/((c-1)z^3)
            float2 df(float2 z, float2 c)
            {
                float2 num1 = cpx_mult(cpx_mult(c+ONE,c)-ONE, z);
                float2 c2 = 2*c;
                float2 num2 = cpx_mult(c2,ONE-c2);
                float2 num = num1 + num2;
                float2 z3 = cpx_mult(z,cpx_mult(z,z)); // z^3
                return cpx_div(num, cpx_mult(c-ONE, z3));
            }

            #include "RationalJulia2.cginc"

            ENDCG
        }
    }
}
