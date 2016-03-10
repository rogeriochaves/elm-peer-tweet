import { expect } from 'chai';
import Followers from '../../src/Api/Followers';

describe('Followers', () => {
  let currentData, result, followers;

  beforeEach(() => {
    global.localStorage = {};

    Date.now = () => 1457409506204;

    currentData = {
      head: { hash: 'head-hash', next: [], f: ['followers-block'] },
      tweets: [],
      followers: [{ hash: 'followers-block', l: ['bar'], next: [] }]
    };
    result = Followers.add(currentData)('baz');
    followers = result.followers;
  });

  it('adds a followers item if there is none', () => {
    result = Followers.add({ head: { f: [] }, followers: [] })('duo');

    expect(result.followers[0]).to.deep.equal({ hash: '8d1b8caacfc16192666d1a87a6a2f71851531e00', d: 1457409506204, l: ['duo'], next: [] });
  });

  it('updates the head', () => {
    expect(result.head).to.deep.equal({ hash: 'head-hash', next: [], f: ['3ef5ef68f145b59990429cd722e035a1aa9d472b'], d: 1457409506204, next: [] });
  });

  it('adds the hash to followers when it has less than 20', () => {
    expect(followers[0]).to.deep.equal({ hash: '3ef5ef68f145b59990429cd722e035a1aa9d472b', d: 1457409506204, l: ['baz', 'bar'], next: [] });
  });

  it('create a new followers object when the current one has 20 already', () => {
    let currentFollowers = {
      hash: 'currentFollowers',
      l: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 'v'],
      next: []
    };
    result = Followers.add({ head: { f: ['currentFollowers'] }, followers: [currentFollowers] })('uno');

    expect(result.followers[0]).to.deep.equal({ hash: 'cc9976d51a3079819439f733c3f04b95af3fef14', d: 1457409506204, l: ['uno'], next: ['currentFollowers'] });
    expect(result.followers[1]).to.deep.equal(currentFollowers);
  });
});
