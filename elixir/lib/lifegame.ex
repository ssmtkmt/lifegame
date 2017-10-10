defmodule LifeGame do
  defstruct size: 0, board: []

  def newGeneration(lifegame = %LifeGame{}) do
    %LifeGame{size: lifegame.size,
              board: (for x <- 0..lifegame.size-1, y <- 0..lifegame.size-1, isAlive(lifegame, x, y), do: {x,y})}
  end

  def countAlive(lifegame = %LifeGame{}, x, y) do
    neigh = for xx <- x-1..x+1, yy <- y-1..y+1, !(xx==x) or !(yy==y), do: {xx, yy}
    lifegame.board
    |> Enum.filter(fn elm -> Enum.member?(neigh, elm) end)
    |> Kernel.length
  end

  def isAlive(lifegame = %LifeGame{}, x, y) do
    numAlive = countAlive(lifegame, x, y)
    nowAlive = Enum.member?(lifegame.board, {x, y})
    cond do
      nowAlive && numAlive != 2 && numAlive != 3
        -> false
      !nowAlive && numAlive == 3
        -> true
      true
        -> nowAlive
    end
  end

  def putCell(lifegame = %LifeGame{}, x, y) do
    if {x, y} in lifegame.board do
      '*'
    else
      ' '
    end
  end

  def printRow(lifegame = %LifeGame{}, row) do
    IO.puts(for y <- 0..lifegame.size, do: putCell(lifegame, row, y))
  end

  def printBoard(lifegame = %LifeGame{}) do
    for x <- 0..lifegame.size, do: printRow(lifegame, x)
  end

  def runLifegame(lifegame = %LifeGame{}) do
    IEx.Helpers.clear()
    printBoard(lifegame)
    IO.puts("")
    :timer.sleep(100)
    runLifegame(newGeneration(lifegame))
  end

  def blinker do
    %LifeGame{size: 5, board: [{1,1}, {1,2}, {1,3}]}
  end

  def pulsar do
    %LifeGame{size: 17, board: [{7,8}, {7,9}, {7,10}, {9,9}, {11,8}, {11,9}, {11,10}]}
  end

  def main do
    runLifegame(pulsar())
  end

end
