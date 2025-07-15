# DirectX – Geometry Shader and Billboard Rendering

This project was developed as part of the **Graphics API Programming** course at the Silesian University of Technology. The focus of this lab was to implement geometry shaders in DirectX 12 to procedurally generate geometry (billboards) around input points, apply textures using UV coordinates, and implement camera-facing (directional) billboards.

## Objective

- Integrate a **geometry shader** into the DirectX 12 pipeline
- Procedurally generate quads around control points using geometry shaders
- Generate and apply **UV texture coordinates** on generated geometry
- Load textures in **DDS format** and bind them using **SRV**
- Transform geometry using **World-View-Projection (WVP)** matrices
- Modify shaders to orient quads toward the **camera position**
- Use **constant buffers** to pass camera data to shaders

## Technical Stack

- **API**: DirectX 12
- **Language**: C++17
- **Shaders**: HLSL (Shader Model 5.0+)
- **IDE**: Visual Studio 2019+
- **Platform**: Windows 10/11

## How to Run

1. Open the Visual Studio solution file (`*.sln`).
2. Build the project using `Ctrl+Shift+B`.
3. Run the application using `F5`.

### Controls

- **Mouse**: Orbit and zoom the camera
- **Keyboard**: Not used in this lab

## Project Structure

├── shader.fx # Vertex, geometry, and pixel shaders (HLSL)
├── GeometryHelper.h/.cpp # Geometry generation and camera logic
├── RenderWidget.cpp/.h # DirectX 12 initialization and rendering loop
├── PwAG_DirectX_4.pdf # Laboratory instruction document
└── README.md # Project documentation

## Results

<p align="center">
  <img src="https://github.com/user-attachments/assets/6bbe5fc7-1f2f-4846-85d7-8a364e7021f7" alt="Billboard Rendering" width="400"/>
</p>

> Note: The output includes textured quads rendered around 3D control points. When transformed using the WVP matrix, the camera can orbit the scene, and the billboards can face the camera dynamically.

## Academic Context

This project was developed as part of laboratory exercises for the course:

> **Graphics API Programming (DirectX)**  
> Silesian University of Technology – Faculty of Automatic Control, Electronics and Computer Science  
> Supervised by: mgr inż. Aleksandra Szymczak

---

> Technical note: Geometry shaders were configured with `maxvertexcount` to control the number of emitted vertices. The camera position was passed through a constant buffer (`ObjectConstants`) to support directional billboarding.

## Author

**inż. Alan Pawleta**  
Silesian University of Technology  
Faculty of Automatic Control, Electronics and Computer Science
