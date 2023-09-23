/-  *tahuti
|%
++  expenses
  |%
  ++  one
    ^-  ex
    :*
      payer=~zod
      amount=2
      involves=(limo [~zod ~])
    ==
  ++  two
    ^-  ex
    :*
      payer=~zod
      amount=2
      involves=(limo [~zod ~nus ~])
    ==
  --
++  groups
  |%
  ++  one
    ^-  group
    :*
      title='foo'
      host=~zod
      members=(silt (limo [~zod ~]))
    ==
  --
--
