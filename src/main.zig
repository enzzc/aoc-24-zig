const std = @import("std");
const fmt = std.fmt;
const input = @embedFile("inputs/aoc-1.txt");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var leftList = std.ArrayList(i32).initCapacity(allocator, 1024) catch @panic("Cannot allocate");
    var rightList = std.ArrayList(i32).initCapacity(allocator, 1024) catch @panic("Cannot allocate");

    defer leftList.deinit();
    defer rightList.deinit();

    var it = std.mem.tokenizeScalar(u8, input, '\n');
    while (it.next()) |line| {
        var parts = std.mem.tokenizeScalar(u8, line, ' ');
        const leftPart = parts.next() orelse "";
        const rightPart = parts.next() orelse "";
        const left = fmt.parseInt(i32, leftPart, 10) catch @panic("Invalid input");
        const right = fmt.parseInt(i32, rightPart, 10) catch @panic("Invalid input");

        try leftList.append(left);
        try rightList.append(right);
    }

    std.mem.sort(i32, leftList.items, {}, std.sort.asc(i32));
    std.mem.sort(i32, rightList.items, {}, std.sort.asc(i32));

    var acc: i32 = 0;
    for (leftList.items, rightList.items) |l, r| {
        var dist = l - r;
        if (dist < 0) {
            dist = -dist;
        }
        acc += dist;
    }

    std.debug.print("{}", .{acc});
}
