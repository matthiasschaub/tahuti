# Inbox

## Back-end

- leave group
- remove from group
- add and use scry path based on gid/eid
- surface pending invites to user (UX)
- evaluate if bankers rounding in `lib/stats.hoon` would be better
- add error handling
  - e.g. add expense for huge integer will error but it is not displayed on the website
- add HTTP response card to state and listen (on-arvo) for OK from %tahuti. Then send out the HTTP response card.

## Front-end

- after join group list is still empty
- replace details and delete by symbols in expenses table
- minify JavaScript files
- use not headers options for HTMX requests
- add default values for empty responses (no groups, no members, etc.)
- validate ship names
- cut elements values to certain length if too long (show full text on hover)
- if deletion of expense happens by a subscriber (not the host) HTMX fetches to fast the new expenses list so that the delete expense is still shown -> Introduce polling.
- select as default drop down currently logged in ship
- mouse pointer on hover for delete link

## Tests

- use module scoped fixtures everywhere to keep it simple

## Misc

- Use peru to manage depedencies such as htmx, mustache and currency
- parse @s to valid JSON number. Currently it is dot seperated (eg. -1000 is -1.000)
- checkout "JSON" guide on how to parse GUID/UUID
- checkout "Fetch JSON" guide on how to use threads to fetch exchange
- use knots (name part of the path) in api `?+`
rates