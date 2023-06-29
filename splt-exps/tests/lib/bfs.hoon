::
::
/+  *test, *bfs
::
|%
++  fixture-graph-one
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
++  fixture-graph-two
  %-  limo
    :*
      ::         a b  c  d e f
      %-  limo  [0 4 13 0 0 0 ~]
      %-  limo  [12 0 10 0 0 0 ~]
      %-  limo  [0 4 0 0 14 0 ~]
      %-  limo  [0 12 9 0 0 8 ~]
      %-  limo  [0 0 0 7 0 4 ~]
      %-  limo  [0 0 0 12 0 0 ~]
      ~
    ==
::
++  test-bfs
  ;:  weld
    %+  expect-eq
     :: path: a -> f
     ::
     !>  (limo [0 0 0 1 2 3 ~])
     !>  (need (bfs [fixture-graph-one 0 5]))
    %+  expect-eq
      :: no path:f -> a
      ::
      !>  ~
      !>  (bfs [fixture-graph-one 5 0])
    %+  expect-eq
      ::
      !>  (limo [0 0 0 4 2 4 ~])
      !>  (need (bfs [fixture-graph-two 0 5]))
  ==
--
