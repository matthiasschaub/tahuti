::
::
/+  *test, *bfs
::
|%
++  fixture-graph
  %-  limo
    :*
      ::         a b  c  d e f
      %-  limo  [0 16 13 0 0 0 ~]  :: a
      %-  limo  [0 0 10 12 0 0 ~]  :: b
      %-  limo  [0 4 0 0 14 0 ~]   :: c
      %-  limo  [0 0 9 0 0 20 ~]   :: d
      %-  limo  [0 0 0 7 0 4 ~]    :: e
      %-  limo  [0 0 0 0 0 0 ~]    :: f
      ~
    ==
::
++  test-bfs
  ;:  weld
    %+  expect-eq  
      :: path: a -> f
      ::
      !>  (limo [0 0 0 1 2 3 ~])
      !>  (need (bfs [fixture-graph 0 5]))
    %+  expect-eq  
      :: no path:f -> a
      ::
      !>  ~
      !>  (bfs [fixture-graph 5 0])
  ==
--
