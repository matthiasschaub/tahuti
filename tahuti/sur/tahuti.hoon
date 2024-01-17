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
+$  group
  $:
    =gid
    =title
    =host
    =currency          ::  three-letter ISO code
  ==
::
::    invites
::
+$  invite    [=gid =host]
+$  invites   (set [=gid =host])
::
::    register of members (reg)
::    access-control list (acl)
::
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
      [%add-invite =gid =host]
      [%del-invite =gid =host]
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
--
