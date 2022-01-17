# Stash
I have to have a file structure with each namespace I want to deploy the repo to, and copy the repo in each of those, because whoever designed Stash is great at the finer details and terrible at the trivial ones.

The secrets contain:
```
    RESTIC_PASSWORD: ${RESTIC_PASSWORD}
    B2_ACCOUNT_ID: ${B2_ACCOUNT_ID}
    B2_ACCOUNT_KEY: ${B2_ACCOUNT_KEY}
```
They're sops encrypted because otherwise pre-commit would be mad.
I defined the rest in cluster secrets.
The reason for this is so that I can syncronize them all on the Flux end, since Stash is too cool for that.
