import { getLocalStorage, dht } from './Utils';
import JSONB from 'json-buffer';

export const push = (head, data) => (text, callback) => {
  const tweet = buildTweet(head, data)(text);

  return Object.assign(data, { blabla: tweet });
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

export default { push };
