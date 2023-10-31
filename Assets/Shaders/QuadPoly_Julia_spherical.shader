Shader "Custom/Spherical/QuadraticPolynomial_Julia"
{
    Properties
    {
        _X("Real(c)", float) = 0
        _Y("Imag(c)", float) = 1
        _Iteration("Max Iteration", Int) = 100
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Tags {"LightMode"="ForwardBase"}
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            
            // シャドウあり、シャドウなしで複数のバリアントにシェーダーをコンパイルします
            // (まだ、ライトマップを考えるひつようはありません。このバリアントを飛ばします)
            #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
            // shadow helper 関数とマクロ
            #include "AutoLight.cginc"

            int _Iteration;
            float _X, _Y;

            #include "common.cginc"

            float2 f(float2 z, float2 c)
            {
                return cpx_mult(z,z)+c;
            }

	        int Julia(float2 z, float2 c)
	        {
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
                float4 pos : SV_POSITION;
                SHADOW_COORDS(1)
                fixed3 diff : COLOR0;
                fixed3 ambient : COLOR1;                
            };

            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;

                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diff = nl * _LightColor0.rgb;
                o.ambient = ShadeSH9(half4(worldNormal,1));
                // シャドウのデータを計算します
                TRANSFER_SHADOW(o)

		        return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
        		float2 z = uv2cpx(i.uv);
                float2 c = float2(_X, _Y);
        		int n = Julia(z,c);
		        
                if (n < 0)
                {
                    return fixed4(0,0,0,1);
                }
                fixed col1 = ((uint) n % 256)/255.0;
                fixed4 col = fixed4(col1,col1,1,1);

                // シャドウの減衰を計算します (1.0 = 完全に照射される, 0.0 = 完全に影になる)
                fixed shadow = SHADOW_ATTENUATION(i);
                // シャドウでライトの照明を暗くします。アンビエントをそのまま保ちます
                fixed3 lighting = i.diff * shadow + i.ambient;
                col.rgb *= lighting;
                return col;
            }
        
            ENDCG
        }
    }
}
