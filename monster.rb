class StatusEffect
  attr_accessor :caster
  attr_accessor :type, :remaining_duration
  attr_accessor :degree

  def initialize(type, remaining_duration = Float::INFINITY)
    @type = type
    @remaining_duration = remaining_duration
  end

  def heritable?
    case type
    when :zawazawa
      true
    when :sleep
      true
    when :paralysis
      true
    when :held
      true
    when :confused
      true
    when :hallucination
      true
    when :quick
      false
    when :bomb
      true
    when :audition_enhancement
      false
    when :olfaction_enhancement
      false
    when :weakening
      false
    else
      true
    end
  end

  def name
    case type
    when :zawazawa
      "ざわざわ"
    when :sleep
      "睡眠"
    when :paralysis
      "かなしばり"
    when :held
      "はりつけ"
    when :confused
      "混乱"
    when :hallucination
      "まどわし"
    when :quick
      "倍速"
    when :bomb
      "爆弾"
    when :audition_enhancement
      "兎耳"
    when :olfaction_enhancement
      "豚鼻"
    when :weakening
      "衰弱"
    else
      type.to_s
    end
  end
end

module StatusEffectPredicates
  attr :status_effects

  def paralyzed?
    @status_effects.any? { |e| e.type == :paralysis }
  end

  def asleep?
    @status_effects.any? { |e| e.type == :sleep }
  end

  def held?
    @status_effects.any? { |e| e.type == :held }
  end

  def confused?
    @status_effects.any? { |e| e.type == :confused }
  end

  def hallucinating?
    @status_effects.any? { |e| e.type == :hallucination }
  end

  def quick?
    @status_effects.any? { |e| e.type == :quick }
  end

  def bomb?
    @status_effects.any? { |e| e.type == :bomb }
  end

  def nullified?
    @status_effects.any? { |e| e.type == :nullification }
  end

  def audition_enhanced?
    @status_effects.any? { |e| e.type == :audition_enhancement }
  end

  def olfaction_enhanced?
    @status_effects.any? { |e| e.type == :olfaction_enhancement }
  end

  def zawazawa?
    @status_effects.any? { |e| e.type == :zawazawa }
  end

  def weakening?
    @status_effects.any? { |e| e.type == :weakening }
  end

end

class Character
  include StatusEffectPredicates

  def visible
    !@invisible
  end
end

