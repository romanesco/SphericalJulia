// Quadratic rational maps with period 4 critical point 0 -> ∞ (critical) -> 1 -> c -> 0
// (z-c)*(z-r)/z^2 with r=(1-2c)/(1-c)
Shader "Custom/QuadraticRational-S_4"
{
    Properties
    {
        _XMin("X min", float) = -25
        _XMax("X max", float) = 75
        _YMin("Y min", float) = -50
        _YMax("Y max", float) = 50
        _Iteration("Max Iteration", Int) = 100
        _MaxIteration("Max Iteration bound", Int) = 1000
        [MainTexture] _Gradient("Texture", 2D) = "red" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
        
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            float _XMin, _XMax, _YMin, _YMax;
            int _Iteration;
            sampler2D _Gradient;

            #include "common.cginc"
 
            float2 f(float2 z, float2 c, float2 r)
            {
                float2 num = cpx_mult(z-c,z-r);
                float2 z2 = cpx_mult(z,z);
                return cpx_div(num,z2);
            }

            int iter(float2 c)
            {
                float2 c2 = 2*c;

                // r = (1-2c)/(1-c)
                float2 r = cpx_div(ONE-c2, ONE-c);

                // critical point: 2c(2c-1)/(c^2+c-1)

                //float2 z = cpx_div(cpx_mult(c2,c2-ONE), cpx_mult(c+ONE,c)-ONE);
                float2 z = cpx_div(cpx_mult(c2,c2-ONE), cpx_mult(c,c)+c-ONE);
 
                for (int n=0; n<_Iteration; n++)
                {
                    if ( (z.x*z.x+z.y*z.y) < 0.00001 )
                    {
                        return n + (n && 3)*64;
                    }
                    z = f(z,c,r);
                }
                return -1;
            }

        #include "ParameterSpace.cginc"
        ENDCG

        }
    }
}