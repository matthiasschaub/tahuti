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
    ++  version
      |=  v=@t
      ^-  (pair %s @t)
      [%s v]
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
        :-  'gid'       [%s gid.g]
        :-  'title'     [%s title.g]
        :-  'host'      [%s (scot %p host.g)]
        :-  'currency'  [%s currency.g]
      ==
    ::  (groups as json array)
    ::
    ++  groups
      ::  turn map of groups into list
      ::
      |=  g=^groups
      ^-  json
      [%a (turn ~(val by g) group:enjs)]
    ++  expense
      |=  e=^expense
      ^-  json
      %-  pairs:enjs:format
      :~
        :-  'gid'       [%s gid.e]
        :-  'eid'       [%s eid.e]
        :-  'title'     [%s title.e]
        :-  'amount'    (numb:enjs:format amount.e)
        :-  'currency'  [%s currency.e]
        ::  TODO
        ::  :-  'currency-format' ...
        :-  'payer'     [%s (scot %p payer.e)]
        :-  'date'      (sect:enjs:format date.e)
        ::  TODO.
        ::  :-  'date-format'  (dust:chrono:userlib (yore date.e))
        :-  'involves'  [%a (turn involves.e ship:enjs)]
      ==
    ++  ledger
      |=  vals=(list ^expense)
      ^-  json
      [%a (turn vals expense:enjs)]
    ::  (net amounts as json array)
    ::
    ++  net
      ::  turn net amounts map into list
      ::
      |=  n=^net
      ^-  json
      :-  %a
      %+  turn  ~(tap by n)
      |=  [member=@p amount=@s]
      =/  [syn=? abs=@]  (old:si amount)
      =/  fmt  ?.(syn "-{<abs>}" "{<abs>}")
      %-  pairs:enjs:format
      :~
        :-  'member'  [%s (scot %p member)]
        :-  'amount'  [%s (crip fmt)]
      ==
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
      :-  %invitee    (se:dejs:format %p)
    ==
  ++  join
    ^-  $-(json [gid=@tas host=@p])
    %-  ot:dejs:format
    :~
      :-  %gid        so:dejs:format
      :-  %host       (se:dejs:format %p)
    ==
  ++  group
    ::  input same as group but without host
    ::
    ^-  $-(json [=gid =title =currency])
    %-  ot:dejs:format                                     :: obj as tuplejsonre
    :~
      :-  %gid        so:dejs:format
      :-  %title      so:dejs:format
      :-  %currency   so:dejs:format
    ==
  ++  expense
    ^-  $-(json ^expense)
    %-  ot:dejs:format                                     :: obj as tuple
    :~
      :-  %gid        so:dejs:format
      :-  %eid        so:dejs:format
      :-  %title      so:dejs:format
      :-  %amount     (su:dejs:format dem)
      :-  %currency   so:dejs:format
      :-  %payer      (se:dejs:format %p)
      :-  %date       du:dejs:format
      :-  %involves   (ar:dejs:format (se:dejs:format %p)):dejs:format
    ==
  --
--
