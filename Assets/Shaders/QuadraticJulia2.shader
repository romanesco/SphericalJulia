Shader "Custom/BiquadraticJulia"
{
    Properties
    {
	    _XMin("X min", float) = -2
	    _XMax("X max", float) = 2
	    _YMin("Y min", float) = -2
	    _YMax("Y max", float) = 2
        _ARe("Real(a)", float) = 0
        _AIm("Imag(a)", float) = 1
        _BRe("Real(b)", float) = 0
        _BIm("Imag(b)", float) = 1
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

            int _Iteration;
            float _XMin, _XMax, _YMin, _YMax;
            float _ARe, _AIm, _BRe, _BIm;

            float2 cpx_mult(float2 z, float2 w)
            {
                return float2(z.x*w.x - z.y*w.y, z.x*w.y + z.y*w.x);
            }

            // f(z) = (z^2+a)^2+b
            float2 f(float2 z, float2 a, float2 b)
            {
                z = cpx_mult(z,z)+a;
                return cpx_mult(z,z)+b;
            }

	        int Julia(float2 z, float2 a, float2 b)
	        {
		        for (int n=0; n<_Iteration; n++)
		        {
		            if ( (z.x*z.x+z.y*z.y) > 100 )
		            {
			            return n;
		            }
		            z = f(z, a, b);
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
                float y = _YMin*i.uv.y + _YMax*(1-i.uv.y);
        		float2 z = float2(x,y);
                float2 a = float2(_ARe, _AIm);
                float2 b = float2(_BRe, _BIm);
        		int n = Julia(z, a, b);
		        
                if (n < 0)
                {
                    return fixed4(0,0,0,1);
                }
                fixed col = (n % 256)/255.0;
                return fixed4(col,col,1,1);
            }
        
            ENDCG
        }
    }
}
