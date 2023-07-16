/-  *tahuti
::    split expenses
|%
++  tahuti
|_  [=exes =fleet]
::
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
  ?:  =(j (lent exes))
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
--
--
