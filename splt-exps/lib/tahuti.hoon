/-  *tahuti
/+  *helper
::    split expenses
|%
++  tahuti
  |_  [=exes =fleet]
  ++  n  (lent exes)
  ::
  ++  sum
    ::    total sum of expenses
    ::
    ^-  @rs
    =/  i    0
    =/  sum  .0
    |-
    ?:  =(i n)
      sum
    %=  $
      sum  (add:rs sum amount:(snag i exes))
      i    +(i)
    ==
  ::
  ++  gro
    ::    gross amount of ships
    ::
    ^-  (map @p @rs)
    =/  i    0
    =/  gro  *(map @p @rs)
    |-
    ?:  =(i n)
      gro
    =/  ex  (snag i exes)
    =/  current  (~(gut by gro) payer:ex .0)
    =/  total    (add:rs current amount:ex)
    %=  $
      gro  (~(put by gro) [payer:ex total])
      i    +(i)
    ==
  ::
  ++  net
    ::    net amount of ships
    ::
    ^-  (map @p @rs)
    =/  net  *(map @p @rs)
    =/  i    0
    |-                            :: for each ship
    ?:  =(i (lent fleet))
      net
    =/  ship  (snag i fleet)
    =/  d     .0                  :: debit
    =/  c     .0                  :: credit
    =/  j     0
    |-                            :: for each expense
    ?:  =(j n)
      %=  ^$
        net  (~(put by net) [ship (sub:rs c d)])
        i    +(i)
      ==
    =/  ex  (snag j exes)
    ?:  :: if, ship is involved and is payer
        ::
        ?&
          ?!  .=  (find [ship ~] involves.ex)  ~
          .=  ship  payer.ex
        ==
        :: then, increase debit and credit
        ::
        %=  $
          d  (add:rs d (div:rs amount.ex (sun:rs (lent involves.ex))))
          c  (add:rs c amount.ex)
          j  +(j)
        ==
    :: else
    ::
    ?:  :: if, ship is only involved
        ::
        ?!  .=  (find [ship ~] involves.ex)  ~
        :: then, increase debit
        ::
        %=  $
          d  (add:rs d (div:rs amount.ex (sun:rs (lent involves.ex))))
          j  +(j)
        ==
    :: else
    ::
    ?:  :: if, ship is only payer
        ::
        .=  ship  payer.ex
        :: then, increase credit
        ::
        %=  $
          c  (add:rs c amount.ex)
          j  +(j)
        ==
    :: else, continue
    ::
    %=($ i +(i))
  ++  ind
    ::  creditor and debitor indices
    ::
    ::    indices are shifted by one to account for the source node
    ::
    ^-  [(list @ud) (list @ud)]
    =/  net  ~(val by net)
    =/  c  *(list @ud)            :: creditor indices
    =/  d  *(list @ud)            :: debitor indices
    =/  i  0
    |-
    ?:  .=  i  (lent net)
      [c d]
    ?:  (gth:rs (snag i net) .0)
      %=  $
        c  (snoc c +(i))
        i  +(i)
      ==
    ?:  (lth:rs (snag i net) .0)
      %=  $
        d  (snoc d +(i))
        i  +(i)
      ==
    %=($ i +(i))
  ++  adj
  ::  adjacency matrix with net amount as capacities
  ::
  ::    the adjacency matrix contains a source and sink node.
  ::
  ::    debitors are adjacent to the source node.
  ::    creditors are adjacent to the sink node.
  ::
  ::    debitors are connected to themself and to the creditors.
  ::
  ::    TODO: is the map of net amount ordered? 
  ::      Should ships have an id which translates to node in graph?
  ::
  ^-  (list (list @ud))
  ::  .g: graph
  ::  .c: creditor indices
  ::  .d: debitor indices
  ::  .v: vertex (row)
  ::  .u: vertex (col)
  =/  g  (reap n (reap n 0))
  ::  TODO:     how to define inf equivalent value?
  ::
  =/  inf       100
  =/  [c=(list @ud) d=(list @ud)]  ind
  =/  v  0
  |-
  ?.  =(v (lent d))
    ::  assigning expenses as capacities to edges
    ::
    =/  u  0
    |-
    ?.  =(u (lent c))
      :: debitor -> creditor edges
      :: are connected by edges with infinit capacity
      ::
      %=  $
        g  (set:edge g v u inf)
        u  +(u)
      ==
    =/  u  0
    |-
    ?.  =(u (lent d))
      :: debitor -> debitor ediges
      :: are connected by edges with infinit capacity
      ::
      ?:  =(v u)
        ::  avoid self-loop
        ::
        %=($ u +(u))
      =.  g  (set:edge g v u inf)
      =.  g  (set:edge g u v inf)
      %=  $
        g  g
        u  +(u)
      ==
    %=(^^$ v +(v))
  =/  v  0
  |-
  ?.  =(v (lent d))
    ::  source -> debitor edges
    ::
    %=  $
      g  g  :: TODO
      v  +(v)
    ==
  =/  v  0
  |-
  ?.  =(v (lent d))
    ::  creditor -> sink edges
    ::
    %=  $
      g  g  :: TODO
      v  +(v)
    ==
  g
  --
--
