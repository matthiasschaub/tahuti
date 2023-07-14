/+  *test, *tahuti
::
|%
++  fixtures
  |%
  ++  exes
    |%
    ++  single-zero
      ^-  (list [@p @rs (list @p)])
      :~
        :*  ~zod  .0  (limo [~zod ~])  ==
      ==
    ++  single
      ^-  (list [@p @rs (list @p)])
      :~
        :*  ~zod  .1  (limo [~zod ~])  ==
      ==
    ++  multi-single
      ::  multiple expenses single ship
      ::
      ^-  (list [@p @rs (list @p)])
      :~
        :*  ~zod  .1  (limo [~zod ~])  ==
        :*  ~zod  .2  (limo [~zod ~])  ==
        :*  ~zod  .3  (limo [~zod ~])  ==
      ==
    ++  multi-multi-equal
      ::  multiple expenses multiple ships with equal involvement
      ::
      ^-  (list [@p @rs (list @p)])
      :~
        :*  ~zod  .1  (limo [~zod ~nus ~])  ==
        :*  ~nus  .2  (limo [~zod ~nus ~])  ==
        :*  ~nus  .3  (limo [~zod ~nus ~])  ==
      ==
    ++  multi-multi-diff
      ::  multiple expenses multiple ships with different involvement
      ::
      ^-  (list [@p @rs (list @p)])
      :~
        :*  ~zod  .1  (limo [~nus ~])  ==
        :*  ~nus  .2  (limo [~zod ~nus ~])  ==
        :*  ~nus  .3  (limo [~zod ~])  ==
      ==
    --
  --
++  test-sum-single
  ;:  weld
    %+  expect-eq
      !>   .0
      !>  (sum single-zero:exes:fixtures)
    %+  expect-eq
      !>  .1
      !>  (sum single:exes:fixtures)
  ==
++  test-sum-multi
  ;:  weld
    %+  expect-eq
      !>   .6
      !>  (sum multi-single:exes:fixtures)
  ==
++  test-gro-single
  %+  expect-eq
    !>  (malt (limo [[~zod .1] ~]))
    !>  (gro single:exes:fixtures)
++  test-gro-multi
  ;:  weld
    %+  expect-eq
      !>  (malt (limo [[~zod .6] ~]))
      !>  (gro multi-single:exes:fixtures)
    %+  expect-eq
      !>  (malt (limo [[~zod .1] [~nus .5] ~]))
      !>  (gro multi-multi-equal:exes:fixtures)
  ==
:: ++  test-net-single
::   %+  expect-eq
::     !>  (malt (limo [[~zod .0] ~]))
::     !>  (net [single:exes:fixtures (limo [~zod ~])])
++  test-net-multi
  ;:  weld
    :: %+  expect-eq
    ::   !>  (malt (limo [[~zod .0] ~]))
    ::   !>  (net [multi-single:exes:fixtures (limo [~zod ~])])
    :: %+  expect-eq
    ::   !>  (malt (limo [[~zod .0.5] [~nus .2.5] ~]))
    ::   !>  (net [multi-multi-equal:exes:fixtures (limo [~zod ~nus ~])])
    %+  expect-eq
      !>  (malt (limo [[~zod .-3] [~nus .3] ~]))
      !>  (net [multi-multi-diff:exes:fixtures (limo [~zod ~nus ~])])
  ==
--
