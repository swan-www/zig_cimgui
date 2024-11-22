#ifndef IMGUI_DISABLE

#include "imgui_impl_sdl3_c.h"
#include "imgui_impl_sdl3.h"



bool     igImplSDL3_InitForOpenGL(SDL_Window* window, void* sdl_gl_context) { return ImGui_ImplSDL3_InitForOpenGL(window, sdl_gl_context); }
bool     igImplSDL3_InitForVulkan(SDL_Window* window){ return ImGui_ImplSDL3_InitForVulkan(window); }
bool     igImplSDL3_InitForD3D(SDL_Window* window) { return ImGui_ImplSDL3_InitForD3D(window); }
bool     igImplSDL3_InitForMetal(SDL_Window* window) { return ImGui_ImplSDL3_InitForMetal(window); }
bool     igImplSDL3_InitForSDLRenderer(SDL_Window* window, SDL_Renderer* renderer){ return ImGui_ImplSDL3_InitForSDLRenderer(window, renderer); }
bool     igImplSDL3_InitForOther(SDL_Window* window){ return ImGui_ImplSDL3_InitForOther(window); }
void     igImplSDL3_Shutdown(){ return ImGui_ImplSDL3_Shutdown(); }
void     igImplSDL3_NewFrame(){ return ImGui_ImplSDL3_NewFrame(); }
bool     igImplSDL3_ProcessEvent(const SDL_Event* event){ return ImGui_ImplSDL3_ProcessEvent(event); }

void    igImplSDL3_SetGamepadMode(igImGui_ImplSDL3_GamepadMode mode, SDL_Gamepad** manual_gamepads_array, int manual_gamepads_count){ return ImGui_ImplSDL3_SetGamepadMode((ImGui_ImplSDL3_GamepadMode)mode, manual_gamepads_array, manual_gamepads_count); }

#endif // #ifndef IMGUI_DISABLE