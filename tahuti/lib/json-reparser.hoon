::  In Hoon JSON is represented as a `unit` and cells head-tagged with the
::  JSON type.
::
::  JSON must be processed twice:
::    1. First the JSON is parsed from text (`@t` `cord`) into a tagged cell
::       representation `+$json` using `++dejs:html`.
::    2. Then the parsed JSON is sent through a custom-built reparser to
::       retrieve particular values.
::
::  This file implements the second processing step: The reparser.
::
/-  *tahuti
=<
|%
++  ex-to-js
  |=  ex=ex
  ^-  json
  %-  pairs:enjs:format
  :~
    :-  'payer'     [%s (scot %p payer.ex)]
    :-  'amount'    (numb:enjs:format amount.ex)
    :-  'involves'  (as-json-array involves.ex)
  ==
++  ex-from-js
  ^-  $-(json ex)
  %-  ot:dejs:format                                     :: obj as tuple
  :~
    :-  %payer     (se:dejs:format %p)                   :: str as aura (@p)
    :-  %amount    ni:dejs:format                        :: num as int
    :-  %involves  (ar:dejs:format (se:dejs:format %p))  :: arr as list
  ==
++  group-to-js
  |=  g=group
  ^-  json
  %-  pairs:enjs:format
  :~
    :-  'title'    [%s title.g]
    :-  'host'     [%s (scot %p host.g)]
    :-  'members'  (as-json-array ~(tap in members.g))
    :-  'acl'      (as-json-array ~(tap in acl.g))
  ==
++  group-from-js
  ^-  $-(json group)
  %-  ot:dejs:format                                     :: obj as tuple
  :~
    :-  %title    so:dejs:format
    :-  %host     (se:dejs:format %p)
    :-  %members  (as:dejs:format (se:dejs:format %p))   :: arr as set
    :-  %acl      (as:dejs:format (se:dejs:format %p))
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
