import { expect } from 'chai';
import { spy } from 'sinon';

import Tweet from '../../src/Api/Tweet';
import JSONB from 'json-buffer';

describe('Tweet', () => {
  let dhtPut, callback, currentData, dhtPutData;

  beforeEach(() => {
    let dht = {
      put: (data, fn) => {
        dhtPutData = data;
        fn();
      }
    };
    Tweet.__Rewire__('dht', dht);

    callback = spy();
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
    Tweet.publish(currentData.foo, currentData)('Hello World!', callback);
  });

  it('triggers the callback with the new tweet', () => {
    let expectedTweet = {v: {t: 'Hello World!', next: ['bar', 'baz', 'uno', 'qui']}};

    expect(callback.getCall(0).args[1]).to.deep.equal(expectedTweet);
  });

  it('triggers the callback with an error when the dht gives an error', () => {
    callback.reset();

    Tweet.__Rewire__('dht', {
      put: (_, fn) => fn('404 DOGE NOT FOUND')
    });
    Tweet.publish(currentData.foo, currentData)('Hello World!', callback);

    expect(callback.getCall(0).args[0]).to.equal('404 DOGE NOT FOUND');
  });

  it('publishes the tweet with right text to dht', () => {
    let text = JSONB.parse(dhtPutData).v.t.toString();

    expect(text).to.equal('Hello World!');
  });

  it('publishes the tweet with right next hashes to dht, with 1, 2, 4 and 8 hops', () => {
    let next = JSONB.parse(dhtPutData).v.next.toString();

    expect(next).to.equal('barbazunoqui');
  });
});
