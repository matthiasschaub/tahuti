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
=<
|_  =bowl:gall
::  aliases
::
+*  this  .
    default  ~(. (default-agent this %.n) bowl)
::
++  on-init
  ^-  [(list card) $_(this)]
  :-  ^-  (list card)
      ~
  this
::
::  envases, produces current state
::
++  on-save
  ^-  vase
  !>(state)
::
::  unwraps old vase, make state changes
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
::
::  another agents sends a message, react
::
++  on-poke
  |=  [=mark =vase]
  ^-  [(list card) $_(this)]
  ?>  ?=(%tahuti-action mark)
  =/  action  !<(action vase)
  ?-  -.action
    ::
      %add-group
    ~&  >  '%tahuti (on-poke): add group'
    ?>  ?&
          .=(our.bowl src.bowl)
          .=(our.bowl host.group.action)
        ==
    ?<  (~(has by groups) gid.group.action)
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
    ~&  >  '%tahuti (on-poke): delete group'
    =/  group  (~(got by groups) gid.action)
    ?>  ?&
          .=(our.bowl src.bowl)
          .=(our.bowl host.group)
        ==
    :-  ^-  (list card)
        :~  [%give %kick [/[gid.action] ~] ~]
        ==
    %=  this
      invites  (~(del by invites) gid.action)
      groups   (~(del by groups) gid.action)
      acls     (~(del by acls) gid.action)
      regs     (~(del by regs) gid.action)
      leds     (~(del by leds) gid.action)
    ==
    ::
      %add-expense
    ~&  >  '%tahuti (on-poke): add expense'
    =/  group  (~(got by groups) gid.action)
    =/  acl    (~(got by acls) gid.action)
    =/  reg    (~(got by regs) gid.action)
    =.  reg    (~(put in reg) `@tas`(scot %p host.group))
    ?>  ?&
          (~(has in reg) `@tas`(scot %p src.bowl))
          (~(has in reg) payer.expense.action)
        ==
    ?>  ?|
          (~(has in acl) src.bowl)
          .=(src.bowl host.group)
        ==
    ?.  =(our.bowl host.group)
      :-  ^-  (list card)
        :~  [%pass ~ %agent [host.group %tahuti] %poke %tahuti-action !>(action)]
        ==
      this
    =/  led  (~(got by leds) gid.action)
    =.  led  (~(put by led) eid.expense.action expense.action)
    :-  ^-  (list card)
      :~
        :*  %give  %fact  [/[gid.action] ~]  %tahuti-update
            !>  ^-  update  [%ledger gid.action led]
        ==
      ==
    %=  this
      leds  (~(put by leds) gid.action led)
    ==
    ::
      ::
      %del-expense
    ~&  >  '%tahuti (on-poke): delete expense'
    =/  group  (~(got by groups) gid.action)
    =/  acl    (~(got by acls) gid.action)
    =/  reg    (~(got by regs) gid.action)
    =.  reg    (~(put in reg) `@tas`(scot %p host.group))
    ?>  (~(has in reg) `@tas`(scot %p src.bowl))
    ?>  ?|
          (~(has in acl) src.bowl)
          .=(src.bowl host.group)
        ==
    ?.  =(our.bowl host.group)
      :-  ^-  (list card)
        :~  (action:effect [host.group action])
        ==
      this
    =/  led  (~(got by leds) gid.action)
    =.  led  (~(del by led) eid.action)
    :-  ^-  (list card)
      :~  (update:effect [%ledger gid.action led])
      ==
    %=  this
      leds  (~(put by leds) gid.action led)
    ==
    ::  (add member without Urbit ID to register)
      ::
      %add-member
    ~&  >  '%tahuti (on-poke): add member'
    =/  group  (~(got by groups) gid.action)
    ?>  ?&
          .=(our.bowl src.bowl)
          .=(our.bowl host.group)
          public.group
        ==
    =/  reg  (~(got by regs) gid.action)
    =.  reg  (~(put in reg) member.action)
    :-  ^-  (list card)
      :~  (update:effect [%reg gid.action reg])
      ==
    %=  this
      regs  (~(put by regs) gid.action reg)
    ==
    ::  (add a ship to access-control list and send an invite)
      ::
      %allow
    ~&  >  '%tahuti (on-poke): allow'
    =/  group  (~(got by groups) gid.action)
    ?>  ?&
          .=(our.bowl src.bowl)
          .=(our.bowl host.group)
          !=(our.bowl p.action)
        ==
    =/  acl  (~(got by acls) gid.action)
    =.  acl  (~(put in acl) p.action)
    :-  ^-  (list card)
      :~
        (update:effect [%acl gid.action acl])
        (action:effect [p.action [%add-invite group]])
      ==
    %=  this
      acls     (~(put by acls) gid.action acl)
    ==
    ::  (receive invitation to join a group)
      ::
      %add-invite
    ~&  >  '%tahuti (on-poke): receive invite'
    ?>  ?|
          .=(our.bowl src.bowl)
          .=(src.bowl host.group.action)
        ==
    :-  ^-  (list card)
        ~
    %=  this
      invites  (~(put by invites) gid.group.action group.action)
    ==
    ::  (decline invitation to join a group)
      ::
      %del-invite
    ~&  >  '%tahuti (on-poke): decline invite'
    ?>  ?|
          .=(our.bowl src.bowl)
          .=(src.bowl host.group.action)
        ==
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
    ?>  ?&
          .=(our.bowl src.bowl)
          .=(our.bowl host.group)
          !=(our.bowl p.action)
        ==
    =/  acl    (~(got by acls) gid.action)
    =.  acl  (~(del in acl) p.action)
    =/  path  /[gid.action]
    :-  ^-  (list card)
      :~
        (update:effect [%acl gid.action acl])
        (action:effect [p.action [%del-invite group]])
        [%give [%kick [path ~] (some p.action)]]
      ==
    %=  this
      acls    (~(put by acls) gid.action acl)
    ==
    ::  (subscribe to a group and remove invite)
      ::
      %join
    ~&  >  '%tahuti (on-poke): join'
    ?>  .=(our.bowl src.bowl)
    =/  path  /[gid.action]
    :-  ^-  (list card)
      :~  [%pass path [%agent [host.action %tahuti] [%watch path]]]
      ==
    %=  this
      invites  (~(del by invites) gid.action)
    ==
    ::  (unsubscribe from a group and delete group data)
      ::
      %leave
    ~&  >  '%tahuti (on-poke): leave'
    ?>  .=(our.bowl src.bowl)
    =/  path  /[gid.action]
    :-  ^-  (list card)
      :~  [%pass path [%agent [host.action %tahuti] [%leave ~]]]
      ==
    %=  this
      invites  (~(del by invites) gid.action)
      groups   (~(del by groups) gid.action)
      acls     (~(del by acls) gid.action)
      regs     (~(del by regs) gid.action)
      leds     (~(del by leds) gid.action)
    ==
  ==
