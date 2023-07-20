::  helper library to get and set edges between vertices in a graph
::
|%
++  edge
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
  --
--
