# Received a string and an index to start looking for
# either a digit or a textual repr of a digit.
# It returns the int value and modifies the index to point
# to the next index to keep looking.
fn str2dig(s: String, inout idx: Int) -> Int:
    if s[idx] == "0" or s[idx : idx + 4] == "zero":
        if s[idx] != "0":
            idx += 4
        return 0
    elif s[idx] == "1" or s[idx : idx + 3] == "one":
        if s[idx] != "1":
            idx += 3
        return 1
    elif s[idx] == "2" or s[idx : idx + 3] == "two":
        if s[idx] != "2":
            idx += 3
        return 2
    elif s[idx] == "3" or s[idx : idx + 5] == "three":
        if s[idx] != "3":
            idx += 5
        return 3
    elif s[idx] == "4" or s[idx : idx + 4] == "four":
        if s[idx] != "4":
            idx += 4
        return 4
    elif s[idx] == "5" or s[idx : idx + 4] == "five":
        if s[idx] != "5":
            idx += 4
        return 5
    elif s[idx] == "6" or s[idx : idx + 3] == "six":
        if s[idx] != "6":
            idx += 3
        return 6
    elif s[idx] == "7" or s[idx : idx + 5] == "seven":
        if s[idx] != "7":
            idx += 5
        return 7
    elif s[idx] == "8" or s[idx : idx + 5] == "eight":
        if s[idx] != "8":
            idx += 5
        return 8
    elif s[idx] == "9" or s[idx : idx + 4] == "nine":
        if s[idx] != "9":
            idx += 4
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
        let maybe_digit: Int = str2dig(adventure, idx)
        if maybe_digit != -1 and first == -1:
            first = maybe_digit
            last = maybe_digit
        elif maybe_digit != -1:
            last = maybe_digit
    print(sum)
