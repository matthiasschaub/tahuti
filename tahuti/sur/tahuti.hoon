::    structure file (type definitions)
::
|%
::
::    group
::
+$  gid        @tas                   ::  uuid
+$  title      @t
+$  host       @p
+$  group      [=gid =title =host]
::
::    acls and members
::
+$  groups    (map gid group)
+$  acls      (map gid (set @p))
+$  members   (map gid (set @p))
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
+$  expenses    (map eid ex)
+$  gexpenses  (map gid expenses)
::
::    input requests/actions
::
+$  action
  $%  :: group actions performed by host
      ::
      [%add-group =gid =group]
      [%add-member =gid member=@p]    :: allow to subscribe (add to acl)
      [%subscribe =gid =host]    :: allow to subscribe (add to acl)
      ::[%del-group =gid]
      ::[%edit-group =gid =title]  :: change title
      ::[%list-groups]
      ::[%join-group =gid =ship]  :: subscribe
      ::[%leave-group =gid =ship]  :: unsubscribe
      ::::
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
+$  update
  $%  [%init =gid =group acl=(set @p) members=(set @p)]
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
