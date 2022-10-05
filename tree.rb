# frozen_string_literal: true

require_relative 'node'

# The Binary Search Tree
class Tree
  def initialize(array)
    @root = build_tree(array)
  end

  def insert(value)
    node = Node.new(value)
    tree = @root
    @root = insert_rec(node, tree)
  end

  def delete(value)
    tree = @root
    @root = delete_rec(value, tree)
  end

  def find(value)
    nodes = [@root]
    until nodes.empty?
      cur_node = nodes.delete_at(0)
      return cur_node if cur_node.value == value

      nodes.append(cur_node.left) unless cur_node.left.nil?
      nodes.append(cur_node.right) unless cur_node.right.nil?
    end
    nil
  end

  def level_order
    queue = [@root]
    nodes = []
    until queue.empty?
      cur_node = queue.delete_at(0)
      if block_given?
        yield(cur_node)
      else
        nodes << cur_node
      end

      queue.append(cur_node.left) unless cur_node.left.nil?
      queue.append(cur_node.right) unless cur_node.right.nil?
    end
    nodes
  end

  def inorder(&block)
    inorder_rec(@root, [], &block)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

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

  def insert_rec(node, tree)
    return node if tree.nil?

    tree.right = insert_rec(node, tree.right) if node.value > tree.value
    tree.left = insert_rec(node, tree.left) if node.value < tree.value
    tree
  end

  def find_min_node(node)
    current = node
    current = current.left until current.left.nil?
    current
  end

  def delete_node(root)
    if root.left.nil?
      root.right
    elsif root.right.nil?
      root.left
    else
      temp = find_min_node(root.right)
      root.value = temp.value
      root.right = delete_rec(temp.value, root.right)
      root
    end
  end

  def delete_rec(value, tree)
    return nil if tree.nil?

    if tree.value == value
      tree = delete_node(tree)
    elsif tree.value > value
      tree.left = delete_rec(value, tree.left)
    else
      tree.right = delete_rec(value, tree.right)
    end
    tree
  end

  def inorder_rec(node, array, &block)
    return array if node.nil?

    array = inorder_rec(node.left, array, &block)
    block.call(node) if block_given?
    array << node
    inorder_rec(node.right, array, &block)
  end

end

tree = Tree.new([1, 5, 2, 9, 8, 3])
tree.pretty_print
tree.inorder { |node| puts node }
puts
puts tree.inorder
