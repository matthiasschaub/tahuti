::    structure file (type definitions)
::
|%
::
::    group
::
+$  gid         @tas                ::  uuid
+$  title      @t
+$  host       @p
+$  group      [=gid =title =host]
::
::    register of members (reg)
::    access-control-group (acl)
::
+$  register  (set @p)
+$  acl       (set @p)
::
::    expense
::
+$  eid  @tas                      :: uuid
+$  expense
  $:
    =gid
    =eid
    title=@tas
    amount=@ud             :: in currency’s smallest unit
    currency=@tas          :: three-letter ISO code
    payer=@p
    date=@da
  ==
+$  ledger   (map eid expense)     :: map expense-id to expense
::
::    maps
::
+$  groups   (map gid group)
+$  regs     (map gid register)
+$  acls     (map gid acl)
+$  leds     (map gid ledger)      :: map group-id to ledger
::
::    legacy
::
+$  ex                            :: expense
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
      [%invite =gid =@p]    :: allow to subscribe (add to acl)
      [%join =gid =host]    :: allow to subscribe (add to acl)
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
