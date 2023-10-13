/-  *tahuti
/+  *test
/=  fixtures  /tests/fixtures
/=  agent     /app/tahuti
|%
::  build an example bowl
::
++  bowl
  |=  run=@ud
  =/  run  3
  ^-  bowl:gall
  :*  [our=~zod src=~zod dap=%tahuti]
      [wex=~ sup=~]
      :*
        ::  .act:  number of moves our agent has processed so far.
        ::
        act=run
        eny=0v0
        ::  .now:  each subsequent event takes place
        ::         one second subsequent to the previous event.
        ::
        now=(add (mul run ~s1) *time)
        byk=[~zod %tahuti [%ud run]]
      ==
  ==
::  build a reference state
::
+$  state
  $:  %0
      =groups
  ==
--
|%
++  test-poke-add-group
  =|  run=@ud
  =^  move  agent
    %-  %~  on-poke  agent
        (bowl run)
    [%tahuti-action !>([%add-group one:group:fixtures])]

  =+  !<(=state on-save:agent)
  %+  expect-eq
    !>  ^-  groups  (malt [[%e7334af6-be91-426d-9109-11191c98acdc one:group:fixtures] ~])
    !>  groups.state
--
