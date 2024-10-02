const std = @import("std");
const dnd = @import("dnd_character.zig");

pub fn main() !void {
    const bron = dnd.Character.init();
    std.debug.print("Str: {d}\n", .{bron.strength});
    std.debug.print("Dex: {d}\n", .{bron.dexterity});
    std.debug.print("Con: {d}\n", .{bron.constitution});
    std.debug.print("Int: {d}\n", .{bron.intelligence});
    std.debug.print("Wis: {d}\n", .{bron.wisdom});
    std.debug.print("Cha: {d}\n", .{bron.charisma});
    std.debug.print("HP: {d}\n", .{bron.hitpoints});
}
