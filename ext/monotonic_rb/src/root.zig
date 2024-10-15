const std = @import("std");
const ruby = @cImport(@cInclude("ruby/ruby.h"));
const testing = std.testing;

fn hundred_doors(passes: c_int) c_int {
    var doors = [_]bool{false} ** 101;
    var pass: u8 = 1;
    var door: u8 = undefined;

    while (pass <= passes) : (pass += 1) {
        door = pass;
        while (door <= 100) : (door += pass)
            doors[door] = !doors[door];
    }

    var num_open: u8 = 0;
    for (doors) |open| {
        if (open)
            num_open += 1;
    }
    return num_open;
}

fn rb_hundred_doors(...) callconv(.C) ruby.VALUE {
    var ap = @cVaStart();
    defer @cVaEnd(&ap);

    const self = @cVaArg(&ap, ruby.VALUE);
    _ = self;

    const passes = ruby.NUM2INT(@cVaArg(&ap, ruby.VALUE));
    return ruby.INT2NUM(hundred_doors(passes));
}

export fn Init_libmonotonic_rb() void {
    const monotonic_rb_module: ruby.VALUE = ruby.rb_define_module("MonotonicRb");
    _ = ruby.rb_define_method(monotonic_rb_module, "hundred_doors", rb_hundred_doors, 1);
}

test "hundred doors 100 passes" {
    try testing.expect(hundred_doors(100) == 10);
}

test "hundred_doors 1 pass" {
    try testing.expect(hundred_doors(1) == 100);
}
