import { findNext, selectHops, hashItem, bencodeItem, sha1 } from './Utils';

export const add = (data) => (text) =>
  updateData(data)(hashItem(buildTweet(data)(text)));

const updateData = (data) => (tweet) =>
  updateHead(tweet)(updateTweets(data)(tweet));

const buildTweet = (data) => (text) =>
  ({ t: text, d: Date.now(), next: selectHops(findNext([], data.head, data.tweets)) });

const updateTweets = (data) => (tweet) =>
  ({ ...data, tweets: [...data.tweets, tweet] });

const updateHead = (tweet) => (data) =>
  ({ ...data, head: buildHead(data)(tweet) });

const buildHead = (data) => (tweet) =>
  ({ ...data.head, d: Date.now(), next: selectHops(findNext([], { next: [tweet.hash] }, data.tweets)) })

export default { add };
