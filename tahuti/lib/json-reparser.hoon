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
    ++  members
      |=  m=^members
      ^-  json
      [%a (turn ~(tap in m) ship:enjs)]
    ++  group
    |=  g=^group
    ^-  json
    %-  pairs:enjs:format
    :~
      :-  'gid'     [%s gid.g]
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
    |=  ex=ex
    ^-  json
    %-  pairs:enjs:format
    :~
      :-  'payer'     [%s (scot %p payer.ex)]
      :-  'amount'    (numb:enjs:format amount.ex)
      :-  'involves'  [%a (turn involves.ex ship:enjs)]
    ==
  --
::
++  dejs
  |%
  ++  member
    ^-  $-(json @p)
    (se:dejs:format %p)
  ++  group
    ^-  $-(json ^group)
    %-  ot:dejs:format                                     :: obj as tuple
    :~
      :-  %gid      so:dejs:format
      :-  %title    so:dejs:format
      :-  %host     (se:dejs:format %p)
    ==
  ++  expense
    ^-  $-(json ex)
    %-  ot:dejs:format                                     :: obj as tuple
    :~
      :-  %payer     (se:dejs:format %p)                   :: str as aura (@p)
      :-  %amount    ni:dejs:format                        :: num as int
      :-  %involves  (ar:dejs:format (se:dejs:format %p))  :: arr as list
    ==
  --
--
