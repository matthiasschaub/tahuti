/-  *tahuti
/+  dbug           :: debug wrapper for agent
/+  default-agent  :: agent arm defaults
/+  server         :: HTTP request processing
/+  schooner       :: HTTP response handling
/+  *json-reparser
::
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 ~]
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-0    :: bunt value with name
=*  state  -   :: refer to state 0
^-  agent:gall
|_  =bowl:gall
+*  this  .
    default  ~(. (default-agent this %.n) bowl)
::
++  on-init
  ^-  [(list card) $_(this)]
  ~&  >  '%tahuti-api: initialized successfully'
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
++  on-poke                                ::  one-off action
  |=  [=mark =vase]
  ^-  [(list card) $_(this)]               ::  messages and new state
  |^
  ?+  mark  (on-poke:default mark vase)
    ::
      %handle-http-request
    ~&  >  '%tahuti-api: handle http request'
    ?>  =(src.bowl our.bowl)             ::  allow only requests from our ship
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
    ?.  authenticated.inbound-request
      [(send [302 ~ [%login-redirect './apps/tahuti']]) state]
    ?+  method.request.inbound-request
      [(send [405 ~ [%plain "405 - Method Not Allowed"]]) state]
      ::
        %'PUT'
      ?~  body.request.inbound-request
        [(send [418 ~ [%plain "418 - I'm a teapot"]]) state]
      ?+  site
        [(send [418 ~ [%plain "418 - I'm a teapot"]]) state]
        ::
          [%apps %tahuti %api %groups @t ~]
        =/  content   (need (de-json:html q.u.body.request.inbound-request))
        =/  group     (group-from-js content)
        =/  gid       `@tas`(rear `(list @t)`site)
        =/  act       [%add-group [gid group]]
        =/  response  (send [200 ~ [%plain "ok"]])
        :-  ^-  (list card)
          %+  snoc
            response
          [%pass /add %agent [our.bowl %tahuti] %poke %tahuti-action !>(act)]
        state
        ::
          [%apps %tahuti %api %groups @t %expenses @t ~]
        =/  content   (need (de-json:html q.u.body.request.inbound-request))
        =/  gid       (snag 4 `(list @t)`site)
        =/  eid       (rear `(list @t)`site)
        =/  response  (pairs:enjs:format [[eid content] ~])
        [(send [200 ~ [%json response]]) state]
      ==
      ::
        %'GET'
      ?+  site
        [(send [404 ~ [%plain "404 - Not Found"]]) state]
        ::
          [%apps %tahuti %api %groups ~]
        =/  path      /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/groups/noun
        =/  groups    .^(groups %gx path)
        =/  response  (groups-to-js groups)
        [(send [200 ~ [%json response]]) state]
      ==
    ==
  --
++  on-arvo  on-arvo:default
++  on-watch                          :: subscribe
  |=  =path
  ^-  [(list card) $_(this)]
  ?+    path  (on-watch:default path)
    ::
      [%http-response *]
    [~ this]
  ==
::
++  on-leave  on-leave:default        :: unsubscribe
++  on-peek  on-peek:default          :: one-off read-only action (scry)
++  on-agent  on-agent:default
++  on-fail  on-fail:default
--
