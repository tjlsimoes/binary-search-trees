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

    def no_children?(node)

        if node.right_child == nil && node.left_child == nil
            true
        else
            false
        end
    end

    def has_only_left_child?(node)
        if (node.right_child == nil && node.left_child != nil)
            true
        else
            false
        end
    end

    def has_only_right_child?(node)
        if (node.left_child == nil && node.right_child != nil)
            true
        else
            false
        end
    end

    def has_both_children?(node)
        if node.left_child != nil && node.right_child != nil
            true
        else
            false
        end
    end

    def inorder(node = @root, array=[], &block)

        if block_given?
            inorder(node.left_child, array) if node.left_child
            inorder(node.right_child, array) if node.right_child

            array << node

            for i in array
                yield(i)
            end
        else
            inorder(node.left_child, array) if node.left_child
            inorder(node.right_child, array) if node.right_child

            array << node.data

            for i in array
                puts "#{i}"
            end

            array
        end
    end


    def level_order(node = @root, &block)

        queue = []
        breath_first = []

        queue << node

        while !queue.empty?

            breath_first << queue[0]
            queue << queue[0].left_child if queue[0].left_child
            queue << queue[0].right_child if queue[0].right_child

            queue.shift
        end

        if block_given?

            for i in breath_first do
                yield i
            end

        else 
            breath_first.map { |node| node.data if node}
        end 
    end


    def min_value(node = @root)

        current = node
        
        while current.left_child != nil
            current = current.left_child
        end

        return current
    end

    def delete(value, node = @root, other_node = nil)
        
        # value == root 

        if value == node.data && has_both_children?(node) && other_node == nil
            
            replacement_value = self.min_value(node.right_child).data
            node.data = replacement_value
            delete(replacement_value, node.right_child, node)
            
        # no children

        elsif value == node.data && other_node.left_child == node && no_children?(node)
            other_node.left_child = nil
        elsif value == node.data && other_node.right_child == node && no_children?(node)
            other_node.right_child = nil

        # other_node.left_child and only 1 child

        elsif value == node.data && other_node.left_child == node && has_only_left_child?(node)
            other_node.left_child = node.left_child
        elsif value == node.data && other_node.left_child == node && has_only_right_child?(node)
            other_node.left_child = node.right_child

        # other_node.right_child and only 1 child

        elsif value == node.data && other_node.right_child == node && has_only_left_child?(node)
            other_node.right_child = node.left_child
        elsif value == node.data && other_node.right_child == node && has_only_right_child?(node)
            other_node.right_child = node.right_child

        # other_node.left_child == node and 2 children

        elsif value == node.data && other_node.left_child == node && has_both_children?(node)
            
            replacement_value = self.min_value(node.right_child).data
            other_node.left_child.data = replacement_value
            delete(replacement_value, other_node.left_child.right_child, other_node.left_child)

        # other_node.right_child == node and 2 children
            
        elsif value == node.data && other_node.right_child == node && has_both_children?(node)
            
            replacement_value = self.min_value(node.right_child).data
            other_node.right_child.data = replacement_value
            delete(replacement_value, other_node.right_child.right_child, other_node.right_child)


        elsif value < node.data
            delete(value, node.left_child, node) if node.left_child
        elsif value > node.data
            delete(value, node.right_child, node) if node.right_child
        end

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


bst.delete(8) 
bst.pretty_print

bst.level_order { |node| puts "#{node.data} " if node}
