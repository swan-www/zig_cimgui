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

    const joined_target_str = try std.mem.concat(b.allocator, u8, &.{ @tagName(target.result.cpu.arch), "_", @tagName(target.result.os.tag), "_", @tagName(target.result.abi) });
    b.lib_dir = try std.fs.path.join(b.allocator, &.{ b.install_path, joined_target_str, "lib" });
    b.h_dir = try std.fs.path.join(b.allocator, &.{ b.install_path, joined_target_str, "include" });
    b.exe_dir = try std.fs.path.join(b.allocator, &.{ b.install_path, joined_target_str, "bin" });
    b.dest_dir = try std.fs.path.join(b.allocator, &.{ b.install_path, joined_target_str });

    const cimgui = b.dependency("cimgui", .{ .target=target, .optimize=optimize,});
    const imgui = b.dependency("imgui", .{ .target=target, .optimize=optimize,});

    const translated_header = b.addTranslateC(.{
        .root_source_file = b.path("aggregate.h"),
        .target = target,
        .optimize = optimize,
    });

    translated_header.addIncludeDir(cimgui.path("").getPath(b));
    translated_header.addIncludeDir(imgui.path("").getPath(b));
    if (target.result.os.tag == .windows) {
        translated_header.defineCMacroRaw("_WINDOWS=");
        translated_header.defineCMacroRaw("_WIN32=");
    }
    translated_header.defineCMacroRaw("CIMGUI_DEFINE_ENUMS_AND_STRUCTS=");
    translated_header.defineCMacroRaw("CIMGUI_USE_SDL3=");
    translated_header.defineCMacroRaw("IMGUI_DISABLE_OBSOLETE_FUNCTIONS=");

    _ = translated_header.addModule("zimgui");
    const zimgui_lib = b.addStaticLibrary(.{
        .name = "zimgui_lib",
        .target = target,
        .optimize = optimize,
    });
    zimgui_lib.linkLibC();
    zimgui_lib.addCSourceFiles(.{
        .root = imgui.path(""),
        .files = &.{
            "imgui.cpp",
            "imgui_draw.cpp",
            "imgui_demo.cpp",
            "imgui_widgets.cpp",
            "imgui_tables.cpp",
        },
        .flags = &.{},
    });

    zimgui_lib.addCSourceFiles(.{
        .root = cimgui.path(""),
        .files = &.{
            "cimgui.cpp"
        },
        .flags = &.{},
    });

    zimgui_lib.root_module.addCMacro("CIMGUI_USE_SDL3", "");
    zimgui_lib.root_module.addCMacro("IMGUI_DISABLE_OBSOLETE_FUNCTIONS", "");

    zimgui_lib.addIncludePath(cimgui.path(""));
    zimgui_lib.addIncludePath(imgui.path(""));
    zimgui_lib.installHeader(imgui.path("LICENSE.txt"), "../lib/imgui_LICENSE.txt");
    zimgui_lib.installHeader(cimgui.path("LICENSE"), "../lib/cimgui_LICENSE");
    zimgui_lib.installHeadersDirectory(imgui.path(""), "", .{ .include_extensions = &.{ ".h" }});
    zimgui_lib.installHeadersDirectory(imgui.path("backends"), "", .{ .include_extensions = &.{ ".h" }});
    b.installArtifact(zimgui_lib);

    _ = b.addModule(
        "imgui_impl_sdl3_src",
        .{
            .target = target,
            .optimize = optimize,
            .root_source_file = imgui.path("backends/imgui_impl_sdl3.cpp"),
        }
    );

    _ = b.addModule(
        "imgui_impl_sdl3_c_src",
        .{
            .target = target,
            .optimize = optimize,
            .root_source_file = b.path("imgui_impl_sdl3_c.cpp"),
        }
    );

    _ = b.addModule(
        "imgui_impl_sdlrenderer3_src",
        .{
            .target = target,
            .optimize = optimize,
            .root_source_file = imgui.path("backends/imgui_impl_sdlrenderer3.cpp"),
        }
    );

     _ = b.addModule(
        "imgui_impl_sdlrenderer3_c_src",
        .{
            .target = target,
            .optimize = optimize,
            .root_source_file = b.path("imgui_impl_sdlrenderer3_c.cpp"),
        }
    );
}