++  on-arvo  on-arvo:default
::
::  another agent subscribes, handle subscription
::
++  on-watch
  |=  path=(pole knot)
  ^-  [(list card) $_(this)]
  ?+  path  ~|('%tahuti (on-watch)' (on-watch:default path))
    ::  (send group data only to the new subscriber)
      ::
      [=gid ~]
    ~&  >  '%tahuti (on-watch)'
    =/  group  (~(got by groups) gid.path)
    =/  acl    (~(got by acls) gid.path)
    =/  reg    (~(got by regs) gid.path)
    =/  led    (~(got by leds) gid.path)
    ?>  (~(has in acl) src.bowl)
    =/  reg    (~(got by regs) gid.path)
    =.  reg  (~(put in reg) `@tas`(scot %p src.bowl))
    :-  ^-  (list card)
        :~  (update:effect [%group gid.path group reg acl led])
        ==
    %=  this
      regs  (~(put by regs) gid.path reg)
    ==
  ==
::
::  another agent unsubscribes, quite subscription
::
++  on-leave
  |=  path=(pole knot)
  ^-  [(list card) $_(this)]
  ?+  path  ~|('%tahuti (on-leave)' (on-leave:default path))
    ::  (remove from access-control list)
      ::
      [=gid ~]
    ~&  >  '%tahuti (on-leave)'
    =/  acl  (~(got by acls) gid.path)
    =.  acl  (~(del in acl) src.bowl)
    :-  ^-  (list card)
      :~  (update:effect [%acl gid.path acl])
      ==
    %=  this
      acls  (~(put by acls) gid.path acl)
    ==
  ==
