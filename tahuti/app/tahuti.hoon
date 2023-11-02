/-  *tahuti
/+  default-agent  :: agent arm defaults
/+  agentio        :: agent input/output helper
/+  dbug
/+  verb
::  types
::
|%
+$  card  card:agent:gall
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  $:  %0
      =groups
      =regs        :: registers
      =acls        :: access-control lists
      =leds        :: ledgers
  ==
--
::  state
::
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
  ~&  >  '%tahuti (on-init)'
  ^-  [(list card) $_(this)]
  :-  ^-  (list card)
      ~
  this
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
++  on-poke
  ~&  >  '%tahuti (on-poke)'
  |=  [=mark =vase]
  ^-  [(list card) $_(this)]
  ?>  ?=(%tahuti-action mark)
  =/  action  !<(action vase)
  ?-  -.action
    ::
      %add-group
    ~&  >  '%tahuti (on-poke): add group'
    ?<  (~(has by groups) id.group.action)
    ?>  =(our.bowl src.bowl)
    :-  ^-  (list card)
        ~
    %=  this
      groups  (~(put by groups) id.group.action group.action)
      acls    (~(put by acls) id.group.action ~)
      regs    (~(put by regs) id.group.action ~)
      leds    (~(put by leds) id.group.action ~)
    ==
    ::
      %add-expense
    ~&  >  '%tahuti (on-poke): add expense'
    =/  group  (~(got by groups) id.action)
    ?.  =(our.bowl host.group)
      :-  ^-  (list card)
        :~  [%pass ~ %agent [host.group %tahuti] %poke %tahuti-action !>(action)]
        ==
      this
    =/  ledger  (~(got by leds) id.action)
    ?<  (~(has by ledger) id.expense.action)
    =/  ledger  (~(put by ledger) id.expense.action expense.action)
    :-  ^-  (list card)
        ~
    %=  this
      leds  (~(put by leds) id.action ledger)
    ==
    ::  (add ship to access-control list)
      ::
      %invite
    ~&  >  '%tahuti (on-poke): invite'
    =/  group  (~(got by groups) id.action)
    ?>  =(our.bowl src.bowl)
    ?>  =(our.bowl host.group)
    ?<  =(our.bowl p.action)
    =/  register  (~(got by regs) id.action)
    =/  acl  (~(got by acls) id.action)
    =.  acl  (~(put in acl) p.action)
    :-  ^-  (list card)
      :~
        :*  %give  %fact  [/[id.action] ~]  %tahuti-update
            !>  ^-  update  [%group id.action group register acl]
        ==
      ==
    %=  this
      acls    (~(put by acls) id.action acl)
    ==
    ::  (subscribe to a group hosted on another ship)
      ::
      %join
    ~&  >  '%tahuti (on-poke): join'
    =/  path  /[id.action]
    :-  ^-  (list card)
        :~  [%pass path %agent [host.action %tahuti] %watch path]
        ==
    this
  ==
++  on-arvo  on-arvo:default
++  on-watch
  ::  (send a %fact back with an empty path,
  ::  which will only go to the new subscriber.)
  ::
  ~&  >  '%tahuti (on-watch)'
  |=  =path
  ^-  [(list card) $_(this)]
  ?>  ?=([@ ~] path)
  =/  =id  `@tas`i.path
  ?>  (~(has by groups) id)
  =/  group  (~(got by groups) id)
  =/  acl    (~(got by acls) id)
  =/  register    (~(got by regs) id)
  ?>  (~(has in acl) src.bowl)
  =.  register    (~(put in register) src.bowl)
  :-  ^-  (list card)
      :~
        :*  %give  %fact  [/[id] ~]  %tahuti-update
            !>  ^-  update  [%group id group register acl]
        ==
      ==
  %=  this
    regs  (~(put by regs) id register)
  ==
++  on-leave  on-leave:default
++  on-peek
  ~&  >  '%tahuti (on-peek)'
  |=  =path
  ^-  (unit (unit [mark vase]))
  ?+  path  ~|('%tahuti (on-peek)' (on-peek:default path))
    ::
      [%x %groups ~]
    [~ ~ [%noun !>(groups.this)]]
    ::
      [%x %regs ~]
    [~ ~ [%noun !>(regs.this)]]
    ::
      [%x %acls ~]
    [~ ~ [%noun !>(acls.this)]]
    ::
      [%x %leds ~]
    [~ ~ [%noun !>(leds.this)]]
  ==
++  on-agent
  ~&  >  '%tahuti (on-agent)'
  |=  [=wire =sign:agent:gall]
  ^-  [(list card) $_(this)]
  ?>  ?=([@ ~] wire)
  =/  =id  `@tas`i.wire
  ?+  -.sign  (on-agent:default wire sign)
    ::
      %watch-ack
    ?~  p.sign
      ~&  >  '%tahuti (on-agent): subscription successful'
      [~ this]
    ~&  >>>  '%tahuti (on-agent): subscription failed'
    [~ this]
    ::
      %fact
    ?>  ?=(%tahuti-update p.cage.sign)
    ~&  >  '%tahuti (on-agent): update from publisher'
    =/  =update  !<(update q.cage.sign)
    ?>  =(id id.update)
    :: ?>  =(our.bowl host.group.update)
    ?-  -.update
      ::
        %group
      ~&  >  '%tahuti (on-agent): update group'
      :-  ^-  (list card)
          :~  (fact:agentio cage.sign [/[id] ~])
          ==
      %=  this
        groups   (~(put by groups) id group.update)
        regs     (~(put by regs) id register.update)
        acls     (~(put by acls) id acl.update)
      ==
    ==
  ==
++  on-fail   on-fail:default
--
