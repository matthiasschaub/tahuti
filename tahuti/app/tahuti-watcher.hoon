/-  *tahuti
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
    default  ~(. (default-agent this %.n) bowl)
++  on-init
  :: list of things this agent would like to do
  ::
  ^-  [(list card) _this]
  ~&  >  '%tahuti initialized successfully'
  =.  state  [%0 *(list @)]
  [~ this]
++  on-save   !>(state)
++  on-load
  |=  old=vase
  ^-  [(list card) _this]
  :-  ^-  (list card)
      ~
  %=  this
    state  !<(state-0 old)
  ==
++  on-poke   on-poke:default
  |=  [=mark =vase]
  ^-  [(list card) _this]
  ?>  ?=(%noun mark)                               :: assert
  =/  action  !<(?([%sub =@p] [%unsub =@p]) vase)
  ?-  (head action)
    %sub
      :-  ^-  (list card)
          :~  [%pass /values-wire %agent [p.action %tahuti] %watch /values]
          ==
      this
    %unsub
      :-  ^-  (list card)
          :~  [%pass /values-wire %agent [p.action %tahuti] %leave ~]
          ==
      this
  ==
::
++  on-arvo   on-arvo:default
++  on-watch  on-watch:default
++  on-leave  on-leave:default
++  on-peek   on-peek:default
++  on-agent  on-agent:default
  |=  [=wire =sign:agent:gall]
  ^-  [(list card) _this]
  ?>  ?=([%values-wire ~] wire)                    ::assert
  ?+  (head sign)
      (on-agent:default wire sign)
    %watch-ack
      ?~  p.sign
        ~&  >  '%tahuti-subscriber: subscribe succeeded!'
        [~ this]
      ~&  >>>  '%tahuti-subscriber: subscribe failed!'
      [~ this]
    %kick
      %-  (slog '%tahuti-subscriber: Got kick, resubscribing...' ~)
      :-  ^-  (list card)
          :~  [%pass /values-wire %agent [src.bowl %tahuti] %watch /values]
          ==
      this
    %fact
      ~&  >>  [%fact p.cage.sign]
      ?>  ?=(%tahuti-update p.cage.sign)          :: assert
      =/  update  !<(update q.cage.sign)          :: coerce type
      ~&  >>  update
      ?-  (head update)
        %init
          [~ this(values values.update)]
        %push
          [~ this(values [value.update values])]
        %pop
          ?~  values
            [~ this]
          [~ this(values t.values)]
      ==
  ==
++  on-fail   on-fail:default
--
