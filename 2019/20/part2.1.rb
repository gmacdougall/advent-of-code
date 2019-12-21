#!/usr/bin/env ruby

# output from part 2 regular
hash = {
  "AAo"=>[["DSo", 8, true], ["UOi", 30, false]],
  "ABi"=>[["YAo", 52, true]],
  "ABo"=>[["MMi", 36, false]],
  "BTi"=>[["UOo", 28, true]],
  "BTo"=>[["HOi", 48, false]],
  "DHi"=>[["UNo", 36, true]],
  "DHo"=>[["SHi", 40, false]],
  "DQi"=>[["LEo", 40, true]],
  "DQo"=>[["UNi", 40, false]],
  "DSi"=>[["QWo", 38, true]],
  "DSo"=>[["AAo", 8, true], ["UOi", 36, false]],
  "GUi"=>[["WTo", 32, true]],
  "GUo"=>[["UVi", 36, false]],
  "HOi"=>[["BTo", 48, true]],
  "HOo"=>[["LYi", 50, false], ["MMo", 14, true], ["IZi", 52, false]],
  "HRi"=>[["SHo", 42, true]],
  "HRo"=>[["YAi", 54, false]],
  "HSi"=>[["UVo", 56, true]],
  "HSo"=>[["PYi", 42, false]],
  "IZi"=>[["HOo", 52, true], ["LYi", 4, false], ["MMo", 64, true]],
  "IZo"=>[["ZHi", 28, false]],
  "JMi"=>[["ZZo", 52, true], ["PYo", 48, true]],
  "JMo"=>[["LUi", 42, false]],
  "LEi"=>[["UFo", 26, true]],
  "LEo"=>[["DQi", 40, false]],
  "LUi"=>[["JMo", 42, true]],
  "LUo"=>[["UFi", 50, false]],
  "LYi"=>[["HOo", 50, true], ["MMo", 62, true], ["IZi", 4, false]],
  "LYo"=>[["QVi", 44, false]],
  "MMi"=>[["ABo", 36, true]],
  "MMo"=>[["HOo", 14, true], ["LYi", 62, false], ["IZi", 64, false]],
  "MZi"=>[["QVo", 44, true]],
  "MZo"=>[["QWi", 52, false]],
  "PYi"=>[["HSo", 42, true]],
  "PYo"=>[["JMi", 48, false], ["ZZo", 6, true]],
  "QVi"=>[["LYo", 44, true]],
  "QVo"=>[["MZi", 44, false]],
  "QWi"=>[["MZo", 52, true]],
  "QWo"=>[["DSi", 38, false]],
  "SHi"=>[["DHo", 40, true]],
  "SHo"=>[["HRi", 42, false]],
  "UFi"=>[["LUo", 50, true]],
  "UFo"=>[["LEi", 26, false]],
  "UNi"=>[["DQo", 40, true]],
  "UNo"=>[["DHi", 36, false]],
  "UOi"=>[["DSo", 36, true], ["AAo", 30, true]],
  "UOo"=>[["BTi", 28, false]],
  "UVi"=>[["GUo", 36, true]],
  "UVo"=>[["HSi", 56, false]],
  "WTi"=>[["ZHo", 32, true]],
  "WTo"=>[["GUi", 32, false]],
  "YAi"=>[["HRo", 54, true]],
  "YAo"=>[["ABi", 52, false]],
  "ZHi"=>[["IZo", 28, true]],
  "ZHo"=>[["WTi", 32, false]],
  "ZZo"=>[["JMi", 52, false], ["PYo", 6, true]]
}

class Graph
  attr_reader :graph, :nodes, :previous, :distance #getter methods
  INFINITY = 1 << 64

  def initialize
    @graph = {} # the graph // {node => { edge1 => weight, edge2 => weight}, node2 => ...
    @nodes = Array.new
  end

  # connect each node with target and weight
  def connect_graph(source, target, weight)
    if (!graph.has_key?(source))
      graph[source] = {target => weight}
    else
      graph[source][target] = weight
    end
    if (!nodes.include?(source))
      nodes << source
    end
  end

  # connect each node bidirectional
  def add_edge(source, target, weight)
    connect_graph(source, target, weight) #directional graph
    connect_graph(target, source, weight) #non directed graph (inserts the other edge too)
  end


  # based of wikipedia's pseudocode: http://en.wikipedia.org/wiki/Dijkstra's_algorithm


  def dijkstra(source)
    @distance={}
    @previous={}
    nodes.each do |node|#initialization
      @distance[node] = INFINITY #Unknown distance from source to vertex
      @previous[node] = -1 #Previous node in optimal path from source
    end

    @distance[source] = 0 #Distance from source to source

    unvisited_node = nodes.compact #All nodes initially in Q (unvisited nodes)

    while (unvisited_node.size > 0)
      u = nil;

      unvisited_node.each do |min|
        if (not u) or (@distance[min] and @distance[min] < @distance[u])
          u = min
        end
      end

      if (@distance[u] == INFINITY)
        break
      end

      unvisited_node = unvisited_node - [u]

      graph[u].keys.each do |vertex|
        alt = @distance[u] + graph[u][vertex]

        if (alt < @distance[vertex])
          @distance[vertex] = alt
          @previous[vertex] = u  #A shorter path to v has been found
        end

      end

    end

  end


  # To find the full shortest route to a node

  def find_path(dest)
    if @previous[dest] != -1
      find_path @previous[dest]
    end
    @path << dest
  end


  # Gets all shortests paths using dijkstra

  def shortest_paths(source)
    @graph_paths=[]
    @source = source
    dijkstra source
    nodes.each do |dest|
      @path=[]

      find_path dest

      actual_distance=if @distance[dest] != INFINITY
                        @distance[dest]
                      else
                        "no path"
                      end
      @graph_paths<< "Target(#{dest})  #{@path.join("-->")} : #{actual_distance}"
    end
    @graph_paths
  end

  # print result

  def print_result
    @graph_paths.each do |graph|
      puts graph
    end
  end
end

g = Graph.new
hash.each do |key, vals|
  50.times do |n|
    vals.each do |set|
      g.add_edge("#{key}-#{n.to_s.rjust(5, '0')}", "#{set[0]}-#{n.to_s.rjust(5, '0')}", set[1])
    end
    if key.include?('i')
      g.add_edge("#{key}-#{n.to_s.rjust(5, '0')}", "#{key.gsub('i', 'o')}-#{(n+1).to_s.rjust(5, '0')}", 1)
    end
  end
end

puts g.shortest_paths('AAo-00000')
