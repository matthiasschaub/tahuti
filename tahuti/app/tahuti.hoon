/-  *tahuti
/+  default-agent  :: agent arm defaults
/+  agentio        :: agent input/output helper
/+  dbug
/+  verb
/+  tahuti         :: tahuti statistics library
::  types
::
|%
+$  card  card:agent:gall
--
=|  state-3
=*  state  -
::  debug wrap
::
%+  verb   %.n
%-  agent:dbug
::  agent core
::
^-  agent:gall
|_  =bowl:gall
::  aliases
::
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
  |=  =vase
  ^-  [(list card) $_(this)]
  |^  =+  !<(old=versioned-state vase)
      :-  ^-  (list card)
          ~
      %=  this
        state  (build-state old)
      ==
  ++  build-state
    |=  old=versioned-state
    ^-  state-3
    |-
    |^  ?-  -.old
          %3  old
          %2  $(old (state-2-to-3 old))
          %1  $(old (state-1-to-2 old))
          %0  $(old (state-0-to-1 old))
        ==
    ++  state-0-to-1
      |=  =state-0
      ^-  state-1
      [%1 ~ groups.state-0 regs.state-0 acls.state-0 leds.state-0]
    ++  state-1-to-2
      |=  =state-1
      ^-  state-2
      |^  :*
            %2
            (~(run by invites.state-1) set-access)
            (~(run by groups.state-1) set-access)
            regs.state-1
            acls.state-1
            leds.state-1
          ==
      ++  set-access
        |=  =group-0
        ^-  group
        [gid.group-0 title.group-0 host.group-0 currency.group-0 %.n]
      --
    ++  state-2-to-3
      |=  =state-2
      ^-  state-3
      |^  :*
            %3
            invites.state-2
            groups.state-2
            (~(run by regs.state-2) reg-0-to-1)
            acls.state-2
            (~(run by leds.state-2) led-0-to-1)
          ==
      ++  reg-0-to-1
        |=  =reg-0
        ^-  reg
        (~(run in reg-0) member-0-to-1)
      ++  led-0-to-1
        |=  =led-0
        ^-  led
        (~(run by led-0) expense-0-to-1)
      ++  expense-0-to-1
        |=  =expense-0
        :*
          gid.expense-0
          eid.expense-0
          title.expense-0
          amount.expense-0
          currency.expense-0
          (member-0-to-1 payer.expense-0)
          date.expense-0
          (turn involves.expense-0 member-0-to-1)
        ==
      ++  member-0-to-1
        |=  =@p
        `@tas`(scot %p p)
      --
    --
  --
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
    ?<  (~(has by groups) gid.group.action)
    ?>  =(our.bowl src.bowl)
    ?>  =(our.bowl host.group.action)
    :-  ^-  (list card)
        ~
    %=  this
      groups  (~(put by groups) gid.group.action group.action)
      acls    (~(put by acls) gid.group.action ~)
      regs    (~(put by regs) gid.group.action ~)
      leds    (~(put by leds) gid.group.action ~)
    ==
    ::  (delete group and kick all subscribers)
      ::
      %del-group
    ~&  >  '%tahuti (on-poke): del group'
    ?>  (~(has by groups) gid.action)
    ?>  =(our.bowl src.bowl)
    =/  group  (~(got by groups) gid.action)
    ?>  =(our.bowl host.group)
    :-  ^-  (list card)
        :~  [%give %kick [/[gid.action] ~] ~]
        ==
    %=  this
      groups  (~(del by groups) gid.action)
      acls    (~(del by acls) gid.action)
      regs    (~(del by regs) gid.action)
      leds    (~(del by leds) gid.action)
    ==
    ::  (add member without Urbit ID)
      ::
      %add-member
    ~&  >  '%tahuti (on-poke): add member'
    =/  group  (~(got by groups) gid.action)
    ?>  public.group
    ?.  =(our.bowl host.group)
      :-  ^-  (list card)
        :~  [%pass ~ %agent [host.group %tahuti] %poke %tahuti-action !>(action)]
        ==
      this
    =/  reg  (~(got by regs) gid.action)
    =.  reg  (~(put in reg) member.action)
    :-  ^-  (list card)
      :~
        :*  %give  %fact  [/[gid.action] ~]  %tahuti-update
            !>  ^-  update  [%reg gid.action reg]
        ==
      ==
    %=  this
      regs  (~(put by regs) gid.action reg)
    ==
    ::
      %add-expense
    ~&  >  '%tahuti (on-poke): add expense'
    =/  group  (~(got by groups) gid.action)
    ?.  =(our.bowl host.group)
      :-  ^-  (list card)
        :~  [%pass ~ %agent [host.group %tahuti] %poke %tahuti-action !>(action)]
        ==
      this
    =/  register  (~(got by regs) gid.action)
    ?>  (~(has in (~(put in register) `@tas`(scot %p host.group))) payer.expense.action)
    ?>  (~(has in (~(put in register) `@tas`(scot %p host.group))) `@tas`(scot %p src.bowl))
    =/  ledger  (~(got by leds) gid.action)
    ?<  (~(has by ledger) eid.expense.action)
    =.  ledger  (~(put by ledger) eid.expense.action expense.action)
    :-  ^-  (list card)
      :~
        :*  %give  %fact  [/[gid.action] ~]  %tahuti-update
            !>  ^-  update  [%ledger gid.action ledger]
        ==
      ==
    %=  this
      leds  (~(put by leds) gid.action ledger)
    ==
    ::
      ::
      %del-expense
    ~&  >  '%tahuti (on-poke): del expense'
    =/  group  (~(got by groups) gid.action)
    ?.  =(our.bowl host.group)
      :-  ^-  (list card)
        :~  [%pass ~ %agent [host.group %tahuti] %poke %tahuti-action !>(action)]
        ==
      this
    ?>  =(our.bowl host.group)
    =/  ledger  (~(got by leds) gid.action)
    =.  ledger  (~(del by ledger) eid.action)
    :-  ^-  (list card)
      :~
        :*  %give  %fact  [/[gid.action] ~]  %tahuti-update
            !>  ^-  update  [%ledger gid.action ledger]
        ==
      ==
    %=  this
      leds  (~(put by leds) gid.action ledger)
    ==
    ::  (add ship to access-control list and send an invite)
      ::
      %allow
    ~&  >  '%tahuti (on-poke): allow'
    =/  group  (~(got by groups) gid.action)
    ?.  =(our.bowl host.group)
      :-  ^-  (list card)
        :~  [%pass ~ %agent [host.group %tahuti] %poke %tahuti-action !>(action)]
        ==
      this
    ?>  =(our.bowl host.group)
    ?<  =(our.bowl p.action)
    =/  acl  (~(got by acls) gid.action)
    =.  acl  (~(put in acl) p.action)
    ~&  p.action
    ~&  group
    :-  ^-  (list card)
      :~
        :*  %give  %fact  [/[gid.action] ~]  %tahuti-update
            !>  ^-  update  [%acl gid.action acl]
        ==
        :*  %pass  ~  %agent  [p.action %tahuti]
            %poke  %tahuti-action  !>([%add-invite group])
        ==
      ==
    %=  this
      acls     (~(put by acls) gid.action acl)
    ==
    ::  (receive invitation)
      ::
      %add-invite
    ~&  >  '%tahuti (on-poke): receive invite'
    :-  ^-  (list card)
        ~
    %=  this
      invites  (~(put by invites) gid.group.action group.action)
    ==
    ::  (decline invitation)
      ::
      %del-invite
    ~&  >  '%tahuti (on-poke): decline invite'
    :-  ^-  (list card)
        ~
    %=  this
      invites  (~(del by invites) gid.group.action)
    ==
    ::  (remove ship from access-control and subscriber lists)
      ::
      %kick
    ~&  >  '%tahuti (on-poke): kick'
    =/  group  (~(got by groups) gid.action)
    ?>  =(our.bowl src.bowl)
    ?>  =(our.bowl host.group)
    ?<  =(our.bowl p.action)
    ?<  =(host.group p.action)
    =/  reg  (~(got by regs) gid.action)
    =.  reg  (~(del in reg) p.action)
    :-  ^-  (list card)
      :~
        :*  %give  %fact  [/[gid.action] ~]  %tahuti-update
            !>  ^-  update  [%reg gid.action reg]
        ==
        :*  %give  %kick  [/[gid.action] ~]  [~ p.action]  ==
      ==
    %=  this
      regs    (~(put by regs) gid.action reg)
    ==
    ::  (subscribe to a group and remove invite)
      ::
      %join
    ~&  >  '%tahuti (on-poke): join'
    ?>  =(our.bowl src.bowl)
    =/  path  /[gid.action]
    :-  ^-  (list card)
        :~  [%pass path %agent [host.action %tahuti] %watch path]
        ==
    %=  this
      invites  (~(del by invites) gid.action)
    ==
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
  =/  gid  `@tas`i.path
  ?>  (~(has by groups) gid)
  =/  group     (~(got by groups) gid)
  =/  register  (~(got by regs) gid)
  =/  acl       (~(got by acls) gid)
  =/  ledger    (~(got by leds) gid)
  ?>  (~(has in acl) src.bowl)
  =.  register    (~(put in register) `@tas`(scot %p src.bowl))
  :-  ^-  (list card)
      :~
        :*  %give  %fact  [/[gid] ~]  %tahuti-update
            !>  ^-  update  [%group gid group register acl ledger]
        ==
      ==
  %=  this
    regs  (~(put by regs) gid register)
  ==
