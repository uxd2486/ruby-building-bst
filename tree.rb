# frozen_string_literal: true

require_relative 'node'

# The Binary Search Tree
class Tree
  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree_rec(sorted)
    return nil if sorted.empty?

    len = sorted.length
    root = Node.new(sorted[len / 2])
    root.left = build_tree_rec(sorted.slice(0, len / 2))
    root.right = build_tree_rec(sorted.slice(len / 2 + 1, len))
    root
  end

  def build_tree(array)
    array = array.uniq
    array.sort!
    build_tree_rec(array)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
