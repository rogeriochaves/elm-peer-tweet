import bencode from 'bencode';
import crypto from 'crypto';
import { encodeItem } from './Publish';

export const add = (hash, data) => (text) => {
  const tweet = hashItem(buildTweet(data)(text));
  const dataWithTweet = { ...data, tweets: [...data.tweets, tweet] };

  return { ...dataWithTweet, head: buildHead(hash, dataWithTweet)(tweet) };
};

const buildHead = (hash, data) => (tweet) =>
  ({ ...data.head, next: selectHops(findNext([], { next: [tweet.hash] }, data)) })

const buildTweet = (data) => (text) => ({
  t: text,
  next: selectHops(findNext([], data.head, data))
});

const findNext = (accumulated, current, data) => {
  let next = current && current.next && current.next[0];
  let nextTweet = data.tweets.find(x => x.hash === next);

  return next ? findNext([...accumulated, next], nextTweet, data) : accumulated;
};

const selectHops = (nexts) =>
  [nexts[0], nexts[1], nexts[3], nexts[7]].filter(a => a)

const hashItem = (item) =>
  ({ hash: sha1(bencodeItem(item)).toString('hex'), ...item });

const bencodeItem = (item) =>
  bencode.encode(encodeItem(null, item).v);

const sha1 = (buf) =>
  crypto.createHash('sha1').update(buf).digest();

export default { add };
