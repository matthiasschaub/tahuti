=<
|%
+$  user
  $:  payer=@p
      amount=@ud
      involved=(list @p)
  ==
++  to-js
  |=  usr=user
  ^-  json
  %-  pairs:enjs:format
  :~
    :-  'payer'     [%s (scot %p payer.usr)]
    :-  'amount'    (numb:enjs:format amount.usr)
    :-  'involved'  (as-json-array involved.usr)
  ==
++  from-js
  ^-  $-(json user)
  %-  ot:dejs:format                                      :: obj as tuple
  :~
    :-  %payer     (se:dejs:format %p)                    :: str as aura (@p)
    :-  %amount    ni:dejs:format                         :: num as int
    :-  %involved  (ar:dejs:format (se:dejs:format %p))   :: arr as list
  ==
--
|%
  ++  as-json-array
    :: =/  ship-to-cord  (cury scot @p)
    :: =/  union-of-str  (cury cell %s)
    :: =/  ships-as-cord  (turn involves.usr (cury scot @p))
  |=  i=(list @p)
  ^-  (pair %a (list (pair %s @t)))
  [%a (turn i as-json-str)]
  :: :-  %a  (turn ships union-of-str)
  ++  as-json-str
    |=  a=@p
    ^-  (pair %s @t)
    [%s (scot %p a)]
--
