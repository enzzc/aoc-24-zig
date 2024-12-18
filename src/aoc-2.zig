const std = @import("std");
const fmt = std.fmt;
const input = @embedFile("inputs/aoc-2.txt");

pub fn main() !void {
    var safeReportsCount: i32 = 0;

    var reports = std.mem.tokenizeScalar(u8, input, '\n');
    while (reports.next()) |report| {
        var reportIsSafe = true;
        var inferredOrder: i8 = 0;

        var levels = std.mem.tokenizeScalar(u8, report, ' ');
        const firstReport = levels.next() orelse "";
        var last = fmt.parseInt(i32, firstReport, 10) catch @panic("Invalid input");
        while (levels.next()) |level| {
            const levelValue = fmt.parseInt(i32, level, 10) catch @panic("Invalid input");
            const dist = levelValue - last;

            if (dist == 0 or @abs(dist) > 3) {
                reportIsSafe = false;
                break;
            }

            var order: i8 = undefined;
            if (dist < 0) {
                order = -1;
            } else if (dist > 0) {
                order = 1;
            } else {
                order = 0;
            }

            if (inferredOrder == 0) {
                // First time: infer order
                inferredOrder = order;
            } else {
                if (inferredOrder != order) {
                    reportIsSafe = false;
                    break;
                }
            }

            last = levelValue;
        }

        if (reportIsSafe) {
            safeReportsCount += 1;
        }
    }

    std.debug.print("{}", .{safeReportsCount});
}
