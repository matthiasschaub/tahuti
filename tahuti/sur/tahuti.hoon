|%
::  $ex:     a single expense
::  $exes:   list of all expenses
::  $fleet:  a list of all group members
::
:: +$  ex
::   $:
::     id=@ud
::     title=@t
::     payer=@p
::     amount=@ud
::     currency=[%usd]  :: three-letter ISO code
::     involves=(list @p)
::     involments=(map @p @ud)  :: how much am I involved: E.g. 0.2 * amount
::     timestamp=@da
::     what=@t
::   ==
+$  ex
  $:  payer=@p
      amount=@ud      :: in currency’s smallest unit
      involves=(list @p)
  ==
+$  exes   (list ex)
+$  fleet  (list @p)  :: TODO: this should be a set?
--
