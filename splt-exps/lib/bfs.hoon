::    Breadth First Search (BFS)
::
::  BFS performed recursively on an adjacency matrix.
::
|%
++  bfs
  ::  a path from source to sink
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
  =/  vis  (reap n |)           :: visited
  =.  vis  (snap vis s &)
  =/  pat  (reap n 0)           :: path
  =/  que  (limo [s ~])         :: queue
  ::
  =/  v    0                    :: vertex
  ::  u    s                    :: vertex
  ::  e    [u v]                :: edge
  ::
  |-
  ?:  =((lent que) 0)           :: if, empty queue
    ?:  (snag t vis)            :: if, sink visited
      (some pat)
    ~
  =/  u  (head que)
  |-                            :: for each neighbor
  ?:  =(n v)
    %=  ^$
      que  (tail que)
      v    0
      vis  (snap vis u &)
    ==
  ?:  :: if, not visited and capacity > 0
      ::
      &(!(snag v vis) (gth (snag v (snag u g)) 0))
    :: then, mark as visited and enqueue it
    ::
    %=  $
      v    +(v)
      vis  (snap vis v &)
      pat  (snap pat v u)
      que  (snoc que v)
    ==
  :: else, continue
  ::
  %=  $
    v  +(v)
  ==
--
