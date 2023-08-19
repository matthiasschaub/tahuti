::
::
/+  *test, *graph
::
|%
++  fixtures
  |%
  ++  given
    %-  limo
      :*
        ::         a b  c  d e f
        %-  limo  [0 16 13 0 0 0 ~]  :: a
        %-  limo  [0 0 10 12 0 0 ~]  :: b
        %-  limo  [0 4 0 0 14 0 ~]   :: c
        %-  limo  [0 0 9 0 0 20 ~]   :: d
        %-  limo  [0 0 0 7 0 4 ~]    :: e
        %-  limo  [0 0 0 0 0 0 ~]    :: f
        ~
      ==
  --
++  test-get
  ;:  weld
    %+  expect-eq
      !>  16
      !>  (get:edge [given:fixtures 0 1])
  ==
++  test-set
  %+  expect-eq
    !>  %-  limo
      :*
        ::         a b  c  d e f
        %-  limo  [0 100 13 0 0 0 ~]  :: a
        %-  limo  [0 0 10 12 0 0 ~]  :: b
        %-  limo  [0 4 0 0 14 0 ~]   :: c
        %-  limo  [0 0 9 0 0 20 ~]   :: d
        %-  limo  [0 0 0 7 0 4 ~]    :: e
        %-  limo  [0 0 0 0 0 0 ~]    :: f
        ~
      ==
    !>  (set:edge [given:fixtures 0 1 100])
--
