fn parse_digit(s: String, inout idx: Int) -> Int:
    var dig = 0
    if s[idx] == "0":
        dig = 0
    elif s[idx] == "1":
        dig = 1
    elif s[idx] == "2":
        dig = 2
    elif s[idx] == "3":
        dig = 3
    elif s[idx] == "4":
        dig = 4
    elif s[idx] == "5":
        dig = 5
    elif s[idx] == "6":
        dig = 6
    elif s[idx] == "7":
        dig = 7
    elif s[idx] == "8":
        dig = 8
    elif s[idx] == "9":
        dig = 9
    else:
        return -1
    idx += 1
    return dig


fn parse_number(s: String, inout idx: Int) -> Int:
    var num = 0
    while idx < len(s):
        let dig = parse_digit(s, idx)
        if dig < 0:
            break
        num = num * 10 + dig
    return num


fn parse_colour(s: String, inout idx: Int) -> String:
    if is_prefix("red", s, idx):
        idx += 3
        return "red"
    elif is_prefix("green", s, idx):
        idx += 5
        return "green"
    elif is_prefix("blue", s, idx):
        idx += 4
        return "blue"
    else:
        return ""

fn is_prefix(prf: String, s: String, idx: Int) -> Bool:
    # Returns true if the string s is a prefix of the string s
    if len(prf) > len(s) - idx:
        return False
    
    var i = 0
    while i < len(prf):
        if prf[i] != s[i+idx]:
            return False
        i += 1
    return True


fn skip_ws(s: String, inout idx: Int):
    while s[idx] == " ":
        idx += 1

fn skip_game(s: String, inout idx: Int):
    print("skip_game")
    while s[idx] != "\n":
        idx += 1
    idx += 1

fn parse_draw(line: String, inout idx: Int) raises -> (Int, Int, Int):
    print("parse_draw", idx)
    # Parses a line of the form:
    # 3 blue, 4 red;
    # that's an int followed by a color, followed by a comma, etc until it gets to a semicolor or end of line.
    # Returns a tuple (red, green, blue)
    var red: Int = 0
    var green: Int = 0
    var blue: Int = 0

    while line[idx] != ";" and line[idx] != "\n":
        let num = parse_number(line, idx)
        if num < 0:
            raise "Invalid digit"
        skip_ws(line, idx)
        let colour = parse_colour(line, idx)
        if colour == "red":
            red += num
        elif colour == "green":
            green += num
        elif colour == "blue":
            blue += num
        else:
            raise "Invalid colour"
        skip_ws(line, idx)
        if line[idx] == ",":
            idx += 1
            skip_ws(line, idx)

    return red, green, blue

fn is_valid_draw(telf: (Int, Int, Int), tgiven: (Int, Int, Int)) -> Bool:
    print("is_valid_draw")
    # Returns true if the given draw is valid for the elf
    #let (elf_red, elf_green, elf_blue) = telf
    let elf_red: Int = telf.get[0, Int]()
    let elf_green: Int = telf.get[1, Int]()
    let elf_blue: Int = telf.get[2, Int]()

    # let (given_red, given_green, given_blue) = tgiven
    let given_red: Int = tgiven.get[0, Int]()
    let given_green: Int = tgiven.get[1, Int]()
    let given_blue: Int = tgiven.get[2, Int]()

    print("elf", elf_red, elf_green, elf_blue)
    print("given", given_red, given_green, given_blue)

    return elf_red >= given_red and elf_green >= given_green and elf_blue >= given_blue and 
        elf_red + elf_green + elf_blue >= given_red + given_green + given_blue

fn max(a: Int, b: Int) -> Int:
    if a > b:
        return a
    else:
        return b

fn find_valid_game(gameStr: String, inout idx: Int) -> Int:
    # Returns the multiplication of the colors of cubes that make the game valid

    # Parse the game
    if not is_prefix("Game", gameStr, idx):
        return 0
    idx += 4
    skip_ws(gameStr, idx)

    let game_num = parse_number(gameStr, idx)
    if game_num <= 0:
        return 0
    print("Game number: ", game_num)

    skip_ws(gameStr, idx)
    if gameStr[idx] != ":":
        return 0
    idx += 1
    skip_ws(gameStr, idx)

    var minRed = 0
    var minGreen = 0
    var minBlue = 0

    # Parse the draws
    while gameStr[idx] != "\n":
        print("game analysis loop", idx)
        try:
            let tup: (Int, Int, Int) = parse_draw(gameStr, idx)
            minRed = max(minRed, tup.get[0, Int]())
            minGreen = max(minGreen, tup.get[1, Int]())
            minBlue = max(minBlue, tup.get[2, Int]())

        except:
            print("exception")
            break

        skip_ws(gameStr, idx)
        if gameStr[idx] == ";":
            idx += 1
        skip_ws(gameStr, idx)
    
    debug_assert(gameStr[idx] == "\n", "Expected newline")
    idx += 1 # skip the newline
    let gamePower = minRed * minGreen * minBlue
    print("game ", game_num, " Power: ", gamePower)
    return gamePower


fn main() raises:
    var lines: String = ""
    with open("day2.txt", "r") as f:
        lines = f.read()

    # Parse games line by line
    var accum = 0
    var idx = 0
    while idx >= 0 and idx < len(lines):
        # A Game is a tuple of (red, green, blue)
        accum += find_valid_game(lines, idx)
    print(accum)
