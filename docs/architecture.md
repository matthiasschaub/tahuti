# Architecture

## Agents

There are three agents:

- `%tahuti-ui`: UI agent. Serves front-end (HTML, CSS, JS and HTMX).
- `%tahuti-api`: REST API agent. Interfaces with front-end via requests with JSON payload.
- `%tahuti`: Core agent. Manages state (groups, expenses and subscriptions).

### %tahuti

Depends on [%mip](https://github.com/urbit/urbit/blob/develop/pkg/landscape/lib/mip.hoon).

### %tahuti-ui

Inspired by [%feature](https://docs.urbit.org/userspace/apps/examples/feature)
Depends on [%schooner](https://github.com/urbit/yard/blob/main/desk/lib/schooner.hoon)

The front-end is build with HTML, CSS, JS and HTMX.
HTMX is used to interfaces with the API using JSON encoded request bodies
(`json-enc` extension) and client side templates (`mustache.json`).

### %tahuti-api

Inspired by [%feature](https://docs.urbit.org/userspace/apps/examples/feature)
Depends on [%schooner](https://github.com/urbit/yard/blob/main/desk/lib/schooner.hoon)

Endpoints:
```
GET   api/groups                         // Get all groups               (JSON array)
PUT   api/groups                         // Add or edit a group          (JSON object)
GET   api/groups/{uuid}                  // Get a group                  (JSON object)

GET   api/groups/{uuid}/invites         // Get all invitees              (JSON array)

GET   api/groups/{uuid}/invitees         // Get all invitees of a group  (JSON array)
PUT   api/groups/{uuid}/invitees         // Invite a ship                (JSON object)

GET   api/groups/{uuid}/members          // Get all members of a group   (JSON array)
PUT   api/groups/{uuid}/members          // Add a member                 (JSON object)

GET   api/groups/{uuid}/expenses         // Get all expenses of a group  (JSON array)
PUT   api/groups/{uuid}/expenses         // Add or edit an expense       (JSON object)
GET   api/groups/{uuid}/expenses/{uuid}  // Get an expense               (JSON object)

POST  api/groups/join                    // Join a group                 (JSON object)

GET   api/groups/{uuid}/balances         // Get balances of a group      (JSON array)
GET   api/groups/{uuid}/reimbursements   // Get reimburesements          (JSON array)
```

## Abbreviations

- gid: group ID
- eid: expense ID
- reg: register (of members)
- acl: access-control list
- led: ledger (of expenses)
- rei: reimbursements