::
::  another agent requests data, send data
::
++  on-peek
  |=  path=(pole knot)
  ^-  (unit (unit [mark vase]))
  ?+  path  ~|('%tahuti (on-peek)' (on-peek:default path))
    ::
      [%x %invites ~]
    ~&  >  '%tahuti (on-peek): show invites'
    [~ ~ [%noun !>(invites.this)]]
    ::
      [%x %groups ~]
    ~&  >  '%tahuti (on-peek): show groups'
    [~ ~ [%noun !>(groups.this)]]
    ::
      [%x =gid ~]
    ~&  >  '%tahuti (on-peek): show group data'
    =/  group  (~(got by groups) gid.path)
    =/  acl    (~(got by acls) gid.path)
    =/  reg    (~(got by regs) gid.path)
    =/  led    (~(got by leds) gid.path)
    =.  reg    (~(put in reg) `@tas`(scot %p host.group))
    =/  reg    (~(got by regs) gid.path)
    [~ ~ [%noun !>([group acl reg led])]]
    ::
      [%x =gid %net ~]
    ~&  >  '%tahuti (on-peek): show balances'
    =/  group  (~(got by groups) gid.path)
    =/  reg    (~(got by regs) gid.path)
    =.  reg    (~(put in reg) `@tas`(scot %p host.group))
    =/  led    (~(got by leds) gid.path)
    =/  net    ~(net tahuti [~(val by led) ~(tap in reg)])
    [~ ~ [%noun !>(net)]]
    ::
      [%x =gid %rei ~]
    ~&  >  '%tahuti (on-peek): show reimbursements'
    =/  group  (~(got by groups) gid.path)
    =/  reg    (~(got by regs) gid.path)
    =.  reg    (~(put in reg) `@tas`(scot %p host.group))
    =/  led    (~(got by leds) gid.path)
    =/  rei    ~(rei tahuti [~(val by led) ~(tap in reg)])
    [~ ~ [%noun !>(rei)]]
  ==
::
::  another agent sends data, receive data
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  [(list card) $_(this)]
  ?+  -.sign  (on-agent:default wire sign)
    ::
      %watch-ack
    ?~  p.sign
      ~&  >  '%tahuti (on-agent): subscription successful'
      [~ this]
    ~&  >>>  '%tahuti (on-agent): subscription failed'
    [~ this]
    ::  TODO: edit status of group to 'kicked'
    ::        which means that either the host
    ::        removed the agent or deleted the group
    ::  NOTE: maybe this agent has already left the group and no more
    ::        group data is present
      ::
      %kick
    !!
    ::
      %fact
    ?>  ?=(%tahuti-update p.cage.sign)
    =/  =update  !<(update q.cage.sign)
    =/  =gid  `@tas`(head wire)
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
      ~&  >  '%tahuti (on-agent): update access-control list'
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
::
::  Helper Core
::
|_  =bowl:gall
+*  this  .
    default  ~(. (default-agent this %|) bowl)
++  cull-data
  |=  =gid
  ^-  [=group =acl =reg =led]
  =/  group  (~(got by groups) gid)
  =/  acl    (~(got by acls) gid)
  =/  reg    (~(got by regs) gid)
  =/  led    (~(got by leds) gid)
  [group=group acl=acl reg=reg led=led]
++  effect
  |%
  ::  (give fact as gift - or update subscribers)
  ::
  ++  update
    |=  data=^update
    ^-  card
    =/  path  /[gid.data]
    =/  vase  !>  ^-  ^update  data
    [%give [%fact [path ~] [%tahuti-update vase]]]
  ::  (pass poke as task - or request action on agent)
  ::
  ++  action
    |=  [=ship data=^action]
    ^-  card
    =/  vase  !>  ^-  ^action  data
    [%pass ~ [%agent [ship %tahuti] [%poke [%tahuti-action vase]]]]
  --
--
