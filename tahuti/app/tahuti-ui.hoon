/+  dbug           :: debug wrapper for agent
/+  default-agent  :: agent arm defaults
/+  server         :: HTTP request processing
/+  schooner       :: HTTP response handling
/*  tahuti-ui-html  %html  /app/tahuti-ui/html
/*  tahuti-ui-css  %css  /app/static/css/style/css
::
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 page=@t]
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
  ^-  [(list card) _this]
  :_  this(page 'Hello World')
  ::  task for eyre
  ::
  :~
    :*  %pass  /eyre/connect  %arvo  %e
        %connect  `/apps/tahuti  %tahuti-ui
    ==
  ==
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-state=vase
  ^-  [(list card) _this]
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
      ?>  =(src.bowl our.bowl)                :: request is from our ship
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
      %'GET'
        ?+  site
            [(send [404 ~ [%plain "404 - Not Found"]]) state]
          [%apps %tahuti ~]
            [(send [200 ~ [%html tahuti-ui-html]]) state]
          [%apps %tahuti %static %css %style ~]
            [(send [200 ~ [%css tahuti-ui-css]]) state]
        ==
    ==
  --
++  on-arvo  on-arvo:default
++  on-watch                    :: subscribe
  |=  =path
  ^-  [(list card) _this]
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
