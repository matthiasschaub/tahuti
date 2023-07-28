::    split expenses
::
/-  *tahuti, *graph
/+  *graph, *edmonds-karp
::
|%
++  tahuti
  |_  [exes=exes fleet=fleet]
  ++  sum
    ::    total sum of expenses
    ::
    ^-  @rs
    =/  n    (lent exes)
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
    =/  n    (lent exes)
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
    =/  n    (lent exes)
    =/  i    0
    =/  net  *(map @p @rs)
    |-                            :: for each ship
    ?:  =(i (lent fleet))
      net
    =/  ship  (snag i fleet)
    =/  d     .0                  :: debit
    =/  c     .0                  :: cr
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
        c  (snoc c i)
        i  +(i)
      ==
    ?:  (lth:rs (snag i net) .0)
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
  =/  g    (reap (add n 2) (reap (add n 2) .0))
  ::  TODO:     how to define inf equivalent value?
  ::
  =/  [c=(list @ud) d=(list @ud)]  ind
  =/  inf  .100
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
      ::  TODO:
      ::    use absolute value
      ::    is val by net ordered?
      ::
      g  (set:edge g 0 v (snag (sub v 1) ~(val by net)))
      i  +(i)
    ==
  =/  j  0
  |-
  ?.  =(j (lent d))
    ::  creditor -> sink edges
    ::
    =.  u  +((snag j c))
    %=  $
      ::  TODO:
      ::    use absolute value
      ::    is val by net ordered?
      ::
      g  (set:edge g u +(n) (snag (sub u 1) ~(val by net)))
      j  +(j)
    ==
  g
  ++  rei
    :: reimbursement
    ::
    (edmonds-karp [adj 0 +((lent fleet))])
  --
--
