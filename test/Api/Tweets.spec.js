import { expect } from 'chai';
import Tweets from '../../src/Api/Tweets';

describe('Tweets', () => {
  let currentData, result, tweet;

  beforeEach(() => {
    currentData = {
      'foo': {next: ['bar', 'baz', 'uno', 'qui']},
      'bar': {next: ['baz', 'qux', 'duo']},
      'baz': {next: ['qux', 'uno', 'tre']},
      'qux': {next: ['uno', 'duo', 'qua']},
      'uno': {next: ['duo', 'tre', 'qui']},
      'duo': {next: ['tre', 'qua']},
      'tre': {next: ['qua', 'qui']},
      'qua': {next: ['qui']},
      'qui': {}
    };
    result = Tweets.push(currentData.foo, currentData)('Hello World!');
    tweet = result['98010244c9fa394acd4058b1a5437869b8b16492'];
  });

  it('has the new tweet on the results with the right key', () => {
    expect(result['98010244c9fa394acd4058b1a5437869b8b16492']).to.be.an('object');
  });

  it('has the right text', () => {
    expect(tweet.t).to.equal('Hello World!');
  });

  it('has the right next hashes, with 1, 2, 4 and 8 hops', () => {
    expect(tweet.next).to.deep.equal(['bar', 'baz', 'uno', 'qui']);
  });
});
