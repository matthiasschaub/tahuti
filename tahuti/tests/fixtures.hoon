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
++  group
  |%
  ++  one
    ^-  ^group
    :*
      title='foo'
      host=~zod
      members=(silt (limo [~nus ~]))
      acl=(silt (limo [~nus ~]))
    ==
  --
++  groups
  |%
  ++  one
    ^-  ^groups
    (malt [[%e7334af6-be91-426d-9109-11191c98acdc one:group] ~])
  --
--
