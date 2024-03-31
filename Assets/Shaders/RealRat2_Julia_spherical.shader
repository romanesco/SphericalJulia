Shader "Custom/Spherical/RealQuadraticRational_Julia"
{
    Properties
    {
        _X("x", float) = -0.5
        _Y("y", float) = 0.5
        _PreIteration("PreIteration", Int) = 30
        _MaxPreIteration("Max PreIteration bound", Int) = 100
        _Iteration("Iteration", Int) = 20
        _MaxIteration("Max Iteration bound", Int) = 100
        [MainTexture] _Gradient("Texture", 2D) = "red" {}
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
            float _X, _Y;
            sampler2D _Gradient;

            #include "common.cginc"

            float2 f(float2 z, float2 c)
            {
                float2 x = float2(c.x, 0);
                float2 r = float2( (1-c.x-c.y)/(1-c.x), 0);

                z = cpx_div(cpx_mult(z-x,z-r), cpx_mult(z,z));
                return z;
            }

            float2 df(float2 z, float2 c)
            {
                float2 x = float2(c.x, 0);
                float2 r = float2( (1-c.x-c.y)/(1-c.x), 0);
                return cpx_div(cpx_mult(r+x,z)-float2(2*x.x*r.x,0), cpx_mult(z,z));
            }

	        int Julia(float2 z, float2 c)
	        {
                int n;
		        for (n=0; n<_PreIteration; n++)
		        {
		            z = f(z,c);
		        }

                float logdfn2 = 0;

                for (n=0; n<_Iteration; n++)
                {                    
                    // df = -2z(a-b)/(z^2+b)^2
                    logdfn2 += log(norm(df(z,c)));
                    z = f(z,c);
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
                float r2 = z.x*z.x+z.y*z.y;
                fixed4 col;

                // show poles 
                if ( (r2 > 100000) || (r2 < 0.00001) ) {
                     col = fixed4(1,1,1,1); // white dot
                    // return fixed4(0,0,0,1); // black dot
                } else {
                    float2 c = float2(_X, _Y);
                    int n = Julia(z,c);
                
                    while (n < 0)
                    {
                        n += 256;
                    }
                    fixed col1 = ((uint) n % 256)/255.0;
                    //fixed4 col = fixed4(col1,col1,1,1);
                    col = tex2D(_Gradient, float2(col1, 0));
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
