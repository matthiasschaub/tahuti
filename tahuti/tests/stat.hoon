::
::
/-  *tahuti
/+  *test, stat, *edmonds-karp, mip
::
|%
++  fixtures
  |%
  ++  fleet
    ^-  (list @p)
    %-  limo
      :: :*  ~zod  ~nus  ~lus  ~ted  ~  ==
      :*  ~zod  ~nus  ~  ==
  ++  expenses
    ^-  (list expense)
    %-  limo
      :*
        [%gid %eid %title 10 %eur ~zod *@da (limo [~nus ~])]
        :: [%gid %eid %title 12 %eur ~zod *@da (limo [~lus ~])]
        [%gid %eid %title 4 %eur ~nus *@da (limo [~zod ~])]
        :: [%gid %eid %title 14 %eur ~nus *@da (limo [~ted ~])]
        :: [%gid %eid %title 9 %eur ~lus *@da (limo [~nus ~])]
        :: [%gid %eid %title 7 %eur ~ted *@da (limo [~lus ~])]
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
  ++  one
    ::  row owns column
    ::  [source alice bob carol dan Sink]
    ::
    %-  limo
      :*
        ::         s a  b  c  d S
        %-  limo  [0 16 13 0 0 0 ~]  :: s
        %-  limo  [0 0 10 12 0 0 ~]  :: a
        %-  limo  [0 4 0 0 14 0 ~]   :: b
        %-  limo  [0 0 9 0 0 20 ~]   :: c
        %-  limo  [0 0 0 7 0 4 ~]    :: d
        %-  limo  [0 0 0 0 0 0 ~]    :: S
        ~
      ==
  ++  two
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
  :: ++  expected
  ::   |%
  ::   ++  one
  ::     %-  limo
  ::       :*
  ::         %-  limo  [0 12 11 0 0 0 ~]
  ::         %-  limo  [0 0 0 12 0 0 ~]
  ::         %-  limo  [0 0 0 0 11 0 ~]
  ::         %-  limo  [0 0 0 0 0 19 ~]
  ::         %-  limo  [0 0 0 7 0 4 ~]
  ::         %-  limo  [0 0 0 0 0 0 ~]
  ::         ~
  ::       ==
  ::   ++  two
  ::     %-  limo
  ::       :*
  ::         %-  limo  [0 0 0 10 20 0 ~]
  ::         %-  limo  [0 0 0 0 0 25 ~]
  ::         %-  limo  [0 0 0 0 0 5 ~]
  ::         %-  limo  [0 10 0 0 0 0 ~]
  ::         %-  limo  [0 15 5 0 0 0 ~]
  ::         %-  limo  [0 0 0 0 0 0 ~]
  ::         ~
  ::       ==
  ::   --
--
++  test-en-de-adj
  ;:  weld
    %+  expect-eq
      !>  adj:fixtures
      !>  ~(en-adj stat [expenses:fixtures fleet:fixtures])
    %+  expect-eq
      !>  [6 flowgraph:fixtures]
      !>  (need (edmonds-karp [~(en-adj stat [expenses:fixtures fleet:fixtures]) 0 3]))
    %+  expect-eq
      !>  rei:fixtures
      !>  ~(de-adj stat [expenses:fixtures fleet:fixtures])
  ==
--
