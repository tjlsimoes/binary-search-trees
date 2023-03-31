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

    def inorder(node = @root, root_method = true, array = [], &block)
        
        # <left><root><right>

        inorder(node.left_child, false, array) if node.left_child
        array << node
        inorder(node.right_child, false, array) if node.right_child


        if block_given?
            for i in array do
                yield(i)
            end

        elsif root_method == false 

            array

        elsif root_method == true

            array.map { |node| node.data if node }
        end
    
    end

    def preorder(node = @root, root_method = true, array = [], &block)
        
        # <root><left><right>

        array << node
        preorder(node.left_child, false, array) if node.left_child
        preorder(node.right_child, false, array) if node.right_child


        if block_given?
            for i in array do
                yield(i)
            end

        elsif root_method == false 

            array

        elsif root_method == true

            array.map { |node| node.data if node }
        end
    
    end

    def postorder(node = @root, root_method = true, array = [], &block)
        
        # <left><right><root>

        postorder(node.left_child, false, array) if node.left_child
        postorder(node.right_child, false, array) if node.right_child
        array << node

        if block_given?
            for i in array do
                yield(i)
            end

        elsif root_method == false 

            array

        elsif root_method == true

            array.map { |node| node.data if node }
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


    def height(node = @root, counter = 0)

        if no_children?(node)

            # puts "No children node #{node.data}, counter: #{counter}."
            return counter
        else
            
            if has_both_children?(node)

                left_counter = height(node.left_child, counter += 1)
                counter -= 1
                right_counter = height(node.right_child, counter += 1) 

            elsif has_only_left_child?(node)

                left_counter = height(node.left_child, counter += 1)
                right_counter = 0

            elsif has_only_right_child?(node)

                left_counter = 0
                right_counter = height(node.right_child, counter += 1) 
            end
            

            if left_counter > right_counter
                # puts "node:#{node.data}  counter:#{left_counter}"
                left_counter
            elsif right_counter > left_counter
                # puts "node:#{node.data}  counter:#{right_counter}"
                right_counter
            else
                # puts "node:#{node.data}  counter:#{left_counter}"
                left_counter
            end

        end

    end


end

bst = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])

# p bst

# bst.pretty_print

# p bst.insert(6)
# p bst.insert(24)
# p bst.insert(0)

# bst.pretty_print
# p bst.find(6)


# bst.delete(8) 
# bst.pretty_print

# p bst.level_order 

# p bst.inorder

# p bst.preorder

# p bst.postorder

# bst.insert(6346)
# bst.insert(6347)
# bst.insert(6348)
# bst.pretty_print


bst.height