Shader "Custom/ToonSkin" {
	Properties {
		_MainColor("Main Color", Color) = (1,1,1,1)
		_Color_r ("R Color", Color) = (1,1,1,1)
		_Color_g("G Color", Color) = (1,1,1,1)
		_Color_b("B Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Ramp("Ramp (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Ramp noshadow 

		sampler2D _Ramp;
		half4 _MainColor;
		half4 _Color_r;
		half4 _Color_g;
		half4 _Color_b;

		half4 LightingRamp(SurfaceOutput s, half3 lightDir, half atten) {
			half NdotL = dot(s.Normal, lightDir);
			half diff = NdotL * 0.5 + 0.5;
			half3 ramp = tex2D(_Ramp, float2(diff, diff)).rgb;
			half3 rgb_r = saturate(_Color_r.rgb + half3(ramp.r, ramp.r, ramp.r));
			half3 rgb_g = saturate(_Color_g.rgb + half3(ramp.g, ramp.g, ramp.g));
			half3 rgb_b = saturate(_Color_b.rgb + half3(ramp.b, ramp.b, ramp.b));
			half4 c;
			c.rgb = s.Albedo * _MainColor.rgb * _LightColor0.rgb * rgb_r * rgb_g * rgb_b * atten;
			//c.rgb = rgb_r;
			//c.rgb = rgb_g;
			//c.rgb = rgb_b;
			c.a = s.Alpha;
			return c;
		}

		struct Input {
			float2 uv_MainTex;
		};

		sampler2D _MainTex;

		void surf(Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
