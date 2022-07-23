const std = @import("std");

pub fn fizzbuzz(buf: []u8, n: i64) ![]u8 {
    if (@mod(n, 15) == 0) {
        std.mem.copy(u8, buf, "fizzbuzz");
        return buf[0..8];
    } else if (@mod(n, 3) == 0) {
        std.mem.copy(u8, buf, "fizz");
        return buf[0..4];
    } else if (@mod(n, 5) == 0) {
        std.mem.copy(u8, buf, "buzz");
        return buf[0..4];
    } else {
        return try std.fmt.bufPrint(buf, "{}", .{n});
    }
}

pub fn main() anyerror!void {
    const stdout = std.io.getStdOut().writer();

    var buf: [10]u8 = undefined;

    var i: i64 = 1;
    while (i <= 30) : (i += 1) {
        const s = try fizzbuzz(buf[0..], i);
        try stdout.print("{s}\n", .{s});
    }
}

fn testFizzbuzz(input: i64, output: anytype) !void {
    var buf: [128]u8 = undefined;

    try std.testing.expect(std.mem.eql(u8, output, try fizzbuzz(buf[0..], input)));
}

test "basic test" {
    try testFizzbuzz(1, "1");
    try testFizzbuzz(3, "fizz");
    try testFizzbuzz(5, "buzz");
    try testFizzbuzz(6, "fizz");
    try testFizzbuzz(7, "7");
    try testFizzbuzz(10, "buzz");
    try testFizzbuzz(11, "11");
    try testFizzbuzz(15, "fizzbuzz");
    try testFizzbuzz(30, "fizzbuzz");
}
