# elm-peer-tweet

> Decentralized feeds using BitTorrent's DHT. Reimplemented in Elm the ideas from [peer-tweet](https://github.com/lmatteis/peer-tweet) and [DHT RSS feeds](http://libtorrent.org/dht_rss.html).

![elm-peer-tweet](https://cloud.githubusercontent.com/assets/792201/14061240/09da8412-f35a-11e5-850a-15623db5b9ff.gif)

### [Download Here](https://github.com/rogeriochaves/elm-peer-tweet/releases)
for Windows, Mac and Linux


## What is ElmPeerTweet?

ElmPeerTweet relies on BitTorrent's DHT network, a vastly used distributed network, to send tweets to anyone listening.

When you create a ElmPeerTweet account, a public and secret key pairs are generated to you, so you can tweet and others can follow you using your unique hash, like `@fb17c08f1fa1562a6bc1bc95630312bfddd92574`, which would be like your Twitter username (ex. `@_rchaves_`).


## Goals

ElmPeerTweet should be a short-messages social network that is:

- Free, as there is no need for pay for a centralized infrastructure
- Distributed, creating a resilient network
- Easy to use, technical details shouldn't affect user experience
- Simple, no algorithmic feeds or unessentials features, main focus should be in tweeting and following
- Open-source


## How does it work?

ElmPeerTweet implementation follows some ideas proposed by the DHT RSS feed proposal http://libtorrent.org/dht_rss.html. Thanks to the current [BEP44](http://bittorrent.org/beps/bep_0044.html) proposal, we can `put()` and `get()` data from the DHT network.

This means that, rather than only using the DHT to announce which torrents one is currently downloading, we can use it to also publish small amounts of data, roughly 1000 bytes, which is more than enough for a 140 characters tweet.

The downside is that data only lasts about 30 minutes in the DHT network, which means that tweets and users information have to be republished every once in a while.

In order to keep the network working, ElmPeerTweet republishes both your data and data from who you follow, so trending tweets and popular accounts are more likely to live up in the network. All downloaded data is also saved on the localStorage so it can get republished even if it is not on the DHT network anymore.

Since you cannot contact the DHT network from the browser, ElmPeerTweet has to be a native app, it uses [Electron](http://electron.atom.io/) for that.

The data structure is composed by 3 main items:

1. **Your feed head**. Which is the only mutable item of the three, it points to the last tweets and followBlocks you published. The hash for this item is what you share so other people can follow you. The public and secret keys are needed to update it.

  ```
  {
    "d": <timestamp of last modification>,
    "next": <last 4 published tweets hashes, 1, 2, 4 and 8 hops away, 40 bytes each>,
    "f": <last 4 followBlocks hashes, 1, 2, 4 and 8 hops away, 40 bytes each>,
    "n": <your name>,
  }
  ```

2. **Your tweets**. These are immutable items which holds your tweets, each linking to the previous ones.

  ```
  {
    "d": <timestamp of the publication>,
    "next": <previous 4 published tweets hashes, 1, 2, 4 and 8 hops away, 40 bytes each>,
    "t": <up to 140 characters tweet>
  }
  ```

3. **Your followBlocks**. They hold the hashes of who you are following, each followBlock have up to 20 account hashes and a link to the next block.

  ```
  {
    "l": <up to 20 hashes of accounts hashes, 40 bytes each>,
    "next": <previous 4 followBlocks hashes, 1, 2, 4 and 8 hops away, 40 bytes each>,
  }
  ```


## Differences from PeerTweet

PeerTweet is a JavaScript project which inspired this one, you can read more about the differences from ElmPeerTweet here:

https://github.com/rogeriochaves/elm-peer-tweet/wiki/Differences-from-peer-tweet


## Naming

I'm looking for a better naming to the project, please suggest any ideas :)


## Building elm-peer-tweet

If you want to build elm-peer-tweet for development, first you'll need `node 5.8.x` with `npm 3.x.x`. That's because electron have problems when node version varies, you may get an error message like `Module version mismatch. Expected 47, got 46`.

Then, run:

```
npm install
npm run build
npm start
```

You should find other npm commands for testing, watching and packaging on the `package.json` file.
