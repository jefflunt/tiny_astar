require 'time'
require 'pry'
require 'pry-nav'

module TinyAstar
  Node = Struct.new(:parent, :x, :y, :f, :g)

  attr_reader :path   # when pathfinding is complete, this attribute is either:
                      # - empty, meaning no path was found
                      # - non-empty, meaning a path was found
            

  # map: a 2d boolean array representing the map with passable and impassable
  # nodes
  #   - passable nodes are `true`
  #   - impassable nodes are `false`
  # start: the coordinates (x, y) of the starting node
  # finish: the coordinates (x, y) of the finishing node
  def self.path_for(map:, start:, finish:)
    width = map.first.length
    height = map.length

    visited = map.map{|row| row.map{|cell| !cell } }

    puts map.map{|row| row.join(', ') }
    puts '---'
    puts visited.map{|row| row.join(', ') }

    pending_nodes = [
      Node.new(
        parent: nil,
        x: start[0],
        y: start[1],
        f: _pythag_distance(start, finish),
        g: 0
      )
    ]

    path = []
    solution_node = loop do
                      p ['pending nodes', pending_nodes]
                      curr_node = pending_nodes.shift
                      break unless curr_node
                      p ['curr_node', curr_node, curr_node.x, curr_node.y, finish, [curr_node.x, curr_node.y] == finish]
                      break curr_node if [curr_node.x, curr_node.y] == finish
            
                      visited[curr_node.y][curr_node.x] = true
            
                      [
                        # N node
                        Node.new(
                          parent: curr_node,
                          x: curr_node.x,
                          y: curr_node.y - 1,
                          f: _pythag_distance([curr_node.x, curr_node.y], finish),
                          g: curr_node.g + 1
                        ),
                        # NE node
                        Node.new(
                          parent: curr_node,
                          x: curr_node.x + 1,
                          y: curr_node.y - 1,
                          f: _pythag_distance([curr_node.x, curr_node.y], finish),
                          g: curr_node.g + 1
                        ),
                        # E node
                        Node.new(
                          parent: curr_node,
                          x: curr_node.x + 1,
                          y: curr_node.y,
                          f: _pythag_distance([curr_node.x, curr_node.y], finish),
                          g: curr_node.g + 1
                        ),
                        # SE node
                        Node.new(
                          parent: curr_node,
                          x: curr_node.x + 1,
                          y: curr_node.y + 1,
                          f: _pythag_distance([curr_node.x, curr_node.y], finish),
                          g: curr_node.g + 1
                        ),
                        # S node
                        Node.new(
                          parent: curr_node,
                          x: curr_node.x,
                          y: curr_node.y + 1,
                          f: _pythag_distance([curr_node.x, curr_node.y], finish),
                          g: curr_node.g + 1
                        ),
                        # SW node
                        Node.new(
                          parent: curr_node,
                          x: curr_node.x - 1,
                          y: curr_node.y + 1,
                          f: _pythag_distance([curr_node.x, curr_node.y], finish),
                          g: curr_node.g + 1
                        ),
                        # W node
                        Node.new(
                          parent: curr_node,
                          x: curr_node.x - 1,
                          y: curr_node.y,
                          f: _pythag_distance([curr_node.x, curr_node.y], finish),
                          g: curr_node.g + 1
                        ),
                        # NW node
                        Node.new(
                          parent: curr_node,
                          x: curr_node.x - 1,
                          y: curr_node.y - 1,
                          f: _pythag_distance([curr_node.x, curr_node.y], finish),
                          g: curr_node.g + 1
                        )
                      ].each do |candidate_node|
                        # out-of-bounds checks
                        next if candidate_node.x < 0
                        next if candidate_node.y < 0
                        next if candidate_node.x >= width
                        next if candidate_node.y >= height
            
                        next if visited[candidate_node.y][candidate_node.x] # skip if we've already been there
                        next unless map[candidate_node.y][candidate_node.x] # skip if impassable
            
                        insert_index = pending_nodes.index(pending_nodes.detect{|n| n.f > candidate_node.f }) || pending_nodes.length
                        pending_nodes.insert(insert_index, candidate_node)
                        p ['inserted new pending node at', insert_index]
                      end
                    end

    loop do
      break unless solution_node
      path.unshift(solution_node)
      solution_node = solution_node.parent
    end

    path
  end

  # calculates a^2 + b^2, where a and b are (x, y) coordinates
  def self._pythag_distance(a, b)
    (
      (b[0] - a[0]).abs**2
    ) + (
      (b[1] - a[1]).abs**2
    )
  end

  def self._to_s(map, start, finish, path)
    s = ''

    s << '-' * map[0].length * 3
    s << "\n"
    map.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        if start == [x, y]
          s << 'SSS'
        elsif finish == [x, y]
          s << 'FFF'
        elsif (path.last || start) == ([x, y])
          s << 'xxx'
        elsif map[y][x]
          s << '   '
        else
          s << '███'
        end
      end
      s << "\n"
    end
    s << '-' * map[0].length * 3
    s << "\n"

    s << "w, h: #{@map[0].length}, #{@map.length}\n"
    s << "heur: #{_pythagorean_square_distance(@path_stack.last || @start, @finish)}"
    
    s
  end
end
