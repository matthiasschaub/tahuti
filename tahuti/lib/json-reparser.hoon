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
      ^-  json
      [%s v]
    ++  ship
      |=  s=@p
      ^-  json
      [%s (scot %p s)]
    ++  ships
      |=  s=(set @p)
      ^-  json
      [%a (turn ~(tap in s) ship:enjs)]
    ++  member
      |=  m=^member
      ^-  json
      [%s m]
    ++  members
      |=  m=(set ^member)
      ^-  json
      [%a (turn ~(tap in m) member:enjs)]
    ++  group
      |=  g=^group
      ^-  json
      %-  pairs:enjs:format
      :~
        :-  'gid'       [%s gid.g]
        :-  'title'     [%s title.g]
        :-  'host'      [%s (scot %p host.g)]
        :-  'currency'  [%s currency.g]
        :-  'public'    [%b public.g]
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
        :-  'payer'     [%s payer.e]
        :-  'date'      (sect:enjs:format date.e)
        :-  'involves'  [%a (turn involves.e member:enjs)]
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
      |=  [member=@tas amount=@s]
      =/  [syn=? abs=@]  (old:si amount)
      =/  fmt  ?.(syn "-{<abs>}" "{<abs>}")
      %-  pairs:enjs:format
      :~
        :-  'member'  [%s member]
        :-  'amount'  [%s (crip fmt)]
      ==
    ++  rei
      ::  turn reimbursements map of map into list
      ::
      |=  r=^rei
      ^-  json
      :-  %a
      %+  turn
        %+  skip
          ~(tap bi:mip r)
        |=  [debitor=@tas creditor=@tas amount=@ud]
        =(amount 0)
      |=  [debitor=@tas creditor=@tas amount=@ud]
      %-  pairs:enjs:format
      :~
        :-  'debitor'   [%s debitor]
        :-  'creditor'  [%s creditor]
        :-  'amount'    (numb:enjs:format amount)
      ==
    --
::
++  dejs
  |%
  ++  member
    ^-  $-(json member=^member)
    %-  ot:dejs:format
    :~
      :-  %member    so:dejs:format
    ==
  ++  invitee
    ^-  $-(json invitee=@p)
    %-  ot:dejs:format
    :~
      :-  %invitee   (se:dejs:format %p)
    ==
  ++  ship
    ^-  $-(json @p)
    %-  ot:dejs:format
    :~
      :-  %ship      (se:dejs:format %p)
    ==
  ++  join
    ^-  $-(json [gid=@tas host=@p])
    %-  ot:dejs:format
    :~
      :-  %gid       so:dejs:format
      :-  %host      (se:dejs:format %p)
    ==
  ++  group
    ::  input same as group but without host
    ::
    ^-  $-(json [=gid =title =currency =public])
    %-  ot:dejs:format
    :~
      :-  %gid       so:dejs:format
      :-  %title     so:dejs:format
      :-  %currency  so:dejs:format
      :-  %public    bo:dejs:format
    ==
  ++  expense
    ^-  $-(json ^expense)
    %-  ot:dejs:format
    :~
      :-  %gid       so:dejs:format
      :-  %eid       so:dejs:format
      :-  %title     so:dejs:format
      :-  %amount    (su:dejs:format dem)
      :-  %currency  so:dejs:format
      :-  %payer     so:dejs:format
      :-  %date      du:dejs:format
      :-  %involves  (ar:dejs:format so:dejs:format):dejs:format
    ==
  --
--
