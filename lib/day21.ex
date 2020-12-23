defmodule Day21 do
  @moduledoc """
  --- Day 21: Allergen Assessment ---
  """

  @doc """
  --- Part One ---
  You reach the train's last stop and the closest you can get to your vacation island without getting wet.
  There aren't even any boats here, but nothing can stop you now: you build a raft.
  You just need a few days' worth of food for your journey.

  You don't speak the local language, so you can't read any ingredients lists.
  However, sometimes, allergens are listed in a language you do understand.
  You should be able to use this information to determine which ingredient contains which allergen
  and work out which foods are safe to take with you on your trip.

  You start by compiling a list of foods (your puzzle input), one food per line.
  Each line includes that food's ingredients list followed by some or all of the allergens the food contains.

  Each allergen is found in exactly one ingredient. Each ingredient contains zero or one allergen.
  Allergens aren't always marked; when they're listed (as in (contains nuts, shellfish) after an ingredients list),
  the ingredient that contains each listed allergen will be somewhere in the corresponding ingredients list.
  However, even if an allergen isn't listed, the ingredient that contains that allergen could still be present:
  maybe they forgot to label it, or maybe it was labeled in a language you don't know.

  For example, consider the following list of foods:

  mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
  trh fvjkl sbzzf mxmxvkd (contains dairy)
  sqjhc fvjkl (contains soy)
  sqjhc mxmxvkd sbzzf (contains fish)

  The first food in the list has four ingredients (written in a language you don't understand):
  mxmxvkd, kfcds, sqjhc, and nhms. While the food might contain other allergens,
  a few allergens the food definitely contains are listed afterward: dairy and fish.

  The first step is to determine which ingredients can't possibly contain any of the allergens in any food in your list.
  In the above example, none of the ingredients kfcds, nhms, sbzzf, or trh can contain an allergen.
  Counting the number of times any of these ingredients appear in any ingredients list produces 5:
  they all appear once each except sbzzf, which appears twice.

  Determine which ingredients cannot possibly contain any of the allergens in your list.
  How many times do any of those ingredients appear?
  """

  def count_ingredients_wo_allergens do
    # "inputs/day21_test1_input.txt")
    ingredients_allergens = get_food_ingredients()
    allergens = get_allergens(ingredients_allergens)

    ingredients_with_allergens =
      get_ingredients_containing_allergens(allergens, ingredients_allergens)

    count_ingredients_wo_allergens(ingredients_allergens, ingredients_with_allergens)
  end

  defp count_ingredients_wo_allergens(ingredients_allergens, ingredients_with_allergens) do
    Enum.reduce(ingredients_allergens, 0, fn {ingredients, _allergens}, count ->
      ingredients_wo_allergens =
        Enum.reject(ingredients, &Enum.member?(ingredients_with_allergens, &1))
        |> Enum.count()

      count + ingredients_wo_allergens
    end)
  end

  @doc """
  --- Part Two ---
  Now that you've isolated the inert ingredients,
  you should have enough information to figure out which ingredient contains which allergen.

  In the above example:

  mxmxvkd contains dairy.
  sqjhc contains fish.
  fvjkl contains soy.

  Arrange the ingredients alphabetically by their allergen and separate them by commas
  to produce your canonical dangerous ingredient list.
  (There should not be any spaces in your canonical dangerous ingredient list.)
  In the above example, this would be mxmxvkd,sqjhc,fvjkl.

  Time to stock your raft with supplies. What is your canonical dangerous ingredient list?
  """
  def dangerous_ingredients do
    # "inputs/day21_test1_input.txt")
    ingredients_allergens = get_food_ingredients()
    allergens = get_allergens(ingredients_allergens)
    allergen_to_ingredient = get_allergen_ingredient(allergens, ingredients_allergens)

    allergen_to_ingredient
    |> Map.keys()
    |> Enum.sort()
    |> Enum.reduce("", fn allergen, dangerous_str ->
      dangerous_str <> allergen_to_ingredient[allergen] <> ","
    end)
    |> String.trim_trailing(",")
  end

  # Common functions

  defp get_food_ingredients(input \\ "inputs/day21_input.txt") do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " (contains "))
    |> Enum.map(fn [ingredients, allergens] ->
      {String.split(ingredients, " ", trim: true),
       String.split(String.replace_suffix(allergens, ")", ""), ", ", trim: true)}
    end)
  end

  defp get_allergens(ingredients_allergens) do
    Enum.reduce(ingredients_allergens, [], fn {_ingredients, allergens}, all_allergens ->
      all_allergens ++ allergens
    end)
    |> Enum.uniq()
  end

  defp get_ingredients_containing_allergens(allergens, ingredients_allergens) do
    Enum.reduce(allergens, [], fn allergen, all_ingredients ->
      [
        {allergen, get_ingredients_containing_allergen(allergen, ingredients_allergens)}
        | all_ingredients
      ]
    end)
    |> reduce_allergen_list()
  end

  defp get_allergen_ingredient(allergens, ingredients_allergens) do
    Enum.reduce(allergens, [], fn allergen, all_ingredients ->
      [
        {allergen, get_ingredients_containing_allergen(allergen, ingredients_allergens)}
        | all_ingredients
      ]
    end)
    |> map_allergen_to_ingredient([], [])
  end

  defp get_ingredients_containing_allergen(allergen, ingredients_allergens) do
    Enum.reduce(ingredients_allergens, [], fn {ingredients, allergens}, may_contain ->
      if Enum.member?(allergens, allergen) do
        [ingredients | may_contain]
      else
        may_contain
      end
    end)
    # Only common ingredients among all the ingredient lists found, can contain the allergen
    # Initialize the common ingredients with the first list of ingredients
    |> Enum.reduce([], fn ingredients, common ->
      case common do
        [] -> ingredients
        _else -> Enum.filter(common, &Enum.member?(ingredients, &1))
      end
    end)
  end

  defp reduce_allergen_list(allergens_ingredients) do
    Enum.reduce(allergens_ingredients, [], fn {_allergen, ingredients},
                                              ingredients_with_allergens ->
      [ingredients | ingredients_with_allergens]
    end)
    |> List.flatten()
    |> Enum.uniq()
  end

  defp map_allergen_to_ingredient([], _used_ingredients, allergen_to_ingredient) do
    Map.new(allergen_to_ingredient)
  end

  defp map_allergen_to_ingredient(allergens_ingredients, used_ingredients, allergen_to_ingredient) do
    {allergens_ingredients, used_ingredients, allergen_to_ingredient} =
      Enum.reduce(
        allergens_ingredients,
        {allergens_ingredients, used_ingredients, allergen_to_ingredient},
        fn {allergen, ingredients},
           {next_allergens_ingredients, next_used_ingredients, next_allergen_to_ingredient} ->
          if length(ingredients) == 1 do
            [ingredient] = ingredients

            {
              List.delete(next_allergens_ingredients, {allergen, ingredients}),
              [ingredient | next_used_ingredients],
              [{allergen, ingredient} | next_allergen_to_ingredient]
            }
          else
            {
              next_allergens_ingredients,
              next_used_ingredients,
              next_allergen_to_ingredient
            }
          end
        end
      )

    allergens_ingredients = remove_used_ingredients(allergens_ingredients, used_ingredients)
    map_allergen_to_ingredient(allergens_ingredients, used_ingredients, allergen_to_ingredient)
  end

  defp remove_used_ingredients(allergen_ingredients, used_ingredients) do
    Enum.map(allergen_ingredients, fn {allergen, ingredients} ->
      {allergen, Enum.reject(ingredients, &Enum.member?(used_ingredients, &1))}
    end)
  end
end
