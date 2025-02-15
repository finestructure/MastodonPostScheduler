# MastodonPostScheduler

MastodonPostScheduler is a command line tool to schedule posts on a Mastodon instance.

## Usage

```
❯ cat post.json
{
    "text": "This is a scheduled test post.",
    "scheduledAt": "2025-02-15 15:00",
}
```

```
❯ mastodon-post-scheduler schedule --instance mas.to --token $MASTODON_ACCESS_TOKEN --input post.json
Scheduling post at 2025-02-15 14:00:00 +0000 on https://mas.to ...
Post scheduled, id: 28329
```

```
❯ mastodon-post-scheduler list --instance mas.to --token $MASTODON_ACCESS_TOKEN
Listing scheduled posts on https://mas.to ...
scheduled at                |   id
---------------------------------------
2025-02-15 14:00:00 +0000   |   28329
```

```
❯ mastodon-post-scheduler delete --instance mas.to --token $MASTODON_ACCESS_TOKEN --id 28329
Delete post '28329' posts on https://mas.to ...
Post '28329' deleted.
```

## Installation

### Mint

You can install MastodonPostScheduler with [Mint](https://github.com/yonaskolb/Mint):

```
mint install finestructure/MastodonPostScheduler
```

### Make

You can also build and install MastodonPostScheduler via the included Makefile by running:

```
make install
This will copy the binary arena to /usr/local/bin.
```

