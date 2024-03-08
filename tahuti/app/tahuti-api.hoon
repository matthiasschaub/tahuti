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
          [(send [200 ~ [%json (version:enjs '2024-03-08.1')]]) state]
          ::
            %members
          ::  FIX: does not work due to reg containing non Urbit-ID
          ::    members which get filtered out when comparing against
          ::    acl
          ::
          =/  regmod    `(set @tas)`(silt (skim ~(tap in reg) |=(m=member ?~(`(unit @p)`(slaw %p `@t`m) %.n %.y))))
          =/  aclmod    `(set @tas)`(~(run in acl) |=(=@p `@tas`(scot %p p)))
          =/  castoffs  (~(dif in regmod) aclmod)
          =/  members   (~(dif in reg) castoffs)
          =.  members   (~(put in members) `@tas`(scot %p host.group))
          [(send [200 ~ [%json (members:enjs members)]]) state]
          ::
            %castoffs
          =/  regmod    `(set @tas)`(silt (skim ~(tap in reg) |=(m=member ?~(`(unit @p)`(slaw %p `@t`m) %.n %.y))))
          =/  aclmod    `(set @tas)`(~(run in acl) |=(=@p `@tas`(scot %p `@t`p)))
          =/  castoffs   (~(dif in regmod) aclmod)
          [(send [200 ~ [%json (members:enjs castoffs)]]) state]
            ::
            %invitees
          =/  aclmod    `(set @tas)`(~(run in acl) |=(=@p `@tas`(scot %p p)))
          =/  invitees  (~(dif in aclmod) reg)
          [(send [200 ~ [%json (members:enjs invitees)]]) state]
          ::
            %expenses
          =/  val       ~(val by led)
          =/  sorted    (sort val |=([a=expense b=expense] (gth date.a date.b)))
          [(send [200 ~ [%json (ledger:enjs sorted)]]) state]
          ::
            %balances
          =/  path  /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/[gid]/net/noun
          =/  net   .^(net %gx path)
          [(send [200 ~ [%json (net:enjs [net currency.group])]]) state]
            %reimbursements
          =/  path  /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/[gid]/rei/noun
          =/  rei   .^(rei %gx path)
          [(send [200 ~ [%json (rei:enjs [rei currency.group])]]) state]
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
        ?:  ?|
              .=(title '')
              .=(title ' ')
            ==
          [(send [422 ~ [%plain "422 - Unprocessable Entity"]]) state]
        :: ?<  (sane ...)
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
        =/  gid      (snag 4 `(list @t)`site)
        =/  content  (need (de:json:html q.u.body.request.inbound-request))
        =/  invitee  (invitee:dejs content)
        =/  action   [%allow gid invitee]
        :-  ^-  (list card)
          %+  snoc
            (send [200 ~ [%plain "ok"]])
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
        ::
          [%apps %tahuti %api %groups @t %members ~]
        ?.  ?&
              auth
              public
            ==
          [(send [401 ~ [%plain "401 - Unauthorized"]]) state]
        =/  gid      (snag 4 `(list @t)`site)
        =/  content  (need (de:json:html q.u.body.request.inbound-request))
        =/  member   (member:dejs content)
        ?:  ?|(=(member '') =(member ' '))
          [(send [422 ~ [%plain "422 - Unprocessable Entity"]]) state]
        =/  action  [%add-member gid member]
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
        ?:  ?|(=(title.expense '') =(title.expense ' '))
          [(send [422 ~ [%plain "422 - Unprocessable Entity"]]) state]
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
        ?.  auth
          [(send [401 ~ [%plain "401 - Unauthorized"]]) state]
        =/  gid        (snag 4 `(list @t)`site)
        =/  path  /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/[gid]/noun
        =,  .^([=group =acl =reg =led] %gx path)
        ?.  .=(our.bowl host.group)
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
        ?.  ?|
              auth
              public
            ==
          [(send [401 ~ [%plain "401 - Unauthorized"]]) state]
        =/  gid       (snag 4 `(list @t)`site)
        =/  eid       (snag 6 `(list @t)`site)
        =/  action    [%del-expense gid eid]
        :-  ^-  (list card)
          %+  snoc
            (send [200 ~ [%plain "ok"]])
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
      ::
          [%apps %tahuti %api %groups @t %invitees ~]
        ?.  auth
          [(send [401 ~ [%plain "401 - Unauthorized"]]) state]
        ?~  body.request.inbound-request
          [(send [418 ~ [%plain "418 - I'm a teapot"]]) state]
        =/  gid      (snag 4 `(list @t)`site)
        =/  content  (need (de:json:html q.u.body.request.inbound-request))
        =/  invitee  (invitee:dejs content)
        =/  action   [%kick gid invitee]
        :-  ^-  (list card)
          %+  snoc
            (send [200 ~ [%plain "ok"]])
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
          [%apps %tahuti %api %groups @t %members ~]
        ?~  body.request.inbound-request
          [(send [418 ~ [%plain "418 - I'm a teapot"]]) state]
        [(send [501 ~ [%plain "501 - Not Implemented"]]) state]
      ==
      ::
        %'POST'
      ~&  >  '%tahuti-api: POST'
      ?.  auth
        [(send [401 ~ [%plain "Unauthorized"]]) state]
      ?~  body.request.inbound-request
        [(send [418 ~ [%plain "418 - I'm a teapot"]]) state]
      ?+  site  [(send [404 ~ [%plain "404 - Not Found"]]) state]
        ::
          [%apps %tahuti %api %join ~]
        ~&  >  '%tahuti-api: POST /join'
        =,  (join:dejs (need (de:json:html q.u.body.request.inbound-request)))
        =/  action    [%join gid host]
        :-  ^-  (list card)
          %+  snoc
            (send [200 ~ [%plain "ok"]])
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
        ::
          [%apps %tahuti %api %leave ~]
        ~&  >  '%tahuti-api: POST /leave'
        =,  (leave:dejs (need (de:json:html q.u.body.request.inbound-request)))
        ?:  .=(our.bowl host)
          [(send [403 ~ [%plain "Forbidden: The group host is not allowed to leave the group."]]) state]
        =/  action   [%leave gid host]
        :-  ^-  (list card)
          %+  snoc
            (send [200 ~ [%plain "ok"]])
          [%pass ~ %agent [our.bowl %tahuti] %poke %tahuti-action !>(action)]
        state
        ::
          [%apps %tahuti %api %groups @t %kick ~]
        ~&  >  '%tahuti-api: POST /kick'
        =/  gid       (snag 4 `(list @t)`site)
        =/  path  /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/[gid]/noun
        =,  .^([=group =acl =reg =led] %gx path)
        ?.  .=(our.bowl host.group)
          [(send [403 ~ [%plain "Forbidden"]]) state]
        =/  content   (need (de:json:html q.u.body.request.inbound-request))
        =/  action    [%kick gid (ship:dejs content)]
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
