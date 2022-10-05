# frozen_string_literal: true

# Represents one node in the binary search tree
class Node
  attr_accessor :value, :left, :right

  include Comparable

  def <=>(other)
    @value <=> other.value
  end

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end

  def to_s
    @value.to_s
  end
end
