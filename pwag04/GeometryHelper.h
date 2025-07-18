#ifndef _RENDERHELPERCLASS_H
#define _RENDERHELPERCLASS_H

#include "common.h"

namespace Geometry
{
	struct Vertex
	{
		Vertex(DirectX::XMFLOAT3 position) :Position(position){}
		DirectX::XMFLOAT3 Position;
	};
	using VertexBuffer = std::vector<Vertex>;

	inline VertexBuffer CreatePointCloud()
	{
		return {
		Vertex({ DirectX::XMFLOAT3(0.0f,  1.2f, 0.0f)}),
		Vertex({ DirectX::XMFLOAT3(0.0f,  0.0f, 0.0f)}),
		Vertex({ DirectX::XMFLOAT3(0.0f, -1.2f, 0.0f)}),
		};
	}

	inline DirectX::XMFLOAT4X4 Identity4x4()
	{
		static DirectX::XMFLOAT4X4 I(
			1.0f, 0.0f, 0.0f, 0.0f,
			0.0f, 1.0f, 0.0f, 0.0f,
			0.0f, 0.0f, 1.0f, 0.0f,
			0.0f, 0.0f, 0.0f, 1.0f);

		return I;
	}

	struct Camera
	{
		float Theta = 1.5f * DirectX::XM_PI;
		float Phi = 2.0f *  DirectX::XM_PIDIV4;
		float Radius = 5.0f;
		float Width = 0.0f;
		float Height = 0.0f;

		DirectX::XMMATRIX GetViewMatrix() const
		{
			return DirectX::XMLoadFloat4x4(&m_view);
		}

		DirectX::XMMATRIX GetProjectionMatrix() const
		{
			return DirectX::XMLoadFloat4x4(&m_proj);
		}

		DirectX::XMFLOAT3 GetPosition() const
		{
			float x = Radius * sinf(Phi) * cosf(Theta);
			float z = Radius * sinf(Phi) * sinf(Theta);
			float y = Radius * cosf(Phi);
			return DirectX::XMFLOAT3(x, y, z);
		}

		void UpdateViewMatrix()
		{
			float x = Radius * sinf(Phi) * cosf(Theta);
			float z = Radius * sinf(Phi) * sinf(Theta);
			float y = Radius * cosf(Phi);

			// Build the view matrix.
			DirectX::XMVECTOR pos = DirectX::XMVectorSet(x, y, z, 1.0f);
			DirectX::XMVECTOR target = DirectX::XMVectorZero();
			DirectX::XMVECTOR up = DirectX::XMVectorSet(0.0f, 1.0f, 0.0f, 0.0f);
			DirectX::XMMATRIX view = DirectX::XMMatrixLookAtLH(pos, target, up);
			DirectX::XMStoreFloat4x4(&m_view, view);
		}

		void UpdateProjetionMatrix()
		{
			const auto aspectRation = Width / Height;
			DirectX::XMMATRIX proj = DirectX::XMMatrixPerspectiveFovLH(0.25f * static_cast<float>(M_PI), aspectRation, 1.0f, 1000.0f);
			DirectX::XMStoreFloat4x4(&m_proj, proj);
		}
	private:
		DirectX::XMFLOAT4X4 m_view = Geometry::Identity4x4();
		DirectX::XMFLOAT4X4 m_proj = Geometry::Identity4x4();
	};
};

namespace DirectXHelper
{
	Microsoft::WRL::ComPtr<ID3DBlob> CompileShader(
		const std::wstring& filename,
		const D3D_SHADER_MACRO* defines,
		const std::string& entrypoint,
		const std::string& target) noexcept;

	Microsoft::WRL::ComPtr< IWICImagingFactory2> CreateWICFactory() noexcept;

	//Function loads a file image to memory buffer
	//Returns: A tuple containing pointer to the buffer, image width and image height
	std::tuple<std::unique_ptr<BYTE[]> /*buffer*/, UINT /*width*/, UINT /*hegiht*/> LoadTextureToBuffer(const wchar_t* path) noexcept;

	inline UINT CalcConstantBufferByteSize(UINT byteSize) noexcept
	{
		return (byteSize + 255) & ~255;
	}
};
#endif