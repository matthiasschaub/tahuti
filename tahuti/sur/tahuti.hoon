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
::    register of members (reg)
::    access-control list (acl)
::
+$  register  (set @p)
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
+$  regs      (map gid register)
+$  acls      (map gid acl)
+$  leds      (map gid ledger)
::
::    legacy
::
+$  ex
  $:  payer=@p
      amount=@ud
      involves=(list @p)          :: TODO: should be a set
      :: involments=(map @p @ud)  :: how much am I involved: 0.2 * amount
      :: description=@t
      :: tags=(set @tas)
  ==
+$  exes       (list ex)
::
::    input requests/actions
::
+$  action
  $%  :: group actions performed by host
      ::
      [%add-group =group]
      [%invite =gid =@p]    :: allow to subscribe
      [%join =gid =host]    :: subscribe
      [%del-group =gid]
      ::[%edit-group =gid =title]  :: change title
      ::[%list-groups]
      ::[%join-group =gid =ship]  :: subscribe
      ::[%leave-group =gid =ship]  :: unsubscribe
      ::::
      ::[%del-member =gid =ship]  :: kick subscriber
      :::: expense actions performed by members
      ::::
      [%add-expense =gid =expense]
      [%del-expense =gid =eid]
      ::[%edit-expense =gid =eid =ex]
      ::[%list-expenses =gid]
      ::[%list-balances =gid]
      ::[%list-reimbursments =gid]
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
::       [%del =gid]
::       [%allow =gid =ship]
::       [%kick =gid =ship]
::       [%join =gid =ship]
::       [%leave =gid =ship]
::       [%pub =gid]
::       [%priv =gid]
::       [%title =gid =title]
    ==
--
