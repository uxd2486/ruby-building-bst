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

  def preorder(&block)
    preorder_rec(@root, [], &block)
  end

  def postorder(&block)
    postorder_rec(@root, [], &block)
  end

  def height(node)
    height_rec(node, 0)
  end

  def depth(node)
    depth_rec(node, @root, 0)
  end

  def balanced?
    balanced_rec(@root)
  end

  def rebalance
    @root = build_tree(preorder)
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

  def preorder_rec(node, array, &block)
    return array if node.nil?

    block.call(node) if block_given?
    array << node
    array = preorder_rec(node.left, array, &block)
    preorder_rec(node.right, array, &block)
  end

  def postorder_rec(node, array, &block)
    return array if node.nil?

    array = postorder_rec(node.left, array, &block)
    postorder_rec(node.right, array, &block)
    block.call(node) if block_given?
    array << node
    array
  end

  def height_rec(node, height)
    return height - 1 if node.nil?

    max_height = height
    left_height = height_rec(node.left, height + 1)
    max_height = left_height if left_height > max_height

    right_height = height_rec(node.right, height + 1)
    right_height > max_height ? right_height : max_height
  end

  def depth_rec(target, node, depth)
    return nil if node.nil?
    return depth if target.value == node.value

    depth_rec(target, node.left, depth + 1) || depth_rec(target, node.right, depth + 1)
  end

  def balanced_rec(node)
    return true if node.nil?
    return false if (height(node.left) - height(node.right)).abs > 1

    balanced_rec(node.left) || balanced_rec(node.right)
  end

end

def print_all_orders(tree)
  print 'Elements in pre order: '
  tree.preorder { |node| print " #{node} " }
  puts
  print 'Elements in post order: '
  tree.postorder { |node| print " #{node} " }
  puts
  print 'Elements in order: '
  tree.inorder { |node| print " #{node} " }
  puts
end

def check_balance(tree)
  print 'Is the tree balanced? '
  puts tree.balanced?
end

tree = Tree.new(Array.new(15) { rand(1..100) })
check_balance(tree)
puts
print_all_orders(tree)
puts
puts 'Inserting many elements to unbalance tree..'
unbalance_array = Array.new(15) { rand(100..10_000) }
unbalance_array.each { |value| tree.insert(value) }
print 'Elements in pre order: '
tree.preorder { |node| print " #{node} " }
puts
check_balance(tree)
puts
puts 'Re-balancing the tree..'
tree.rebalance
check_balance(tree)
print_all_orders(tree)
