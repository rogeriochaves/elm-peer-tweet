import { expect } from 'chai';
import Tweets from '../../src/Api/Tweets';

describe('Tweets', () => {
  let currentData, result, tweet;

  beforeEach(() => {
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
    tweet = result.tweets.find(x => x.hash === '30671613bbf209cf79a466b469bac7dcec35557c');
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

  it('returns the right result for the first tweet', () => {
    result = Tweets.add('foo', { head: { hash: 'my-hash', next: [] }, tweets: [] })('foo');

    expect(result).to.deep.equal({
      head: { hash: 'my-hash', next: ['8a4d908bf7daaf30abb6b8e1ea79510893a4385b'] },
      tweets: [
        { hash: '8a4d908bf7daaf30abb6b8e1ea79510893a4385b', t: 'foo', next: [] }
      ]
    });
  });
});
