defmodule Aoc2020Test do
  use ExUnit.Case

  test "Day 01 fix_expense_report_1" do
    assert Day01.fix_expense_report_1 == 436404
  end

  test "Day 01 fix_expense_report_2" do
    assert Day01.fix_expense_report_2 == 274879808
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

  test "Day 04 validate_passports_1" do
    assert Day04.count_valid_passports_1 == 245
  end

  test "Day 04 validate_passports_2" do
    assert Day04.count_valid_passports_2 == 133
  end
end
