const std = @import("std");
const builtin = @import("builtin");

const zig_version = builtin.zig_version;
fn lazy_from_path(path_chars: []const u8, owner: *std.Build) std.Build.LazyPath {
    if (zig_version.major > 0 or zig_version.minor >= 13) {
        return std.Build.LazyPath{ .src_path = .{ .sub_path = path_chars, .owner = owner } };
    } else if (zig_version.minor >= 12) {
        return std.Build.LazyPath{ .path = path_chars };
    } else unreachable;
}

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const opt_cimgui_use_glfw = b.option(bool, "CIMGUI_USE_GLFW", "Whether to expose GLFW implementation.") orelse false;
    const opt_cimgui_use_opengl3 = b.option(bool, "CIMGUI_USE_OPENGL3", "Whether to expose OpenGL3 implementation.") orelse false;
    const opt_cimgui_use_opengl2 = b.option(bool, "CIMGUI_USE_OPENGL2", "Whether to expose OPENGL2 implementation.") orelse false;
    const opt_cimgui_use_sdl2 = b.option(bool, "CIMGUI_USE_SDL2", "Whether to expose SDL2 implementation.") orelse false;
    const opt_cimgui_use_sdl3 = b.option(bool, "CIMGUI_USE_SDL3", "Whether to expose SDL3 implementation.") orelse false;
    const opt_cimgui_use_sdl3gpu = b.option(bool, "CIMGUI_USE_SDL3_GPU", "Whether to expose SDL3 GPU implementation.") orelse false;
    const opt_cimgui_use_vulkan = b.option(bool, "CIMGUI_USE_VULKAN", "Whether to expose Vulkan implementation.") orelse false;

    const joined_target_str = try std.mem.concat(b.allocator, u8, &.{ @tagName(target.result.cpu.arch), "_", @tagName(target.result.os.tag), "_", @tagName(target.result.abi) });
    b.lib_dir = try std.fs.path.join(b.allocator, &.{ b.install_path, joined_target_str, "lib" });
    b.h_dir = try std.fs.path.join(b.allocator, &.{ b.install_path, joined_target_str, "include" });
    b.exe_dir = try std.fs.path.join(b.allocator, &.{ b.install_path, joined_target_str, "bin" });
    b.dest_dir = try std.fs.path.join(b.allocator, &.{ b.install_path, joined_target_str });

    const cimgui = b.dependency("cimgui", .{ .target=target, .optimize=optimize,});
    const imgui = b.dependency("imgui", .{ .target=target, .optimize=optimize,});
    var cimgui_flags = std.ArrayList([] const u8).empty;

    if(opt_cimgui_use_glfw) try cimgui_flags.append(b.allocator, "CIMGUI_USE_GLFW");
    if(opt_cimgui_use_opengl3) try cimgui_flags.append(b.allocator, "CIMGUI_USE_OPENGL3");
    if(opt_cimgui_use_opengl2) try cimgui_flags.append(b.allocator, "CIMGUI_USE_OPENGL2");
    if(opt_cimgui_use_sdl2) try cimgui_flags.append(b.allocator, "CIMGUI_USE_SDL2");
    if(opt_cimgui_use_sdl3) try cimgui_flags.append(b.allocator, "CIMGUI_USE_SDL3");
    if(opt_cimgui_use_sdl3gpu) try cimgui_flags.append(b.allocator, "CIMGUI_USE_SDL3_GPU");
    if(opt_cimgui_use_vulkan) try cimgui_flags.append(b.allocator, "CIMGUI_USE_VULKAN");

    const translated_header = b.addTranslateC(.{
        .root_source_file = b.path("aggregate.h"),
        .target = target,
        .optimize = optimize,
    });

    translated_header.addIncludePath(b.path(""));
    translated_header.addIncludePath(cimgui.path(""));
    translated_header.addIncludePath(imgui.path(""));
    if (target.result.os.tag == .windows) {
        translated_header.defineCMacroRaw("_WINDOWS=");
        translated_header.defineCMacroRaw("_WIN32=");
    }
    translated_header.defineCMacroRaw("CIMGUI_DEFINE_ENUMS_AND_STRUCTS=");
    translated_header.defineCMacroRaw("IMGUI_DISABLE_OBSOLETE_FUNCTIONS=");
    for(cimgui_flags.items) |cimgui_flag|
    {
        translated_header.defineCMacro(cimgui_flag, "1");
    }

    _ = translated_header.addModule("zimgui");
    const install_zimgui_zig = b.addInstallFile(translated_header.getOutput(), "zimgui.zig");
    b.getInstallStep().dependOn(&install_zimgui_zig.step);
    const zimgui_lib = b.addLibrary(.{
        .name = "zimgui_lib",
        .root_module = b.createModule(.{ .target=target, .optimize=optimize, }),
        .linkage = .static,
    });
    zimgui_lib.linkLibC();
    
    var prefixed_cimgui_flags = std.ArrayList([] const u8).empty;
    for(cimgui_flags.items) |cimgui_flag|
    {
        try prefixed_cimgui_flags.append(b.allocator, b.fmt("-D{s}", .{ cimgui_flag, }));
    }
    //try prefixed_cimgui_flags.append(b.allocator, "-fno-ubsan-rt");

    zimgui_lib.addCSourceFiles(.{
        .files = &.{
            "aggregate.cpp",
        },
        .flags = prefixed_cimgui_flags.items,
    });

    zimgui_lib.root_module.addCMacro("IMGUI_DISABLE_OBSOLETE_FUNCTIONS", "");
    zimgui_lib.root_module.sanitize_c = .off;
    zimgui_lib.bundle_ubsan_rt = false;

    zimgui_lib.addIncludePath(b.path(""));
    zimgui_lib.addIncludePath(cimgui.path(""));
    zimgui_lib.addIncludePath(imgui.path(""));
    zimgui_lib.addIncludePath(imgui.path("backends"));
    zimgui_lib.installHeader(imgui.path("LICENSE.txt"), "../lib/imgui_LICENSE.txt");
    zimgui_lib.installHeader(cimgui.path("LICENSE"), "../lib/cimgui_LICENSE");
    zimgui_lib.installHeadersDirectory(imgui.path(""), "", .{ .include_extensions = &.{ ".h" }});
    zimgui_lib.installHeadersDirectory(imgui.path("backends"), "", .{ .include_extensions = &.{ ".h" }});
    b.installArtifact(zimgui_lib);

    _ = b.addModule("imgui_impl_sdl3gpu_source",
        .{
            .target = target,
            .optimize = optimize,
            .root_source_file = imgui.path("backends/imgui_impl_sdlgpu3.cpp"),
        },
    );
    _ = b.addModule("imgui_impl_sdlrenderer3_source",
        .{
            .target = target,
            .optimize = optimize,
            .root_source_file = imgui.path("backends/imgui_impl_sdlrenderer3.cpp"),
        },
    );
    _ = b.addModule("imgui_impl_sdl3_source",
        .{
            .target = target,
            .optimize = optimize,
            .root_source_file = imgui.path("backends/imgui_impl_sdl3.cpp"),
        },
    );
}
