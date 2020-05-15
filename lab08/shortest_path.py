#!/usr/bin/env python3

import sys, re

(start, end) = (sys.argv[1], sys.argv[2])
roads = {}
visited = {}

for line in sys.stdin:
   matches = re.findall('(\S+)\s+(\S+)\s+(\d+)', line)
   frm = matches[0][0]
   to = matches[0][1]
   length = matches[0][2]

   visited[frm] = 0
   visited[to] = 0

   if (frm not in roads.keys()):
      roads[frm] = {}
   roads[frm][to] = int(length)

   if (to not in roads.keys()):
      roads[to] = {}
   roads[to][frm] = int(length)

prev = {}
dist = {}

dist[start] = 0

while (1):
   curr = sorted(dist, key=dist.get)
   curr = sorted(curr, key=visited.get)[0]
   visited[curr] = 1
   #print("curr = %s" % curr)

   for next in roads[curr]:
      alt = dist[curr] + roads[curr][next]
      if (next not in dist or alt < dist[next]):
         dist[next] = alt
         prev[next] = curr
   if (curr == end):
      #print(dist[end])
      break

curr = end
route = []
while (curr != start):
   route.insert(0, curr)
   curr = prev[curr]
route.insert(0, start)

#print(route)

path = " ".join(route)

print("Shortest route is length = %d: %s." % (dist[end], path))



