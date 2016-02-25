import { getLocalStorage, dht } from './Utils';
import JSONB from 'json-buffer';

export const publish = (head, data) => (text, callback) => {
  const tweet = buildTweet(head, data)(text);

  dht.put(encodeTweet(tweet), (err) => {
    callback(err, tweet);
  });
};

const buildTweet = (head, data) => (text) => ({
  v: {
    t: text,
    next: selectHops(findNext([], head, data))
  }
});

const findNext = (accumulated, current, data) => {
  let next = current.v.next && current.v.next[0];

  return next ? findNext([...accumulated, next], data[next], data) : accumulated;
};

const selectHops = (nexts) =>
  [nexts[0], nexts[1], nexts[3], nexts[7]].filter(a => a)

const encodeTweet = (rawTweet) => JSONB.stringify({
  v: {
    t: new Buffer(rawTweet.v.t),
    next: Buffer.concat(rawTweet.v.next.map(x => new Buffer(x)))
  }
})

export default { publish };
