|%
::  $ex:     a single expense
::  $exes:   list of all expenses
::  $fleet:  a list of all group members
::
+$  ex
  $:  ::  title=@t
      payer=@p
      amount=@rs
      involves=(list @p)
  ==
+$  exes   (list ex)
+$  fleet  (list @p)  :: TODO: should this be a set?
--
