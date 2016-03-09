import bencode from 'bencode';
import crypto from 'crypto';
import { encodeItem } from './Publish';
import { findNext, selectHops, hashItem, bencodeItem, sha1 } from './Utils';

export const add = (data) => (hash) =>
  updateData(data)(hash);

const updateData = (data) => (hash) =>
  updateHead(hash)(updateFollowers(data)(hash));

const updateFollowers = (data) => (hash) =>
  ({ ...data, followers: addHashToFollowers(data)(hash) });

const addHashToFollowers = (data) => (hash) => {
  const lastFollowersBlock = data.followers.find(x => x.hash === data.head.f[0]);

  return lastFollowersBlock && lastFollowersBlock.l.length < 20 ?
    [ hashItem(addHash(data)(lastFollowersBlock)(hash)), ...data.followers.filter(x => x.hash != data.head.f[0]) ] :
    [ hashItem(buildFollower(data)(hash)), ...data.followers ]
}

const addHash = (data) => (follower) => (hash) =>
  ({ ...follower, d: Date.now(), l: [ hash, ...follower.l ] });

const buildFollower = (data) => (hash) => {
  return ({ d: Date.now(), l: [ hash ], next: selectHops(findNext([], { next: data.head.f }, data.followers)) });
}

const updateHead = (hash) => (data) =>
  ({ ...data, head: buildHead(data)(hash) });

const buildHead = (data) => (hash) =>
  ({ ...data.head, d: Date.now(), f: selectHops(findNext([], { next: [data.followers[0].hash] }, data.followers)) })

export default { add };
