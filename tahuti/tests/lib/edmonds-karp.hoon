::
::
/+  *test, *edmonds-karp
::
|%
++  fixtures
  |%
  ++  given
    |%
    ++  one
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
    ++  two
      :: row owns column
      :: [source alice bob carol dan sink]
      ::
      =/  inf  100
      %-  limo
        :*
          %-  limo  [0 0 0 10 20 0 ~]
          %-  limo  [0 0 0 0 0 25 ~]
          %-  limo  [0 0 0 0 0 5 ~]
          %-  limo  [0 inf inf 0 inf 0 ~]
          %-  limo  [0 inf inf inf 0 0 ~]
          %-  limo  [0 0 0 0 0 0 ~]
          ~
        ==
    --
  ++  expected
    |%
    ++  one
      %-  limo
        :*
          %-  limo  [0 12 11 0 0 0 ~]
          %-  limo  [0 0 0 12 0 0 ~]
          %-  limo  [0 0 0 0 11 0 ~]
          %-  limo  [0 0 0 0 0 19 ~]
          %-  limo  [0 0 0 7 0 4 ~]
          %-  limo  [0 0 0 0 0 0 ~]
          ~
        ==
    ++  two
      %-  limo
        :*
          %-  limo  [0 0 0 10 20 0 ~]
          %-  limo  [0 0 0 0 0 25 ~]
          %-  limo  [0 0 0 0 0 5 ~]
          %-  limo  [0 10 0 0 0 0 ~]
          %-  limo  [0 15 5 0 0 0 ~]
          %-  limo  [0 0 0 0 0 0 ~]
          ~
        ==
    --
  --
++  test-edmonds-karp
  ;:  weld
    %+  expect-eq
      !>  [23 one:expected:fixtures]
      !>  (need (edmonds-karp [one:given:fixtures 0 5 100]))
    %+  expect-eq
      !>  [30 two:expected:fixtures]
      !>  (need (edmonds-karp [two:given:fixtures 0 5 100]))
  ==
--
