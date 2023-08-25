/+  dbug, default-agent, server, schooner
/*  tahuti-ui-html  %html  /app/tahuti-ui/html
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
++  on-init
  ^-  (quip card _this)
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
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  ?-  -.old
    %0  [~ this(state old)]
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  ?+    mark  (on-poke:default mark vase)
      %handle-http-request
    ?>  =(src.bowl our.bowl)
    =^  cards  state
      (handle-http !<([@ta =inbound-request:eyre] vase))
    [cards this]
  ==
  ++  handle-http
    |=  [eyre-id=@ta =inbound-request:eyre]
    ^-  (quip card _state)
    =/  ,request-line:server
      (parse-request-line:server url.request.inbound-request)
    =+  send=(cury response:schooner eyre-id)
    ::
    ?+    method.request.inbound-request
      [(send [405 ~ [%stock ~]]) state]
      ::
        %'GET'
      ?+    site
          :_  state
          (send [404 ~ [%plain "Tahuti: 404 - Not Found"]])
        ::
          [%apps %tahuti ~]
        ?.  authenticated.inbound-request
          :_  state
          %-  send
          [302 ~ [%login-redirect './apps/tahuti']]
        :_  state
        %-  send
        :+  200  ~
        :-  %html  tahuti-ui-html
      ==
    ==
  --
++  on-peek  on-peek:default
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  (on-watch:default path)
      [%http-response *] 
    `this
  ==
::
++  on-leave  on-leave:default
++  on-agent  on-agent:default
++  on-arvo  on-arvo:default
++  on-fail  on-fail:default
--
