# Deployment

## First-time setup

1. Create and boot a moon on the local machine
2. On the moon: Install and distribute the application
3. On the planet: Sync from the moon: `|sync %tahuti ~sarwyd-taswyn-talfus-laddus %tahuti`
4. On the planet: Publish the app: `:treaty|publish`
5. Shutdown the moon on the local machine

## Release a new version

1. Boot the moon
2. `|commit` the changes

The planet will automatically retrieve those updates and distribute them.

Thanks `~tiller-tolbus` for the initial instructions.
