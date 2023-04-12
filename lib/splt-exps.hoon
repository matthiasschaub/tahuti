::    split expenses
::
::
::  > =splt -build-file %/lib/splt-exps/hoon
::  > =myexps [[~zod 1] [~pub 2] [~zod 3] ~]
::  > =myexps (add:splt myexps ~zod 1)
::  > =myexps (sum.splt myexps)
::  > myexps
::
::
|%
::  $ex: expense
::  $exs: expenses
+$  ex   [plot=@p val=@]
+$  exs  (list ex)
::
++  add
  ::    add expense to shared expenses list
  ::
  |=  [exps=exs exp=ex]
  ^-  exs
  (snoc exps exp)
::
++  sum
  ::    sum up shared expenses per plot
  ::
  |=  exps=exs
  ^-  (map @p @)
  %+  roll  exps                             ::  moves across list and slam gate
    |=  [[plot=@p val=@] sum=(map @p @)]
    ::  .cur: current value
    ::  .tlt: total value
    =/  cur
      %:
        ::  grab value with default
        %~  gut  by                          ::  pull the gut arm of the by core
          sum  plot  0                       ::  arguments (map key val)
      ==
    =/  tlt
      %:  ^add
        cur  val
      ==
    %:
      ::  add key-value pair
      %~  put  by
        sum  plot  tlt
    ==
--
