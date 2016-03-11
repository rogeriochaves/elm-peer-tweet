import bencode from 'bencode';
import crypto from 'crypto';
import { encodeItem } from './Publish';
import { findNext, selectHops, hashItem, bencodeItem, sha1 } from './Utils';

export const add = (account) => (hash) =>
  updateAccount(account)(hash);

const updateAccount = (account) => (hash) =>
  updateHead(hash)(updateFollowBlocks(account)(hash));

const updateFollowBlocks = (account) => (hash) =>
  ({ ...account, followBlocks: addHashToFollowBlocks(account)(hash) });

const addHashToFollowBlocks = (account) => (hash) => {
  const lastFollowBlock = account.followBlocks.find(x => x.hash === account.head.f[0]);

  return lastFollowBlock && lastFollowBlock.l.length < 20 ?
    [ hashItem(addHash(account)(lastFollowBlock)(hash)), ...account.followBlocks.filter(x => x.hash != account.head.f[0]) ] :
    [ hashItem(buildFollowBlock(account)(hash)), ...account.followBlocks ]
}

const addHash = (account) => (follower) => (hash) =>
  ({ ...follower, l: [ hash, ...follower.l ] });

const buildFollowBlock = (account) => (hash) => {
  return ({ l: [ hash ], next: selectHops(findNext([], { next: account.head.f }, account.followBlocks)) });
}

const updateHead = (hash) => (account) =>
  ({ ...account, head: buildHead(account)(hash) });

const buildHead = (account) => (hash) =>
  ({ ...account.head, d: Date.now(), f: selectHops(findNext([], { next: [account.followBlocks[0].hash] }, account.followBlocks)) })

export default { add };
