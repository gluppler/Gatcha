## Gatcha: A Simple Grep-Like Tool in Haskell

**Gatcha** is a command-line application built in Haskell, designed to function similarly to the Unix `grep` utility. It allows users to search through text using regular expressions, supporting features such as character classes, anchors, and simple quantifiers.

This tool is a lightweight and functional way to match patterns in text, making it perfect for learning Haskell or building your own text-processing utilities.

### Features:
- Supports regex patterns with character classes (`[abc]`), negation (`[^abc]`), and anchors (`^`, `$`).
- Handles quantifiers like `+` (one or more) and `?` (zero or one).
- Supports alphanumeric matching (`\w`) and digit matching (`\d`).

---
### Premise

1. **Start**: 
   - The user provides input via the command line with the `-E <pattern>` option.
   
2. **Pattern Validation**:
   - Gatcha checks if the provided arguments are valid. If the arguments are incorrect or missing, it prints: 
     ```
     Usage: -E <pattern>
     ```
     and exits with an error.

3. **Input Loop**:
   - The program enters a continuous loop, waiting for the user to input lines of text (typically one line at a time).

4. **Pattern Matching**:
   - For each line entered, Gatcha attempts to match the given pattern against the line using its regex engine.
   - It checks for:
     - Literal characters
     - Character classes (like `\d` for digits or `\w` for alphanumeric)
     - Special symbols (`.`, `+`, `*`, etc.)
     - Anchors (like `^` for start-of-line or `$` for end-of-line)
     - Alternation and grouping (`|` and `()`)

5. **Match Found**:
   - If the pattern matches the line:
     - The program prints the matching line and continues waiting for more input.
   
6. **No Match**:
   - If no match is found:
     - The program moves on to the next input line without taking any further action.

7. **Exit**:
   - The user can terminate the program manually (e.g., via Ctrl+C) when they no longer want to input more lines.

---

### Usage Example:

To compile and run **Gatcha** on your machine, follow these steps:

1. **Compile**:
   ```
   ghc -o gatcha Main.hs
   ```

2. **Run**:
   ```
   ./gatcha -E "^hello"
   ```

   After launching, Gatcha will wait for your input. For example:

   ```
   > hello world
   (Output) hello world  # This line matches the pattern
   > goodbye world
   (No output, as the pattern doesn't match)
   ```

Gatcha will continue to read and check lines against your pattern until you exit manually.

## How to Compile and Run Gatcha

### Prerequisites
- [GHC (Glasgow Haskell Compiler)](https://www.haskell.org/ghc/) installed.
- [Cabal](https://www.haskell.org/cabal/) for building the project.

### Step-by-Step Guide

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/gatcha.git
   cd gatcha
   ```

2. **Build the Project**:
   Use Cabal to build the project:
   ```bash
   cabal build
   ```

3. **Run the Program**:
   After successfully building, you can run Gatcha from the command line:
   ```bash
   cabal run gatcha -- -E "<pattern>"
   ```
   Replace `<pattern>` with the regular expression you want to use.

4. **Example**:
   To search for all lines that contain digits:
   ```bash
   echo "123 abc" | cabal run gatcha -- -E "\\d+"
   ```
   This will output lines matching the digit pattern.

---

### Continuous Mode (Optional)

If you'd like Gatcha to run continuously, reading input line by line, you can pipe multiple lines into it, or modify the `main` function to repeatedly prompt for input.

---

Feel free to explore, customize, and enhance Gatcha for your own use cases!
