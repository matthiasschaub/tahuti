/-  *tahuti
/+  dbug
/+  verb
/+  default-agent
/+  server         :: HTTP request processing
/+  schooner       :: HTTP response handling
/+  *json-reparser
::
::  types
::
|%
+$  card  card:agent:gall
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 ~]
--
::
::  state
::
=|  state-0
=*  state  -
::
::  debug wrap
::
%+  verb  %.n
%-  agent:dbug
::
::  agent core
::
^-  agent:gall
|_  =bowl:gall
+*  this  .
    default  ~(. (default-agent this %.n) bowl)
::
++  on-init
  ~&  >  '%tahuti-api: initialize'
  ^-  [(list card) $_(this)]
  :-  ^-  (list card)
    :~
      :*  %pass  /eyre/connect  %arvo  %e
          %connect  `/apps/tahuti/api  %tahuti-api
      ==
    ==
  this
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  old=vase
  ^-  [(list card) $_(this)]
  :-  ^-  (list card)
      ~
  %=  this
    state  !<(state-0 old)
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  [(list card) $_(this)]
  |^
  ?+  mark  (on-poke:default mark vase)
    ::
      %handle-http-request
    ~&  >  '%tahuti-api: handle http request'
    ?>  =(src.bowl our.bowl)
    =^  cards  state
      (handle-http !<([@ta =inbound-request:eyre] vase))
    [cards this]
  ==
  ++  handle-http
    ::  TODO: add HTTP response card to state and listen (on-arvo)
    ::  for OK from %tahuti. Then send out the HTTP response card.
    ::
    |=  [eyre-id=@ta =inbound-request:eyre]
    ^-  [(list card) $_(state)]
    =/  ,request-line:server
      (parse-request-line:server url.request.inbound-request)
    =/  send  (cury response:schooner eyre-id)
    ::
    ?.  authenticated.inbound-request
      [(send [302 ~ [%login-redirect './apps/tahuti']]) state]
    ?+  method.request.inbound-request
      [(send [405 ~ [%plain "405 - Method Not Allowed"]]) state]
      ::
        %'GET'
      ?+  site
        [(send [404 ~ [%plain "404 - Not Found"]]) state]
        ::
          [%apps %tahuti %api %groups ~]
        =/  path      /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/groups/noun
        =/  groups    .^(groups %gx path)
        =/  response  (groups:enjs groups)
        [(send [200 ~ [%json response]]) state]
        ::
          [%apps %tahuti %api %groups @t ~]
        =/  id       (snag 4 `(list @t)`site)
        =/  path      /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/groups/noun
        =/  groups    .^(groups %gx path)
        =/  group     (need (~(get by groups) id))
        =/  response  (group:enjs group)
        [(send [200 ~ [%json response]]) state]
        ::
          [%apps %tahuti %api %groups @t %register ~]
        =/  id       (snag 4 `(list @t)`site)
        =/  path      /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/regs/noun
        =/  regs      .^(regs %gx path)
        =/  reg       (~(got by regs) id)
        =/  response  (ships:enjs reg)
        [(send [200 ~ [%json response]]) state]
        ::
          [%apps %tahuti %api %groups @t %invitees ~]
        =/  id       (snag 4 `(list @t)`site)
        =/  path      /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/acls/noun
        =/  acls      .^(acls %gx path)
        =/  acl       (need (~(get by acls) id))
        =.  path      /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/regs/noun
        =/  regs      .^(regs %gx path)
        =/  reg       (~(got by regs) id)
        =/  invitees  (~(dif in acl) reg)
        =/  response  (ships:enjs invitees)
        [(send [200 ~ [%json response]]) state]
        ::
          [%apps %tahuti %api %groups @t %expenses ~]
        =/  id       (snag 4 `(list @t)`site)
        =/  path      /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/leds/noun
        =/  leds      .^(leds %gx path)
        =/  led       (~(got by leds) id)
        =/  response  (ledger:enjs led)
        [(send [200 ~ [%json response]]) state]
      ==
      ::
        %'PUT'
      ?~  body.request.inbound-request
        [(send [418 ~ [%plain "418 - I'm a teapot"]]) state]
      ?+  site
        [(send [418 ~ [%plain "418 - I'm a teapot"]]) state]
        ::
          [%apps %tahuti %api %groups ~]
        =/  content   (need (de:json:html q.u.body.request.inbound-request))
        =/  group     (group:dejs content)
        =/  action    [%add-group group]
        =/  response  (send [200 ~ [%plain "ok"]])
        :-  ^-  (list card)
          %+  snoc
            response
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
        ::
          [%apps %tahuti %api %groups @t %invitees ~]
        =/  id       (snag 4 `(list @t)`site)
        =/  content   (need (de:json:html q.u.body.request.inbound-request))
        =/  invitee   (invitee:dejs content)
        =/  action    [%invite id invitee]
        =/  response  (send [200 ~ [%plain "ok"]])
        :-  ^-  (list card)
          %+  snoc
            response
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
        ::
          [%apps %tahuti %api %groups @t %expenses ~]
        ~&  >  '%tahuti-api: add expense'
        =/  content   (need (de:json:html q.u.body.request.inbound-request))
        =/  id       (snag 4 `(list @t)`site)
        =/  expense   (expense:dejs content)
        =/  action    [%add-expense id expense]
        =/  response  (send [200 ~ [%plain "ok"]])
        :-  ^-  (list card)
          %+  snoc
            response
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
      ==
      ::
        %'POST'
      ?~  body.request.inbound-request
        [(send [418 ~ [%plain "418 - I'm a teapot"]]) state]
      ?+  site
        [(send [418 ~ [%plain "418 - I'm a teapot"]]) state]
        ::
          [%apps %tahuti %api %action %join ~]
        =/  content   (need (de:json:html q.u.body.request.inbound-request))
        =/  group     (group:dejs content)
        =/  action    [%join id.group host.group]
        =/  response  (send [200 ~ [%plain "ok"]])
        :-  ^-  (list card)
          %+  snoc
            response
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
      ==
    ==
  --
++  on-arvo  on-arvo:default
  :: |=  [=wire =sign-arvo]
  :: ^-  [(list card) $_(this)]
  :: ?.  ?=([%bind ~] wire)
  ::   (on-arvo:default [wire sign-arvo])
  :: ?.  ?=([%eyre %bound *] sign-arvo)
  ::   (on-arvo:default [wire sign-arvo])
  :: ~?  !accepted.sign-arvo                 :: error if not accepted
  ::   %eyre-rejected-tahuti-binding
  :: :-  ^-  (list card)
  ::     ~
  :: this
++  on-watch                          :: subscribe
  |=  =path
  ^-  [(list card) $_(this)]
  ?+    path  (on-watch:default path)
    ::
      [%http-response *]
    [~ this]
  ==
::
++  on-leave  on-leave:default
++  on-peek  on-peek:default
++  on-agent  on-agent:default
++  on-fail  on-fail:default
--
