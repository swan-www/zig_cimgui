#pragma once
//expose C friendly binding for SDL_GPU as Cimgui doesn't currently

#ifdef _cplusplus
extern "C" 
{
#endif

#ifdef CIMGUI_USE_SDL3
#ifdef CIMGUI_USE_SDL3_GPU
#ifdef CIMGUI_DEFINE_ENUMS_AND_STRUCTS
typedef struct SDL_GPUCommandBuffer SDL_GPUCommandBuffer;
typedef struct SDL_GPURenderPass SDL_GPURenderPass;
typedef struct SDL_GPUGraphicsPipeline SDL_GPUGraphicsPipeline;
typedef struct ImGui_ImplSDLGPU3_InitInfo ImGui_ImplSDLGPU3_InitInfo;
#endif //CIMGUI_DEFINE_ENUMS_AND_STRUCTS

CIMGUI_API bool ImGui_ImplSDLGPU3_Init(ImGui_ImplSDLGPU3_InitInfo* info);
CIMGUI_API void ImGui_ImplSDLGPU3_Shutdown();
CIMGUI_API void ImGui_ImplSDLGPU3_NewFrame();
CIMGUI_API void ImGui_ImplSDLGPU3_PrepareDrawData(ImDrawData* draw_data, SDL_GPUCommandBuffer* command_buffer);
CIMGUI_API void ImGui_ImplSDLGPU3_RenderDrawData(ImDrawData* draw_data, SDL_GPUCommandBuffer* command_buffer, SDL_GPURenderPass* render_pass, SDL_GPUGraphicsPipeline* pipeline);
CIMGUI_API void ImGui_ImplSDLGPU3_CreateDeviceObjects();
CIMGUI_API void ImGui_ImplSDLGPU3_DestroyDeviceObjects();
CIMGUI_API void ImGui_ImplSDLGPU3_UpdateTexture(ImTextureData* tex);

#endif //CIMGUI_USE_SDL3_GPU
#endif //CIMGUI_USE_SDL3

//expose C friendly binding for SDL_Renderer3 as Cimgui doesn't currently

#ifdef CIMGUI_USE_SDL3
#ifdef CIMGUI_DEFINE_ENUMS_AND_STRUCTS
typedef struct SDL_Renderer SDL_Renderer;
#endif //CIMGUI_DEFINE_ENUMS_AND_STRUCTS

CIMGUI_API bool ImGui_ImplSDLRenderer3_Init(SDL_Renderer* renderer);
CIMGUI_API void ImGui_ImplSDLRenderer3_Shutdown();
CIMGUI_API void ImGui_ImplSDLRenderer3_NewFrame();
CIMGUI_API void ImGui_ImplSDLRenderer3_RenderDrawData(ImDrawData* draw_data, SDL_Renderer* renderer);
CIMGUI_API void ImGui_ImplSDLRenderer3_CreateDeviceObjects();
CIMGUI_API void ImGui_ImplSDLRenderer3_DestroyDeviceObjects();
CIMGUI_API void ImGui_ImplSDLRenderer3_UpdateTexture(ImTextureData* tex);

#endif //CIMGUI_USE_SDL3

#ifdef _cplusplus
}
#endif