|%
+$  expense
  $:  payer=@p
      amount=@ud               :: smallest unit of currency
      involves=(list @p)
  ==
++  to-js
  |=  ex=expense
  ^-  json
  %-  pairs:enjs:format
  :~
    ['payer' (ship:enjs:format payer.ex)]    :: string
    ['amount' (numb:enjs:format amount.ex)]  :: number
    ['involves' [%a (turn involves.ex ship:enjs:format)]]  :: number
  ==
--
:: ++  to-js
::   |=  usr=user
::   |^  ^-  json
::   %-  pairs:enjs:format
::   :~
::     ['username' s+username.usr]
::     ['name' name]
::     ['joined' (sect:enjs:format joined.usr)]
::     ['email' s+email.usr]
::   ==
::   ++  name
::     :-  %a
::     :~
::       [%s first.name.usr]
::       [%s mid.name.usr]
::       [%s last.name.usr]
::     ==
::   --
:: ++  from-js
::   =,  dejs:format
::   ^-  $-(json user)
::   %-  ot
::   :~
::     [%username so]
::     [%name (at ~[so so so])]
::     [%joined du]
::     [%email so]
::   ==
:: --
