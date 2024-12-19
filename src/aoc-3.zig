const std = @import("std");
const input = @embedFile("inputs/aoc-3.txt");

fn getShift(char: u8) usize {
    switch (char) {
        'm' => return 3,
        'u' => return 2,
        'l' => return 1,
        else => return 4,
    }
}

fn isDigit(char: u8) bool {
    return char >= '0' and char <= '9';
}

fn parseExpressionAndMul(start: usize, text: []const u8) i64 {
    var idx: usize = start + 4; // Ignore leading "mul("

    var operand1: f64 = 0;
    var operand2: f64 = 0;

    var power: f64 = 0;
    while (true) {
        const char = text[idx];
        if (isDigit(char)) {
            const ord = char - 48;
            operand1 += @as(f64, @floatFromInt(ord)) * (std.math.pow(f64, 10, -power));
            power += 1;
        } else if (char == ',') {
            idx += 1;
            break;
        } else {
            // Syntax error
            return 0;
        }
        idx += 1;
    }

    operand1 *= std.math.pow(f64, 10, power - 1);

    power = 0;
    while (true) {
        const char = text[idx];
        if (isDigit(char)) {
            const ord = char - 48;
            operand2 += @as(f64, @floatFromInt(ord)) * (std.math.pow(f64, 10, -power));
            power += 1;
        } else if (char == ')') {
            idx += 1;
            break;
        } else {
            // Syntax error
            return 0;
        }
        idx += 1;
    }
    operand2 *= std.math.pow(f64, 10, power - 1);

    const product = @round(operand1) * @round(operand2);
    return @as(i64, @intFromFloat(product));
}

pub fn main() !void {
    std.debug.print("Start.\n", .{});
    var acc: i64 = 0;

    // This is an ad-hoc Boyer-Moore-Horspool algorithm implementation
    const key = "mul(";
    const N = key.len;
    var pos = N - 1;
    while (pos < input.len) {
        if (input[pos - (N - 4)] != '(') {
            pos += getShift(input[pos - (N - 4)]);
            continue;
        }
        if (input[pos - (N - 3)] != 'l') {
            pos += getShift(input[pos - (N - 3)]);
            continue;
        }
        if (input[pos - (N - 2)] != 'u') {
            pos += getShift(input[pos - (N - 2)]);
            continue;
        }
        if (input[pos - (N - 1)] != 'm') {
            pos += getShift(input[pos - (N - 1)]);
            continue;
        }

        const idx = pos - (N - 1);
        const product = parseExpressionAndMul(idx, input);
        acc += product;

        pos += getShift(input[pos - (N - 1)]);
    }

    std.debug.print("{}\n", .{acc});
}
