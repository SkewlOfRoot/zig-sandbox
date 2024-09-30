const std = @import("std");
var generalPurposeAllocator = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = generalPurposeAllocator.allocator();

pub fn main() !void {
    const args = try std.process.argsAlloc(gpa);
    defer std.process.argsFree(gpa, args);

    const stdout = std.io.getStdOut().writer();

    // Validate correct number of arguments.
    if (args.len < 2 or args.len > 2) {
        try stdout.print("Invalid number of arguments. Usage: {s} <number>\nExample: {s} 1234", .{ args[0], args[0] });
        return;
    }

    // Validate input numbers.
    const asciiNumbers = args[1];
    if (!validateNumbers(asciiNumbers)) {
        try stdout.print("Invalid input. Must contain only numbers.\n", .{});
        return;
    }

    const numbers = try convertToNumbers(gpa, asciiNumbers);

    // Run the Luhn algorithm and return the check digit.
    const checkDigit = try algo(gpa, numbers[0 .. numbers.len - 1]);

    // If the result is 0 it means that the input number is valid.
    try stdout.print("Check digit: {d}\n", .{checkDigit});
    if (checkDigit == numbers[numbers.len - 1]) {
        try stdout.print("Valid number!", .{});
    } else {
        try stdout.print("NOT a valid number!", .{});
    }
}

// Validate input bytes - make sure all are numbers.
fn validateNumbers(input: []u8) bool {
    var num = input;
    if (std.mem.endsWith(u8, input, "\r")) {
        num = input[0 .. input.len - 1];
    }

    for (num) |n| {
        if (n < '0' or n > '9') {
            return false;
        }
    }
    return true;
}

// Convert from ASCII bytes to ints.
fn convertToNumbers(allocator: std.mem.Allocator, asciiNumbers: []u8) ![]u8 {
    const len = asciiNumbers.len;
    const numbers = try allocator.alloc(u8, len);

    for (0.., asciiNumbers) |i, val| {
        numbers[i] = val - '0';
    }
    return numbers;
}

// This is the actual Luhn algorithm.
fn algo(allocator: std.mem.Allocator, numbers: []u8) !u8 {
    var newNumbers: []u8 = try allocator.alloc(u8, numbers.len);

    var i: usize = numbers.len;
    var count: usize = 0;
    while (i > 0) {
        i -= 1;
        const n = numbers[i];
        if (count % 2 == 0) {
            const product = n * 2;
            if (product >= 10) {
                const tens = product / 10;
                const units = product % 10;
                newNumbers[i] = tens + units;
            } else {
                newNumbers[i] = product;
            }
        } else {
            newNumbers[i] = n;
        }
        count += 1;
    }

    var sum: u8 = 0;
    for (newNumbers) |n| {
        sum += n;
    }
    // Calculate the check digit from the sum.
    return 10 - (sum % 10);
}
