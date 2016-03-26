import ed from 'ed25519-supercop';
import DHT from 'bittorrent-dht';
import bencode from 'bencode';
import crypto from 'crypto';
import { encodeItem } from './Publish';

export const dht = new DHT({ verify: ed.verify });

export const findNext = (accumulated, current, list) => {
  let next = current && current.next && current.next[0];
  let nextTweet = list.find(x => x.hash === next);

  return next ? findNext([...accumulated, next], nextTweet, list) : accumulated;
};

export const selectHops = (nexts) =>
  [nexts[0], nexts[1], nexts[3], nexts[7]].filter(a => a);

export const hashItem = (item) =>
  ({ ...item, hash: sha1(bencodeItem(item)).toString('hex') });

export const bencodeItem = (item) =>
  bencode.encode(encodeItem(null, item).v);

export const sha1 = (buf) =>
  crypto.createHash('sha1').update(buf).digest();
