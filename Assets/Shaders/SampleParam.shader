Shader "Custom/SampleParameterSpace"
{
    Properties
    {
        _XMin("X min", float) = -1.8
        _XMax("X max", float) = 0.4
        _YMin("Y min", float) = -1.1
        _YMax("Y max", float) = 1.1
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
 
            float2 f(float2 z, float2 c)
            {
                z = cpx_mult(z,z-float2(1,0));
                return cpx_div(c/4,z);
            }

            int iter(float2 c)
            {
                float2 z = float2(0.5,0);
                c = c;

                for (int n=0; n<_Iteration; n++)
                {
                    if ( (z.x*z.x+z.y*z.y) > 100 )
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