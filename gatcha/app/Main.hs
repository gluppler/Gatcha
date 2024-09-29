module Main where

import System.Environment (getArgs)
import System.Exit (exitFailure, exitSuccess)
import Data.Char (isDigit, isAlpha)

-- Match a character against a positive character group
matchPositiveCharGroup :: String -> String -> Bool
matchPositiveCharGroup group text = any (`elem` text) group

-- Match a character against a negative character group
matchNegativeCharGroup :: String -> String -> Bool
matchNegativeCharGroup group text = not $ matchPositiveCharGroup group text

-- Strip zero or more occurrences of a character from the start of a string
stripZeroOrMoreChars :: Char -> String -> String
stripZeroOrMoreChars _ [] = []
stripZeroOrMoreChars c (d:remaining)
  | c == d = stripZeroOrMoreChars c remaining
  | otherwise = d : remaining

-- Match a regex pattern at the current position in the text
matchHere :: String -> String -> Bool
matchHere ('\\':'d':remainingExpr) (d:text) = isDigit d && matchHere remainingExpr text
matchHere ('\\':'w':remainingExpr) (a:text) = isAlpha a && matchHere remainingExpr text

-- Match a negative character group
matchHere ('[':'^':remainingExpr) text =
  case text of
    (c:remainingText) -> matchNegativeCharGroup negGroup [c] && matchHere (drop 1 restExpr) remainingText
      where (negGroup, restExpr) = span (/= ']') remainingExpr
    [] -> False  -- No more characters in text to match

-- Match a positive character group
matchHere ('[':remainingExpr) text =
  case text of
    (c:remainingText) -> matchPositiveCharGroup posGroup [c] && matchHere (drop 1 restExpr) remainingText
      where (posGroup, restExpr) = span (/= ']') remainingExpr
    [] -> False  -- No more characters in text to match

-- Match one or more occurrences of a character
matchHere (c:'+':remainingExpr) (d:remainingText)
  | c == d = matchHere remainingExpr (stripZeroOrMoreChars c remainingText)
  | otherwise = False

-- Match zero or one occurrence of a character
matchHere (c:'?':remainingExpr) text@(d:remainingText)
  | c == d = matchHere remainingExpr remainingText
  | otherwise = matchHere remainingExpr text

-- Match alternation pattern
matchHere ('(':remainingExpr) text =
  let (leftAlt, rest) = break (== '|') remainingExpr
      (rightAlt, endParen) = span (/= ')') (drop 1 rest)  -- Drop 1 to skip the '|'
  in case endParen of
      (')':restExpr) -> matchHere leftAlt text || matchHere rightAlt text && matchHere restExpr text
      _ -> False  -- Malformed pattern, missing closing parenthesis

-- Match any single character
matchHere ('.':remainingExpr) (_:remainingText) = matchHere remainingExpr remainingText

-- Match a literal character
matchHere (c:remainingExpr) (d:remainingText) = c == d && matchHere remainingExpr remainingText

-- Match end of expression
matchHere [] _ = True
matchHere _ [] = False

-- Check if the pattern matches anything in the regular expression
matchPattern :: String -> String -> Bool
matchPattern [] _ = True
matchPattern _ [] = False

-- Handle start-of-string anchor
matchPattern ('^':startExpr) text = matchHere startExpr text

matchPattern expr@(p:_) text
  -- Handle end-of-string anchor
  | last expr == '$' =
      let (endExpr, suffix) = span (/= '$') expr
          textSuffix = drop (length text - length endExpr) text
      in suffix == "$" && matchHere endExpr textSuffix
  -- Handle non-anchored patterns
  | matchHere expr text = True
  | otherwise = matchPattern expr (tail text)

-- Loop continuously, reading input and applying the regex
main :: IO ()
main = do
  args <- getArgs
  if null args || head args /= "-E" || length args < 2 then do
      putStrLn "Usage: grippy -E <pattern>"
      exitFailure
    else do
      let pattern = args !! 1
      putStrLn $ "Matching pattern: " ++ pattern
      putStrLn "Enter lines of text to match against the pattern (Ctrl+C to exit):"
      inputLoop pattern

-- Function to continuously accept input and process it
inputLoop :: String -> IO ()
inputLoop pattern = do
  putStr "> "  -- Print a prompt
  input_line <- getLine
  if matchPattern pattern input_line
    then putStrLn "Match!"
    else putStrLn "No match."
  inputLoop pattern  -- Continue the loop


