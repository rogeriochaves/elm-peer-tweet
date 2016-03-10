import bencode from 'bencode';
import crypto from 'crypto';
import { encodeItem } from './Publish';
import { findNext, selectHops, hashItem, bencodeItem, sha1 } from './Utils';

export const add = (data) => (hash) =>
  updateData(data)(hash);

const updateData = (data) => (hash) =>
  updateHead(hash)(updateFollowBlocks(data)(hash));

const updateFollowBlocks = (data) => (hash) =>
  ({ ...data, followBlocks: addHashToFollowBlocks(data)(hash) });

const addHashToFollowBlocks = (data) => (hash) => {
  const lastFollowBlock = data.followBlocks.find(x => x.hash === data.head.f[0]);

  return lastFollowBlock && lastFollowBlock.l.length < 20 ?
    [ hashItem(addHash(data)(lastFollowBlock)(hash)), ...data.followBlocks.filter(x => x.hash != data.head.f[0]) ] :
    [ hashItem(buildFollowBlock(data)(hash)), ...data.followBlocks ]
}

const addHash = (data) => (follower) => (hash) =>
  ({ ...follower, l: [ hash, ...follower.l ] });

const buildFollowBlock = (data) => (hash) => {
  return ({ l: [ hash ], next: selectHops(findNext([], { next: data.head.f }, data.followBlocks)) });
}

const updateHead = (hash) => (data) =>
  ({ ...data, head: buildHead(data)(hash) });

const buildHead = (data) => (hash) =>
  ({ ...data.head, d: Date.now(), f: selectHops(findNext([], { next: [data.followBlocks[0].hash] }, data.followBlocks)) })

export default { add };
