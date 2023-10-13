/-  *tahuti
/+  default-agent
/+  dbug
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
    =/  acl  (~(gut by acls) gid.action ^*((set member)))
    =.  acl  (~(put in acl) member.action)
    :-  ^-  (list card)
        ~
    %=  this
      acls  (~(put by acls) gid.action acl)
    ==
  ==
    :: if value changed notify subscriber
    :: [%give %fact ~[/group] %tahuti-update !>(`update`act)]~
    ::
++  on-arvo   on-arvo:default
++  on-watch  on-watch:default  :: subscribe
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
++  on-agent  on-agent:default
++  on-fail   on-fail:default
--
