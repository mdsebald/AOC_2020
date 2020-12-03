defmodule Aoc2020Test do
  use ExUnit.Case

  test "Day 01 fix_expense_report" do
    assert Day01.fix_expense_report
  end

  test "Day 02 count_valid_sled_passwords" do
    assert Day02.count_valid_sled_passwords == 548
  end

  test "Day 02 count_valid_toboggan_passwords" do
    assert Day02.count_valid_toboggan_passwords == 502
  end

  test "Day 03 tree_encounter" do
    assert Day03.tree_encounter == 209
  end

  test "Day 03 check_multiple_slopes" do
    assert Day03.check_multiple_slopes == 1574890240
  end

end
