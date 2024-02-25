::    statistics
::
/-  *tahuti, *graph
/+  *graph, *edmonds-karp, mip
::
|_  [exs=(list expense) reg=(list member)]
++  sum
  ::    total sum of expenses
  ::
  ^-  @ud
  =/  n    (lent exs)
  =/  i    0
  =/  sum  0
  |-
  ?:  =(i n)
    sum
  %=  $
    sum  (add sum amount:(snag i exs))
    i    +(i)
  ==
::
++  inf  (mul sum 2)
++  gro
  ::    gross amount of ships
  ::
  ^-  (map member @ud)
  =/  n    (lent exs)
  =/  i    0
  =/  gro  *(map member @ud)
  |-
  ?:  =(i n)
    gro
  =/  ex  (snag i exs)
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
  ::  rounding strategy of fra:si is half round down
  ::
  ^-  (map member @s)
  =/  n    (lent exs)
  =/  i    0
  =/  net  *(map member @s)
  |-                            :: for each ship
  ?:  =(i (lent reg))
    net
  =/  ship  (snag i reg)
  =/  d     --0                 :: debit
  =/  c     --0                 :: credit
  =/  j     0
  |-                            :: for each expense
  ?:  =(j n)
    %=  ^$
      net  (~(put by net) [ship (dif:si c d)])
      i    +(i)
    ==
  =/  ex  (snag j exs)
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
  %=($ j +(j))
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
  =/  n    (lent reg)
  =/  g    (reap (add n 2) (reap (add n 2) 0))
  =/  [c=(list @ud) d=(list @ud)]  ind
  ::  indices are shifted by one to account for the source node
  ::
  =/  i    0
  =/  j    0
  =/  v    0
  =/  u    0
  ::  for each debitor
  ::
  |-
  ?.  =(i (lent d))
    =.  v  +((snag i d))
    =.  j  0
    ::  for each creditor
    ::
    |-
    ?.  =(j (lent c))
      ::  create debitor -> creditor edges with infinit capacity
      ::
      =.  u  +((snag j c))
      %=  $
        g  (set:edge g v u inf)
        j  +(j)
      ==
    =.  j  0
    ::  for each debitor
    ::
    |-
    ?.  =(j (lent d))
      ::  create debitor -> debitor edges with infinit capacity
      ::
      =.  u  +((snag j d))
      ::  if, same node
      ::
      ?:  =(v u)
        ::  then, do not create edge (avoid self-loop)
        ::
        %=($ j +(j))
      =.  g  (set:edge g v u inf)
      =.  g  (set:edge g u v inf)
      %=  $
        g  g
        j  +(j)
      ==
    %=(^^$ i +(i))
  ::  for each debitor
  ::
  =.  i  0
  |-
  ?.  =(i (lent d))
    ::  create source -> debitor edges
    ::
    =.  v  +((snag i d))
    %=  $
      g  (set:edge g 0 v (abs:si (snag (sub v 1) ~(val by net))))
      i  +(i)
    ==
  ::  for each creditor
  ::
  =.  j  0
  |-
  ?.  =(j (lent c))
    ::  create creditor -> sink edges
    ::
    =.  u  +((snag j c))
    %=  $
      g  (set:edge g u +(n) (abs:si (snag (sub u 1) ~(val by net))))
      j  +(j)
    ==
  g
++  rei
  ^-  ^rei
  ::  .r: reimbursements
  ::  .g: graph
  ::  .s: ships
  ::  .n: number of ships
  ::  .c: creditor indices
  ::  .d: debitor indices
  ::  .v: vertex (row)
  ::  .u: vertex (col)
  ::  .i: counter
  ::  .j: counter
  ::  .a: amount
  ::
  =/  g  (tail (need (edmonds-karp [adj 0 +((lent reg)) inf])))
  =/  s  ~(tap in ~(key by net))
  =/  r  *^rei
  =/  n  (lent s)
  =/  [c=(list @ud) d=(list @ud)]  ind
  ::  indices are shifted by one to account for the source node
  ::
  =/  i    0
  =/  j    0
  =/  v    0
  =/  u    0
  =/  a    0
  ::  for each debitor
  ::
  |-
  ?.  =(i (lent d))
    =.  v  (snag i d)
    ::  for each creditor
    ::
    =.  j  0
    |-
    ?.  =(j (lent c))
      ::  debitor -> creditor edge
      ::
      =.  u  (snag j c)
      =.  a  (get:edge g +(v) +(u))
      =.  r  (~(put bi:mip r) (snag v s) (snag u s) a)
      %=  $
        r  r
        j  +(j)
      ==
    ::  for each debitor
    ::
    =.  j  0
    |-
    ?.  =(j (lent d))
      ::  debitor -> debitor edge
      ::
      =.  u  (snag j d)
      ::  if, same node
      ::
      ?:  =(v u)
        ::  then, avoid self-loop
        ::
        %=($ j +(j))
      ::  else,
      ::
      =.  a  (get:edge g +(v) +(u))
      =.  r  (~(put bi:mip r) (snag v s) (snag u s) a)
      =.  a  (get:edge g +(u) +(v))
      =.  r  (~(put bi:mip r) (snag u s) (snag v s) a)
      %=  $
        r  r
        j  +(j)
      ==
    %=(^^$ i +(i))
  r
--
