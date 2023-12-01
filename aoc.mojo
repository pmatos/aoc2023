from utils.vector import DynamicVector


# Reads lines from filename as a list of strings
""" fn read_lines(filename: String) raises -> DynamicVector[StringRef]:
    var handler: FileHandle = open("day1.txt", "r")
    let adventure: String = handler.read()
    handler.close()

    # In the absence of a string.split, lets loop over the
    # string and grab slices to put into a vector.
    var lines: DynamicVector[StringRef]
    var start: Int = 0
    var idx: Int = 0
    for i in range(len(adventure)):
        if adventure[i] == "\n" or i == len(adventure) - 1:
            lines.push_back(adventure[start:i])
            start = i + 1
    return lines """


fn str2dig(s: String) -> Int:
    if s == "0":
        return 0
    elif s == "1":
        return 1
    elif s == "2":
        return 2
    elif s == "3":
        return 3
    elif s == "4":
        return 4
    elif s == "5":
        return 5
    elif s == "6":
        return 6
    elif s == "7":
        return 7
    elif s == "8":
        return 8
    elif s == "9":
        return 9
    else:
        return -1


fn main() raises:
    # We can read the file on the fly while calculating what we need.
    # It looks ugly but it's the best we can do without better stdlib.
    var handler: FileHandle = open("day1.txt", "r")
    let adventure: String = handler.read()
    handler.close()

    # We can now loop through the string and find first and last digits
    # and accumulate them as we go.
    var first: Int = -1  # int value of first digit in current line
    var last: Int = -1  # int value of last digit in current line
    var sum: Int = 0  # current sum
    for idx in range(len(adventure)):
        if adventure[idx] == "\n" or idx == len(adventure) - 1:
            if first == -1 or last == -1:
                print("Invalid line")
            let val: Int = first * 10 + last
            sum += val
            first = -1
            last = -1
            continue
        let maybe_digit: Int = str2dig(adventure[idx])
        if maybe_digit != -1 and first == -1:
            first = maybe_digit
            last = maybe_digit
        elif maybe_digit != -1:
            last = maybe_digit
    print(sum)
