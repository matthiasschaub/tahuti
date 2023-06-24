::    Edmonds-Karp algorithm for finding the maximum flow.
::
/+  *bfs
|%
++  get
  :: the capacity of an edge
  ::
  |=  ::  .g:  adjacency matrix
      ::  .v: vertex (row)
      ::  .u: vertex (col)
      $:  g=(list (list @ud))
          v=@ud
          u=@ud
      ==
  ^-  @ud
  (snag u (snag v g))
++  set
  :: a graph with the capacity of an edge changed
  ::
  |=  ::  .g: adjacency matrix
      ::  .v: vertex (row)
      ::  .u: vertex (col)
      ::  .c: capacity
      $:  g=(list (list @ud))
          v=@ud
          u=@ud
          c=@ud
      ==
  ^-  (list (list @ud))
  (snap g v (snap (snag v g) u c))
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
  ^-  (unit @ud)
  ::
  =/  n    (lent g)             :: size
  =/  flow-graph  (reap n (reap n 0))
  =/  max-flow  0
  =/  path  (bfs [g s t])
  =/  inf  100
  ::  while there is an augmenting path
  ::
  |-
  ?:  =([~] path)
    (some max-flow)
  =/  path  (need path)
  ::  find bottleneck of the path
  =/  bottleneck  inf
  =/  v  s
  =/  u  (snag v path)
  |-
  ?:  !=(v t)
    %=  $
      bottleneck  (min bottleneck (snag u (snag v g)))
      v  u
      u  (snag v path)
    ==
  :: update residual path
  =/  v  s
  =/  u  (snag v path)
  |-
  ?:  !=(v t)
    =/  uv  (snag u (snag v g))  :: capacity u->v
    =/  vu  (snag v (snag u g))
    %=  $
      :: decrease capacity u->v by bottleneck
      :: increase capacity v->u by bottleneck
      :: increase flow u->v by bottleneck
      ::
      g       (into g u (into (snag g u) v (sub uv bottleneck)))
      g       (into g v (into (snag g v) u (add vu bottleneck)))
      flow-graph  (into g u (into (snag g u) v (sub uv bottleneck)))
      v  u
      u  (snag v path)
    ==
  %=  $
    max-flow  (add max-flow bottleneck)
    path  (bfs [g s t])
  ==
--
