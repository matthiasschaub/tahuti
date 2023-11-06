/+  dbug
/+  default-agent
/+  server         :: HTTP request processing
/+  schooner       :: HTTP response handling
/*  groups                 %html  /app/ui/groups/html
/*  members                %html  /app/ui/members/html
/*  expenses               %html  /app/ui/expenses/html
/*  add                    %html  /app/ui/add/html
/*  style                  %css   /app/ui/static/css/min/style/css
/*  print                  %css   /app/ui/static/css/min/print/css
/*  htmx                   %js    /app/ui/assets/htmx/js
/*  json-enc               %js    /app/ui/assets/json-enc/js
/*  path-deps              %js    /app/ui/assets/path-deps/js
/*  client-side-templates  %js    /app/ui/assets/client-side-templates/js
/*  mustache               %js    /app/ui/assets/mustache/js
/*  currency               %js    /app/ui/assets/currency/js
/*  table-sort             %js    /app/ui/assets/table-sort/js
/*  request                %js    /app/ui/assets/request/js
::
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 page=@t]
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this  .
    default  ~(. (default-agent this %.n) bowl)
::
++  on-init
  ^-  [(list card) $_(this)]
  ~&  >  '%tahuti-ui: initialize'
  :-  ^-  (list card)
    :~
      :*  %pass  /eyre/connect  %arvo  %e
          %connect  `/apps/tahuti  %tahuti-ui
      ==
    ==
  %=  this
    page  'Hello World'
  ==
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
++  on-poke                                   :: one-off action
  |=  [=mark =vase]
  ^-  [(list card) $_(this)]                  :: messages and new state
  |^
  ?+  mark  (on-poke:default mark vase)
    ::
      %handle-http-request
    ?>  =(src.bowl our.bowl)                :: request is from our ship
    =^  cards  state
      (handle-http !<([@ta =inbound-request:eyre] vase))
    [cards this]
  ==
  ++  handle-http
    |=  [eyre-id=@ta =inbound-request:eyre]
    ^-  [(list card) $_(state)]
    =/  ,request-line:server
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
          ::  TODO:  redirect to /groups
          [(send [200 ~ [%html groups]]) state]
        [%apps %tahuti %groups ~]
          [(send [200 ~ [%html groups]]) state]
        [%apps %tahuti %groups @t %expenses ~]
          [(send [200 ~ [%html expenses]]) state]
        [%apps %tahuti %groups @t %members ~]
          [(send [200 ~ [%html members]]) state]
        [%apps %tahuti %groups @t %add ~]
          [(send [200 ~ [%html add]]) state]
        [%apps %tahuti %static %css %min %style ~]
          [(send [200 ~ [%css style]]) state]
        [%apps %tahuti %static %css %min %print ~]
          [(send [200 ~ [%css print]]) state]
        [%apps %tahuti %assets %htmx ~]
          [(send [200 ~ [%js htmx]]) state]
        [%apps %tahuti %assets %json-enc ~]
          [(send [200 ~ [%js json-enc]]) state]
        [%apps %tahuti %assets %path-deps ~]
          [(send [200 ~ [%js path-deps]]) state]
        [%apps %tahuti %assets %client-side-templates ~]
          [(send [200 ~ [%js client-side-templates]]) state]
        [%apps %tahuti %assets %mustache ~]
          [(send [200 ~ [%js mustache]]) state]
        [%apps %tahuti %assets %currency ~]
          [(send [200 ~ [%js currency]]) state]
        [%apps %tahuti %assets %request ~]
          [(send [200 ~ [%js request]]) state]
        [%apps %tahuti %assets %table-sort ~]
          [(send [200 ~ [%js table-sort]]) state]
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
++  on-leave  on-leave:default
++  on-peek  on-peek:default
++  on-agent  on-agent:default
++  on-fail  on-fail:default
--
