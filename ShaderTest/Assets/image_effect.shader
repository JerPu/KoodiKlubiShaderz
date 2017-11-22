Shader "Custom/WibblyWobbly"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MyInt("MyInt", Int) = 10
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

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
			
			sampler2D _MainTex;
			int _MyInt;


			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv +float2(0, sin(i.vertex.x / 50 + _Time[0] / _MyInt))); //Unity editorissa WibblyWobbly-materiaalin _MyInttiä säätämällä saa aikaan efektiin muutoksia
				//uncomment the following line to just invert the colors
				//col = 1 - col;
				return col;
			}
			ENDCG
		}
	}
}
