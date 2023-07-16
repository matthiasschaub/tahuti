|%
::  $ex:     a single expense
::  $exes:   list of all expenses
::  $fleet:  a list of all group members
::
::
  +$  ex
    $:  payer=@p
        amount=@rs
        involves=(list @p)
    ==
+$  exes   (list ex)
+$  fleet  (list @p)
--
