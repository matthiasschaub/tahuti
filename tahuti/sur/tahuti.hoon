/+  mip  ::  maps of maps
::    structure file (type definitions)
::
|%
::
::  state
::
+$  versioned-state
  $%  state-0
      state-1
      state-2
      state-3
  ==
+$  state-3         :: latest state
  $:  %3
      =invites
      =groups
      =regs         :: registers
      =acls         :: access-control lists
      =leds         :: ledgers
  ==
::
::    group
::
+$  gid       @tas  ::  group uuid
+$  title     @t
+$  host      @p
+$  currency  @tas  ::  three-letter ISO codesur
+$  public    ?
+$  group
  $:
    =gid
    =title
    =host
    =currency
    =public
  ==
::
::    register of members (reg)
::    access-control list (acl)
::
+$  member    @tas
+$  register  (set member)
+$  reg       (set member)
+$  acl       (set @p)
::
::    expense
::
+$  eid       @tas  ::  expense uuid
+$  amount    @ud   ::  in currency’s smallest unit
+$  payer     member
+$  date      @da
+$  involves  (list member)
+$  expense
  $:
    =gid
    =eid
    =title
    =amount
    =currency
    =payer
    =date
    =involves
  ==
::
::    maps
::
+$  groups    (map gid group)
+$  invites   (map gid group)
+$  ledger    (map eid expense)
+$  led       (map eid expense)
+$  regs      (map gid register)
+$  acls      (map gid acl)
+$  leds      (map gid ledger)
::
::    statistics
::
+$  net  (map member @s)
+$  rei  (mip:mip member member @ud)  :: reimbursements
::
::    input requests/actions
::
+$  action
  $%  ::  group actions
      ::
      [%add-group =group]
      [%del-group =gid]
      ::
      ::  member actions
      ::
      [%add-member =gid =member]
      ::
      [%add-invite =group]
      [%del-invite =group]
      ::
      [%allow =gid =@p]     :: allow to subscribe
      [%kick =gid =@p]      :: kick subscriber
      [%join =gid =host]    :: subscribe
      ::
      ::  expense actions
      ::
      [%add-expense =gid =expense]
      [%del-expense =gid =eid]
  ==
::
::    output events/updater
::
::  these are all the possible events that can be sent to subscribers.
::
+$  update
  $%  [%group =gid =group =register =acl =ledger]
      [%ledger =gid =ledger]
      [%acl =gid =acl]
      [%reg =gid =reg]
    ==
::
::    old / legacy
::
+$  state-0
  $:  %0
      groups=groups-0
      regs=regs-0
      =acls
      leds=leds-0
  ==
+$  state-1
  $:  %1
      invites=invites-0
      groups=groups-0
      regs=regs-0
      =acls
      leds=leds-0
  ==
+$  state-2
  $:  %2
      =invites
      =groups
      regs=regs-0
      =acls
      leds=leds-0
  ==
+$  group-0
  $:
    =gid
    =title
    =host
    =currency
  ==
+$  groups-0    (map gid group-0)
+$  invites-0   (map gid group-0)
+$  register-0  (set @p)
+$  reg-0       (set @p)
+$  expense-0
  $:
    =gid
    =eid
    =title
    =amount
    =currency
    payer=@p
    =date
    involves=(list @p)
  ==
+$  ledger-0    (map eid expense-0)
+$  led-0       (map eid expense-0)
+$  regs-0      (map gid reg-0)
+$  leds-0      (map gid led-0)
--
