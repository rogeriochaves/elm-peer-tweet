import { expect } from 'chai';
import Tweets from '../../src/Api/Tweets';

describe('Tweets', () => {
  let currentData, result, tweet;

  beforeEach(() => {
    Date.now = () => 1457409506204;

    currentData = {
      head: { hash: 'foo', next: ['bar', 'baz', 'uno', 'qui'] },
      tweets: [
        { hash: 'bar', next: ['baz', 'qux', 'duo'] },
        { hash: 'baz', next: ['qux', 'uno', 'tre'] },
        { hash: 'qux', next: ['uno', 'duo', 'qua'] },
        { hash: 'uno', next: ['duo', 'tre', 'qui'] },
        { hash: 'duo', next: ['tre', 'qua'] },
        { hash: 'tre', next: ['qua', 'qui'] },
        { hash: 'qua', next: ['qui'] },
        { hash: 'qui', next: [] }
      ]
    };
    result = Tweets.add('foo', currentData)('Hello World!');
    tweet = result.tweets.find(x => x.hash === '160e7fc4e51400ecd09ece3aed1788e9ecbcfaf5');
  });

  it('has the new tweet on the results with the right key', () => {
    expect(tweet).to.be.an('object');
  });

  it('has the right text', () => {
    expect(tweet.t).to.equal('Hello World!');
  });

  it('has the right next hashes, with 1, 2, 4 and 8 hops', () => {
    expect(tweet.next).to.deep.equal(['bar', 'baz', 'uno', 'qui']);
  });

  it('has the right timestamp', () => {
    expect(tweet.d).to.equal(1457409506204);
  });

  it('updates the head next keys', () => {
    expect(result.head.next).to.deep.equal(['160e7fc4e51400ecd09ece3aed1788e9ecbcfaf5', 'bar', 'qux', 'qua']);
  });

  it('updates the head timestamp', () => {
    expect(result.head.d).equal(1457409506204);
  });

  it('returns the right result for the first tweet', () => {
    result = Tweets.add('foo', { head: { hash: 'my-hash', next: [] }, tweets: [] })('foo');

    expect(result).to.deep.equal({
      head: { hash: 'my-hash', d: 1457409506204, next: ['b076d09e41bb54d3e6a9021240389807f5cdc97f'] },
      tweets: [
        { hash: 'b076d09e41bb54d3e6a9021240389807f5cdc97f', d: 1457409506204, t: 'foo', next: [] }
      ]
    });
  });
});
