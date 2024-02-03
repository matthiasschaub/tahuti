/+  dbug
/+  verb
/+  default-agent
/+  server                 :: HTTP request processing
/+  schooner               :: HTTP response handling
/*  groups                 %html  /app/ui/groups/html
/*  invites                %html  /app/ui/invites/html
/*  create                 %html  /app/ui/create/html
/*  balances               %html  /app/ui/balances/html
/*  reimbursements         %html  /app/ui/reimbursements/html
/*  expenses               %html  /app/ui/expenses/html
/*  add                    %html  /app/ui/add/html
/*  details                %html  /app/ui/details/html
/*  settings               %html  /app/ui/settings/html
/*  about                  %html  /app/ui/about/html
/*  invite                 %html  /app/ui/invite/html
/*  style                  %css   /app/ui/css/style/css
/*  print                  %css   /app/ui/css/print/css
/*  manifest               %json  /app/ui/manifest/json
/*  index                  %js    /app/ui/js/index/js
/*  json-enc               %js    /app/ui/js/json-enc/js
/*  path-deps              %js    /app/ui/js/path-deps/js
/*  client-side-templates  %js    /app/ui/js/client-side-templates/js
/*  dinero                 %js    /app/ui/assets/dinero/js
/*  dinero-currencies      %js    /app/ui/assets/dinero-currencies/js
/*  cur                    %js    /app/ui/assets/cur/js
/*  groups-js              %js    /app/ui/js/groups/js
/*  expenses-js            %js    /app/ui/js/expenses/js
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
        [%apps %tahuti %invites ~]
          [(send [200 ~ [%html invites]]) state]
        [%apps %tahuti %groups %create ~]
          [(send [200 ~ [%html create]]) state]
        [%apps %tahuti %groups @t %expenses ~]
          [(send [200 ~ [%html expenses]]) state]
        [%apps %tahuti %groups @t %expenses @t ~]
          [(send [200 ~ [%html details]]) state]
        [%apps %tahuti %groups @t %balances ~]
          [(send [200 ~ [%html balances]]) state]
        [%apps %tahuti %groups @t %reimbursements ~]
          [(send [200 ~ [%html reimbursements]]) state]
        [%apps %tahuti %groups @t %add ~]
          [(send [200 ~ [%html add]]) state]
        [%apps %tahuti %groups @t %settings ~]
          [(send [200 ~ [%html settings]]) state]
        [%apps %tahuti %groups @t %about ~]
          [(send [200 ~ [%html about]]) state]
        [%apps %tahuti %groups @t %invite ~]
          [(send [200 ~ [%html invite]]) state]
        ::  css
        ::
        [%apps %tahuti %css %style ~]
          [(send [200 ~ [%css style]]) state]
        [%apps %tahuti %css %print ~]
          [(send [200 ~ [%css print]]) state]
        ::  javascript
        ::
        [%apps %tahuti %manifest ~]
          [(send [200 ~ [%json manifest]]) state]
        [%apps %tahuti %js %index ~]
          [(send [200 ~ [%js index]]) state]
        [%apps %tahuti %js %json-enc ~]
          [(send [200 ~ [%js json-enc]]) state]
        [%apps %tahuti %js %path-deps ~]
          [(send [200 ~ [%js path-deps]]) state]
        [%apps %tahuti %js %client-side-templates ~]
          [(send [200 ~ [%js client-side-templates]]) state]
        [%apps %tahuti %assets %cur ~]
          [(send [200 ~ [%js cur]]) state]
        [%apps %tahuti %assets %dinero ~]
          [(send [200 ~ [%js dinero]]) state]
        [%apps %tahuti %assets %dinero-currencies ~]
          [(send [200 ~ [%js dinero-currencies]]) state]
        [%apps %tahuti %js %groups ~]
          [(send [200 ~ [%js groups-js]]) state]
        [%apps %tahuti %js %expenses ~]
          [(send [200 ~ [%js expenses-js]]) state]
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
