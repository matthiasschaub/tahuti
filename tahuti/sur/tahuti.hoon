::    structure file (type definitions)
::
|%
::
::    group
::
+$  id         @tas                   ::  uuid
+$  title      @t
+$  host       @p
+$  group      [=id =title =host]
::
::    register of members (reg) and access-control-group (acl)
::
+$  register  (set @p)
+$  acl       (set @p)
::
::    maps
::
+$  groups    (map id group)
+$  regs      (map id register)
+$  acls      (map id acl)
::
::    expense
::
+$  eid  @tas                     :: uuid
+$  expense
  $:
    id=@tas
    title=@tas
    amount=@ud             :: in currency’s smallest unit
    currency=@tas          :: three-letter ISO code
    payer=@p
    :: date=@da
  ==
+$  ledger   (map id expense)     :: map expense-id to expense
+$  leds     (map id ledger)      :: map group-id to ledger
+$  ex                            :: expense
  $:  payer=@p
      amount=@ud
      involves=(list @p)          :: TODO: should be a set
      :: involments=(map @p @ud)  :: how much am I involved: 0.2 * amount
      :: description=@t
      :: tags=(set @tas)
  ==
+$  exes       (list ex)
:: +$  expenses  (map gid exes)
::
::    input requests/actions
::
+$  action
  $%  :: group actions performed by host
      ::
      [%add-group =group]
      [%invite =id =@p]    :: allow to subscribe (add to acl)
      [%join =id =host]    :: allow to subscribe (add to acl)
      ::[%del-group =gid]
      ::[%edit-group =gid =title]  :: change title
      ::[%list-groups]
      ::[%join-group =gid =ship]  :: subscribe
      ::[%leave-group =gid =ship]  :: unsubscribe
      ::::
      ::[%del-member =gid =ship]  :: kick subscriber
      :::: expense actions performed by members
      ::::
      [%add-expense =id =expense]
      ::[%del-expense =gid =eid]
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
  $%  [%group =id =group =register =acl]
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
