const std = @import("std");

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
}

// Structs

const Response = struct {
    counter: i30 = 0,
    payload: [*]u8,
};

// Enums 1: Standard enums

const Category = enum {
    TEST,
    RUNTIME,
};

// Enums 2: Tagged unions (like Rust)

const Request = union(enum) {
    delete_all,
    delete: []u8,
    read: struct {
        target: []u8,
        offset: ?u32,
    },
};

fn takes_request(request: Request) void {
    switch (request) {
        .delete_all => {},
        .delete => |*target| {
            _ = target;
        },
        .delete_all => |*val| {
            _ = val.target;
        },
    }
}

// Methods

// Must be declared in-place.

const HasMethod = struct {
    field: i32,
    fn takes_self(self: @This()) void {
        _ = self.field;
    }
};

// Options

fn maybe_do(data: ?u32) void {
    // has to be different name :(
    if (data) |actual_data| {
        _ = actual_data;
    }
}

// Error handling

fn try_do() !i32 {
    return error.NotImplemented;
}

fn use_result() !void {
    _ = try try_do();

    _ = try_do().?;

    _ = try_do() catch 0;

    _ = try_do() catch |err| {
        _ = err;
        @panic("woops");
    };
}

// Generics 1: Generic structs/unions etc.

fn LinkedList(item: type) type {
    return struct {
        item: item,
        allocator: std.mem.Allocator,
        next: ?*@This() = null,

        fn append(self: *@This(), i: item) void {
            var this = self;
            while (this.next) |next| {
                this = next;
            }
            this.next = this.allocator.alloc(@This(), 1);
            this.next.item = i;
            this.next.allocator = this.allocator;
        }

        fn deinit(self: *@This()) void {
            if (self.next) |next| {
                next.deinit();
            }

            self.allocator.free(self);
        }
    };
}

// Generics 2: Duck typing (C++ style)

const NoiseMaker = struct {
    fn bark(self: @This()) void {
        _ = self;
    }
};

// "punning"
fn takes_noise_maker(maker: anytype) void {
    maker.bark();
}

// Clean-up: defer

const WarnsOnDrop = struct {
    fn deinit() void {
        std.log.warn("I think you forgot about me!", .{});
    }
};

fn warns_on_drop() void {
    const wod = WarnsOnDrop{};
    // have to readd for every usage, does not get run automatically, but is explicit
    defer wod.deinit();
}

// Async: Currently unavailable, but planned with a similar approach to Rust,
// but somehow magically without "function coloring"..

// Tests

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
