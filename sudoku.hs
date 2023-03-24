import Data.List
import Data.Maybe

type Matrix = [[Int]]

solveSudoku :: Matrix -> Maybe Matrix
solveSudoku matrix =
  let emptyCell = findIndex (== 0) (concat matrix)
  in case emptyCell of
    Nothing -> Just matrix
    Just i ->
      let (row, col) = i `divMod` 9
          choices = [1..9] \\ (getRow matrix row ++ getCol matrix col ++ getBox matrix (row, col))
      in case choices of
        [] -> Nothing
        _ ->
          let solve choice = solveSudoku (replaceCell matrix row col choice)
          in listToMaybe (mapMaybe solve choices)

replaceCell :: Matrix -> Int -> Int -> Int -> Matrix
replaceCell matrix row col val =
  let (top, row':bottom) = splitAt row matrix
      (left, _:right) = splitAt col row'
  in top ++ [left ++ val:right] ++ bottom

getRow :: Matrix -> Int -> [Int]
getRow matrix row = matrix !! row

getCol :: Matrix -> Int -> [Int]
getCol matrix col = map (!! col) matrix

getBox :: Matrix -> (Int, Int) -> [Int]
getBox matrix (row, col) =
  let row' = (row `div` 3) * 3
      col' = (col `div` 3) * 3
  in [ matrix !! r !! c | r <- [row'..row'+2], c <- [col'..col'+2] ]

parseMatrix :: String -> Matrix
parseMatrix = map (map read . words) . lines

main :: IO ()
main = do
  input <- readFile "hard_sudoku_2.txt"
  let matrix = parseMatrix input
      solution = solveSudoku matrix
  case solution of
    Nothing -> putStrLn "No solution"
    Just m -> mapM_ print m
