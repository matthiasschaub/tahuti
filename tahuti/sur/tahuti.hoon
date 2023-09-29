::    structure file (type definitions)
::
|%
::
::    group
::
+$  gid  @tas                     ::  uuid
+$  host  @p
+$  title  @t
+$  members  (set @p)  :: subscribers
+$  acl  (set @p)      :: access control list
+$  group
  $:
    =title
    =host
    =members
    =acl
  ==
+$  groups  (map gid group)
::
::    expense
::
+$  eid  @tas                     :: uuid
+$  ex                            :: expense
  $:  payer=@p
      amount=@ud                  :: in currency’s smallest unit
      involves=(list @p)          :: TODO: should be a set
      :: =id
      :: =title
      :: currency=[%usd]          :: three-letter ISO code
      :: involves=(list @p)
      :: involments=(map @p @ud)  :: how much am I involved: 0.2 * amount
      :: timestamp=@da
      :: description=@t
      :: tags=(set @tas)
  ==
+$  exes   (list ex)
+$  expenses        (map eid ex)
+$  group-expenses  (map gid expenses)
::
::    input requests/actions
::
+$  action
  $%  :: group actions performed by host
      ::
      [%add-group =gid =group]
      ::[%del-group =gid]
      ::[%edit-group =gid =title]  :: change title
      ::[%list-groups]
      ::[%join-group =gid =ship]  :: subscribe
      ::[%leave-group =gid =ship]  :: unsubscribe
      ::::
      ::[%add-member =gid =ship]  :: allow to subscribe
      ::[%del-member =gid =ship]  :: kick subscriber
      :::: expense actions performed by members
      ::::
      ::[%add-expense =gid =ex]
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
:: +$  update
::   $%  [%init-all =groups =acl =members]
::       [%init =gid =squad acl=ppl =ppl]
::       [%del =gid]
::       [%allow =gid =ship]
::       [%kick =gid =ship]
::       [%join =gid =ship]
::       [%leave =gid =ship]
::       [%pub =gid]
::       [%priv =gid]
::       [%title =gid =title]
::     ==
--
