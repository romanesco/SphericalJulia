Shader "Custom/Spherical/SampleRationalJulia"
{
    Properties
    {
        _X("Real(c)", float) = -0.5
        _Y("Imag(c)", float) = 0
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
                z = cpx_mult(z,z-float2(1,0));
                return cpx_div(c/4,z);
            }

            float2 df(float2 z, float2 c)
            {
                float2 z1 = z - float2(1,0);
                float2 num = -cpx_mult(c/2,z1);
                z = cpx_mult(z, z1);
                return cpx_div(num, cpx_mult(z,z));
            }

            #include "RationalJulia2.cginc"

            ENDCG
        }
    }
}
