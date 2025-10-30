const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const lib_dep = b.dependency("libpng", .{});
    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "libpng",
        .root_module = b.addModule("libpng", .{.target = target, .optimize = optimize}),
    });
    lib.installHeader(lib_dep.path("png.h"), "png.h");
    lib.linkLibC();
    lib.root_module.addCSourceFiles(.{
        .root = lib_dep.path(""), 
        .files = &.{
            "png.c",
            "pngerror.c",
            "pngget.c",
            "pngmem.c",
            "pngpread.c",
            "pngread.c",
            "pngrio.c",
            "pngrtran.c",
            "pngrutil.c",
            "pngset.c",
            "pngtrans.c",
            "pngwio.c",
            "pngwrite.c",
            "pngwtran.c",
            "pngwutil.c",
        }});
    b.installArtifact(lib);
}
