/-  *tahuti
/+  default-agent  :: agent arm defaults
/+  agentio        :: agent input/output helper
/+  dbug           :: debug wrapper for agent
::
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  $:  [%0 =groups =members =acls]
  ==
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-0                     :: bunt value with name
=*  state  -                    :: refer to state 0
^-  agent:gall
|_  =bowl:gall
+*  this  .
    default  ~(. (default-agent this %.n) bowl)
::
++  on-init
  ^-  [(list card) $_(this)]
  ~&  >  '%tahuti (on-init)'
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
++  on-poke  :: one-off request
  |=  [=mark =vase]
  ^-  [(list card) $_(this)]
  ~&  >  '%tahuti (on-poke)'
  ?>  ?=(%tahuti-action mark)
  =/  action  !<(action vase)
  ?-  -.action
    ::
      %add-group
    ::  TODO:  assert group not in groups
    ~&  >  '%tahuti (on-poke): add group'
    :-  ^-  (list card)
        ~
    %=  this
      groups   (~(put by groups) gid.action group.action)
    ==
    ::
      %add-member
    ~&  >  '%tahuti (on-poke): add member'
    =/  group  (~(got by groups) gid.action)
    ?>  =(our.bowl host.group)
    ?<  =(our.bowl member.action)
    =/  acl  (~(gut by acls) gid.action ^*((set @p)))
    =.  acl  (~(put in acl) member.action)
    :-  ^-  (list card)
      :: :~  %+  fact:agentio
      ::       :-  %group-change  !>(`update`[%add-member gid.action member.action])
      ::       ~[/local/all /[name.gid.act]]
      [%give %fact [/[gid.action] ~] %tahuti-update !>(`update`[%group gid.action group acl acl])]~  :: notify subscriber
        ::
    %=  this
      acls     (~(put by acls) gid.action acl)
      members  (~(put by members) gid.action acl)
    ==
    ::
      %join
      :: subscribe to a group hosted on another ship
    ~&  >  '%tahuti (on-poke): join group'
    =/  path  /[gid.action]
    :-  ^-  (list card)
        :~  [%pass path %agent [host.action %tahuti] %watch path]
        ==
    this
  ==
++  on-arvo   on-arvo:default
++  on-watch  :: subscribe
  :: on new subscription, send a %fact back with an empty path,
  :: which will only go to the new subscriber.
  |=  =path
  |^  ^-  [(list card) $_(this)]
  ?>  ?=([@ ~] path)
  =/  =gid  `@tas`i.path
  ~&  'tahuti (on-watch)'  :: TODO add gid
  :-  ^-  (list card)
      [(init gid) ~]
  this
  ::
  ++  init
    |=  =gid
    ^-  card
    %+  fact-init:agentio  %tahuti-update
    !>  ^-  update
    :*  %init
        gid
        (~(got by groups) gid)
        (~(got by members) gid)
        (~(got by acls) gid)
    ==
  --
++  on-leave  on-leave:default  :: unsubscribe
++  on-peek                     :: one-off read-only action (scry endpoint)
  |=  =path
  ^-  (unit (unit [mark vase]))
  ?+  path  (on-peek:default path)
    ::
      [%x %groups ~]
    [~ ~ [%noun !>(groups.this)]]
    ::
      [%x %members ~]
    [~ ~ [%noun !>(members.this)]]
    ::
      [%x %acls ~]
    [~ ~ [%noun !>(acls.this)]]
  ==
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  [(list card) $_(this)]
  ?>  ?=([@ ~] wire)
  =/  =gid  `@tas`i.wire
  ~&  >  '%tahuti (on-agent)'  :: TODO add gid
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
    ?>  =(gid gid.update)
    ?-  -.update
      ::
        %init
      ~&  >  '%tahuti (on-agent): initialize group'
      :-  ^-  (list card)
          :~  (fact:agentio cage.sign [/[gid] ~])
          ==
      %=  this
        groups   (~(put by groups) gid group.update)
        acls     (~(put by acls) gid acl.update)
        members  (~(put by members) gid members.update)
      ==
      ::
        %group
      ~&  >  '%tahuti (on-agent): update group'
      :-  ^-  (list card)
          :~  (fact:agentio cage.sign [/[gid] ~])
          ==
      %=  this
        groups   (~(put by groups) gid group.update)
        acls     (~(put by acls) gid acl.update)
        members  (~(put by members) gid members.update)
      ==
    ==
  ==
++  on-fail   on-fail:default
--
