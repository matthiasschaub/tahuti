/+  default-agent, dbug
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  $:  [%0 values=(list @)]
  ==
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-0  :: bunt value with name
=*  state  -  :: refer to state 0
^-  agent:gall
|_  =bowl:gall
+*  this  .
    default  ~(. (default-agent this %|) bowl)
++  on-init
  :: list of things this agent would like to do
  ::
  ^-  (quip card _this)  :: TODO: how can this be written as a list?
  ~&  >  '%bravo initialized successfully'
  =.  state  [%0 *(list @)]  [~ this]
++  on-save   on-save:default
++  on-load   on-load:default
++  on-poke   on-poke:default
++  on-arvo   on-arvo:default
++  on-watch  on-watch:default
++  on-leave  on-leave:default
++  on-peek   on-peek:default
++  on-agent  on-agent:default
++  on-fail   on-fail:default
--
:: TODO: does not work yet
:: |%
:: ++  helper-core  !!
:: --