++  on-leave  on-leave:default
++  on-peek
  ~&  >  '%tahuti (on-peek)'
  |=  path=(pole knot)
  ^-  (unit (unit [mark vase]))
  ?+  path  ~|('%tahuti (on-peek)' (on-peek:default path))
    ::
      [%x %invites ~]
    [~ ~ [%noun !>(invites.this)]]
    ::
      [%x %groups ~]
    ~&  >  '%tahuti (on-peek): groups'
    [~ ~ [%noun !>(groups.this)]]
    ::
      [%x =gid ~]
    ~&  >  '%tahuti (on-peek): gid'
    =/  group  (~(got by groups) gid.path)
    =/  acl    (~(got by acls) gid.path)
    =/  reg    (~(got by regs) gid.path)
    =/  led    (~(got by leds) gid.path)
    [~ ~ [%noun !>([group acl reg led])]]
    ::
      [%x =gid %net ~]
    ?>  (~(has by groups) gid.path)
    =/  group  (~(got by groups) gid.path)
    =/  reg    (~(got by regs) gid.path)
    =/  led    (~(got by leds) gid.path)
    =.  reg    (~(put in reg) `@tas`(scot %p host.group))
    =/  net    ~(net tahuti [~(val by led) ~(tap in reg)])
    [~ ~ [%noun !>(net)]]
    ::
      [%x =gid %rei ~]
    ~&  >  '%tahuti (on-peek): reimbursements'
    ?>  (~(has by groups) gid.path)
    =/  group  (~(got by groups) gid.path)
    =/  reg    (~(got by regs) gid.path)
    =/  led    (~(got by leds) gid.path)
    =.  reg    (~(put in reg) `@tas`(scot %p host.group))
    ~&  reg
    =/  rei    ~(rei tahuti [~(val by led) ~(tap in reg)])
    [~ ~ [%noun !>(rei)]]
  ==
