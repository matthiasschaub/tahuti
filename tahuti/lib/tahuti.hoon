::    split expenses
::
/-  *tahuti, *graph
/+  *graph, *edmonds-karp
::
|%
++  tahuti
  |_  [exes=exes fleet=(list @p)]
  ++  sum
    ::    total sum of expenses
    ::
    ^-  @ud
    =/  n    (lent exes)
    =/  i    0
    =/  sum  0
    |-
    ?:  =(i n)
      sum
    %=  $
      sum  (add sum amount:(snag i exes))
      i    +(i)
    ==
  ::
  ++  gro
    ::    gross amount of ships
    ::
    ^-  (map @p @ud)
    =/  n    (lent exes)
    =/  i    0
    =/  gro  *(map @p @ud)
    |-
    ?:  =(i n)
      gro
    =/  ex  (snag i exes)
    =/  current  (~(gut by gro) payer:ex 0)
    =/  total    (add current amount:ex)
    %=  $
      gro  (~(put by gro) [payer:ex total])
      i    +(i)
    ==
  ::
  ++  net
    ::    net amount of ships
    ::
    ^-  (map @p @sd)
    =/  n    (lent exes)
    =/  i    0
    =/  net  *(map @p @sd)
    |-                            :: for each ship
    ?:  =(i (lent fleet))
      net
    =/  ship  (snag i fleet)
    =/  d     --0                 :: debit
    =/  c     --0                 :: credit
    =/  j     0
    |-                            :: for each expense
    ?:  =(j n)
      %=  ^$
        net  (~(put by net) [ship (dif:si c d)])
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
          d  (sum:si d (fra:si (new:si & amount.ex) (new:si & (lent involves.ex))))
          c  (sum:si c (new:si & amount.ex))
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
          d  (sum:si d (fra:si (new:si & amount.ex) (new:si & (lent involves.ex))))
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
          c  (sum:si c (new:si & amount.ex))
          j  +(j)
        ==
    :: else, continue
    ::
    %=($ i +(i))
  ++  ind
    ::  creditor and debitor indices
    ::
    ^-  [(list @ud) (list @ud)]
    =/  net  ~(val by net)
    =/  c  *(list @ud)            :: creditor indices
    =/  d  *(list @ud)            :: debitor indices
    =/  i  0
    |-
    ?:  .=  i  (lent net)
      [c d]
    ?:  =((cmp:si (snag i net) --0) --1)
      %=  $
        c  (snoc c i)
        i  +(i)
      ==
    ?:  =((cmp:si (snag i net) --0) -1)
      %=  $
        d  (snoc d i)
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
    ^-  graph
    ::  .n: size
    ::  .g: graph
    ::  .c: creditor indices
    ::  .d: debitor indices
    ::  .v: vertex (row)
    ::  .u: vertex (col)
    ::
    =/  n    (lent fleet)
    =/  g    (reap (add n 2) (reap (add n 2) 0))
    ::  TODO:     how to define inf equivalent value?
    ::
    =/  [c=(list @ud) d=(list @ud)]  ind
    =/  inf  100
    ::    indices are shifted by one to account for the source node
    ::
    =/  i    0
    =/  j    0
    =/  v    0
    =/  u    0
    |-
    ?.  =(i (lent d))
      ::  assigning expenses as capacities to edges
      ::
      =.  v  +((snag i d))
      =.  j  0
      |-
      ?.  =(j (lent c))
        :: debitor -> creditor edges
        :: are connected by edges with infinit capacity
        ::
        =.  u  +((snag j c))
        %=  $
          g  (set:edge g v u inf)
          j  +(j)
        ==
      =.  j  0
      |-
      ?.  =(j (lent d))
        :: debitor -> debitor edges
        :: are connected by edges with infinit capacity
        ::
        =.  u  +((snag j d))
        ?:  =(v u)
          ::  avoid self-loop
          ::
          %=($ j +(j))
        =.  g  (set:edge g v u inf)
        =.  g  (set:edge g u v inf)
        %=  $
          g  g
          j  +(j)
        ==
      %=(^^$ i +(i))
    =.  i  0
    |-
    ?.  =(i (lent d))
      ::  source -> debitor edges
      ::
      =.  v  +((snag i d))
      %=  $
        g  (set:edge g 0 v (abs:si (snag (sub v 1) ~(val by net))))
        i  +(i)
      ==
    =/  j  0
    |-
    ?.  =(j (lent d))
      ::  creditor -> sink edges
      ::
      =.  u  +((snag j c))
      %=  $
        g  (set:edge g u +(n) (abs:si (snag (sub u 1) ~(val by net))))
        j  +(j)
      ==
    g
  ++  rei
    :: reimbursement
    ::
    (edmonds-karp [adj 0 +((lent fleet))])
  --
--
