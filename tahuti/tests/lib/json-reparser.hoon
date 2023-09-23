/-  *tahuti
/+  *test, *json-reparser
/=  fixtures  /tests/fixtures
::
|%
++  test-ex-to-js
  ;:  weld
    %+  expect-eq
      ::   trip - cord to tape
      !>  (trip '{"amount":2,"involves":["~zod"],"payer":"~zod"}')
      !>  (en-json:html (ex-to-js one:expenses:fixtures))
    %+  expect-eq
      !>  (trip '{"amount":2,"involves":["~zod","~nus"],"payer":"~zod"}')
      !>  (en-json:html (ex-to-js two:expenses:fixtures))
  ==
++  test-ex-from-js
  ;:  weld
    %+  expect-eq
      !>  one:expenses:fixtures
      !>  (ex-from-js (ex-to-js one:expenses:fixtures))
    %+  expect-eq
      !>  two:expenses:fixtures
      !>  (ex-from-js (ex-to-js two:expenses:fixtures))
  ==
++  test-group-to-js
  %+  expect-eq
    ::   trip - cord to tape
    !>  (trip '{"title":"foo","host":"~zod","members":["~zod"]}')
    !>  (en-json:html (group-to-js one:groups:fixtures))
++  test-group-from-js
  %+  expect-eq
    !>  one:groups:fixtures
    !>  (group-from-js (group-to-js one:groups:fixtures))
--
