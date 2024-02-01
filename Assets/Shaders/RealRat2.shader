/*
 * Real Quadratic rational map (by Hironaka et al.) with x → 0 (cp) → ∞ → y
 * z -> (z-a)*(z-r)/z^2 with r=(1-x-y)/(1-x)
 * (parameter space)
 */

 Shader "Custom/RealQuadraticRational"
{
    Properties
    {
        _XMin("X min", float) = -2
        _XMax("X max", float) = 2
        _YMin("Y min", float) = -2
        _YMax("Y max", float) = 2
        _Eps("epsilon", float) = 0.01
        _Iteration("Iteration", Int) = 100
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
            float _Eps;
            int _Iteration;

            #include "common.cginc"

            float2 f(float2 z, float2 c)
            {
                float2 x = float2(c.x, 0);
                float2 r = float2( (1-c.x-c.y)/(1-c.x), 0);

                z = cpx_div(cpx_mult(z-x,z-r), cpx_mult(z,z));
                return z;
            }

	        int doIteration(float2 c)
	        {
                float2 z = float2(c.y,0);
                float eps2 = _Eps*_Eps;

		        for (int n=0; n<_Iteration; n++)
		        {
		            if ( ((z.x-c.x)*(z.x-c.x)+z.y*z.y) < eps2 )
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
        		int n = doIteration(c);
		        
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
