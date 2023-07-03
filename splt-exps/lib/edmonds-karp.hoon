::    Edmonds-Karp algorithm for finding the maximum flow.
::
/+  *bfs
!:
|%
++  get
  :: the capacity of an edge
  ::
  |=  ::  .g: graph as adjacency matrix
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
  |=  ::  .g: graph as adjacency matrix
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
  ::  a pair of the maximum flow from source to sink and the flow graph
  ::
  |=  ::  .g: graph as adjacency matrix
      ::  .s: source
      ::  .t: sink
      $:  g=(list (list @ud))
          s=@ud
          t=@ud
      ==
  ^-  (unit (pair maxflow=@ud flowgraph=(list (list @ud))))
  ::
  =/  n         (lent g)                         :: size
  =/  f         (reap n (reap n 0))              :: flow graph as adjacency matrix
  =/  maxflow   0
  =/  path      (bfs [g s t])                    :: augmenting path
  ::  TODO:     how to define inf equivalent value?
  ::
  =/  inf       100
  ::  while there is an augmenting path
  ::
  |-
  ?:  =([~] path)
    (some [maxflow f])
  =/  path        (need path)
  =/  bottleneck  inf                            :: bottleneck capacity
  =/  v           t
  ::  find bottleneck of the path
  ::
  |-
  ?:  ?!(.=(v s))
    =/  u  (snag v path)
    %=  $
      bottleneck  (min bottleneck (get [g u v]))
      v           u
    ==
  =/  v  t
  ::  update residual and flow graph
  ::
  |-
  ?:  ?!(.=(v s))
    =/  u   (snag v path)
    =/  uv  (get [g u v])                        :: capacity u->v
    =.  g   (set [g u v (sub uv bottleneck)])
    =/  vu  (get [g v u])
    =.  g   (set [g v u (add vu bottleneck)])
    %=  $
      :: decrease capacity u->v by bottleneck
      :: increase capacity v->u by bottleneck
      :: increase flow     u->v by bottleneck
      ::
      g  g
      f  (set [f u v (add (get [f u v]) bottleneck)])
      v  u
    ==
  %=  ^^$
    maxflow   (add maxflow bottleneck)
    path      (bfs [g s t])
  ==
--
