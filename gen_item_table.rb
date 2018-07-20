ITEM_TABLE = [
  ["こん棒", 5, 1..99],
  ["金の剣", 5, 1..99],
  ["銅の剣", 5, 1..99],
  ["鉄の斧", 5, 1..99],
  ["ドラゴンキラー", 4, 1..99],
  ["メタルヨテイチの剣", 4, 1..99],
  ["エンドゲーム", 1, 1..99],
  ["木の矢", 10, 1..99],
  # ["鉄の矢", 10, 1..99],
  # ["銀の矢", 10, 1..99],
  ["皮の盾", 5, 1..99],
  ["青銅の盾", 5, 1..99],
  ["うろこの盾", 4, 1..99],
  ["銀の盾", 4, 1..99],
  ["鋼鉄の盾", 4, 1..99],
  ["ドラゴンシールド", 3, 1..99],
  ["メタルヨテイチの盾", 1, 1..99],
  ["薬草", 15, 1..99],
  ["高級薬草", 15, 1..99],
  ["毒けし草", 8, 1..99],
  ["ちからの種", 7, 1..99],
  ["幸せの種", 5, 1..99],
  ["すばやさの種", 10, 1..99],
  ["目薬草", 5, 1..99],
  ["毒草", 5, 1..99],
  # ["目つぶし草", 10, 1..99],
  # ["まどわし草", 10, 1..99],
  ["混乱草", 5, 1..99],
  ["ワープ草", 5, 1..99],
  ["火炎草", 5, 1..99],
  ["やりなおしの巻物", 1, 1..99],
  ["武器強化の巻物", 10, 1..99],
  ["盾強化の巻物", 10, 1..99],
  ["メッキの巻物", 5, 1..99],
  # ["シャナクの巻物", 10, 1..99],
  # ["インパスの巻物", 10, 1..99],
  ["あかりの巻物", 10, 1..99],
  ["かなしばりの巻物", 10, 1..99],
  ["結界の巻物", 2, 1..99],
  # ["さいごの巻物", 10, 1..99],
  # ["証明の巻物", 10, 1..99],
  # ["千里眼の巻物", 10, 1..99],
  # ["地獄耳の巻物", 10, 1..99],
  # ["パンの巻物", 10, 1..99],
  # ["祈りの巻物", 10, 1..99],
  ["爆発の巻物", 5, 1..99],
  # ["くちなしの巻物", 10, 1..99],
  # ["時の砂の巻物", 10, 1..99],
  # ["ワナの巻物", 10, 1..99],
  # ["パルプンテの巻物", 10, 1..99],
  ["いかずちの杖", 5, 1..99],
  ["鈍足の杖", 5, 1..99],
  ["睡眠の杖", 5, 1..99],
  # ["メダパニの杖", 10, 1..99],
  ["封印の杖", 5, 1..99],
  ["ワープの杖", 5, 1..99],
  ["変化の杖", 5, 1..99],
  # ["ピオリムの杖", 10, 1..99],
  # ["レオルムの杖", 10, 1..99],
  ["転ばぬ先の杖", 5, 1..99],
  ["分裂の杖", 5, 1..99],
  # ["ザキの杖", 10, 1..99],
  ["もろ刃の杖", 5, 1..99],
  # ["大損の杖", 10, 1..99],
  # ["ちからの指輪", 10, 1..99],
  ["毒けしの指輪", 5, 1..99],
  ["眠らずの指輪", 5, 1..99],
  # ["ルーラの指輪", 10, 1..99],
  ["ハラヘラズの指輪", 3, 1..99],
  ["盗賊の指輪", 3, 1..99],
  # ["きれいな指輪", 10, 1..99],
  # ["シャドーの指輪", 10, 1..99],
  # ["ハラペコの指輪", 10, 1..99],
  ["ワナ抜けの指輪", 5, 1..99],
  ["人形よけの指輪", 3, 1..99],
  # ["ザメハの指輪", 10, 1..99],
  ["パン", 10, 1..99],
  ["大きなパン", 10, 1..99],
  ["くさったパン", 10, 1..99],
]

table = (1..99).map { |f| [f] }

ITEM_TABLE.each do |name, freq, range|
  range.each do |floor|
    row = table.assoc(floor)
    row.push([name, freq])
  end
end

require 'pp'
pp table
