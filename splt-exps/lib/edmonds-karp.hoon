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
  =/  n     (lent g)            :: size
  =/  flow  (reap n (reap n 0))
  =/  maxi  0                   :: maximum flow
  =/  path  (bfs [g s t])       :: augmenting path
  =/  inf   100                 :: TODO: how to define inf equivalent value?
  ::  while there is an augmenting path
  ::
  |-
  ?:  =([~] path)
    (some maxi)
  =/  path  (need path)
  =/  mini  inf                 :: bottleneck capacity
  =/  v  t
  ::  find bottleneck of the path
  ::
  |-
  ?:  ?!(.=(v s))
    =/  u  (snag v path)
    %=  $
      mini  (min mini (get [g u v]))
      v     u
    ==
  =/  v  t
  ::  update residual path
  ::
  |-
  ?:  ?!(.=(v s))
    =/  u   (snag v path)
    =/  uv  (get [g u v])             :: capacity u->v
    =/  g1  (set [g u v (sub uv mini)])
    =/  vu  (get [g1 v u])
    =/  g2  (set [g1 v u (add vu mini)])
    %=  $
      :: decrease capacity u->v by bottleneck
      :: increase capacity v->u by bottleneck
      :: increase flow u->v by bottleneck
      ::
      g     g2
      flow  (set [flow u v (add (get [flow u v]) mini)])
      v     u
    ==
  %=  ^^$
    maxi  (add maxi mini)
    path  (bfs [g s t])
  ==
--
