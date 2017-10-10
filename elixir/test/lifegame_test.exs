defmodule LifeGameTest do
  use ExUnit.Case
  doctest LifeGame
  import LifeGame

  test "blinker" do
    assert newGeneration(blinker()) == %LifeGame{size: 5, board: [{0,2}, {1,2}, {2,2}]}
  end
end
