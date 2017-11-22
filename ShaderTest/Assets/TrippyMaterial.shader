Shader "Custom/TrippyMaterialShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DisplaceTex ("DisplacementTexture", 2D) = "white"{} //Nimeämiskäytänne shadereissa on alaviiva nimen edessä ja iso alkukirjain
		_Magnitude ("Magnitude", Range(0, 0.1)) = 1 //Rangen arvoja vaihtamalla tapahtuu jänniä or not
	}
	SubShader
	{
		//Tää koodi on lähinnä Unityn luomaa, poistin vain turhat fog rivit
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc" //tää on tärkee lisätä koodiin, jos ite lähtee kirjottaa shaderii, tosin Unity lisää automaagisesti ite kuten tän muunkin koodin

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

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _DisplaceTex;
			float _Magnitude;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float2 disp = tex2D(_DisplaceTex, i.uv).xy; //xy voi olla x, y tai xy, riippuu mitä haluaa
				disp = ((disp * 2) - 1) * _Magnitude; //näiden arvojen kanssa voi kikkailla

				//Unityn luomaa, paitsi + disp eteenpäin. Tän koodinpätkän avulla saa Texturen elämään, ei vaikuta DisplacementTextureen. _Time[x]:ssä x voi olla 0, 1, 2 tai 3. Lisäämällä sin(koodi x), sin(koodi y) saadaan texture hyppimään
				fixed4 col = tex2D(_MainTex, i.uv + disp + float2(sin(i.vertex.x / 50 + _Time[1]), sin(i.vertex.y / 50 + _Time[1])));
				
				return col;
			}
			ENDCG
		}
	}
}
