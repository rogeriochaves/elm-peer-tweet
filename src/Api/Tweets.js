import { findNext, selectHops, hashItem, bencodeItem, sha1 } from './Common';

export const add = (account) => (text) =>
  updateAccount(account)(hashItem(buildTweet(account)(text)));

const updateAccount = (account) => (tweet) =>
  updateHead(tweet)(updateTweets(account)(tweet));

const buildTweet = (account) => (text) =>
  ({ t: text, d: Date.now(), next: selectHops(findNext([], account.head, account.tweets)) });

const updateTweets = (account) => (tweet) =>
  ({ ...account, tweets: [...account.tweets, tweet] });

const updateHead = (tweet) => (account) =>
  ({ ...account, head: buildHead(account)(tweet) });

const buildHead = (account) => (tweet) =>
  ({ ...account.head, d: Date.now(), next: selectHops(findNext([], { next: [tweet.hash] }, account.tweets)) })

export default { add };
