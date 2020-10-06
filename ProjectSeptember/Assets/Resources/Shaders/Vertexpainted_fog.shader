// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Vertexpainted_fog"
{
	Properties
	{
		_Main_Color("Main_Color", Color) = (0,0,0,0)
		_Albedo("Albedo", 2D) = "white" {}
		_FogColor_Map("FogColor_Map", CUBE) = "white" {}
		[Toggle(_DISTANCEFOG_ON)] _DistanceFog("Distance Fog", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature _DISTANCEFOG_ON
		struct Input
		{
			float3 worldNormal;
			float3 viewDir;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float eyeDepth;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform samplerCUBE _FogColor_Map;
		uniform float4 _Main_Color;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float Falloff;
		uniform float Distance;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			SurfaceOutputStandardSpecular s168 = (SurfaceOutputStandardSpecular ) 0;
			s168.Albedo = float3( 0,0,0 );
			float3 ase_worldNormal = i.worldNormal;
			s168.Normal = ase_worldNormal;
			float4 appendResult141 = (float4(i.viewDir.x , ( i.viewDir.y * -1.0 ) , i.viewDir.z , 0.0));
			s168.Emission = texCUBE( _FogColor_Map, appendResult141.xyz ).rgb;
			s168.Specular = float3( 0,0,0 );
			s168.Smoothness = 0.0;
			s168.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi168 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g168 = UnityGlossyEnvironmentSetup( s168.Smoothness, data.worldViewDir, s168.Normal, float3(0,0,0));
			gi168 = UnityGlobalIllumination( data, s168.Occlusion, s168.Normal, g168 );
			#endif

			float3 surfResult168 = LightingStandardSpecular ( s168, viewDir, gi168 ).rgb;
			surfResult168 += s168.Emission;

			#ifdef UNITY_PASS_FORWARDADD//168
			surfResult168 -= s168.Emission;
			#endif//168
			SurfaceOutputStandard s109 = (SurfaceOutputStandard ) 0;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			s109.Albedo = ( _Main_Color * tex2D( _Albedo, uv_Albedo ) ).rgb;
			s109.Normal = ase_worldNormal;
			s109.Emission = float3( 0,0,0 );
			s109.Metallic = 0.0;
			s109.Smoothness = 0.0;
			s109.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi109 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g109 = UnityGlossyEnvironmentSetup( s109.Smoothness, data.worldViewDir, s109.Normal, float3(0,0,0));
			gi109 = UnityGlobalIllumination( data, s109.Occlusion, s109.Normal, g109 );
			#endif

			float3 surfResult109 = LightingStandard ( s109, viewDir, gi109 ).rgb;
			surfResult109 += s109.Emission;

			#ifdef UNITY_PASS_FORWARDADD//109
			surfResult109 -= s109.Emission;
			#endif//109
			float VertexGreen156 = i.vertexColor.g;
			float VertexRed151 = i.vertexColor.r;
			float cameraDepthFade112 = (( i.eyeDepth -_ProjectionParams.y - Distance ) / Falloff);
			#ifdef _DISTANCEFOG_ON
				float staticSwitch127 = ( 1.0 - saturate( cameraDepthFade112 ) );
			#else
				float staticSwitch127 = 1.0;
			#endif
			float3 lerpResult97 = lerp( surfResult168 , surfResult109 , saturate( ( ( 1.0 - VertexGreen156 ) + ( VertexRed151 * staticSwitch127 ) ) ));
			c.rgb = lerpResult97;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.z = customInputData.eyeDepth;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.eyeDepth = IN.customPack1.z;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.vertexColor = IN.color;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16600
42;397;1863;714;639.7449;889.6251;1.3;True;True
Node;AmplifyShaderEditor.CommentaryNode;163;-1607.43,677.5726;Float;False;1198.128;366.5178;;7;115;114;112;116;128;118;127;Fog pass calculation;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-1543.368,790.7485;Float;False;Global;Falloff;Falloff;4;0;Create;True;0;0;True;0;3;34.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-1557.43,929.0903;Float;False;Global;Distance;Distance;5;0;Create;True;0;0;True;0;100;-16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;162;-1601.256,1203.868;Float;False;534.5609;281.1327;Painting in/out fog;3;100;151;156;Vertexcolor;1,1,1,1;0;0
Node;AmplifyShaderEditor.CameraDepthFade;112;-1302.595,794.0942;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;116;-1035.613,812.4495;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;100;-1551.256,1283.001;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;160;-285.5637,-711.7469;Float;False;995.8439;410.7959;;5;140;141;139;126;124;Fog color cubemap;0.3254717,0.7371002,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;156;-1309.695,1350.626;Float;False;VertexGreen;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-883.9044,727.5726;Float;False;Constant;_Float2;Float 2;4;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;165;-258.9363,462.2575;Float;False;662.4366;183;Comment;3;158;159;157;Removing Fog;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;118;-882.5975,806.1157;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;126;-220.7884,-586.7918;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;164;-258.4862,719.8136;Float;False;485.8255;271.8575;Comment;2;122;153;Adding Fog;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;151;-1310.364,1253.868;Float;False;VertexRed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;140;-205.4964,-416.8663;Float;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;157;-208.9363,512.6627;Float;False;156;VertexGreen;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;-208.4862,769.8136;Float;False;151;VertexRed;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;127;-682.3018,814.1169;Float;False;Property;_DistanceFog;Distance Fog;3;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;161;-281.0574,-148.3788;Float;False;883.3233;466.9392;;4;135;136;137;109;Base Shader;1,0.8296983,0.4198113,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;4.733315,-440.8664;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;58.33913,858.6711;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;136;-231.0574,88.56039;Float;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;135;-156.0179,-98.37875;Float;False;Property;_Main_Color;Main_Color;0;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;158;39.58599,517.7507;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;141;177.6556,-588.8696;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;146.1799,33.50324;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;159;249.5004,512.2576;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;124;371.3539,-616.5184;Float;True;Property;_FogColor_Map;FogColor_Map;2;0;Create;True;0;0;False;0;None;18366c39f7d41974686e8d38b55eca55;True;0;False;white;Auto;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomStandardSurface;109;380.0742,73.72824;Float;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;120;629.4753,503.6078;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomStandardSurface;168;676.0055,-615.0023;Float;False;Specular;World;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;97;941.5989,-18.48563;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;73;1529.47,16.33876;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;MyShaders/Vertexpainted_fog;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;112;0;114;0
WireConnection;112;1;115;0
WireConnection;116;0;112;0
WireConnection;156;0;100;2
WireConnection;118;0;116;0
WireConnection;151;0;100;1
WireConnection;127;1;128;0
WireConnection;127;0;118;0
WireConnection;139;0;126;2
WireConnection;139;1;140;0
WireConnection;122;0;153;0
WireConnection;122;1;127;0
WireConnection;158;0;157;0
WireConnection;141;0;126;1
WireConnection;141;1;139;0
WireConnection;141;2;126;3
WireConnection;137;0;135;0
WireConnection;137;1;136;0
WireConnection;159;0;158;0
WireConnection;159;1;122;0
WireConnection;124;1;141;0
WireConnection;109;0;137;0
WireConnection;120;0;159;0
WireConnection;168;2;124;0
WireConnection;97;0;168;0
WireConnection;97;1;109;0
WireConnection;97;2;120;0
WireConnection;73;13;97;0
ASEEND*/
//CHKSM=344D8135FA1DED99DB544AFDB34598DDB81BFEC3