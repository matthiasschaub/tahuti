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
|%
++  enjs
  |%
    ++  ship
      |=  s=@p
      ^-  (pair %s @t)
      [%s (scot %p s)]
    ++  ships
      |=  s=(set @p)
      ^-  json
      [%a (turn ~(tap in s) ship:enjs)]
    ++  group
    |=  g=^group
    ^-  json
    %-  pairs:enjs:format
    :~
      :-  'id'       [%s id.g]
      :-  'title'    [%s title.g]
      :-  'host'     [%s (scot %p host.g)]
    ==
    ::  (a list of groups, not a map of groups, to json array)
    ::
  ++  groups
    |=  g=^groups
    ^-  json
    [%a (turn ~(val by g) group:enjs)]
  ++  expense
    |=  e=^expense
    ^-  json
    %-  pairs:enjs:format
    :~
      :-  'id'        [%s id.e]
      :-  'title'     [%s title.e]
      :-  'amount'    (numb:enjs:format amount.e)
      :-  'currency'  [%s currency.e]
      :-  'payer'     [%s (scot %p payer.e)]
      :: :-  'date'     [%s (scot %p payer.e)]
      :: :-  'involves'  [%a (turn involves.ex ship:enjs)]
    ==
  ++  ledger
    |=  l=^ledger
    ^-  json
    [%a (turn ~(val by l) expense:enjs)]
  --
::
++  dejs
  |%
  ++  ship
    ^-  $-(json @p)
    (se:dejs:format %p)
  ++  invitee
    ^-  $-(json invitee=@p)
    %-  ot:dejs:format                                     :: obj as tuplejsonre
    :~
      :-  %invitee  (se:dejs:format %p)
    ==
  ++  group
    ^-  $-(json ^group)
    %-  ot:dejs:format                                     :: obj as tuplejsonre
    :~
      :-  %id        so:dejs:format
      :-  %title     so:dejs:format
      :-  %host      (se:dejs:format %p)
    ==
  ++  expense
    ^-  $-(json ^expense)
    %-  ot:dejs:format                                     :: obj as tuple
    :~
      :-  %id        so:dejs:format
      :-  %title     so:dejs:format
      :-  %amount    (su:dejs:format dem)
      :-  %currency  so:dejs:format
      :-  %payer     (se:dejs:format %p)
      :: :-  %date      so:dejs:format
      :: :-  %involves  (ar:dejs:format (se:dejs:format %p))  :: arr as list
    ==
  --
--
