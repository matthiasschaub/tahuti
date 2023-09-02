/-  *tahuti
=<
|%
++  to-json
  |=  ex=ex
  ^-  json
  %-  pairs:enjs:format
  :~
    :-  'payer'     [%s (scot %p payer.ex)]
    :-  'amount'    (numb:enjs:format amount.ex)
    :-  'involves'  (as-json-array involves.ex)
  ==
++  from-json
  ^-  $-(json ex)
  %-  ot:dejs:format                                      :: obj as tuple
  :~
    :-  %payer     (se:dejs:format %p)                    :: str as aura (@p)
    :-  %amount    ni:dejs:format                         :: num as int
    :-  %involves  (ar:dejs:format (se:dejs:format %p))   :: arr as list
  ==
--
|%
  ++  as-json-array
  |=  i=(list @p)
  ^-  (pair %a (list (pair %s @t)))
  [%a (turn i as-json-str)]
  ++  as-json-str
    |=  a=@p
    ^-  (pair %s @t)
    [%s (scot %p a)]
--
