# RRSSW - Ruby RSS Watcher
### Description
Watch RSS feeds for items that match a requested title.
Type `rrssw.rb -h` for more details.
### Config
- size: Max file size. Acceptable unit: KB, MB, GB, TB.
- rss: URL to contact for RSS data.
- path: Absolute path to place where files will be downloaded.
- requests: Titles to watch for. The more specific the better.
```
groups:
  group1:
    size: 3 GB
    rss: https://example.com/rss
    path: /path/to/group1
    requests:
       - request1 E\d+
       - request2 S\d+E\d+
```
