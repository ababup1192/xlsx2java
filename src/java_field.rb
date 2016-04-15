# coding: utf-8

# Javaのフィールドを表すクラス
class JavaField
  def initialize(type_name, var_name)
    @type_name = type_name;
    @var_name = var_name;
  end

  def to_s
    "#{@type_name} #{@var_name};"
  end
end

class IntField < JavaField
  def initialize(var_name)
    super('Integer', var_name)
  end
end
