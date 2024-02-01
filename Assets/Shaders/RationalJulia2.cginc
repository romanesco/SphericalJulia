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
        		// float2 z = uv2cpx(i.uv);
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