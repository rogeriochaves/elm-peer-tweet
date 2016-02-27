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
    tweet = result.tweets.find(x => x.hash === '98010244c9fa394acd4058b1a5437869b8b16492');
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
    result = Tweets.add('foo', { head: { hash: 'foo', next: [] }, tweets: [] })('Hello World!');

    expect(result).to.deep.equal({
      head: { hash: 'foo', next: ['e99efbee7f6affc92c20bc2bdef3eddd8b611728'] },
      tweets: [
        { hash: 'e99efbee7f6affc92c20bc2bdef3eddd8b611728', t: 'Hello World!', next: [] }
      ]
    });
  });
});
