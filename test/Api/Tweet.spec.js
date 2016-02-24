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

  it('publishes the tweet with right text to dht', () => {
    let text = JSONB.parse(dhtPutData).v.t.toString();

    expect(text).to.equal('Hello World!');
  });

  it('publishes the tweet with right next hashes to dht, with 1, 2, 4 and 8 hops', () => {
    let next = JSONB.parse(dhtPutData).v.next.toString();

    expect(next).to.equal('barbazunoqui');
  });
});
