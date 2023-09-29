  ::  Modified (reduced) version of /pkg/yard/lib/schooner.hoon
::::  Dalten Collective, with modifications by ~hanfel-dovned & ~lagrev-nocfep
::    Version ~2023.7.24
::
::  Schooner is a Hoon library intended to de-clutter raw HTTP handling
::  in Gall agents.
::
::  It expects to receive a [=eyre-id =http-status =headers =resource]
::  which are conveniently defined below.
::
/+  server
::
|%
::
+$  eyre-id  @ta
+$  header  [key=@t value=@t]
+$  headers  (list header)
::
+$  resource
  $%
    [%css h=cord]
    [%html h=cord]
    [%js h=cord]
    [%json j=json]
    [%plain p=tape]
    ::
    [%login-redirect l=cord]
    [%none ~]
    [%redirect o=cord]
  ==
::
+$  http-status  @ud
::
++  response
  |=  [=eyre-id =http-status =headers =resource]
  ^-  (list card:agent:gall)
  %+  give-simple-payload:app:server
    eyre-id
  ^-  simple-payload:http
  ?-  -.resource
      %json
    :-  :-  http-status
        %+  weld  headers
        ['content-type'^'application/json']~
    `(as-octt:mimes:html (en-json:html j.resource))
    ::
     %html
    :-  :-  http-status
      (weld headers ['content-type'^'text/html']~)
    `(as-octs:mimes:html h.resource)
    ::
     %css
    :-  :-  http-status
      (weld headers ['content-type'^'text/css']~)
    `(as-octs:mimes:html h.resource)
    ::
     %js
    :-  :-  http-status
      (weld headers ['content-type'^'application/javascript']~)
    `(as-octs:mimes:html h.resource)
    ::
      %plain
    :_  `(as-octt:mimes:html p.resource)
    :-  http-status
    (weld headers ['content-type'^'text/plain']~)
    ::
      %login-redirect
    =+  %^  cat  3
      '/~/login?redirect='
    l.resource
    :_  ~
    :-  http-status
    (weld headers [['location' -]]~)
    ::
      %redirect
    :_  ~
    :-  http-status
    (weld headers ['location'^o.resource]~)
    ::
      %none
    [[http-status headers] ~]
    ::
  ==
--