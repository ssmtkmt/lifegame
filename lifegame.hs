import Data.Array

data Lifegame = Lifegame { size :: Int
                         , board :: [(Int, Int)]
                         }

newGeneration :: Lifegame -> Lifegame
newGeneration (Lifegame size board) = (Lifegame size [(x,y) |x <- [0..size-1], y <- [0..size-1], isAlive (x,y) (Lifegame size board)])

isAlive :: (Int, Int) -> Lifegame -> Bool
isAlive (x, y) (Lifegame size board)
  | nowAlive && numAlive /= 2 && numAlive /= 3  = False
  | not nowAlive && numAlive == 3               = True
  | otherwise = nowAlive
  where numAlive = countAlive (x,y) (Lifegame size board)
        nowAlive = (x,y) `elem` board

countAlive :: (Int, Int) -> Lifegame -> Int
countAlive (x,y) (Lifegame size board) = length $ filter (flip elem [(xx,yy)|xx <- [x-1..x+1], yy <- [y-1..y+1], (xx,yy)/=(x,y)]) board

-- 以下は出力用関数

putCell :: Lifegame -> (Int, Int) -> Char
putCell (Lifegame size board) (x,y) = if (x,y) `elem` board 
                                          then '*'
                                          else ' '

printRow :: Lifegame -> Int -> IO ()
printRow (Lifegame size board) row = print $ map (putCell (Lifegame size board)) [(row,y)|y <- [0..size-1]] 

printBoard :: Lifegame -> IO ()
printBoard (Lifegame size board) = mapM_ (printRow (Lifegame size board)) [x|x <- [0..size-1]]

runLifegame :: Lifegame -> IO String
runLifegame lifegame = do
    printBoard lifegame
    getLine
    runLifegame $ newGeneration lifegame

init_state :: Lifegame
init_state = Lifegame 10 [(1,1), (1,2), (1,3)]

main = do
    runLifegame init_state
