cbuffer cbPerObject : register(b0)
{
	float4x4 gWorldViewProj;
    float3 gCameraPosition; // dodane
    float pad;
};

struct VertexIn
{
	float3 PosL  : POSITION;
};

struct VertexOut
{
    float4 PosL : SV_POSITION;
    float2 UV : TEXCOORD;
};

struct PSInput
{
    float4 PosL : SV_POSITION;
    float2 TexC : TEXCOORD;
};

PSInput VS_Main(VertexIn vin)
{
    PSInput vout;
    vout.PosL = float4(vin.PosL, 1.0f);
    vout.TexC = float2(0.0f, 0.0f);
    return vout;
}

Texture2D    gTexture1 : register(t0);
SamplerState gSampler1  : register(s0);

float4 PS_Main(PSInput pin) : SV_Target
{
    return gTexture1.Sample(gSampler1, pin.TexC);
}

float4 PS_Main(VertexOut pin) : SV_Target
{
    return gTexture1.Sample(gSampler1, pin.UV);
}

void DrawRect(inout TriangleStream<PSInput> outputStream, float4 position)
{
    float size = 0.5;

    float4 vertex1_pos = float4(-size, -size, 0.0f, 0.0f); // bottom-left
    float4 vertex2_pos = float4(-size, size, 0.0f, 0.0f); // top-left
    float4 vertex3_pos = float4(size, -size, 0.0f, 0.0f); // bottom-right
    float4 vertex4_pos = float4(size, size, 0.0f, 0.0f); // top-right

    PSInput vertex1;
    vertex1.PosL = mul(position + vertex1_pos, gWorldViewProj);
    vertex1.TexC = float2(0.0f, 1.0f);

    PSInput vertex2;
    vertex2.PosL = mul(position + vertex2_pos, gWorldViewProj);
    vertex2.TexC = float2(0.0f, 0.0f);

    PSInput vertex3;
    vertex3.PosL = mul(position + vertex3_pos, gWorldViewProj);
    vertex3.TexC = float2(1.0f, 1.0f);

    PSInput vertex4;
    vertex4.PosL = mul(position + vertex4_pos, gWorldViewProj);
    vertex4.TexC = float2(1.0f, 0.0f);

    outputStream.Append(vertex1);
    outputStream.Append(vertex2);
    outputStream.Append(vertex3);
    outputStream.RestartStrip();

    outputStream.Append(vertex2);
    outputStream.Append(vertex4);
    outputStream.Append(vertex3);
    outputStream.RestartStrip();
}

[maxvertexcount(18)]
void GS_Main(triangle VertexOut inputData[3], inout TriangleStream<VertexOut> outputStream)
{
    float size = 0.2;

    for (int i = 0; i < 3; ++i)
    {
        float3 worldPos = inputData[i].PosL.xyz;

        float3 forward = normalize(worldPos - gCameraPosition);

        float3 upGuide = abs(forward.y) > 0.99 ? float3(0, 0, 1) : float3(0, 1, 0);

        float3 right = normalize(cross(upGuide, forward));
        float3 up = normalize(cross(forward, right));

        float3 offset1 = (-right - up) * size;
        float3 offset2 = (-right + up) * size;
        float3 offset3 = (right - up) * size;
        float3 offset4 = (right + up) * size;

        VertexOut v1, v2, v3, v4;

        v1.PosL = mul(float4(worldPos + offset1, 1.0f), gWorldViewProj);
        v1.UV = float2(0.0f, 1.0f);

        v2.PosL = mul(float4(worldPos + offset2, 1.0f), gWorldViewProj);
        v2.UV = float2(0.0f, 0.0f);

        v3.PosL = mul(float4(worldPos + offset3, 1.0f), gWorldViewProj);
        v3.UV = float2(1.0f, 1.0f);

        v4.PosL = mul(float4(worldPos + offset4, 1.0f), gWorldViewProj);
        v4.UV = float2(1.0f, 0.0f);

        outputStream.Append(v1);
        outputStream.Append(v2);
        outputStream.Append(v3);
        outputStream.RestartStrip();

        outputStream.Append(v2);
        outputStream.Append(v4);
        outputStream.Append(v3);
        outputStream.RestartStrip();
    }
}



