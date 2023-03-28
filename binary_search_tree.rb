class Node
    attr_accessor :data, :left_child, :right_child

    def initialize(data)
        @data = data
        @left_child = nil
        @right_child = nil
    end
end

class Tree
    def initialize(array)
        @root = build_tree(array)
    end

    def build_tree(array)

        return nil if !array.kind_of?(Array) || array.empty?

        sorted_array = array.uniq.sort

        mid = sorted_array.length / 2

        root_node = Node.new(sorted_array[mid])

        root_node.left_child = build_tree(sorted_array[0...mid])

        root_node.right_child = build_tree(sorted_array[(mid + 1)..sorted_array.length - 1])

        root_node                
    end

    def pretty_print(node = @root, prefix = '', is_left = true)

        pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child

    end

    def insert(number, node = @root)

        if number > node.data && node.right_child == nil
            node.right_child = Node.new(number)
        elsif number < node.data && node.left_child == nil
            node.left_child = Node.new(number)
        elsif number > node.data
            insert(number, node.right_child)
        elsif number < node.data
            insert(number, node.left_child)
        end
    end

    def delete(value)
        
        # you’ll have to deal with several cases for delete such as when a node has children or not

        # if !find(value), non existent node with that value

        # if it doesn't have children, just set previous node's corresponding child to nil

        # if it only has one child, replace node with child

        # if two children, replace node with inorder values and reinsert them?
    end

    def find(value, node = @root)

       if value == node.data
            node
       elsif value < node.data
            find(value, node.left_child) if node.left_child
       elsif value > node.data
            find(value, node.right_child) if node.right_child
       end
        
    end
end

bst = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])

p bst

bst.pretty_print

p bst.insert(6)
p bst.insert(24)
p bst.insert(0)

bst.pretty_print
p bst.find(6)