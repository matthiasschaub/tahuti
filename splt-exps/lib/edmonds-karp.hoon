::    Edmonds-Karp algorithm for finding the maximum flow.
::
/+  *bfs, *graph
/-  *graph
::
|%
++  edmonds-karp
  ::  a pair of the maximum flow from source to sink and the flow graph
  ::
  |=  ::  .g: graph as adjacency matrix
      ::  .s: source
      ::  .t: sink
      $:  g=graph
          s=@ud
          t=@ud
      ==
  ^-  (unit (pair maxflow=@rs flowgraph=graph))
  ::
  =/  n         (lent g)                         :: size
  =/  f         (reap n (reap n .0))              :: flow graph as adjacency matrix
  =/  maxflow   .0
  =/  path      (bfs [g s t])                    :: augmenting path
  ::  TODO:     how to define inf equivalent value?
  ::
  =/  inf       .100
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
      ::  TODO:  does min work with @rs?
      ::
      bottleneck  (min bottleneck (get:edge [g u v]))
      v           u
    ==
  =/  v  t
  ::  update residual and flow graph
  ::
  |-
  ?:  ?!(.=(v s))
    :: decrease capacity u->v by bottleneck
    :: increase capacity v->u by bottleneck
    :: increase flow     u->v by bottleneck
    ::
    =/  u   (snag v path)
    =/  uv  (get:edge [g u v])
    =.  g   (set:edge [g u v (sub:rs uv bottleneck)])
    =/  vu  (get:edge [g v u])
    =.  g   (set:edge [g v u (add:rs vu bottleneck)])
    %=  $
      g  g
      f  (set:edge [f u v (add:rs (get:edge [f u v]) bottleneck)])
      v  u
    ==
  %=  ^^$
    maxflow   (add:rs maxflow bottleneck)
    path      (bfs [g s t])
  ==
--
