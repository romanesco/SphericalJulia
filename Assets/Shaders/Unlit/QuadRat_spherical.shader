Shader "Custom/Spherical/Unlit/QuadraticRationalJulia"
{
    Properties
    {
        _ARe("Real(a)", float) = 1
        _AIm("Imag(a)", float) = 0
        _BRe("Real(b)", float) = -1
        _BIm("Imag(b)", float) = 0
        _PreIteration("PreIteration", Int) = 25
        _Iteration("Iteration", Int) = 10
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

            int _PreIteration, _Iteration;
            float _ARe, _AIm, _BRe, _BIm;

            #include "../common.cginc"

            float2 f(float2 z, float2 a, float2 b)
            {
                float2 z2 = cpx_mult(z,z);
                return cpx_div(z2+a, z2+b);
            }

	        int Julia(float2 z, float2 a, float2 b)
	        {
                int n;
		        for (n=0; n<_PreIteration; n++)
		        {
		            z = f(z,a, b);
		        }

                float logdfn2 = 0;

                for (n=0; n<_Iteration; n++)
                {
                    // df = -2z(a-b)/(z^2+b)^2
                    float2 z2 = cpx_mult(z,z), den = z2+b;
                    logdfn2 += log(norm(2*cpx_mult(z,a-b)/cpx_mult(den,den)));
                    z = cpx_div(z2+a,den);
                }

                int r = (int) (logdfn2 * 5);
		        return r;
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
                float2 a = float2(_ARe, _AIm);
                float2 b = float2(_BRe, _BIm);
        		int n = Julia(z,a,b);
             
                while (n < 0)
                {
                    n += 256;
                }
                fixed col = ((uint) n % 256)/255.0;
                return fixed4(col,col,1,1);
            }
        
            ENDCG
        }
    }
}
