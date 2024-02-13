/+  dbug
/+  verb
/+  default-agent
/+  server                    :: HTTP request processing
/+  schooner                  :: HTTP response handling
::
/*  html-groups               %html  /app/ui/html/groups/html
/*  html-create               %html  /app/ui/html/create/html
/*  html-invites              %html  /app/ui/html/invites/html
/*  html-expenses             %html  /app/ui/html/expenses/html
/*  html-balances             %html  /app/ui/html/balances/html
/*  html-reimbursements       %html  /app/ui/html/reimbursements/html
/*  html-settings             %html  /app/ui/html/settings/html
/*  html-about                %html  /app/ui/html/about/html
/*  html-add                  %html  /app/ui/html/add/html
/*  html-invite               %html  /app/ui/html/invite/html
/*  html-details              %html  /app/ui/html/details/html
/*  css-style                 %css   /app/ui/css/style/css
/*  css-print                 %css   /app/ui/css/print/css
/*  svg-tahuti                %svg   /app/ui/svg/tahuti/svg
/*  svg-circles               %svg   /app/ui/svg/circles/svg
/*  js-index                  %js    /app/ui/js/index/js
/*  js-groups                 %js    /app/ui/js/groups/js
/*  js-json-enc               %js    /app/ui/js/json-enc/js
/*  js-path-deps              %js    /app/ui/js/path-deps/js
/*  js-client-side-templates  %js    /app/ui/js/client-side-templates/js
/*  json-manifest             %json  /app/ui/json/manifest/json
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
          [(send [200 ~ [%html html-groups]]) state]
        [%apps %tahuti %groups ~]
          [(send [200 ~ [%html html-groups]]) state]
        [%apps %tahuti %invites ~]
          [(send [200 ~ [%html html-invites]]) state]
        [%apps %tahuti %groups %create ~]
          [(send [200 ~ [%html html-create]]) state]
        [%apps %tahuti %groups @t %expenses ~]
          [(send [200 ~ [%html html-expenses]]) state]
        [%apps %tahuti %groups @t %balances ~]
          [(send [200 ~ [%html html-balances]]) state]
        [%apps %tahuti %groups @t %reimbursements ~]
          [(send [200 ~ [%html html-reimbursements]]) state]
        [%apps %tahuti %groups @t %settings ~]
          [(send [200 ~ [%html html-settings]]) state]
        [%apps %tahuti %groups @t %about ~]
          [(send [200 ~ [%html html-about]]) state]
        [%apps %tahuti %groups @t %add ~]
          [(send [200 ~ [%html html-add]]) state]
        [%apps %tahuti %groups @t %invite ~]
          [(send [200 ~ [%html html-invite]]) state]
        [%apps %tahuti %groups @t %expenses @t ~]
          [(send [200 ~ [%html html-details]]) state]
        ::  css
        ::
        [%apps %tahuti %css %style ~]
          [(send [200 ~ [%css css-style]]) state]
        [%apps %tahuti %css %print ~]
          [(send [200 ~ [%css css-print]]) state]
        ::  svg
        ::
        [%apps %tahuti %svg %tahuti ~]
          [(send [200 ~ [%svg svg-tahuti]]) state]
        [%apps %tahuti %svg %circles ~]
          [(send [200 ~ [%svg svg-circles]]) state]
        ::  javascript
        ::
        [%apps %tahuti %js %index ~]
          [(send [200 ~ [%js js-index]]) state]
        [%apps %tahuti %js %json-enc ~]
          [(send [200 ~ [%js js-json-enc]]) state]
        [%apps %tahuti %js %path-deps ~]
          [(send [200 ~ [%js js-path-deps]]) state]
        [%apps %tahuti %js %client-side-templates ~]
          [(send [200 ~ [%js js-client-side-templates]]) state]
        [%apps %tahuti %js %groups ~]
          [(send [200 ~ [%js js-groups]]) state]
        ::  json
        [%apps %tahuti %manifest ~]
          [(send [200 ~ [%json json-manifest]]) state]
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
