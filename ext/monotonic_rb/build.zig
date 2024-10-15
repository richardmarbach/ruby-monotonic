const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addSharedLibrary(.{
        .name = "monotonic_rb",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .version = .{ .major = 0, .minor = 0, .patch = 1 },
    });

    const ruby_libdir = std.process.getEnvVarOwned(b.allocator, "RUBY_LIBDIR") catch "";
    lib.addLibraryPath(.{ .cwd_relative = ruby_libdir });
    const ruby_hdrdir = std.process.getEnvVarOwned(b.allocator, "RUBY_HDRDIR") catch "";
    lib.addIncludePath(.{ .cwd_relative = ruby_hdrdir });
    const ruby_archhdrdir = std.process.getEnvVarOwned(b.allocator, "RUBY_ARCHHDRDIR") catch "";
    lib.addIncludePath(.{ .cwd_relative = ruby_archhdrdir });

    lib.linkSystemLibrary("c");

    b.installArtifact(lib);

    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
}
