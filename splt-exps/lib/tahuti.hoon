::    split expenses
::
|%
::  $ex: expense
::  $exes: expenses
+$  ex
  $:
    payer=@p
    amount=@ud
    involves=(list @p)
  ==
+$  exes  (list ex)
::
::++  add
::  ::    add expense to shared expense list
::  ::
::  |=  [=exes =ex]
::  ^-  exes
::  (snoc exes ex)
::
++  sum
  ::    total sum of expenses
  ::
  |=  [=exes]
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
++  gro
  ::    gross amount of members
  ::
  |=  [=exes]
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
++  net
  ::    net amount of members
  ::
  |=  [=exes ships=(list @p)]
  ^-  (map @p @rs)
  =/  net  *(map @p @rs)
  =/  i    0
  |-                            :: for each member
  ?:  =(i (lent ships))
    net
  =/  m  (snag i ships)         :: member
  =/  d  .0                     :: debit
  =/  c  .0                     :: credit
  =/  j  0
  |-                            :: for each expense
  ?:  =(j (lent exes))
    %=  ^$
      net  (~(put by net) [m (sub:rs c d)])
      i    +(i)
    ==
  =/  ex  (snag j exes)
  ?:  :: if, member is involved and is payer
      ::
      ?&
        ?!  .=  (find [m ~] involves.ex)  ~
        .=  m  payer.ex
      ==
      :: then, increase debit and credit
      ::
      %=  $
        d  (add:rs d (div:rs (sun:rs amount.ex) (sun:rs (lent involves.ex))))
        c  (add:rs c (sun:rs amount.ex))
        j  +(j)
      ==
  :: else
  ::
  ?~  :: if, member is only involved
      ::
      (find [m ~] involves.ex)
      :: then, increase debit
      ::
      %=  $
        d  (add:rs d (div:rs (sun:rs amount.ex) (sun:rs (lent involves.ex))))
        j  +(j)
      ==
  :: else
  ::
  ?:  :: if, member is only payer
      ::
      .=  m  payer.ex
      :: then, increase credit
      ::
      %=  $
        c  (add:rs c (sun:rs amount.ex))
        j  +(j)
      ==
  :: else, continue
  ::
  %=  $
    j  +(j)
  ==
--
