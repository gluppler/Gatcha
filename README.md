## Gatcha: A Simple Grep-Like Tool in Haskell

**Gatcha** is a command-line application built in Haskell, designed to function similarly to the Unix `grep` utility. It allows users to search through text using regular expressions, supporting features such as character classes, anchors, and simple quantifiers.

This tool is a lightweight and functional way to match patterns in text, making it perfect for learning Haskell or building your own text-processing utilities.

### Features:
- Supports regex patterns with character classes (`[abc]`), negation (`[^abc]`), and anchors (`^`, `$`).
- Handles quantifiers like `+` (one or more) and `?` (zero or one).
- Supports alphanumeric matching (`\w`) and digit matching (`\d`).

---

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
