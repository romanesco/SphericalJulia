// Quadratic rational maps with period 3 critical point 0 -> ∞ (critical) -> 1 -> 0
// (z-c)*(z-1)/z^2
Shader "Custom/QuadraticRational-S_3"
{
    Properties
    {
        _XMin("X min", float) = -5
        _XMax("X max", float) = 10
        _YMin("Y min", float) = -7.5
        _YMax("Y max", float) = 7.5
        _Iteration("Max Iteration", Int) = 100
        _MaxIteration("Max Iteration bound", Int) = 1000

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

            #include "common.cginc"
 
            float2 f(float2 z, float2 c)
            {
                float2 z2 = cpx_mult(z,z);
                z = cpx_mult(z-c,z-float2(1,0));
                return cpx_div(z,z2);
            }

            int iter(float2 c)
            {
                // critical point: 2c/(c+1)                                
                float2 z = cpx_div(2*c,c+float2(1,0));

                for (int n=0; n<_Iteration; n++)
                {
                    if ( (z.x*z.x+z.y*z.y) < 0.0001 )
                    {
                        return n;
                    }
                    z = f(z,c);
                }
                return -1;
            }

        #include "ParameterSpace.cginc"
        ENDCG

        }
    }
}