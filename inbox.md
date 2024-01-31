# Inbox

## Todo

- feat: leave group as member
    - what should happen?
    - archive vs remove
- feat: remove member from group
    - what should happen?
    - archive vs remove
- feat: simplify debts
- feat: support multiple currencies when creating a new group
- feat: support multiple currencies when adding a new expense
- feat: public groups
- api: response only after successful %poke
    - add HTTP response card to state
    - wait (on-arvo) for ack from %tahuti before sending HTTP response
    - use eyre id in wire for pokes
- bug: add expense for huge integer will error but it is not displayed on the website
- ui: after join group list is still empty -> introduce polling
- ui: if deletion of expense happens by a subscriber (not the host) HTMX fetches to fast the new expenses list so that the deleted expense is still shown -> introduce polling.
- build: minify JavaScript files
- ui: add default values in case of empty responses (no groups, no members, no reimbursements etc.)
- ui: validate ship names
- ui(add-expense): payer default value should be current ship
- ui: smooth out page load and transition
- ui: loading of pages can be slow. Add feedback to user that a button or link has been pressed
    - could be highlighting the element or add a load spinner
- test: use module scoped fixtures everywhere to keep it simple
- build: use peru to manage depedencies such as htmx and mustache
- misc: check-out bankers rounding
- misc: parse @s to valid JSON number. Currently it is dot seperated (eg. -1000 is -1.000)
- misc: checkout "JSON" guide on how to parse GUID/UUID
- misc: checkout "Fetch JSON" guide on how to use threads to fetch exchange
- misc: use knots (name part of the path) in api `?+`

## Done

- ui: make table rows clickable
    - click on rows leads to details.html
    - move delete button to details view
- ui: cut elements values to certain length if too long (show full text on hover)
- ui: mouse pointer on hover for delete link
- ui: add "report a bug" and "feedback" button
- ui: add support button
- ui: export of all expenses as backup
- ui: use no headers option for HTMX requests
- ui: if cancel is pressed validation is triggered. Disable validation for cancel button.
