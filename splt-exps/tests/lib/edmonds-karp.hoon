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
          %-  limo  [0 16 13 0 0 0 ~]
          %-  limo  [0 0 10 12 0 0 ~]
          %-  limo  [0 4 0 0 14 0 ~]
          %-  limo  [0 0 9 0 0 20 ~]
          %-  limo  [0 0 0 7 0 4 ~]
          %-  limo  [0 0 0 0 0 0 ~]
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
::
++  test-get
  ;:  weld
    %+  expect-eq
      !>  16
      !>  (get [one:given:fixtures 0 1])
  ==
:: ++  test-set
::   ;:  weld
::     %+  expect-eq
::       !>  %-  limo
::         :*
::           %-  limo  [0 100 13 0 0 0 ~]
::           %-  limo  [0 0 10 12 0 0 ~]
::           %-  limo  [0 4 0 0 14 0 ~]
::           %-  limo  [0 0 9 0 0 20 ~]
::           %-  limo  [0 0 0 7 0 4 ~]
::           %-  limo  [0 0 0 0 0 0 ~]
::           ~
::         ==
::       !>  (set [one:given:fixtures 0 1 100])
::   ==
:: ++  test-edmonds-karp
::   ;:  weld
::     %+  expect-eq
::       !>  [23 one:expected:fixtures]
::       !>  (need (edmonds-karp [one:given:fixtures 0 5]))
::     %+  expect-eq
::       !>  [30 two:expected:fixtures]
::       !>  (need (edmonds-karp [two:given:fixtures 0 5]))
::   ==
--
