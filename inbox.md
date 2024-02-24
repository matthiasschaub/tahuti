# Inbox

## Priority

- feat: leave group as member
- feat: remove member from group
- feat: edit expense
- fix: decline invite
- ui: make error message for request failure due to unauthenticated request nicer
- ui: page transitions
- fix: update static links to icons
- feat: support multiple currencies when creating a new group
- feat: support multiple currencies when adding a new expense

## Backlog

- refactor: move state transition to its own library or helper arm
- refactor: add helper to get all data of a group (reg, led, acl, group)
- refactor: host should be part of register
- feat: who paid how much for the whole group?
- feat: history/event log for each event
- feat: tags
- ui: sort table after column header
- ui: make upper margin of add button/svg bigger
- ui: move about page from group pages (`/groups/{gid}`) to index page (`/groups`)
- bug: add expense for huge integer will error but it is not displayed on the website
- feat: show connection status if host is not reachable
- feat(reimbursement): click on suggested reimbursement to add new expense covering debt
- ui: different setting pages for different roles
  - host will have delete group button and remove member
  - members will have a leave group button
  - if public group no settings are available (only group metadata)
- api: response only after successful %poke
  - add HTTP response card to state
  - wait (on-arvo) for ack from %tahuti before sending HTTP response
  - use eyre id in wire for pokes
- ui: how to
    - install this app natively
    - see details of an expense
- ui: dark mode
- ui: after joining a group the group list is still empty -> introduce polling
- ui: if deletion of expense happens by a subscriber (not the host) HTMX fetches to fast the new expenses list so that the deleted expense is still shown -> introduce polling.
- ui: add default values in case of empty responses (no groups, no members, no reimbursements etc.)
- ui: validate ship names
- ui(add-expense): payer default value should be current ship
- test: use module scoped fixtures everywhere to keep it simple
- misc: check-out bankers rounding
- misc: parse @s to valid JSON number. Currently it is dot seperated (eg. -1000 is -1.000)
- misc: checkout "JSON" guide on how to parse GUID/UUID
- misc: use knots (name part of the path) in api `?+`
- misc: add donation button (buy me a coffee, open collective, paypal?)
- misc: submit to https://urbit.org/applications/submit
