# Inbox

## Priority

- feat: remove member from group as a host
- feat: edit expense
- ui: make error message for request failure due to unauthenticated request nicer
- ui: page transitions - keep spinner between sending add expense request and waiting
      for response and going to expenses page.
      Currently, spinner loads, disappears and shortly after loads again.
- fix: assert in backend that expense.currency is the same as group.currency

## Backlog

- refactor(ui): move settings and about sites to hamburger menu
    - main pages are expenses and balances. One could switch between those to
      with a swipe like on mobile.
    - move members to hamburger menu (separate from settings page)
    - or click on heading to go to settings
- refactor(ui): move about page from group pages (`/groups/{gid}`)
  to index page (`/groups`)
- refactor(ui): make upper margin of add button/svg bigger
- refactor(ui): different setting pages for different roles
  - host will have delete group button and remove member
  - members will have a leave group button
  - if public group no settings are available (only group metadata)
- refactor(tahuti): move state transition to its own library or helper arm
- refactor(tahuti): add helper to get all data of a group (reg, led, acl, group)
- refactor(tahuti): host should be part of register
- feat: if host deleted group notify members
- feat: show connection status if host is not reachable
- feat: who paid how much for the whole group?
- feat: history/event log for each event (like chat of tricount)
- feat: tags
- feat(ui): sort table after column header
- feat(ui): click on suggested reimbursement to add new expense covering debt
- refactor(api): response only after successful %poke
  - add HTTP response card to state
  - wait (on-arvo) for ack from %tahuti before sending HTTP response
  - use eyre id in wire for pokes
- docs(ui): how to
    - install this app natively
    - see details of an expense
- feat(ui): dark mode
- fix(ui): after joining a group the group list is still empty -> introduce polling
- fix(ui): if deletion of expense happens by a subscriber (not the host) HTMX fetches
  to fast the new expenses list so that the deleted expense is still shown 
  (introduce polling)
- ui: add default values in case of empty responses (no groups, no members, no reimbursements etc.)
- ui: validate ship names
- feat(ui): add expense form payer default value should be current ship
- test: use module scoped fixtures everywhere to keep it simple
- test: front-end test using selenium to extract parts of the html for approval testing

## Misc

- check-out bankers rounding
- parse @s to valid JSON number. Currently it is dot seperated (eg. -1000 is -1.000)
- checkout "JSON" guide on how to parse GUID/UUID
- use knots (name part of the path) in api `?+`
- add donation button (buy me a coffee, open collective, paypal?)
- submit to https://urbit.org/applications/submit
