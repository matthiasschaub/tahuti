::    Breadth First Search (BFS)
::
::  BFS is performed recursively on an adjacency matrix.
::
|%
++  bfs
  ::  find a path in the graph between source and sink
  ::
  |=  ::  g: graph
      ::  s: source
      ::  t: sink
      $:  g=(list (list @ud))
          s=@ud
          t=@ud
      ==
  ^-  (unit (list @sd))
  =/  n    (lent g)         :: size
  =/  vis  (reap n `?`%.n)  :: visited
  =/  pat  (reap n --1)     :: path
  =/  que  (limo [s ~])     :: queue
  =/  u    (head que)       :: vertex
  =/  v    0                :: vertex
  ::       [u v]            :: edge
  ::
  |-
  ?:  =((lent que) 0)
    ?:  (snag s vis)
      [~ pat]
    ~
  :: for each neighbor
  ::
  |-
  ?:  =(n v)
    :: if not visited and capacity > 0
    ::
    ?:  &(!(snag v vis) (gth (snag v (snag u g)) 0))
      %=  $
        v    +(v)
        vis  (snap vis v `?`%.y)
        pat  (snap pat v `@sd`u)
        que  (snoc que v)
      ==
    %=  $
      v  .+  v
    ==
  %=  ^$
    u    (head que)
    que  (tail que)
    vis  (snap vis u `?`%.y)
  ==
--
