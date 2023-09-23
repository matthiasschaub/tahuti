/-  *tahuti
/+  *test
::
|%
++  test-ex-to-js
  %+  expect-eq
    !>  (trip '{"amount":0,"involves":["zod"],"payer":"zod"}')  :: trip - cord as tape
    !>  (en-json:html (ex-to-js [payer=~zod amount=0 involves=[~zod ~]]))
--
