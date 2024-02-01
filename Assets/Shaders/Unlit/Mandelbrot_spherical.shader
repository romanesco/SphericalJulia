Shader "Custom/Spherical/Unlit/Mandelbrot"
{
    Properties
    {
        _MaxIteration("Max Iteration", Int) = 100
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

            int _MaxIteration;

            #include "../common.cginc"

            float2 f(float2 z, float2 c)
            {
                return cpx_mult(z,z)+c;
            }

	        int Mandelbrot(float2 c)
	        {
                float2 z = c;
		        for (int n=0; n<_MaxIteration; n++)
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
                float2 c = uv2cpx(i.uv);
        		int n = Mandelbrot(c);
		        
                if (n < 0)
                {
                    return fixed4(0,0,0,1);
                }
                fixed col = ((uint) n % 256)/255.0;
                return fixed4(col,col,1,1);
            }
        
            ENDCG
        }
    }
}
