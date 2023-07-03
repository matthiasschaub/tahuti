::
::
/+  *test, *edmonds-karp
::
|%
++  fixture-graph
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
::
++  test-get
  ;:  weld
    %+  expect-eq
      !>  16
      !>  (get [fixture-graph 0 1])
  ==
++  test-set
  ;:  weld
    %+  expect-eq
      !>  %-  limo
        :*
          %-  limo  [0 100 13 0 0 0 ~]
          %-  limo  [0 0 10 12 0 0 ~]
          %-  limo  [0 4 0 0 14 0 ~]
          %-  limo  [0 0 9 0 0 20 ~]
          %-  limo  [0 0 0 7 0 4 ~]
          %-  limo  [0 0 0 0 0 0 ~]
          ~
        ==
      !>  (set [fixture-graph 0 1 100])
  ==
++  test-edmonds-karp
  ;:  weld
    %+  expect-eq
      !>  23
      !>  (head (need (edmonds-karp [fixture-graph 0 5])))
  ==
--
