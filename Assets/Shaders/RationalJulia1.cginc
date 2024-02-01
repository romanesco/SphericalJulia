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