class Monster < Character
  # mimic.rb による生成。
  MIMIC_TABLE = eval IO.read File.join File.dirname(__FILE__),'mimic_definition.rb'
  SPECIES = eval IO.read File.join File.dirname(__FILE__),'monster_definition.rb'
  SPECIES.concat(MIMIC_TABLE)

  class << self
    def make_monster(name)
      definition = SPECIES.find { |r| r[:name] == name }
      fail "no such monster: #{name}" unless definition

      wake_rate = definition[:initial_wake_rate] || 0.5
      state = (rand() < wake_rate) ? :awake : :asleep
      facing = [1,1]
      goal = nil
      return Monster.new(definition, state, facing, goal)
    end
  end

  attr :defense, :exp
  attr_accessor :drop_rate
  attr_accessor :hp, :max_hp, :strength
  attr_accessor :state, :facing, :goal
  attr_accessor :item
  attr :trick_range
  attr_accessor :invisible
  attr_accessor :action_point, :action_point_recovery_rate
  attr_accessor :impersonating_name, :impersonating_char
  attr_reader :contents
  attr_accessor :capacity
  attr_reader :attrs
  attr_reader :initial_wake_rate,
              :proximity_wake_rate,
              :entrance_wake_rate

  def initialize(definition,
                 state, facing, goal)
    @char     = definition[:char] || fail
    @name     = definition[:name] || fail
    @max_hp   = definition[:max_hp] || fail
    @strength = definition[:strength] || fail
    @defense  = definition[:defense] || fail
    @exp      = definition[:exp] || fail
    @drop_rate = definition[:drop_rate] || 0.0
    @attrs    = definition[:attrs] || []
    @initial_wake_rate = definition[:initial_wake_rate] || 0.5
    @proximity_wake_rate = definition[:proximity_wake_rate] || 0.5
    @entrance_wake_rate = definition[:entrance_wake_rate] || 0.5

    @state = state
    @facing = facing
    @goal = goal

    @hp = @max_hp

    @status_effects = []
    @item = nil
    case @name
    when "催眠術師", "どろぼう猫"
      # 攻撃されるまで動き出さないモンスター
      @status_effects << StatusEffect.new(:paralysis, Float::INFINITY)
    when "ノーム"
      @item = Gold.new(rand(250..1500))
    when "白い手", "動くモアイ像"
      @status_effects << StatusEffect.new(:held, Float::INFINITY)
    when "メタルヨテイチ"
      @status_effects << StatusEffect.new(:hallucination, Float::INFINITY)
      @item = Item::make_item("幸せの種")
    when "化け狸"
      @impersonating_name = @name
      @impersonating_char = @char
    when "ボンプキン"
      @status_effects << StatusEffect.new(:bomb, Float::INFINITY)
    end

    @trick_range = definition[:trick_range] || :none
    @trick_rate = definition[:trick_rate] || 0.0

    case @name
    when "ゆうれい"
      @invisible = true
    else
      @invisible = false
    end

    @action_point = 0
    @action_point_recovery_rate = definition[:action_point_recovery_rate] || 2

    # 合成モンスター。
    @contents = []
    @capacity = definition[:capacity] || 0
  end

  def trick_rate
    @trick_rate
  end

  # state = :awake の操作は別。モンスターの特殊な状態を解除して動き出
  # させる。
  def on_party_room_intrusion
    case @name
    when "催眠術師", "どろぼう猫"
      # 攻撃されるまで動き出さないモンスター
      @status_effects.reject! { |e| e.type == :paralysis }
    when "動くモアイ像"
      @status_effects.reject! { |e| e.type == :held }
    end
  end

  def char
    case @name
    when "ボンプキン"
      if hp < 1.0
        "\u{104238}\u{104239}" # puff of smoke
      elsif !nullified? && bomb? && hp <= max_hp/2
        '􄁮􄁯'
      else
        @char
      end
    when "化け狸"
      if hp < 1.0
        @char
      else
        @impersonating_char
      end
    when "動くモアイ像"
      if held?
        @char
      else
        "\u{104066}\u{104067}"
      end
    else
      if hp < 1.0
        "\u{104238}\u{104239}" # puff of smoke
      else
        @char
      end
    end
  end

  def reveal_self!
    if @name == "化け狸"
      @impersonating_name = @name
      @impersonating_char = @char
    end
  end

  def name
    if @name == "化け狸"
      @impersonating_name
    else
      @name
    end
  end

  def tipsy?
    @name == "コウモリ" || @name == "ゆうれい"
  end

  def single_attack?
    case @name
    when "ツバメ"
      true
    else
      false
    end
  end

  def divide?
    case @name
    when "グール"
      true
    else
      false
    end
  end

  def poisonous?
    case @name
    when 'ファンガス', '土偶'
      true
    else
      false
    end
  end

  def undead?
    case @name
    when '木乃伊', 'ゆうれい'
      true
    else
      false
    end
  end

  def hp_maxed?
    @hp == @max_hp
  end

  def damage_capped?
    @name == "メタルヨテイチ"
  end

  def teleport_on_attack?
    @name == "メタルヨテイチ"
  end

  PHYLOGENY = [
    ["スライム", "スライム2", "スライム3"]
  ]

  # 次のレベルのモンスター名。
  # () -> String|nil
  def descendant
    PHYLOGENY.each do |series|
      if (i = series.index(@name)) && (i < series.size - 1)
        return series[i + 1]
      end
    end
    return nil
  end

  # 前のレベルのモンスター名。
  # () -> String|nil
  def ancestor
    PHYLOGENY.each do |series|
      if (i = series.index(@name)) && (i > 0)
        return series[i - 1]
      end
    end
    return nil
  end

private

end
