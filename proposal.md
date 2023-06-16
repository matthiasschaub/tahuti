# Proposal - Expense Sharing App for Urbit

## Motivation

> The Urbit community hosts many IRL events and, inevitably, this means splitting tabs
with other Urbiters. Urbit needs its own expense sharing app that seamlessly keeps
track of all expenses and IOUs in one place and works with both crypto and fiat
([RFP](https://urbit.org/grants/splitwise)).

Urbit is for small communities. Communities need a way to keep track of and to split
shared expenses.

## Basic User Story

A member of a group wants to keep track of all expenses in order to eventually settle
debts with a minimal number of transactions.

## Basic User Tasks

- Create or select a group
- Invite other people
- Add an expense involving other group members
- View all expenses
- Delete an expense
- Retrieve a suggestion on how to balance debts with minimal number of transactions

## Basic User Flow

1. Select a group
2. Add an expense
3. Check balance
    - Who are owed, and who owes money to the group and how much?
4. Settle debts
    - The app suggests an efficient way to settle debts in the group
    - Mark outstanding expenses as paid

## Architecture

The architecture will be loosely modeled on existing expense sharing apps such as
[Splitwise](https://www.splitwise.com/) and [Tricount](https://www.tricount.com/).

An expense can involve only a subset of all group members. It has the following attributes:
- title (For what reasons?)
- payer (Who paid?)
- involves (For whom?)
- date (When?)
- amount (How much?)
- currency
- note

All group members are ships (`@p`). A list of group members and all expenses of the
group will be stored on the ship of the group initiator. Other group members will read
and write from and to there.

In order to find a minimum number of transaction to settle debts in the group
("simplified debts"), shared expenses will be modeled as a flow network. Money flows
from the participants who owe money to the group (debitors) to the participants who are
owed money by the group (creditors). Using
[Edmonds–Karp](https://en.wikipedia.org/wiki/Edmonds%E2%80%93Karp_algorithm) algorithm
the [maximum flow](https://en.wikipedia.org/wiki/Maximum_flow_problem) of this network
will be computed. From the resulting residual network transactions to balance out shared
expenses will be derived. A Python reference implementation can already be found
[here](https://git.sr.ht/~talfus-laddus/splt-exps-py).

### Backend

The backend will be a gall agent with a basic set of operations addressing the users
needs mentioned above. Alongside the gall agent, a couple of libraries will be created: A
library implementing the Edmonds-Karp algorithm and a library handling currency exchange
rates and conversions.

### Frontend

> [Keep it simple, stupid!](https://en.wikipedia.org/wiki/KISS_principle)

The frontend will be a mobile-first website.

It is an open question whether the frontend will be served from Mars or Earth. 
The website, of course, should eventually be served from the ship.

## Milestones

Documentation and tests throughout the code base will be present. The source code will
be available in a public git repository and licensed under MIT.

### Milestone 1 - Proof of Concept

Completion
: Beginning of App School Live (August 2023)

Payment
: None

Deliverables
: Edmonds-Karp Library

The Proof of Concept (POC) demonstrates how to model shared expenses as a flow network
and how to derive from it the minimum number of transactions needed to settle debts
. The POC implements the Edmonds-Karp algorithm as well as the logic of how to
construct the flow network from a list of expenses and how to derive a list of
transactions from the residual network.

### Milestone 2 - Minimal Viable Product

Completion
: End of App School Live before Assembly (October 2023)

Payment 
: 1 Star

Deliverables
: Gall Agent
: Website

The Minimal Viable Product (MVP) consists of a gall agent as backend and a website as
frontend.

#### Iterations

1. Create a *gall agent* containing a basic set of operations to manage
   groups and to add, store, delete and retrieve group expenses.
2. Create a simple, stupid and mobile-first *website* as an interface to the
   gall agent.
3. Add a feature to "simplify debts" by integrating the Edmonds-Karp library into the
   gall agent. The agent can suggest a way to balance out shared expenses with a minimal
   number of transactions.
4. Synchronize the state of the gall agent among the group members.
5. Handle different currencies by creating and integrating a library. The library can
   retrieve the current exchange rate and do conversions between currencies.
6. Make the app available through Software Distribution.


## Considerations

The applications design is based around groups of people such as roommates or a bunch of
friends on a trip. The nature of such groups is rather static. The group members do
not change frequently, and expenses (re)occur over time. Keeping track of one-to-one
transactions by going through an interface designed around groups is tedious.

## Additional Future Work

The future of the app could entail:
- A more polished interface
- An integration into Groups
- Apps for Android and iOS
- A new feature to categorize expenses and derive statistics
- Yet unforeseen improvements

## About Me

I am in search of something worthwhile to contribute my time and effort to.

My name is Matthias Schaub (`~talfus-laddus`). Even though I work part-time as a
software developer for a non-profit corporation dedicated to better society and
environment, I feel the need to spend my time on projects of which I am more confident
that they provide sustained value to society (or at least have the potential to). That
is why I am invested to contribute to the Urbit ecosystem by learning Hoon and how to
build applications on Urbit. A more basic motivation is to have my flat mates on Urbit.
Beside a chat, we need a way to handle shared expenses.

I attended Hoon School and registered for App School. Alongside the App School
curriculum I want to foster my learning by building this application. On Earth side I
have solid Python and basic HTML, CSS and JavaScript skills. I am proficient in git and
I am used to working with a terminal on a Linux machine. In the past I wanted to read
the reference of a Hoon rune without leaving Vim. So I wrote a Python script to convert
Hoon rune references from Markdown to Vimdoc. The result is a Vim helpfile in disguise
of a plugin ([`hoon-runes.vim`](https://git.sr.ht/~talfus-laddus/hoon-runes.vim)).
Shortly after, I did the same for the documentation of the Hoon standard library
([`hoon-stdlib.vim`](https://git.sr.ht/~talfus-laddus/hoon-stdlib.vim)).

In order to find out more about my previous works:

- [Personal website](https://talfus-laddus.de/)
- [Sourcehut](https://git.sr.ht/~talfus-laddus)
- [GitHub](https://github.com/matthiasschaub)
