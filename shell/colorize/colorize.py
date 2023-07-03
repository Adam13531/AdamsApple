#!/usr/bin/python3
# This program transforms a string with color tokens into a single string that
# can be outputted on the terminal.
#
# Examples:
# "^rHello ^gthere!" - prints "Hello" in red and "there!" in green.
# "Caret character: ^^" - prints "Caret character: ^"
# "Newlines \n are \n allowed" - prints "Newlines are allowed" on separate lines.
#
# Colors:
# k - black
# r - red
# g - green
# y - yellow
# b - blue
# p - pink
# c - cyan
# w - white
# n - "noisy" (pink on yellow)
# = - regular colors (whatever colors you have when you first start a Terminal)

import sys
import os

# Keys: str - escape character to find in a string. These must be a single
# character.
# Values: str - the numerical color code(s) to use.
COLORS = {
    'k': '30',  # black
    'r': '31',  # red
    'g': '32',  # green
    'y': '33',  # yellow
    'b': '34',  # blue
    'p': '35',  # pink
    'c': '36',  # cyan
    'w': '37',  # white
    '=': '0',   # regular colors (whatever colors you have when you first start a Terminal)
    'n': '35;43'  # "noisy" (pink on yellow)
}

CLOSE_COLOR_TAG = '\033[0m'

# If this is True, we will output strings without colorizing them. We can't
# simply print input text when this is True because we still need to convert
# newlines and doubled carets.
disableColorization = False


def colorize(text):
    """
    Converts a string like "^rhi" into "\033[31mhi\033[0m".
    :param text: any input string.
    :return: the tokenized string.
    """
    global disableColorization
    finalStr = ''
    openedTag = False

    # We iterate over text, destroying parts of it as we print.
    while True:
        nextCaret = text.find('^')

        # If there is no other '^' or if it's at the end of the text, we're
        # done.
        if nextCaret == -1 or nextCaret == len(text) - 1:
            break

        # Get the character after the caret.
        nextChar = text[nextCaret + 1]

        # Is it a color?
        if nextChar in COLORS:
            # As long as the color tag isn't at the beginning of our string,
            # then we have text to output before emitting this new color.
            if nextCaret != 0:
                finalStr += text[0:nextCaret]

            # Destroy the part of the text that we printed.
            text = text[nextCaret + 2:]

            # Close any open color tags. This may not be necessary except for
            # once at the end.
            if openedTag:
                finalStr += CLOSE_COLOR_TAG

            # Add the new color tag as long as colorization is on.
            if not disableColorization:
                finalStr += '\033[' + COLORS[nextChar] + 'm'
                openedTag = True
        elif nextChar == '^':
            # Found "^^", so only emit one "^".
            finalStr += text[0:nextCaret]
            text = text[nextCaret + 1:]
        else:
            # Didn't find a color tag, so just output the text including the
            # caret that we found.
            finalStr += text[0:nextCaret + 1]
            text = text[nextCaret + 1:]

    # Emit the remaining text.
    finalStr += text

    # Close the open color tag.
    if openedTag:
        finalStr += CLOSE_COLOR_TAG

    # Convert newlines.
    finalStr = finalStr.replace('\\n', os.linesep)

    print(finalStr)


def main():
    if len(sys.argv) == 1:
        return

    # Combine all args after the program's name into a single string.
    argBlob = ' '.join(sys.argv[1:])

    colorize(argBlob)


if __name__ == '__main__':
    main()
