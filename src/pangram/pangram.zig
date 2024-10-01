const std = @import("std");

pub fn isPangram(str: []const u8) bool {
    const allocator = std.heap.page_allocator;

    var map = std.AutoHashMap(u8, void).init(allocator);
    defer map.deinit();

    for (str) |c| {
        if (!std.ascii.isAlphabetic(c)) continue;
        map.put(std.ascii.toLower(c), {}) catch {};
    }

    return map.count() == 26;
}
