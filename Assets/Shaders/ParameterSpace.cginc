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
        		int n = iter(c);
		        
                if (n < 0)
                {
                    return fixed4(0,0,0,1);
                }
                n = n*4;
                fixed col = ((uint) n % 256)/255.0;
                return fixed4(1,col,col,1);
            }
