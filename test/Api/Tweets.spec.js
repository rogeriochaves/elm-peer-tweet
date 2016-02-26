import { expect } from 'chai';
import Tweets from '../../src/Api/Tweets';

describe('Tweets', () => {
  let currentData, result, tweet;

  beforeEach(() => {
    currentData = {
      'foo': {v: {next: ['bar', 'baz', 'uno', 'qui']}},
      'bar': {v: {next: ['baz', 'qux', 'duo']}},
      'baz': {v: {next: ['qux', 'uno', 'tre']}},
      'qux': {v: {next: ['uno', 'duo', 'qua']}},
      'uno': {v: {next: ['duo', 'tre', 'qui']}},
      'duo': {v: {next: ['tre', 'qua']}},
      'tre': {v: {next: ['qua', 'qui']}},
      'qua': {v: {next: ['qui']}},
      'qui': {v: {}}
    };
    result = Tweets.push(currentData.foo, currentData)('Hello World!');
    tweet = result['blabla'];
  });

  it('has the new tweet on the results with the right key', () => {
    expect(result['blabla']).to.be.an('object');
  });

  it('has the right text', () => {
    expect(tweet.v.t).to.equal('Hello World!');
  });

  it('has the right next hashes, with 1, 2, 4 and 8 hops', () => {
    expect(tweet.v.next).to.deep.equal(['bar', 'baz', 'uno', 'qui']);
  });
});
