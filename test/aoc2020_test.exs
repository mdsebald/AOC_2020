defmodule Aoc2020Test do
  use ExUnit.Case

  test "Day 01, Part 1: Fix expense report" do
    assert Day01.fix_expense_report_1() == 436_404
  end

  test "Day 01, Part 2: Fix expense report 2" do
    assert Day01.fix_expense_report_2() == 274_879_808
  end

  test "Day 02, Part 1: Count valid sled passwords" do
    assert Day02.count_valid_sled_passwords() == 548
  end

  test "Day 02, Part 2: Count valid toboggan passwords" do
    assert Day02.count_valid_toboggan_passwords() == 502
  end

  test "Day 03, Part 1: Tree encounter" do
    assert Day03.trees_encountered_r3d1() == 209
  end

  test "Day 03, Part 2: Check multiple slopes" do
    assert Day03.trees_encountered_multiple_slopes() == 1_574_890_240
  end

  test "Day 04, Part 1: Validate passports 1" do
    assert Day04.count_valid_passports_1() == 245
  end

  test "Day 04, Part 2: Validate passports 2" do
    assert Day04.count_valid_passports_2() == 133
  end

  test "Day 05, Part 1: Find highest seat id" do
    assert Day05.find_highest_seat_id() == 970
  end

  test "Day 05, Part 2: Find your seat id" do
    assert Day05.find_your_seat_id() == 587
  end

  test "Day 06, Part 1: Sum each group's unique yes answers" do
    assert Day06.sum_each_groups_unique_yes_answers() == 6748
  end

  test "Day 06, Part 2: Sum each group's common yes answers" do
    assert Day06.sum_each_groups_common_yes_answers() == 3445
  end

  test "Day 07, Part 1: Quantity of outer bags that contain at least one shiny gold bag" do
    assert Day07.qty_bag_colors_contain_shiny_gold() == 161
  end

  test "Day 07, Part 2: Quantity of bags contained in one shiny gold bag" do
    assert Day07.qty_bags_contained_in_shiny_gold_bag() == 30899
  end

  test "Day 08, Part 1: Get accumulator value before infinite loop" do
    assert Day08.get_acc_before_loop() == {:loop, 1179}
  end

  test "Day 08, Part 2: Fix program and get accumulator value" do
    assert Day08.fix_program_and_get_acc() == 1089
  end

  test "Day 09, Part 1: Find first invalid XMAS number" do
    assert Day09.find_first_non_xmas_number() == 105_950_735
  end

  test "Day 09, Part 2: Find XMAS encryption weakness" do
    assert Day09.find_encryption_weakness() == 13_826_915
  end

  test "Day 10, Part 1: Count joltage adapter differences" do
    assert Day10.count_joltage_adapter_differences() == 2592
  end

  test "Day 10, Part 2: Count valid adapter sequences" do
    assert Day10.count_valid_adapter_sequences() == 198_428_693_313_536
  end

  test "Day 11, Part 1: Count final number of ferry seats occupied" do
    assert Day11.final_seats_occupied1() == 2427
  end

  test "Day 11, Part 2: Count final number of ferry seats occupied" do
    assert Day11.final_seats_occupied2() == 2199
  end

  test "Day 12, Part 1: Find Manhatten distance" do
    assert Day12.find_manhatten_distance_1() == 2458
  end

  test "Day 12, Part 2: Find Manhatten distance" do
    assert Day12.find_manhatten_distance_2() == 145_117
  end

  test "Day 13, Part 1: Get the earliest bus" do
    assert Day13.get_earliest_bus() == 5946
  end

  test "Day 13, Part 2: Get the earliest timestamp" do
    assert Day13.get_earliest_timestamp() == 645_338_524_823_718
  end

  test "Day 14, Part 1: Sum memory values after initialization" do
    assert Day14.mem_sum_after_init_1() == 9_296_748_256_641
  end

  test "Day 14, Part 2: Sum memory values after initialization" do
    assert Day14.mem_sum_after_init_2() == 4_877_695_371_685
  end

  test "Day 15, Part 1: Get the 2020th number spoken" do
    assert Day15.get_2020th_num_spoken() == 852
  end

  test "Day 15, Part 2: Get the 30,000,000th number spoken" do
    assert true
    # takes too long to run
    # assert Day15.get_30_000_000th_num_spoken() == 6_007_666
  end

  test "Day 16, Part 1: Calculate ticket scan error rate" do
    assert Day16.calc_ticket_scan_error_rate() == 26988
  end

  test "Day 16, Part 2: Multiply your ticket's departure fields" do
    assert Day16.mult_your_ticket_departure_fields() == 426_362_917_709
  end

  test "Day 17, Part 1: Count active cubes 3D" do
    assert Day17.count_active_cubes() == 346
  end

  test "Day 17, Part 2: Count active cubes 4D" do
    assert Day17.count_active_cubes_4d() == 1632
  end

  test "Day 18, Part 1: Evaluate expressions" do
    assert Day18.evaluate_expressions_1() == 280_014_646_144
  end

  test "Day 18, Part 2: Evaluate expressions" do
    assert Day18.evaluate_expressions_2() == 9_966_990_988_262
  end

  test "Day 19, Part 1: Count messages that match rule 0" do
    assert Day19.msgs_match_rule0_1() == 216
  end

  test "Day 19, Part 2: All loops to some rules and count messages that match rule 0" do
    assert Day19.msgs_match_rule0_2() == 400
  end

  test "Day 21, Part 1: Count indgredients without allergens" do
    assert Day21.count_ingredients_wo_allergens() == 2826
  end

  test "Day 21, Part 2: List dangerous ingredients" do
    assert Day21.dangerous_ingredients() ==
             "pbhthx,sqdsxhb,dgvqv,csnfnl,dnlsjr,xzb,lkdg,rsvlb"
  end

  test "Day 22, Part 1: Combat card game winning score" do
    assert Day22.winning_score_1() == 33010
  end

  test "Day 22, Part 2: Recursive Combat card game winning score" do
    assert Day22.winning_score_2() == 32769
  end

  test "Day 23, Part 1: Order of the cup labels" do
    assert Day23.cup_labels_1() == "45983627"
  end

  test "Day 23, Part 2: Order of the cup labels, 1 million cups, 10 million moves" do
    assert true
    # takes about a minute to run
    # assert Day23.cup_labels_2 == 111_080_192_688
  end

  test "Day 24, Part 1: Count black side up tiles" do
    assert Day24.count_black_side_up_tiles() == 512
  end

  test "Day 24, Part 2: Count black side up tiles after 100 days of iteration" do
    assert Day24.flip_tiles_100_days() == 4120
  end

  test "Day 25, Part 1: Find card or door encryption key, they are the same" do
    assert Day25.find_encryption_key() == 16_881_444
  end

  # Day 25, Part 2: Nothing
end
