/-  *tahuti
/+  dbug
/+  verb
/+  default-agent
/+  server         :: HTTP request processing
/+  schooner       :: HTTP response handling
/+  *json-reparser
::  types
::
|%
+$  card  card:agent:gall
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 ~]
--
=|  state-0
=*  state  -
::  debug wrap
::
:: %+  verb  %.n
%-  agent:dbug
::  agent core
::
^-  agent:gall
|_  =bowl:gall
+*  this  .
    default  ~(. (default-agent this %.n) bowl)
::
++  on-init
  ^-  [(list card) $_(this)]
  ~&  >  '%tahuti-api: initialize'
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
      ~&  >  '%tahuti-api: GET'
      ?+  site
        [(send [404 ~ [%plain "404 - Not Found"]]) state]
        ::
          [%apps %tahuti %api %version ~]
        [(send [200 ~ [%json (version:enjs '2024-02-09')]]) state]
        ::
          [%apps %tahuti %api %our ~]
        [(send [200 ~ [%json (ship:enjs our.bowl)]]) state]
        ::
          [%apps %tahuti %api %invites ~]
        =/  path      /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/invites/noun
        =/  invites   .^(invites %gx path)
        =/  response  (groups:enjs invites)
        [(send [200 ~ [%json response]]) state]
        ::
          [%apps %tahuti %api %groups ~]
        =/  path      /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/groups/noun
        =/  groups    .^(groups %gx path)
        =/  response  (groups:enjs groups)
        [(send [200 ~ [%json response]]) state]
        ::
          [%apps %tahuti %api %groups @t ~]
        =/  gid       (snag 4 `(list @t)`site)
        =/  path      /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/[gid]/noun
        =,  .^([=group =acl =reg =led] %gx path)
        =/  response  (group:enjs group)
        [(send [200 ~ [%json response]]) state]
        ::
          [%apps %tahuti %api %groups @t %expenses @t ~]
        =/  gid       (snag 4 `(list @t)`site)
        =/  eid       (snag 6 `(list @t)`site)
        =/  path  /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/[gid]/noun
        =,  .^([=group =acl =reg =led] %gx path)
        =/  expense   (~(got by led) eid)
        =/  response  (expense:enjs expense)
        [(send [200 ~ [%json response]]) state]
        ::
          [%apps %tahuti %api %groups @t @t ~]
        ::  get state of a group
        =/  gid       (snag 4 `(list @t)`site)
        =/  endpoint  (snag 5 `(list @t)`site)
        =/  path  /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/[gid]/noun
        =,  .^([=group =acl =reg =led] %gx path)
        ?+  endpoint
          [(send [404 ~ [%plain "404 - Not Found"]]) state]
          ::
            %members
          =/  members   (~(int in reg) acl)
          =.  members   (~(put in members) host.group)
          =/  response  (ships:enjs members)
          [(send [200 ~ [%json response]]) state]
          ::
            %castoffs
          =/  members   (~(put in reg) host.group)
          =/  castoff   (~(int in members) acl)
          =/  response  (ships:enjs castoff)
          [(send [200 ~ [%json response]]) state]
            ::
            %invitees
          =/  invitees  (~(dif in acl) reg)
          =/  response  (ships:enjs invitees)
          [(send [200 ~ [%json response]]) state]
          ::
            %expenses
          =/  vals      ~(val by led)
          =.  vals      (sort vals |=([a=expense b=expense] (gth date.a date.b)))
          =/  response  (ledger:enjs vals)
          [(send [200 ~ [%json response]]) state]
          ::
            %balances
          =/  path  /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/[gid]/net/noun
          =/  net   .^(net %gx path)
          =/  resp  (net:enjs net)
          [(send [200 ~ [%json resp]]) state]
            %reimbursements
          =/  path  /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/[gid]/rei/noun
          =/  rei   .^(rei %gx path)
          =/  res   (rei:enjs rei)
          [(send [200 ~ [%json res]]) state]
        ==
      ==
      ::
        %'PUT'
      ~&  >  '%tahuti-api: PUT'
      ?~  body.request.inbound-request
        [(send [418 ~ [%plain "418 - I'm a teapot"]]) state]
      ?+  site
        [(send [418 ~ [%plain "418 - I'm a teapot"]]) state]
        ::
          [%apps %tahuti %api %groups ~]
        =/  content   (need (de:json:html q.u.body.request.inbound-request))
        =,  (group:dejs content)
        =/  action    [%add-group [gid title host=our.bowl currency]]
        =/  response  (send [200 ~ [%plain "ok"]])
        :-  ^-  (list card)
          %+  snoc
            response
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
        ::
          [%apps %tahuti %api %groups @t %invitees ~]
        =/  gid       (snag 4 `(list @t)`site)
        =/  content   (need (de:json:html q.u.body.request.inbound-request))
        =/  invitee   (invitee:dejs content)
        =/  action    [%allow gid invitee]
        =/  response  (send [200 ~ [%plain "ok"]])
        :-  ^-  (list card)
          %+  snoc
            response
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
        ::
          [%apps %tahuti %api %groups @t %kick ~]
        =/  gid       (snag 4 `(list @t)`site)
        =/  content   (need (de:json:html q.u.body.request.inbound-request))
        =/  p         (ship:dejs content)
        =/  action    [%kick gid p]
        =/  response  (send [200 ~ [%plain "ok"]])
        :-  ^-  (list card)
          %+  snoc
            response
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
        ::
          [%apps %tahuti %api %groups @t %expenses ~]
        =/  gid       (snag 4 `(list @t)`site)
        =/  content   (need (de:json:html q.u.body.request.inbound-request))
        =/  expense   (expense:dejs content)
        =/  action    [%add-expense gid expense]
        =/  response  (send [200 ~ [%plain "ok"]])
        :-  ^-  (list card)
          %+  snoc
            response
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
      ==
      ::
        %'DELETE'
      ~&  >  '%tahuti-api: DELETE'
      ?+  site
        [(send [418 ~ [%plain "418 - I'm a teapot"]]) state]
        ::
          [%apps %tahuti %api %groups @t ~]
        =/  gid        (snag 4 `(list @t)`site)
        =/  action    [%del-group gid]
        =/  response  (send [200 ~ [%plain "ok"]])
        :-  ^-  (list card)
          %+  snoc
            response
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
      ::
          [%apps %tahuti %api %groups @t %expenses @t ~]
        ~&  >  '%tahuti-api: DELETE /expenses/{eid}'
        =/  gid       (snag 4 `(list @t)`site)
        =/  eid       (snag 6 `(list @t)`site)
        =/  action    [%del-expense gid eid]
        =/  response  (send [200 ~ [%plain "ok"]])
        :-  ^-  (list card)
          %+  snoc
            response
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
      ==
      ::
        %'POST'
      ~&  >  '%tahuti-api: POST'
      ?~  body.request.inbound-request
        [(send [418 ~ [%plain "418 - I'm a teapot"]]) state]
      ?+  site
        [(send [418 ~ [%plain "418 - I'm a teapot"]]) state]
        ::
          [%apps %tahuti %api %action %join ~]
        ~&  >  '%tahuti-api: /action/join'
        =/  content   (need (de:json:html q.u.body.request.inbound-request))
        =/  join      (join:dejs content)
        =/  action    [%join gid.join host.join]
        =/  response  (send [200 ~ [%plain "ok"]])
        :-  ^-  (list card)
          %+  snoc
            response
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
      ==
    ==
  --
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  [(list card) $_(this)]
  ?.  ?=([%bind ~] wire)
    (on-arvo:default [wire sign-arvo])
  ?.  ?=([%eyre %bound *] sign-arvo)
    (on-arvo:default [wire sign-arvo])
  :: error if not accepted
  ::
  ~?  !accepted.sign-arvo
    %eyre-rejected-tahuti-api-binding
  :-  ^-  (list card)
      ~
  this
++  on-watch
  |=  =path
  ^-  [(list card) $_(this)]
  ?+    path  (on-watch:default path)
      [%http-response *]
    [~ this]
  ==
::
++  on-leave  on-leave:default
++  on-peek  on-peek:default
++  on-agent  on-agent:default
++  on-fail  on-fail:default
--
