class PolyTreeNode
  attr_accessor :parent, :value
  
  def initialize(value = nil)
    @value, @parent, @children = value, nil, []
  end
  
  def children
    @children.dup
  end
  
  def add_child(new_child)
    @children << new_child
    new_child.parent = self
  end
  
  #depth first search
  def dfs(target) 
    return self if @value == target
    
    @children.each do |child|
      next if child.nil?
      
      result = child.dfs(target)
      return result unless result.nil?
    end
    
    nil
  end
  
  def path_to(other_node)
    result = []
    
    node = self
    until node == other_node
      result << node.value
      node = node.parent
    end
    result << other_node.value unless result.nil?
    
    result
  end
end

# testing of the class
if $PROGRAM_NAME == __FILE__
  a = PolyTreeNode.new(1)
  b = PolyTreeNode.new(2)
  c = PolyTreeNode.new(3)
  d = PolyTreeNode.new(4)
  e = PolyTreeNode.new(5)
  a.add_child(b)
  a.add_child(c)
  c.add_child(d)
  b.add_child(e)
  #puts a.dfs(4).value
 visited = a.dfs_path(5)
 puts parse_path(a, visited).map {|node| node.value}
end