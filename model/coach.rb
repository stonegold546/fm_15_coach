# Coach class
class Coach
  attr_accessor :discipline, :determination, :motivating

  def initialize(discipline, determination, motivating)
    # Instance variables
    @discipline = discipline
    @determination = determination
    @motivating = motivating
  end

  def final_check(formula, divisor)
    # Output: Number of stars
    star = (formula / divisor.to_f) + 0.5
    val = star % 1 < 0.5 ? star.to_i : star.to_i + 0.5
    [val, 5].min
  end

  def ddm(multiplier)
    # Instance variables frequently repeatedly multiplied by single number
    (discipline + determination + motivating) * multiplier
  end

  def fitness_tactics(variable, multiplier, ddm_multiplier, divisor)
    # Fitness and tactics share similar structure
    formula = variable * multiplier + ddm(ddm_multiplier)
    final_check(formula, divisor)
  end

  def strength(fitness)
    # Input: Fitness variable
    # Output: Aerobics & Srength stars
    fitness_tactics(fitness, 9, 2, 60)
  end

  def tactics(tactical)
    # Input: Tactical variable
    # Output: Tactics stars
    fitness_tactics(tactical, 2, 1, 20)
  end

  def goalkeeping(goalkeepers, other_var)
    # Input: 'goalkeepers' & other_var variables
    # If shot stopping, other_var is tactical, if handling, technical
    # Output: Shot stopping or handling stars
    formula = goalkeepers * 8 + other_var * 3 + ddm(3)
    final_check(formula, 80)
  end

  def defending(defending, tactical)
    # Input: defending and tactical variables
    # Output: Defending stars
    # Defending similar to goalkeeping
    goalkeeping(defending, tactical)
  end

  def ball_att_shoot(var_1, var_2)
    # Ball control, attacking, and shooting share similar structure
    formula = var_1 * 6 + var_2 * 3 + ddm(2)
    final_check(formula, 60)
  end

  def ball_control(technical, mental)
    ball_att_shoot(technical, mental)
  end

  def attacking(attacking, tactical)
    ball_att_shoot(attacking, tactical)
  end

  def shooting(technical, attacking)
    ball_att_shoot(technical, attacking)
  end
end
