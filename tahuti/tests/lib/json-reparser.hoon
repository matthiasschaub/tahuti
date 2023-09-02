/-  *tahuti
/+  *test, *json-reparser
::
|%
++  fixtures
  |%
  ++  ex-single
    ^-  ex
    [~zod 0 (limo [~zod ~])]
  ++  ex-multi
    ^-  ex
    [~zod 5 (limo [~zod ~nus ~])]
  --
++  test-ex-to-js
  ;:  weld
    %+  expect-eq
      ::   trip - cord to tape
      !>  (trip '{"amount":0,"involves":["~zod"],"payer":"~zod"}')
      !>  (en-json:html (to-json ex-single:fixtures))
    %+  expect-eq
      !>  (trip '{"amount":5,"involves":["~zod","~nus"],"payer":"~zod"}')
      !>  (en-json:html (to-json ex-multi:fixtures))
  ==
++  test-ex-from-js
  ;:  weld
    %+  expect-eq
      !>  ex-single:fixtures
      !>  (from-json (to-json ex-single:fixtures))
    %+  expect-eq
      !>  ex-multi:fixtures
      !>  (from-json (to-json ex-multi:fixtures))
  ==
--
