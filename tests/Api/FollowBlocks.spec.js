import { expect } from 'chai';
import FollowBlocks from '../../src/Api/FollowBlocks';

describe('FollowBlocks', () => {
  let currentAccount, result, followers;

  beforeEach(() => {
    global.localStorage = { publicKey: '6393a821af08e151399a8df339d02a9e36134b3da5f893849673cf176810eb98', secretKey: 'foo' };

    Date.now = () => 1457409506204;

    currentAccount = {
      head: { hash: 'head-hash', next: [], f: ['followers-block'] },
      tweets: [],
      followBlocks: [{ hash: 'followers-block', l: ['bar'], next: [] }]
    };
    result = FollowBlocks.add(currentAccount)('baz');
    followers = result.followBlocks;
  });

  it('adds a followers item if there is none', () => {
    result = FollowBlocks.add({ head: { f: [] }, followBlocks: [] })('duo');

    expect(result.followBlocks[0]).to.deep.equal({ hash: 'ca59aaf2550f380eee38be3f881b0543adb45a54', l: ['duo'], next: [] });
  });

  it('updates the head', () => {
    expect(result.head).to.deep.equal({ hash: 'head-hash', next: [], f: ['f0782090940ed9fc044dbe8e3b8b4471f3f5fb42'], d: 1457409506204, next: [] });
  });

  it('adds the hash to followers when it has less than 20', () => {
    expect(followers[0]).to.deep.equal({ hash: 'f0782090940ed9fc044dbe8e3b8b4471f3f5fb42', l: ['baz', 'bar'], next: [] });
  });

  it('create a new followers object when the current one has 20 already', () => {
    let currentFollowBlock = {
      hash: 'currentFollowBlock',
      l: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 'v'],
      next: []
    };
    result = FollowBlocks.add({ head: { f: ['currentFollowBlock'] }, followBlocks: [currentFollowBlock] })('uno');

    expect(result.followBlocks[0]).to.deep.equal({ hash: '941814736afcceba27d226e4c10166c7fb3e52b2', l: ['uno'], next: ['currentFollowBlock'] });
    expect(result.followBlocks[1]).to.deep.equal(currentFollowBlock);
  });
});
