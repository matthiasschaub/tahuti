/-  *tahuti
/+  *test
/+  *json-reparser
/=  fixtures  /tests/fixtures
::
|%
++  test-ships-enjs
  %+  expect-eq
    !>  '["~nus"]'
    !>  (en:json:html (ships:enjs one:ships:fixtures))
::
++  test-group-enjs
  %+  expect-eq
    !>  '{"title":"foo","host":"~zod","gid":"e7334af6-be91-426d-9109-11191c98acdc"}'
    !>  (en:json:html (group:enjs one:group:fixtures))
::
++  test-group-dejs
  %+  expect-eq
    !>  one:group:fixtures
    !>  (group:dejs (group:enjs one:group:fixtures))
::
++  test-groups-enjs
  %+  expect-eq
    !>  '[{"title":"foo","host":"~zod","gid":"e7334af6-be91-426d-9109-11191c98acdc"}]'
    !>  (en:json:html (groups:enjs one:groups:fixtures))
::
++  test-expense-enjs
  ;:  weld
    %+  expect-eq
      !>  '{"amount":2,"involves":["~zod"],"payer":"~zod"}'
      !>  (en:json:html (expense:enjs one:expense:fixtures))
    %+  expect-eq
      !>  '{"amount":2,"involves":["~zod","~nus"],"payer":"~zod"}'
      !>  (en:json:html (expense:enjs two:expense:fixtures))
  ==
::
++  test-expense-dejs
  ;:  weld
    %+  expect-eq
      !>  one:expense:fixtures
      !>  (expense:dejs (expense:enjs one:expense:fixtures))
    %+  expect-eq
      !>  two:expense:fixtures
      !>  (expense:dejs (expense:enjs two:expense:fixtures))
  ==
::
--
