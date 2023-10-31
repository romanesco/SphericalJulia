Shader "Custom/Spherical/Unlit/QuadraticPolynomialJulia"
{
    Properties
    {
        _CRe("Real(c)", float) = 0
        _CIm("Imag(c)", float) = 1
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
            float _CRe, _CIm;

            #include "common.cginc"

            float2 f(float2 z, float2 c)
            {
                return cpx_mult(z,z)+c;
            }

	        int Julia(float2 z, float2 c)
	        {
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
        		float2 z = uv2cpx(i.uv);
                float2 c = float2(_CRe, _CIm);
        		int n = Julia(z,c);
		        
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
