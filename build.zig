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

    const cimgui = b.dependency("cimgui", .{});
    const imgui = b.dependency("imgui", .{});

    const translated_header = b.addTranslateC(.{
        .root_source_file = b.path("aggregate.h"),
        .target = target,
        .optimize = optimize,
    });

    translated_header.addIncludeDir(cimgui.path("").getPath(b));
    translated_header.addIncludeDir(imgui.path("").getPath(b));

    const zimgui = translated_header.addModule("zimgui");
    zimgui.addCSourceFiles(.{
        .root = imgui.path(""),
        .files = &.{
            "imgui.cpp",
            "imgui_draw.cpp",
            "imgui_demo.cpp",
            "imgui_widgets.cpp",
            "imgui_tables.cpp",
        },
    });

    zimgui.addCSourceFiles(.{
        .root = cimgui.path(""),
        .files = &.{
            "cimgui.cpp"
        },
    });

    _ = b.addModule("imgui_license", .{
        .root_source_file = imgui.path("LICENSE.txt"),
    });

    _ = b.addModule("cimgui_license", .{
        .root_source_file = imgui.path("LICENSE"),
    });

    _ = b.addModule("imgui_include_path", .{
        .root_source_file = imgui.path(""),
    });
}
