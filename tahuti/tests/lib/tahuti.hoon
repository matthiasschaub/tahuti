/+  *test, *tahuti
::
|%
++  fixtures
  ::  fixtures are a pair of expenses and ships
  ::
  |%
  ++  single-zero
    ^-  (pair (list [@p @rs (list @p)]) (list @p))
    :-
      :~
        :*  ~zod  .0  (limo [~zod ~])  ==
      ==
    :~  ~zod  ==
  ++  single-single
    ^-  (pair (list [@p @rs (list @p)]) (list @p))
    :-
      :~
        :*  ~zod  .1  (limo [~zod ~])  ==
      ==
    :~  ~zod  ==
  ++  multi-single
    ::  multiple expenses single ship
    ::
    ^-  (pair (list [@p @rs (list @p)]) (list @p))
    :-
      :~
        :*  ~zod  .1  (limo [~zod ~])  ==
        :*  ~zod  .2  (limo [~zod ~])  ==
        :*  ~zod  .3  (limo [~zod ~])  ==
      ==
    :~  ~zod  ==
  ++  multi-multi-equal
    ::  multiple expenses multiple ships with equal involvement
    ::
    ^-  (pair (list [@p @rs (list @p)]) (list @p))
    :-
      :~
        :*  ~zod  .1  (limo [~zod ~nus ~])  ==
        :*  ~nus  .2  (limo [~zod ~nus ~])  ==
        :*  ~nus  .3  (limo [~zod ~nus ~])  ==
      ==
    :~  ~zod  ~nus  ==
  ++  multi-multi-diff
    ::  multiple expenses multiple ships with different involvement
    ::
    ^-  (pair (list [@p @rs (list @p)]) (list @p))
    :-
      :~
        :*  ~zod  .1  (limo [~nus ~])  ==
        :*  ~nus  .2  (limo [~zod ~nus ~])  ==
        :*  ~nus  .3  (limo [~zod ~])  ==
      ==
    :~  ~zod  ~nus  ==
  --
++  test-sum-single
  ;:  weld
    %+  expect-eq
      !>   .0
      !>  ~(sum tahuti single-zero:fixtures)
    %+  expect-eq
      !>  .1
      !>  ~(sum tahuti single-single:fixtures)
  ==
++  test-sum-multi
  ;:  weld
    %+  expect-eq
      !>   .6
      !>  ~(sum tahuti multi-single:fixtures)
  ==
++  test-gro-single
  %+  expect-eq
    !>  (malt (limo [[~zod .1] ~]))
    !>  ~(gro tahuti single-single:fixtures)
++  test-gro-multi
  ;:  weld
    %+  expect-eq
      !>  (malt (limo [[~zod .6] ~]))
      !>  ~(gro tahuti multi-single:fixtures)
    %+  expect-eq
      !>  (malt (limo [[~zod .1] [~nus .5] ~]))
      !>  ~(gro tahuti multi-multi-equal:fixtures)
  ==
++  test-net-single
  %+  expect-eq
    !>  (malt (limo [[~zod .0] ~]))
    !>  ~(net tahuti single-single:fixtures)
++  test-net-multi
  ;:  weld
    %+  expect-eq
      !>  (malt (limo [[~zod .0] ~]))
      !>  ~(net tahuti multi-single:fixtures)
    %+  expect-eq
      !>  (malt (limo [[~zod .-2] [~nus .2] ~]))
      !>  ~(net tahuti multi-multi-equal:fixtures)
    %+  expect-eq
      !>  (malt (limo [[~zod .-3] [~nus .3] ~]))
      !>  ~(net tahuti multi-multi-diff:fixtures)
  ==
++  test-ind-single
  %+  expect-eq
    !>  [(limo [~]) (limo [~])]
    !>  ~(ind tahuti single-single:fixtures)
++  test-ind-multi
  %+  expect-eq
    !>  [(limo [1 ~]) (limo [0 ~])]
    !>  ~(ind tahuti multi-multi-equal:fixtures)
++  test-adj-multi
  ;:  weld
    %+  expect-eq
      !>
        %-  limo
          :*
            ::         s ~zod ~nus t
            %-  limo  [.0 .2 .0 .0 ~]  :: s
            %-  limo  [.0 .0 .100 .0 ~]  :: ~zod
            %-  limo  [.0 .0 .0 .2 ~]  :: ~nus
            %-  limo  [.0 .0 .0 .0 ~]  ::  t
            ~
          ==
      !>  ~(adj tahuti multi-multi-equal:fixtures)
    %+  expect-eq
      !>
        %-  limo
          :*
            ::         s ~zod ~nus t
            %-  limo  [.0 .3 .0 .0 ~]  :: s
            %-  limo  [.0 .0 .100 .0 ~]  :: ~zod
            %-  limo  [.0 .0 .0 .3 ~]  :: ~nus
            %-  limo  [.0 .0 .0 .0 ~]  ::  t
            ~
          ==
      !>  ~(adj tahuti multi-multi-diff:fixtures)
  ==
++  test-rei-multi
  %+  expect-eq
      !>
        :-  .2
          %-  limo
            :*
              ::         s ~zod ~nus t
              %-  limo  [.0 .2 .0 .0 ~]  :: s
              %-  limo  [.0 .0 .2 .0 ~]  :: ~zod
              %-  limo  [.0 .0 .0 .2 ~]  :: ~nus
              %-  limo  [.0 .0 .0 .0 ~]  ::  t
              ~
            ==
    !>  (need ~(rei tahuti multi-multi-equal:fixtures))
--
