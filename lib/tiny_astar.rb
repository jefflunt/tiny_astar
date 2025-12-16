require 'time'

class TinyAstar
  attr_reader :path   # when pathfinding is complete, this attribute is either:
                      # - empty, meaning no path was found
                      # - non-empty, meaning a path was found
            

  # map: a 2d boolean array representing the map with passable and impassable
  # nodes
  #   - passable nodes are `true`
  #   - impassable nodes are `false`
  # start: the coordinates (x, y) of the starting node
  # finish: the coordinates (x, y) of the finishing node
  def initialize(map:, start:, finish:)
    @map = map
    @start = start
    @finish = finish

    @path = []
  end

  def _pathfind
    # add the starting square (or node) to the open list
    # repeat:
    #   - look for the lowest F cost squre on the open list - we refer to this
    #     as the current square
    #   - switch ?it? (the current square?) to the closed list (probably want to
    #     use a Set)
    #   - for each of the 8 squares adjacent to this current square:
    #     - if it is not passable, or if it's already on the closed list, ignore
    #     - if it isn't on the open list, add it to the open list. make the
    #       current square the parent of this square. record f, g, and h costs
    #       of the square.
    #     - if it is on the open list already, check to see if this path to that
    #       square is better, using G cost as the measure. a lower G cost means
    #       that this is a better path. if it is a lower cost, change the parent
    #       of the square to the current square, and recalculate the G and F
    #       scores of the square. if you are keeping your open list sorted by F
    #       score, you may need to resort the list ot account for the change.
    #   - stop when:
    #     - the target square is added to the closed list, in which case the
    #       path has been found
    #     - you fail to find the target square, and the open list is empty, in
    #       this case there is no path
    # save the path, working backwards from the target square, go from each
    # squre to its parent square until you reach the starting square.
  end

  def to_s
    s = ''

    s << '-' * @map[0].length * 3
    s << "\n"
    @map.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        if @start == [x, y]
          s << 'SSS'
        elsif @finish == [x, y]
          s << 'FFF'
        elsif @path.include?([x, y])
          s << 'xxx'
        elsif @map[y][x]
          s << '   '
        else
          s << '███'
        end
      end
      s << "\n"
    end
    s << '-' * @map[0].length * 3

    s
  end
end
