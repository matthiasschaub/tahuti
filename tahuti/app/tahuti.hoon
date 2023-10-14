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
  ~&  >  '%tahuti: initialize'
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
  |=  [=mark =vase]
  ^-  [(list card) $_(this)]
  ~&  >  '%tahuti: handle poke'
  ?>  ?=(%tahuti-action mark)
  =/  action  !<(action vase)
  ?-  -.action
    ::
      %add-group
    ::  TODO:  assert group not in groups
    ~&  >  '%tahuti: %add-group'
    :-  ^-  (list card)
        ~
    %=  this
      groups   (~(put by groups) gid.action group.action)
    ==
    ::
      %add-member
    ~&  >  '%tahuti: %add-member'
    =/  acl  (~(gut by acls) gid.action ^*((set @p)))
    =.  acl  (~(put in acl) member.action)
    :-  ^-  (list card)
        ~
    %=  this
      acls  (~(put by acls) gid.action acl)
    ==
    ::
      %subscribe
    ~&  gid.action
    :-  ^-  (list card)
        :~  [%pass /[gid.action] %agent [host.action %tahuti] %watch /[gid.action]]
        ==
    this
  ==
    :: if value changed notify subscriber
    :: [%give %fact ~[/group] %tahuti-update !>(`update`act)]~
    ::
++  on-arvo   on-arvo:default
++  on-watch  :: subscribe
  |=  =path
  |^  ^-  [(list card) $_(this)]
  ?>  ?=([@t ~] path)
  =/  gid  i.path
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
        %-  ~(got by groups)   gid
        %-  ~(got by members)  gid
        %-  ~(got by acls)     gid
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
  ?>  ?=([@t ~] wire)
  =/  =gid  i.wire
  ?+    -.sign  (on-agent:default wire sign)
    ::
      %watch-ack
    ?~  p.sign
      ~&  >  '%tahuti: subscribe succeeded!'
      [~ this]
    ~&  >>>  '%tahuti: subscribe failed!'
    [~ this]
    ::
      %fact
    ~&  >>  [%fact p.cage.sign]
    ?>  ?=(%tahuti-update p.cage.sign)
    ~&  >>  !<(update q.cage.sign)
    =/  result=update  !<(update q.cage.sign)
    ?-  -.result
      ::
        %init
      [~ this]
    ==
  ==
++  on-fail   on-fail:default
--
