/+  dbug           :: debug wrapper for agent
/+  default-agent  :: agent arm defaults
/+  server         :: HTTP request processing
/+  schooner       :: HTTP response handling
/*  tahuti-ui-groups-html    %html  /app/ui/groups/html
/*  tahuti-ui-members-html   %html  /app/ui/members/html
/*  tahuti-ui-expenses-html  %html  /app/ui/expenses/html
/*  tahuti-ui-style-css  %css  /app/ui/static/css/min/style/css
/*  tahuti-ui-print-css  %css  /app/ui/static/css/min/print/css
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
  ~&  >  '%tahuti-ui: initialize'
  :_  this(page 'Hello World')
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
            ::  todo:  redirect to /groups
            [(send [200 ~ [%html tahuti-ui-groups-html]]) state]
          [%apps %tahuti %groups ~]
            [(send [200 ~ [%html tahuti-ui-groups-html]]) state]
          [%apps %tahuti %groups @t %expenses ~]
            [(send [200 ~ [%html tahuti-ui-expenses-html]]) state]
          [%apps %tahuti %groups @t %members ~]
            [(send [200 ~ [%html tahuti-ui-members-html]]) state]
          [%apps %tahuti %static %css %min %style ~]
            [(send [200 ~ [%css tahuti-ui-style-css]]) state]
          [%apps %tahuti %static %css %min %print ~]
            [(send [200 ~ [%css tahuti-ui-print-css]]) state]
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
