#ifndef IMGUI_DISABLE

#include "imgui_impl_sdlrenderer3_c.h"
#include "imgui_impl_sdlrenderer3.h"

bool     igImplSDLRenderer3_Init(SDL_Renderer* renderer){ return ImGui_ImplSDLRenderer3_Init(renderer); }
void     igImplSDLRenderer3_Shutdown(){ ImGui_ImplSDLRenderer3_Shutdown(); }
void     igImplSDLRenderer3_NewFrame(){ ImGui_ImplSDLRenderer3_NewFrame(); }
void     igImplSDLRenderer3_RenderDrawData(ImDrawData* draw_data, SDL_Renderer* renderer){ ImGui_ImplSDLRenderer3_RenderDrawData(draw_data, renderer); }
bool     igImplSDLRenderer3_CreateFontsTexture(){ return ImGui_ImplSDLRenderer3_CreateFontsTexture(); }
void     igImplSDLRenderer3_DestroyFontsTexture(){ ImGui_ImplSDLRenderer3_DestroyFontsTexture(); }
bool     igImplSDLRenderer3_CreateDeviceObjects(){ return ImGui_ImplSDLRenderer3_CreateDeviceObjects(); }
void     igImplSDLRenderer3_DestroyDeviceObjects(){ ImGui_ImplSDLRenderer3_DestroyDeviceObjects(); }

#endif // #ifndef IMGUI_DISABLE