const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const zlib_dep = b.dependency("zlib", .{
        .target = target,
        .optimize = optimize
    });
    const zlib_lib = zlib_dep.artifact("zlib");

    const lib_dep = b.dependency("libpng", .{});
    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "libpng",
        .root_module = b.addModule("libpng", .{.target = target, .optimize = optimize}),
    });
    const wf = b.addWriteFiles();
    const install = wf.addCopyFile(lib_dep.path("scripts/pnglibconf.h.prebuilt"), "pnglibconf.h");
    lib.step.dependOn(&wf.step);
    lib.linkLibC();
    lib.root_module.linkLibrary(zlib_lib);
    lib.root_module.addIncludePath(wf.getDirectory());
    lib.installHeader(lib_dep.path("png.h"), "png.h");
    lib.installHeader(install, "pnglibconf.h");
    lib.installHeader(lib_dep.path("pngconf.h"), "pngconf.h");
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
