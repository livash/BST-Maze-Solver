require_relative "poly_tree_node"
require 'debugger'

class Board
  attr_reader :board, :explored_tiles_array
  
  def initialize(str = "")
    lines = str.split("\\n")
    @board = []
    lines.each_with_index do |line, idx|
      next if idx == 0 
      @board << []
      line.split("").each_with_index do |position, j|
          @board[idx - 1] << position
      end
    end
    
    @explored_tiles_array = []
  end

  def build_tree(start_point) # start_point = [row, col]
    
    root = PolyTreeNode.new(start_point)
    root = self.add_leaves_to_tree_at(root)
    
    roots_array = [root]
    until roots_array.empty?
      node = roots_array.pop
      @explored_tiles_array << node.value
      node.children.each do |child|
        roots_array << self.add_leaves_to_tree_at(child)
      end
    end
    
    root
  end
  
  def add_leaves_to_tree_at(root)
    possible_moves = self.allowed_moves(root.value)
    # add nodes to the root
    possible_moves.each do |move|
      node = PolyTreeNode.new(move)
      root.add_child(node)
    end
    
    root
  end
  
  # returns an array of positions [row, col]
  # which are available for a move
  def allowed_moves(position_array)
    
    row, col = position_array.first, position_array.last
    results = []
    #debugger
    if self.board[row][col] == "_"
      results << [row - 1, col] if self.is_valid_move?(row - 1, col) and self.is_not_ceiling?(row - 1, col)
      results << [row, col - 2] if self.is_not_wall?(row, col - 1) and self.is_valid_move?(row, col - 2)
      results << [row, col + 2] if self.is_not_wall?(row, col + 1) and self.is_valid_move?(row, col + 2)

    elsif self.board[row][col] == " "
      results << [row + 1, col] if self.is_valid_move?(row + 1, col) 
      results << [row - 1, col] if self.is_valid_move?(row - 1, col) and self.is_not_ceiling?(row - 1, col)
      results << [row, col - 2] if self.is_not_wall?(row, col - 1) and self.is_valid_move?(row, col - 2)
      results << [row, col + 2] if self.is_not_wall?(row, col + 1) and self.is_valid_move?(row, col + 2)
 
    else
      puts "Incorrect move #{position_array}"
    end
    
    results
  end
  
  def print_board
    board.each do |row| 
      puts row.join('')
    end
    
    nil
  end
  
  #rows, columns
  def dimentions
    [board.length, board.first.length]
  end
  
  #private
  def is_valid_move?(row, col)
    return false if self.is_out_of_bounds?(row, col)
    return false if board[row][col] == "|"
    return false if self.was_visited_at?(row, col)
    
    true
  end
  
  def is_not_ceiling?(row, col)
    self.board[row][col] != "_"
  end
  
  def is_not_wall?(row, col)
    board[row][col] != "|"
  end
  
  def was_visited_at?(row, col)
    explored_tiles_array.include?([row, col])
  end
  
  def is_out_of_bounds?(row, col)
    rows, cols = self.dimentions
    !(row > -1 and col > -1 and row < rows and col < cols)
  end
end