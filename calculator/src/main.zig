const std = @import("std");

const Calculator = struct {
    stack: [256]i64,
    idx: u8,
    gonext: bool,

    pub fn init() Calculator {
        var c = Calculator{
            .stack = undefined,
            .idx = 0,
            .gonext = false,
        };
        c.stack[0] = 0;
        return c;
    }

    fn move_next_if_need(self: *Calculator) void {
        if (self.gonext) {
            self.idx += 1;
            self.stack[self.idx] = 0;
            self.gonext = false;
        }
    }

    fn pop(self: *Calculator) void {
        self.gonext = true;
        self.idx -= 1;
    }

    pub fn calc_char(self: *Calculator, char: u8) !void {
        switch (char) {
            '0'...'9' => {
                self.move_next_if_need();
                self.stack[self.idx] = self.stack[self.idx] * 10 + (char - '0');
            },
            ' ', '\t' => self.gonext = true,
            '+' => {
                self.stack[self.idx - 1] += self.stack[self.idx];
                self.pop();
            },
            '-' => {
                self.stack[self.idx - 1] -= self.stack[self.idx];
                self.pop();
            },
            '*' => {
                self.stack[self.idx - 1] *= self.stack[self.idx];
                self.pop();
            },
            '/' => {
                self.stack[self.idx - 1] = @divTrunc(self.stack[self.idx - 1], self.stack[self.idx]);
                self.pop();
            },
            else => return error.InvalidCharacter,
        }
    }

    pub fn calc(self: *Calculator, expr: anytype) !i64 {
        for (expr) |c| {
            try self.calc_char(c);
        }

        return self.stack[self.idx];
    }
};

fn calculate(expr: anytype) !i64 {
    var calculator = Calculator.init();

    return try calculator.calc(expr);
}

pub fn main() anyerror!void {
    var result = try calculate("10 20 + 5 / 1 - 1 1 + *");
    std.log.info("result:{}", .{result});
}

test "basic test" {
    try std.testing.expectEqual(@as(i64, 10), try calculate("10"));
    try std.testing.expectEqual(@as(i64, 20), try calculate("10 20"));
    try std.testing.expectEqual(@as(i64, 30), try calculate("10 20 +"));
    try std.testing.expectEqual(@as(i64, 10), try calculate("1 2 3 + 4 + +"));
    try std.testing.expectEqual(@as(i64, 20), try calculate("10 30 + 2 /"));
    try std.testing.expectEqual(@as(i64, 7), try calculate("5 2 * 3 -"));
}
