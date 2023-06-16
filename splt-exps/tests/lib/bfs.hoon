/+  *test, *bfs
|%
++  test-bfs
  ;:  weld
  %+  expect-eq
    =/  given
      %-  limo
        :*
          %-  limo  [0 16 13 0 0 0 ~]
          %-  limo  [0 0 10 12 0 0 ~]
          %-  limo  [0 4 0 0 14 0 ~]
          %-  limo  [0 0 9 0 0 20 ~]
          %-  limo  [0 0 0 7 0 4 ~]
          %-  limo  [0 0 0 0 0 0 ~]
          ~
        ==
    =/  expected  (limo [--1 0 0 1 2 3 ~])
    !>  expected
    !>  (need (bfs given 0 5))
  :: %+  expect-eq
  ::   !>  .1
  ::   !>  (absolute .1)
  :: %-  expect-fail
  ::   |.  (absolute .0)
  ==
--
