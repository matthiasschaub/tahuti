::    Edmonds-Karp algorithm for finding the maximum flow.
::
/+  *bfs
|%
++  edmonds-karp
  ::  a pair of the maximum flow from source to sink and the resulting
  ::  flow graph
  ::
  |=  ::  .g: graph as adjacency matrix
      ::  .s: source
      ::  .t: sink
      $:  g=(list (list @ud))
          s=@ud
          t=@ud
      ==
  ^-  (unit (list @ud))
  ::
  =/  n    (lent g)             :: size
  =/  flow-graph  (reap n (reap n 0))
  =/  max-flow  0
  :-  ~  %-  need  %-  bfs  [g s t]
--
