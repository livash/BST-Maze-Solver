=begin
Task: Write a function that reads in a string representation 
of a maze and outputs a string of letters; N, S, E or W 
where each letter corresponds to North, South, East or West 
such that the maze is solved from the top left corner to the bottom right.
=end

require_relative "poly_tree_node"
require_relative "board"
require 'debugger'

def solve_maze(file_name)
  content = File.read(file_name)
  board = Board.new(content)
  board.print_board
  # buils a Tree of possible moves
  # from the top left "TL" corner of the maze
  root = board.build_tree([0,1]) 
  # is there a connection between TL and BR corners
  search_node = root.dfs([9,19])
  path = []
  if search_node
    path = search_node.path_to(root)
    translated_path = translate(path)
  end

  translated_path.reverse
end

def translate(path_array)
  result = []
  path_array.each_with_index do |position, idx|
    point_1 = path_array[idx]
    if (idx + 1) < path_array.length 
      point_2 = path_array[idx + 1]
    else
      point_2 = point_1
    end
    
    result << "N" if point_1.first - point_2.first < 0
    result << "S" if point_1.first - point_2.first > 0
    result << "E" if point_1.last - point_2.last > 0
    result << "W" if point_1.last - point_2.last < 0 
  end
  
  result.join('')
end

if $PROGRAM_NAME == __FILE__
  p solve_maze("maze.txt")
end







