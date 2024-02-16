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
%+  verb   %.n
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
    =^  cards  state
      (handle-http !<([@ta =inbound-request:eyre] vase))
    [cards this]
  ==
  ++  handle-http
    |=  [eyre-id=@ta =inbound-request:eyre]
    ^-  [(list card) $_(state)]
    =/  request-line
      (parse-request-line:server url.request.inbound-request)
    =+  site=site.request-line
    =+  send=(cury response:schooner eyre-id)
    =+  auth=authenticated.inbound-request
    =/  public=?
        ?:  (gte (lent site) 5)
          =/  gid   (snag 4 site)
          =/  path  /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/[gid]/noun
          =,  .^([=group =acl =reg =led] %gx path)
          public.group
        %.n
    ?.  ?|(auth public)
      [(send [401 ~ [%plain "401 - Unauthorized"]]) state]
    ?+  method.request.inbound-request
      [(send [405 ~ [%plain "405 - Method Not Allowed"]]) state]
      ::
        %'GET'
      ~&  >  '%tahuti-api: GET'
      ?+  site  [(send [404 ~ [%plain "404 - Not Found"]]) state]
        ::
          [%apps %tahuti %api @t ~]
        =/  endpoint  (snag 3 `(list @t)`site)
        ?+  endpoint  [(send [404 ~ [%plain "404 - Not Found"]]) state]
          ::
            %invites
          =/  path      /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/invites/noun
          =/  invites   .^(invites %gx path)
          [(send [200 ~ [%json (groups:enjs invites)]]) state]
          ::
            %groups
          ?.  auth
            [(send [401 ~ [%plain "401 - Unauthorized"]]) state]
          =/  path      /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/groups/noun
          =/  groups    .^(groups %gx path)
          [(send [200 ~ [%json (groups:enjs groups)]]) state]
        ==
        ::
          [%apps %tahuti %api %groups @t ~]
        =/  gid       (snag 4 `(list @t)`site)
        =/  path  /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/[gid]/noun
        =,  .^([=group =acl =reg =led] %gx path)
        [(send [200 ~ [%json (group:enjs group)]]) state]
        ::
          [%apps %tahuti %api %groups @t @t ~]
        ::  get state of a group
        =/  gid       (snag 4 `(list @t)`site)
        =/  path  /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/[gid]/noun
        =/  endpoint  (snag 5 `(list @t)`site)
        =,  .^([=group =acl =reg =led] %gx path)
        ?+  endpoint
          [(send [404 ~ [%plain "404 - Not Found"]]) state]
          ::
            %version
          [(send [200 ~ [%json (version:enjs '2024-02-16.1')]]) state]
          ::
            %members
          =/  members   (~(int in reg) acl)
          =.  members   (~(put in members) host.group)
          [(send [200 ~ [%json (ships:enjs members)]]) state]
          ::
            %castoffs
          =/  members   (~(put in reg) host.group)
          =/  castoff   (~(int in members) acl)
          [(send [200 ~ [%json (ships:enjs castoff)]]) state]
            ::
            %invitees
          =/  invitees  (~(dif in acl) reg)
          [(send [200 ~ [%json (ships:enjs invitees)]]) state]
          ::
            %expenses
          =/  val       ~(val by led)
          =/  sorted    (sort val |=([a=expense b=expense] (gth date.a date.b)))
          [(send [200 ~ [%json (ledger:enjs sorted)]]) state]
          ::
            %balances
          =/  path  /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/[gid]/net/noun
          =/  net   .^(net %gx path)
          [(send [200 ~ [%json (net:enjs net)]]) state]
            %reimbursements
          =/  path  /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/[gid]/rei/noun
          =/  rei   .^(rei %gx path)
          [(send [200 ~ [%json (rei:enjs rei)]]) state]
        ==
        ::
          [%apps %tahuti %api %groups @t %expenses @t ~]
        =/  gid       (snag 4 `(list @t)`site)
        =/  eid       (snag 6 `(list @t)`site)
        =/  path  /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/[gid]/noun
        =,  .^([=group =acl =reg =led] %gx path)
        =/  expense   (~(got by led) eid)
        [(send [200 ~ [%json (expense:enjs expense)]]) state]
      ==
      ::
        %'PUT'
      ~&  >  '%tahuti-api: PUT'
      ?~  body.request.inbound-request
        [(send [418 ~ [%plain "418 - I'm a teapot"]]) state]
      ?+  site  [(send [404 ~ [%plain "404 - Not Found"]]) state]
        ::
          [%apps %tahuti %api %groups ~]
        ?.  auth
          [(send [401 ~ [%plain "401 - Unauthorized"]]) state]
        =/  content   (need (de:json:html q.u.body.request.inbound-request))
        =,  (group:dejs content)
        =/  action    [%add-group [gid title host=our.bowl currency public]]
        :-  ^-  (list card)
          %+  snoc
            (send [200 ~ [%plain "ok"]])
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
        ::
          [%apps %tahuti %api %groups @t %invitees ~]
        ?.  auth
          [(send [401 ~ [%plain "401 - Unauthorized"]]) state]
        =/  gid       (snag 4 `(list @t)`site)
        =/  content   (need (de:json:html q.u.body.request.inbound-request))
        =/  invitee   (invitee:dejs content)
        =/  action    [%allow gid invitee]
        :-  ^-  (list card)
          %+  snoc
            (send [200 ~ [%plain "ok"]])
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
        ::
          [%apps %tahuti %api %groups @t %kick ~]
        ?.  auth
          [(send [401 ~ [%plain "401 - Unauthorized"]]) state]
        =/  gid       (snag 4 `(list @t)`site)
        =/  content   (need (de:json:html q.u.body.request.inbound-request))
        =/  p         (ship:dejs content)
        =/  action    [%kick gid p]
        :-  ^-  (list card)
          %+  snoc
            (send [200 ~ [%plain "ok"]])
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
        ::
          [%apps %tahuti %api %groups @t %expenses ~]
        =/  gid       (snag 4 `(list @t)`site)
        =/  content   (need (de:json:html q.u.body.request.inbound-request))
        =/  expense   (expense:dejs content)
        =/  action    [%add-expense gid expense]
        :-  ^-  (list card)
          %+  snoc
            (send [200 ~ [%plain "ok"]])
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
      ==
      ::
        %'DELETE'
      ~&  >  '%tahuti-api: DELETE'
      ?+  site  [(send [404 ~ [%plain "404 - Not Found"]]) state]
        ::
          [%apps %tahuti %api %groups @t ~]
        =/  gid        (snag 4 `(list @t)`site)
        =/  path  /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/[gid]/noun
        =,  .^([=group =acl =reg =led] %gx path)
        ?.  auth
          [(send [401 ~ [%plain "Unauthorized"]]) state]
        ?.  =(our.bowl host.group)
          [(send [403 ~ [%plain "Forbidden"]]) state]
        =/  action    [%del-group gid]
        :-  ^-  (list card)
          %+  snoc
            (send [200 ~ [%plain "ok"]])
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
      ::
          [%apps %tahuti %api %groups @t %expenses @t ~]
        ~&  >  '%tahuti-api: DELETE /expenses/{eid}'
        =/  gid       (snag 4 `(list @t)`site)
        =/  eid       (snag 6 `(list @t)`site)
        =/  action    [%del-expense gid eid]
        :-  ^-  (list card)
          %+  snoc
            (send [200 ~ [%plain "ok"]])
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
      ==
      ::
        %'POST'
      ~&  >  '%tahuti-api: POST'
      ?~  body.request.inbound-request
        [(send [418 ~ [%plain "418 - I'm a teapot"]]) state]
      ?+  site  [(send [404 ~ [%plain "404 - Not Found"]]) state]
        ::
          [%apps %tahuti %api %join ~]
        ?.  auth
          [(send [401 ~ [%plain "401 - Unauthorized"]]) state]
        ~&  >  '%tahuti-api: /action/join'
        =/  content   (need (de:json:html q.u.body.request.inbound-request))
        =/  join      (join:dejs content)
        =/  action    [%join gid.join host.join]
        :-  ^-  (list card)
          %+  snoc
            (send [200 ~ [%plain "ok"]])
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
