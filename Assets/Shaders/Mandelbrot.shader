Shader "Custom/Mandelbrot"
{
    Properties
    {
        _XMin("X min", float) = -2.25
        _XMax("X max", float) = 0.75
        _YMin("Y min", float) = -1.5
        _YMax("Y max", float) = 1.5
        _Iteration("Max Iteration", Int) = 100
        _Gradient("Texture", 2D) = "red" {}
 
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
                return cpx_mult(z,z)+c;
            }

	        int Mandelbrot(float2 c)
	        {
                float2 z = c;
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
        		int n = Mandelbrot(c);
		        
                if (n < 0)
                {
                    return fixed4(0,0,0,1);
                }
                fixed col1 = ((uint) n % 256)/255.0;
                fixed4 col = tex2D(_Gradient, float2(col1, 0));
                //return fixed4(1,col,col,1);
                return col;
            }
        
            ENDCG
        }
    }
}
