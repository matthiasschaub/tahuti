::
::
/-  *tahuti
/+  *test, stat, *edmonds-karp, mip
::
|%
++  fixtures
  |%
  ++  one
    |%
    ++  fleet
      ^-  (list @p)
      %-  limo
        :*  ~zod  ~nus  ~  ==
    ++  expenses
      ^-  (list expense)
      %-  limo
        :*
          [%gid %eid %title 10 %eur ~zod *@da (limo [~nus ~])]
          [%gid %eid %title 4 %eur ~nus *@da (limo [~zod ~])]
          ~
        ==
    ++  adj
      =/  inf  28  :: two-time sum of all expenses
      %-  limo
        :~
          ::         s z n S
          %-  limo  [0 0 6 0 ~]    :: s
          %-  limo  [0 0 0 6 ~]    :: z
          %-  limo  [0 inf 0 0 ~]  :: n
          %-  limo  [0 0 0 0 ~]    :: S
        ==
    ++  flowgraph
      %-  limo
        :~
          ::         s z n S
          %-  limo  [0 0 6 0 ~]  :: s
          %-  limo  [0 0 0 6 ~]  :: z
          %-  limo  [0 6 0 0 ~]  :: n
          %-  limo  [0 0 0 0 ~]  :: s
        ==
    ++  rei
      =/  r  *^rei
      (~(put bi:mip r) ~nus ~zod -6)
    --
  ++  two
    ::  two payments simplified to one
    |%
    ++  fleet
      ^-  (list @p)
      %-  limo
        :*  ~zod  ~nus  ~lus  ~
        ==
    ++  expenses
      ^-  (list expense)
      %-  limo
        :*
          ::  ~nus owes ~zod 5
          ::  ~zod owes ~lus 5
          ::
          ::  -> simplified: ~nus owes ~lus 5
          ::
          [%gid %eid %title 5 %eur ~zod *@da (limo [~nus ~])]
          [%gid %eid %title 5 %eur ~lus *@da (limo [~zod ~])]
          ~
        ==
    ++  rei
      =/  r  *^rei
      (~(put bi:mip r) ~nus ~lus --5)
    --
  --
++  test-en-de-adj
  ;:  weld
    %+  expect-eq
      !>  adj:one:fixtures
      !>  ~(en-adj stat [expenses:one:fixtures fleet:one:fixtures])
    %+  expect-eq
      !>  [6 flowgraph:one:fixtures]
      !>  (need (edmonds-karp [~(en-adj stat [expenses:one:fixtures fleet:one:fixtures]) 0 3]))
    %+  expect-eq
      !>  rei:one:fixtures
      !>  ~(de-adj stat [expenses:one:fixtures fleet:one:fixtures])
  ==
++  test-en-de-adj-two
  ;:  weld
    %+  expect-eq
      !>  rei:two:fixtures
      !>  ~(de-adj stat [expenses:two:fixtures fleet:two:fixtures])
  ==
--
