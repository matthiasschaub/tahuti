/+  dbug
/+  verb
/+  default-agent
/+  server                 :: HTTP request processing
/+  schooner               :: HTTP response handling
/*  groups                 %html  /app/ui/groups/html
/*  create                 %html  /app/ui/create/html
/*  balances               %html  /app/ui/balances/html
/*  expenses               %html  /app/ui/expenses/html
/*  add                    %html  /app/ui/add/html
/*  details                %html  /app/ui/details/html
/*  settings               %html  /app/ui/settings/html
/*  invite                 %html  /app/ui/invite/html
/*  style                  %css   /app/ui/static/css/min/style/css
/*  print                  %css   /app/ui/static/css/min/print/css
/*  manifest               %json  /app/ui/manifest/json
/*  htmx                   %js    /app/ui/assets/htmx/js
/*  json-enc               %js    /app/ui/assets/json-enc/js
/*  path-deps              %js    /app/ui/assets/path-deps/js
/*  client-side-templates  %js    /app/ui/assets/client-side-templates/js
/*  mustache               %js    /app/ui/assets/mustache/js
/*  currency               %js    /app/ui/assets/currency/js
/*  request-group          %js    /app/ui/assets/request-group/js
/*  request-expense        %js    /app/ui/assets/request-expense/js
/*  icon-16                %png   /app/ui/static/images/icons/16/png
/*  icon-180               %png   /app/ui/static/images/icons/180/png
/*  icon-192               %png   /app/ui/static/images/icons/192/png
/*  icon-512               %png   /app/ui/static/images/icons/512/png
::
|%
+$  card  card:agent:gall
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 page=@t]
--
=|  state-0
=*  state  -
::  debug wrap
::
%+  verb  %.n
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
  ~&  >  '%tahuti-ui: initialize'
  :-  ^-  (list card)
    :~
      :*  %pass  /bind  %arvo  %e
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
    =/  ,request-line:server
      (parse-request-line:server url.request.inbound-request)
    =+  send=(cury response:schooner eyre-id)
    ::  redirect if not authenticated
    ::
    ?.  authenticated.inbound-request
      [(send [302 ~ [%login-redirect './apps/tahuti']]) state]
    ::  crash if request is not from our ship
    ::
    ?>  =(src.bowl our.bowl)
    ?+  method.request.inbound-request
      [(send [405 ~ [%plain "405 - Method Not Allowed"]]) state]
      ::
        %'GET'
      ?+  site
          [(send [404 ~ [%plain "404 - Not Found"]]) state]
        ::  html
        ::
        [%apps %tahuti ~]
          [(send [200 ~ [%html groups]]) state]
        [%apps %tahuti %groups ~]
          [(send [200 ~ [%html groups]]) state]
        [%apps %tahuti %groups %create ~]
          [(send [200 ~ [%html create]]) state]
        [%apps %tahuti %groups @t %expenses ~]
          [(send [200 ~ [%html expenses]]) state]
        [%apps %tahuti %groups @t %expenses @t ~]
          [(send [200 ~ [%html details]]) state]
        [%apps %tahuti %groups @t %balances ~]
          [(send [200 ~ [%html balances]]) state]
        [%apps %tahuti %groups @t %add ~]
          [(send [200 ~ [%html add]]) state]
        [%apps %tahuti %groups @t %settings ~]
          [(send [200 ~ [%html settings]]) state]
        [%apps %tahuti %groups @t %invite ~]
          [(send [200 ~ [%html invite]]) state]
        ::  css
        ::
        [%apps %tahuti %static %css %min %style ~]
          [(send [200 ~ [%css style]]) state]
        [%apps %tahuti %static %css %min %print ~]
          [(send [200 ~ [%css print]]) state]
        ::  javascript
        ::
        [%apps %tahuti %manifest ~]
          [(send [200 ~ [%json manifest]]) state]
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
        [%apps %tahuti %assets %request-group ~]
          [(send [200 ~ [%js request-group]]) state]
        [%apps %tahuti %assets %request-expense ~]
          [(send [200 ~ [%js request-expense]]) state]
        ::  icons
        ::
        [%apps %tahuti %static %images %icons %16 ~]
          [(send [200 ~ [%png icon-16]]) state]
        [%apps %tahuti %static %images %icons %180 ~]
          [(send [200 ~ [%png icon-180]]) state]
        [%apps %tahuti %static %images %icons %192 ~]
          [(send [200 ~ [%png icon-192]]) state]
        [%apps %tahuti %static %images %icons %512 ~]
          [(send [200 ~ [%png icon-512]]) state]
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
    %eyre-rejected-tahuti-ui-bind
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
