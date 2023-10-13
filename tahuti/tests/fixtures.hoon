/-  *tahuti
|%
++  ships
  |%
  ++  one
    ^-  (set @p)
    (silt (limo [~nus ~]))
  --
++  group
  |%
  ++  one
    ^-  ^group
    :*
      gid=%e7334af6-be91-426d-9109-11191c98acdc
      title='foo'
      host=~zod
    ==
  --
++  groups
  |%
  ++  one
    ^-  ^groups
    (malt [[%e7334af6-be91-426d-9109-11191c98acdc one:group] ~])
  --
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