++  on-agent
  ~&  >  '%tahuti (on-agent)'
  |=  [=wire =sign:agent:gall]
  ^-  [(list card) $_(this)]
  ?>  ?=([@ ~] wire)
  =/  =gid  `@tas`i.wire
  ?+  -.sign  (on-agent:default wire sign)
    ::
      %watch-ack
    ?~  p.sign
      ~&  >  '%tahuti (on-agent): subscription successful'
      [~ this]
    ~&  >>>  '%tahuti (on-agent): subscription failed'
    [~ this]
    ::  (archive group)
      ::
      :: %kick
    ::
      %fact
    ?>  ?=(%tahuti-update p.cage.sign)
    ~&  >  '%tahuti (on-agent): update from publisher'
    =/  =update  !<(update q.cage.sign)
    ?>  =(gid gid.update)
    :: ?>  =(our.bowl host.group.update)
    ?-  -.update
      ::
        %group
      ~&  >  '%tahuti (on-agent): update group'
      :-  ^-  (list card)
          :~  (fact:agentio cage.sign [/[gid] ~])
          ==
      %=  this
        groups   (~(put by groups) gid group.update)
        regs     (~(put by regs) gid register.update)
        acls     (~(put by acls) gid acl.update)
        leds     (~(put by leds) gid ledger.update)
      ==
      ::
        %acl
      ~&  >  '%tahuti (on-agent): update acl'
      :-  ^-  (list card)
          :~  (fact:agentio cage.sign [/[gid] ~])
          ==
      %=  this
        acls     (~(put by acls) gid acl.update)
      ==
      ::
        %reg
      ~&  >  '%tahuti (on-agent): update register'
      :-  ^-  (list card)
          :~  (fact:agentio cage.sign [/[gid] ~])
          ==
      %=  this
        regs  (~(put by regs) gid reg.update)
      ==
        %ledger
      ~&  >  '%tahuti (on-agent): update ledger'
      :-  ^-  (list card)
          :~  (fact:agentio cage.sign [/[gid] ~])
          ==
      %=  this
        leds     (~(put by leds) gid ledger.update)
      ==
    ==
  ==
++  on-fail   on-fail:default
--
