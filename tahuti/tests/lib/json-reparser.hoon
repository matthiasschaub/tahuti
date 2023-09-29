/-  *tahuti
/+  *test
/+  *json-reparser
/=  fixtures  /tests/fixtures
::
|%
++  test-ex-to-js
  ;:  weld
    %+  expect-eq
      !>  (trip '{"amount":2,"involves":["~zod"],"payer":"~zod"}')
      !>  (en-json:html (ex-to-js one:expense:fixtures))
    %+  expect-eq
      !>  (trip '{"amount":2,"involves":["~zod","~nus"],"payer":"~zod"}')
      !>  (en-json:html (ex-to-js two:expense:fixtures))
  ==
::
++  test-ex-from-js
  ;:  weld
    %+  expect-eq
      !>  one:expense:fixtures
      !>  (ex-from-js (ex-to-js one:expense:fixtures))
    %+  expect-eq
      !>  two:expense:fixtures
      !>  (ex-from-js (ex-to-js two:expense:fixtures))
  ==
::
++  test-group-to-js
  %+  expect-eq
    !>  (trip '{"title":"foo","acl":["~nus"],"host":"~zod","members":["~nus"]}')
    !>  (en-json:html (group-to-js one:group:fixtures))
::
++  test-group-from-js
  %+  expect-eq
    !>  one:group:fixtures
    !>  (group-from-js (group-to-js one:group:fixtures))
::
++  test-groups-to-js
  %+  expect-eq
    !>  (trip '{"e7334af6-be91-426d-9109-11191c98acdc":{"title":"foo","acl":["~nus"],"host":"~zod","members":["~nus"]}}')
    !>  (en-json:html (groups-to-js one:groups:fixtures))
--
