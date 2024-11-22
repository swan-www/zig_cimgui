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

typedef struct SDL_Window SDL_Window;
typedef struct SDL_Renderer SDL_Renderer;
typedef struct SDL_Gamepad SDL_Gamepad;
typedef union SDL_Event SDL_Event;
enum igImGui_ImplSDL3_GamepadMode { igImGui_ImplSDL3_GamepadMode_AutoFirst, igImGui_ImplSDL3_GamepadMode_AutoAll, igImGui_ImplSDL3_GamepadMode_Manual };
typedef enum igImGui_ImplSDL3_GamepadMode igImGui_ImplSDL3_GamepadMode;

IMGUI_IMPL_EXTERN bool     igImplSDL3_InitForOpenGL(SDL_Window* window, void* sdl_gl_context);
IMGUI_IMPL_EXTERN bool     igImplSDL3_InitForVulkan(SDL_Window* window);
IMGUI_IMPL_EXTERN bool     igImplSDL3_InitForD3D(SDL_Window* window);
IMGUI_IMPL_EXTERN bool     igImplSDL3_InitForMetal(SDL_Window* window);
IMGUI_IMPL_EXTERN bool     igImplSDL3_InitForSDLRenderer(SDL_Window* window, SDL_Renderer* renderer);
IMGUI_IMPL_EXTERN bool     igImplSDL3_InitForOther(SDL_Window* window);
IMGUI_IMPL_EXTERN void     igImplSDL3_Shutdown();
IMGUI_IMPL_EXTERN void     igImplSDL3_NewFrame();
IMGUI_IMPL_EXTERN bool     igImplSDL3_ProcessEvent(const SDL_Event* event);

IMGUI_IMPL_EXTERN void     igImplSDL3_SetGamepadMode(igImGui_ImplSDL3_GamepadMode mode, SDL_Gamepad** manual_gamepads_array, int manual_gamepads_count);

#ifdef _cplusplus
}//extern "c" 
#endif

#endif // #ifndef IMGUI_DISABLE