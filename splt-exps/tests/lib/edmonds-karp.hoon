/+  *test, *edmonds-karp
|%
++  test-edmonds-karp
  ;:  weld
  %+  expect-eq
    !>  (limo [0 0 0 1 2 3 ~])
    !>
      %-  need  %-  edmonds-karp
        :*
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
          0
          5
        ==
    ==
--
