defmodule Aoc2020Test do
  use ExUnit.Case

  test "Day 01 fix expense report 1" do
    assert Day01.fix_expense_report_1() == 436_404
  end

  test "Day 01 fix expense report 2" do
    assert Day01.fix_expense_report_2() == 274_879_808
  end

  test "Day 02 count valid sled passwords" do
    assert Day02.count_valid_sled_passwords() == 548
  end

  test "Day 02 count valid toboggan passwords" do
    assert Day02.count_valid_toboggan_passwords() == 502
  end

  test "Day 03 tree encounter" do
    assert Day03.trees_encountered_r3d1() == 209
  end

  test "Day 03 check multiple slopes" do
    assert Day03.trees_encountered_multiple_slopes() == 1_574_890_240
  end

  test "Day 04 validate passports 1" do
    assert Day04.count_valid_passports_1() == 245
  end

  test "Day 04 validate passports 2" do
    assert Day04.count_valid_passports_2() == 133
  end

  test "Day 05 find highest seat id" do
    assert Day05.find_highest_seat_id() == 970
  end

  test "Day 05 find your seat id" do
    assert Day05.find_your_seat_id() == 587
  end

  test "Day 06 sum each group's unique yes answers" do
    assert Day06.sum_each_groups_unique_yes_answers() == 6748
  end

  test "Day 06 sum each group's common yes answers" do
    assert Day06.sum_each_groups_common_yes_answers() == 3445
  end

  test "Day 07 Quantity of outer bags that contain at least one shiny gold bag" do
    assert Day07.qty_bag_colors_contain_shiny_gold() == 161
  end

  test "Day 07 Quantity of bags contained in one shiny gold bag" do
    assert Day07.qty_bags_contained_in_shiny_gold_bag() == 30899
  end

  test "Day 08 Get accumulator value before infinite loop" do
    assert Day08.get_acc_before_loop() == {:loop, 1179}
  end

  test "Day 08 Fix program and get accumulator value" do
    assert Day08.fix_program_and_get_acc() == 1089
  end

  test "Day 09 Find first invalid XMAS number" do
    assert Day09.find_first_non_xmas_number() == 105_950_735
  end

  test "Day 09 Find XMAS encryption weakness" do
    assert Day09.find_encryption_weakness() == 13_826_915
  end

  test "Day 10 Count joltage adapter differences" do
    assert Day10.count_joltage_adapter_differences() == 2592
  end

  test "Day 10 Count valid adapter sequences" do
    assert Day10.count_valid_adapter_sequences() == 198_428_693_313_536
  end

  test "Day 11 Count final number of ferry seats occupied, Part 1" do
    assert Day11.final_seats_occupied1() == 2427
  end

  test "Day 11 Count final number of ferry seats occupied, Part 2" do
    assert Day11.final_seats_occupied2() == 2199
  end

  test "Day 12 Find Manhatten distance, Part 1" do
    assert Day12.find_manhatten_distance_1() == 2458
  end

  test "Day 12 Find Manhatten distance, Part 2" do
    assert Day12.find_manhatten_distance_2() == 145_117
  end

  test "Day 13 Get the earliest bus" do
    assert Day13.get_earliest_bus() == 5946
  end

  test "Day 13 Get the earliest timestamp" do
    assert Day13.get_earliest_timestamp() == 645_338_524_823_718
  end
end
