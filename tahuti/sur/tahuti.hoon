/+  mip  ::  maps of maps
::    structure file (type definitions)
::
|%
::
::    group
::
+$  gid       @tas     ::  group uuid
+$  title     @t
+$  host      @p
+$  currency  @tas
+$  public    ?
+$  group
  $:
    =gid
    =title
    =host
    =currency          ::  three-letter ISO codesur
    =public
  ==
::
::    register of members (reg)
::    access-control list (acl)
::
+$  member
  $?
    @tas
    @p
  ==
+$  register  (set @p)
+$  reg       (set @p)
+$  acl       (set @p)
::
::    expense
::
+$  eid       @tas     ::  expense uuid
+$  amount    @ud      ::  in currency’s smallest unit
+$  payer     @p
+$  date      @da
+$  involves  (list @p)
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
::    legacy
::
+$  ex
  $:  payer=@p
      amount=@ud
      involves=(list @p)
  ==
+$  exes      (list ex)
::
::    statistics
::
+$  net  (map @p @s)
+$  rei  (mip:mip @p @p @ud)  :: reimbursements
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
::    old
::
+$  group-0
  $:
    =gid
    =title
    =host
    =currency
  ==
+$  groups-0   (map gid group-0)
+$  invites-0  (map gid group-0)
--
