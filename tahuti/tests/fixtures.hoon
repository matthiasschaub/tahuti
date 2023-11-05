/-  *tahuti
|%
++  expense
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
--
