import bencode from 'bencode';
import crypto from 'crypto';

export const push = (head, data) => (text, callback) => {
  const tweet = buildTweet(head, data)(text);
  const hash = hashTweet(tweet);

  return { ...data, [hash]: tweet };
};

const buildTweet = (head, data) => (text) => ({
  t: text,
  next: selectHops(findNext([], head, data))
});

const findNext = (accumulated, current, data) => {
  let next = current.next && current.next[0];

  return next ? findNext([...accumulated, next], data[next], data) : accumulated;
};

const selectHops = (nexts) =>
  [nexts[0], nexts[1], nexts[3], nexts[7]].filter(a => a)

const hashTweet = (data) =>
  sha1(bencode.encode(data)).toString('hex');

const sha1 = (buf) =>
  crypto.createHash('sha1').update(buf).digest();

export default { push };
