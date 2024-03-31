/-  *tahuti
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
/*  html-settings-host        %html  /app/ui/html/settings-host/html
/*  html-settings-member      %html  /app/ui/html/settings-member/html
/*  html-settings-public      %html  /app/ui/html/settings-public/html
/*  html-about                %html  /app/ui/html/about/html
/*  html-add                  %html  /app/ui/html/add/html
/*  html-invite               %html  /app/ui/html/invite/html
/*  html-invite-public        %html  /app/ui/html/invite-public/html
/*  html-details              %html  /app/ui/html/details/html
/*  html-edit                 %html  /app/ui/html/edit/html
/*  css-udjat                 %css   /app/ui/css/udjat/css
/*  css-style                 %css   /app/ui/css/style/css
/*  css-print                 %css   /app/ui/css/print/css
/*  svg-add                   %svg   /app/ui/svg/add/svg
/*  svg-circles               %svg   /app/ui/svg/circles/svg
/*  svg-icon                  %svg   /app/ui/svg/icon/svg
/*  png-16                    %png   /app/ui/png/16/png
/*  png-64                    %png   /app/ui/png/64/png
/*  png-180                   %png   /app/ui/png/180/png
/*  png-192                   %png   /app/ui/png/192/png
/*  png-512                   %png   /app/ui/png/512/png
/*  ttf-soria                 %ttf   /app/ui/ttf/soria/ttf
/*  js-index                  %js    /app/ui/js/index/js
/*  js-groups                 %js    /app/ui/js/groups/js
/*  js-add                    %js    /app/ui/js/add/js
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
    =/  hx-req=?
      ?~  (get-header:http 'hx-request' header-list.request.inbound-request)
        %.n
      %.y
    =/  request-line
      (parse-request-line:server url.request.inbound-request)
    =+  site=site.request-line
    =+  ext=ext.request-line
    =+  send=(cury response:schooner eyre-id)
    =+  auth=authenticated.inbound-request
    =/  group=(unit group)
      ?.  (gte (lent site) 4)
        ~
      =/  gid   (snag 3 site)
      =/  path  /(scot %p our.bowl)/tahuti/(scot %da now.bowl)/[gid]/noun
      =,  .^([=group =acl =reg =led] %gx path)
      (some group)
    =/  public=?
      ?^  group
        public:(need group)
      ?~  ext
        %.n
      ?+  +.ext  %.n
        %css   %.y
        %js    %.y
        %svg   %.y
        %json  %.y
      ==
    ?.  ?|(auth public)
      ?.  hx-req
        [(send [302 ~ [%login-redirect './apps/tahuti']]) state]
      [(send [200 ~ [%hx-login-redirect './apps/tahuti']]) state]
    ?.  =(method.request.inbound-request %'GET')
      [(send [405 ~ [%plain "405 - Method Not Allowed"]]) state]
    ?+  site  [(send [404 ~ [%plain "404 - Not Found"]]) state]
      ::
      [%apps %tahuti ~]
        ?.  hx-req
          [(send [302 ~ [%redirect '/apps/tahuti/groups']]) state]
        [(send [200 ~ [%hx-redirect '/apps/tahuti/groups']]) state]
      ::  css
      ::
      [%apps %tahuti %udjat ~]
        [(send [200 ~ [%css css-udjat]]) state]
      [%apps %tahuti %style ~]
        [(send [200 ~ [%css css-style]]) state]
      [%apps %tahuti %print ~]
        [(send [200 ~ [%css css-print]]) state]
      ::  svg
      ::
      [%apps %tahuti %add-icon ~]
        [(send [200 ~ [%svg svg-add]]) state]
      [%apps %tahuti %circles ~]
        [(send [200 ~ [%svg svg-circles]]) state]
      [%apps %tahuti %icon ~]
        [(send [200 ~ [%svg svg-icon]]) state]
      ::  png
      ::
      [%apps %tahuti %icon16 ~]
        [(send [200 ~ [%png png-16]]) state]
      [%apps %tahuti %icon64 ~]
        [(send [200 ~ [%png png-64]]) state]
      [%apps %tahuti %icon180 ~]
        [(send [200 ~ [%png png-180]]) state]
      [%apps %tahuti %icon192 ~]
        [(send [200 ~ [%png png-192]]) state]
      [%apps %tahuti %icon512 ~]
        [(send [200 ~ [%png png-512]]) state]
      ::  ttf
      ::
      [%apps %tahuti %soria ~]
        [(send [200 ~ [%font-ttf q.ttf-soria]]) state]
      ::  js
      ::
      [%apps %tahuti %index ~]
        [(send [200 ~ [%js js-index]]) state]
      [%apps %tahuti %helper ~]
        [(send [200 ~ [%js js-groups]]) state]
      [%apps %tahuti %add ~]
        [(send [200 ~ [%js js-add]]) state]
      [%apps %tahuti %json-enc ~]
        [(send [200 ~ [%js js-json-enc]]) state]
      [%apps %tahuti %path-deps ~]
        [(send [200 ~ [%js js-path-deps]]) state]
      [%apps %tahuti %client-side-templates ~]
        [(send [200 ~ [%js js-client-side-templates]]) state]
      ::  json
      ::
      [%apps %tahuti %manifest ~]
        [(send [200 ~ [%json json-manifest]]) state]
      ::  html
      ::
      [%apps %tahuti @t ~]
        ?.  auth
          ?.  hx-req
            [(send [302 ~ [%login-redirect './apps/tahuti']]) state]
          [(send [200 ~ [%hx-login-redirect './apps/tahuti']]) state]
        =/  endpoint  (snag 2 `(list @t)`site)
        ?+  endpoint  [(send [404 ~ [%plain "404 - Not Found"]]) state]
          %groups   [(send [200 ~ [%html html-groups]]) state]
          %invites  [(send [200 ~ [%html html-invites]]) state]
          %create   [(send [200 ~ [%html html-create]]) state]
        ==
      ::
      [%apps %tahuti %groups @t @t ~]
        =/  endpoint  (snag 4 `(list @t)`site)
        ?+  endpoint  [(send [404 ~ [%plain "404 - Not Found"]]) state]
          %expenses        [(send [200 ~ [%html html-expenses]]) state]
          %balances        [(send [200 ~ [%html html-balances]]) state]
          %reimbursements  [(send [200 ~ [%html html-reimbursements]]) state]
          %settings
            ?:  auth
              ?:  .=(our.bowl host:(need group))
                [(send [200 ~ [%html html-settings-host]]) state]
              [(send [200 ~ [%html html-settings-member]]) state]
            [(send [200 ~ [%html html-settings-public]]) state]
          %about           [(send [200 ~ [%html html-about]]) state]
          %add             [(send [200 ~ [%html html-add]]) state]
          %invite
            ?.  auth
              ?.  hx-req
                [(send [302 ~ [%login-redirect './apps/tahuti']]) state]
              [(send [200 ~ [%hx-login-redirect './apps/tahuti']]) state]
            ?:  public
              [(send [200 ~ [%html html-invite-public]]) state]
            [(send [200 ~ [%html html-invite]]) state]
        ==
      ::
      [%apps %tahuti %groups @t %expenses @t %details ~]
        [(send [200 ~ [%html html-details]]) state]
      [%apps %tahuti %groups @t %expenses @t %edit ~]
        [(send [200 ~ [%html html-edit]]) state]
      ::
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
