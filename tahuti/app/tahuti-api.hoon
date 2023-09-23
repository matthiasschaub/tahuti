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
^-  agent:gall
=|  state-0
=*  state  -
|_  =bowl:gall
+*  this  .
    default  ~(. (default-agent this %.n) bowl)
::
++  on-init
  ^-  [(list card) $_(this)]
  ~&  >  '%tahuti-api initialized successfully'
  :_  this
  :~
    :*  %pass  /eyre/connect  %arvo  %e
        %connect  `/apps/tahuti/api  %tahuti-api
    ==
  ==
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-state=vase
  ^-  [(list card) $_(this)]
  =/  old  !<(versioned-state old-state)
  ?-  -.old
    %0  [~ this(state old)]
  ==
::
++  on-poke  :: one-off action
  |=  [=mark =vase]
  ^-  [(list card) $_(this)]                  :: messages and new state
  |^
  ?+  mark
      (on-poke:default mark vase)
    %handle-http-request
      ~&  >  '%tahuti-api handle http request'
      ?>  =(src.bowl our.bowl)              :: allow only requests from our ship
      =^  cards  state
        (handle-http !<([@ta =inbound-request:eyre] vase))
      [cards this]
  ==
  ++  handle-http
    |=  [eyre-id=@ta =inbound-request:eyre]
    ^-  [(list card) $_(state)]
    =/  ,request-line:server  :: ^: switch parser into structure mode and produce a gate
      (parse-request-line:server url.request.inbound-request)
    =+  send=(cury response:schooner eyre-id)
    ::
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
          [%apps %tahuti %api %groups @t ~]
            :: TODO: Add error handling
            =/  group  (need (de-json:html q.u.body.request.inbound-request))
            =/  group  (group-from-js group)
            =/  uuid  (rear `(list @t)`site)
            =/  response  (pairs:enjs:format [[uuid (group-to-js group)] ~])
            [(send [200 ~ [%json response]]) state]
          [%apps %tahuti %api %groups @t %expenses @t ~]
            =/  content  (need (de-json:html q.u.body.request.inbound-request))
            =/  gid  (snag 4 `(list @t)`site)
            =/  eid  (rear `(list @t)`site)
            =/  response  (pairs:enjs:format [[eid content] ~])
            [(send [200 ~ [%json response]]) state]
        ==
      ::
      %'GET'
        ?+  site
            [(send [404 ~ [%plain "404 - Not Found"]]) state]
          [%apps %tahuti %api %groups ~]
            [(send [200 ~ [%json (ship:enjs:format ~zod)]]) state]
        ==
    ==
  --
++  on-arvo  on-arvo:default
++  on-watch  :: subscribe
  |=  =path
  ^-  [(list card) $_(this)]
  ?+    path  (on-watch:default path)
      [%http-response *]
    [~ this]
  ==
::
++  on-leave  on-leave:default  :: unsubscribe
++  on-peek  on-peek:default    :: one-off read-only action (scry)
++  on-agent  on-agent:default
++  on-fail  on-fail:default
--
