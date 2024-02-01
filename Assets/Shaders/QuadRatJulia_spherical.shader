Shader "Custom/Spherical/QuadraticRational_Julia"
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

            int _PreIteration, _Iteration;
            float _ARe, _AIm, _BRe, _BIm;

            #include "common.cginc"

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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                SHADOW_COORDS(1)
                fixed3 diff : COLOR0;
                fixed3 ambient : COLOR1;   
                float3 normal : NORMAL;             
            };

            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                o.normal = v.normal;

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
                float2 z = n2cpx(i.normal);
        		//float2 z = uv2cpx(i.uv);
                float r2 = z.x*z.x + z.y*z.y;
                float4 col;

                // show poles 
                if ( (r2 > 100000) || (r2 < 0.00001) ) {
                    //col = fixed4(1,1,1,1);
                    return fixed4(0,0,0,1);
                } else {
                    float2 a = float2(_ARe, _AIm);
                    float2 b = float2(_BRe, _BIm);
                    int n = Julia(z,a,b);
                
                    while (n < 0)
                    {
                        n += 256;
                    }
                    fixed col1 = ((uint) n % 256)/255.0;
                    col = fixed4(col1,col1,1,1);
                }

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
