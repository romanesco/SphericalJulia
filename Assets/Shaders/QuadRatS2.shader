/*
 * Quadratic rational map with period 2 cycle 0 <-> \infty
 * z -> 1/4*c/(z^2-z)
 * (parameter space)
 */
 Shader "Custom/QuadraticRational-S_2"
{
    Properties
    {
        _XMin("X min", float) = -1.8
        _XMax("X max", float) = 0.4
        _YMin("Y min", float) = -1.1
        _YMax("Y max", float) = 1.1
        _Iteration("Max Iteration", Int) = 100
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
                z = cpx_mult(z,z-float2(1,0));
                return cpx_div(c,z);
            }

	        int Rat2Per2(float2 c)
	        {
                float2 z = float2(0.5,0);
                c = c/4;

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
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
		        return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                float x = _XMin*(1-i.uv.x) + _XMax*i.uv.x;
                float y = _YMin*(1-i.uv.y) + _YMax*i.uv.y;
                float2 c = float2(x,y);
        		int n = Rat2Per2(c);
		        
                if (n < 0)
                {
                    return fixed4(0,0,0,1);
                }
                n = n*4;
                fixed col = ((uint) n % 256)/255.0;
                return fixed4(1,col,col,1);
            }
        
            ENDCG
        }
    }
}
