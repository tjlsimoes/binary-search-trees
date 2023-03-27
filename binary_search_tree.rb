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
end

bst = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])


p srt_array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324].uniq.sort
p srt_array[srt_array.length/ 2]

p bst

bst.pretty_print