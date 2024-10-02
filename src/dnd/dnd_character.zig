const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

pub fn modifier(score: i8) i8 {
    const number = score - 10;
    const result = std.math.divFloor(i8, number, 2) catch return 0;
    return result;
}

pub fn ability() i8 {
    const rolls = roll(4) catch return 0;
    defer allocator.free(rolls);

    std.mem.sort(u8, rolls, {}, std.sort.desc(u8));

    var sum: u8 = 0;
    for (0..rolls.len - 1) |i| {
        sum += rolls[i];
    }

    const result: i8 = @intCast(sum);
    return result;
}

pub const Character = struct {
    strength: i8,
    dexterity: i8,
    constitution: i8,
    intelligence: i8,
    wisdom: i8,
    charisma: i8,
    hitpoints: i8,

    pub fn init() Character {
        const constitition = ability();
        const hitpoints = 10 + modifier(constitition);
        return Character{ .strength = ability(), .dexterity = ability(), .constitution = constitition, .intelligence = ability(), .wisdom = ability(), .charisma = ability(), .hitpoints = hitpoints };
    }
};

fn roll(numOfDice: u8) ![]u8 {
    var rng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });

    var rolls = try allocator.alloc(u8, numOfDice);

    for (0..numOfDice) |i| {
        rolls[i] = rng.random().intRangeAtMost(u8, 1, 6);
    }

    return rolls;
}
