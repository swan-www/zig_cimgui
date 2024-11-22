#pragma once
#ifndef IMGUI_DISABLE

#ifndef IMGUI_IMPL_EXTERN
#if defined __cplusplus
    #define IMGUI_IMPL_EXTERN extern "C"
#else
    #include <stdbool.h>
    #define IMGUI_IMPL_EXTERN extern
#endif
#endif

#ifdef _cplusplus
extern "C" 
{
#endif

typedef struct SDL_Renderer SDL_Renderer;
typedef struct ImDrawData ImDrawData;

IMGUI_IMPL_EXTERN bool     igImplSDLRenderer3_Init(SDL_Renderer* renderer);
IMGUI_IMPL_EXTERN void     igImplSDLRenderer3_Shutdown();
IMGUI_IMPL_EXTERN void     igImplSDLRenderer3_NewFrame();
IMGUI_IMPL_EXTERN void     igImplSDLRenderer3_RenderDrawData(ImDrawData* draw_data, SDL_Renderer* renderer);

IMGUI_IMPL_EXTERN bool     igImplSDLRenderer3_CreateFontsTexture();
IMGUI_IMPL_EXTERN void     igImplSDLRenderer3_DestroyFontsTexture();
IMGUI_IMPL_EXTERN bool     igImplSDLRenderer3_CreateDeviceObjects();
IMGUI_IMPL_EXTERN void     igImplSDLRenderer3_DestroyDeviceObjects();

typedef struct
{
    SDL_Renderer*       Renderer;
} igImplSDLRenderer3_RenderState;

#ifdef _cplusplus
}//extern "c" 
#endif

#endif // #ifndef IMGUI_DISABLE