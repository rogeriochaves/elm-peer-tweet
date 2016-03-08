import { expect } from 'chai';
import { spy } from 'sinon';
import Download from '../../src/Api/Download';

describe('Download', () => {
  let headResponse, tweetResponse, callback;

  beforeEach(() => {
    tweetResponse = {
      id: new Buffer([138, 77, 221, 23, 241, 16, 219, 114, 118, 255, 212, 115, 239, 100, 122, 70, 102, 112, 72, 78]),
      seq: 0,
      token: new Buffer([224, 103, 19, 182, 217, 173, 135, 131, 137, 52, 54, 117, 68, 29, 121, 120, 21, 99, 112, 24]),
      v: {
        next: new Buffer([52, 55, 51, 51, 56, 49, 102, 102, 56, 56, 49, 99, 57, 49, 102, 51, 98, 102, 101, 100, 101, 50, 56, 102, 52, 50, 102, 56, 99, 98, 100, 55, 55, 55, 52, 50, 53, 51, 54, 51, 56, 97, 52, 100, 57, 48, 56, 98, 102, 55, 100, 97, 97, 102, 51, 48, 97, 98, 98, 54, 98, 56, 101, 49, 101, 97, 55, 57, 53, 49, 48, 56, 57, 51, 97, 52, 51, 56, 53, 98]),
        t: new Buffer([98, 97, 122]),
        d: new Buffer([1, 83, 84, 75, 138, 211])
      }
    };

    headResponse = {
      id: new Buffer([166, 90, 117, 6, 113, 138, 228, 210, 68, 169, 251, 112, 255, 252, 189, 64, 144, 130, 185, 166]),
      k: new Buffer([3, 179, 163, 70, 213, 86, 159, 236, 194, 177, 249, 2, 202, 254, 60, 227, 223, 55, 133, 90, 54, 144, 180, 173, 123, 120, 188, 30, 216, 92, 169, 95]),
      seq: 1,
      sig: new Buffer([25, 66, 61, 55, 169, 216, 110, 92, 168, 94, 79, 106, 247, 46, 243, 142, 231, 163, 136, 185, 17, 138, 219, 213, 160, 60, 92, 30, 18, 52, 169, 82, 87, 154, 39, 248, 10, 210, 133, 11, 59, 34, 23, 215, 90, 240, 83, 54, 155, 73, 215, 95, 164, 79, 72, 130, 145, 234, 120, 163, 226, 221, 100, 0]),
      token: new Buffer([137, 80, 157, 37, 43, 84, 119, 65, 221, 211, 151, 231, 53, 237, 98, 191, 48, 25, 18, 69]),
      v: {
        next: new Buffer([52, 55, 51, 51, 56, 49, 102, 102, 56, 56, 49, 99, 57, 49, 102, 51, 98, 102, 101, 100, 101, 50, 56, 102, 52, 50, 102, 56, 99, 98, 100, 55, 55, 55, 52, 50, 53, 51, 54, 51, 56, 97, 52, 100, 57, 48, 56, 98, 102, 55, 100, 97, 97, 102, 51, 48, 97, 98, 98, 54, 98, 56, 101, 49, 101, 97, 55, 57, 53, 49, 48, 56, 57, 51, 97, 52, 51, 56, 53, 98]),
        d: new Buffer([1, 83, 86, 34, 199, 187])
      }
    };

    let dht = {
      get: (hash, fn) => {
        hash === 'head' ? fn(null, headResponse) : fn(null, tweetResponse);
      }
    };
    Download.__Rewire__('dht', dht);

    callback = spy();
    Download.download('head', callback);
    Download.download('tweet', callback);
  });

  it('calls the callback with the head response', () => {
    expect(callback.getCall(0).args[1]).to.deep.equal({
      hash: 'head',
      d: 1457439033275,
      next: ['473381ff881c91f3bfede28f42f8cbd777425363', '8a4d908bf7daaf30abb6b8e1ea79510893a4385b']
    });
    expect(callback.getCall(1).args[1]).to.deep.equal({
      hash: 'tweet',
      t: 'baz',
      d: 1457408150227,
      next: ['473381ff881c91f3bfede28f42f8cbd777425363', '8a4d908bf7daaf30abb6b8e1ea79510893a4385b']
    });
  });

  it('calls the callback without errors', () => {
    expect(callback.getCall(0).args[0]).to.equal(null);
    expect(callback.getCall(1).args[0]).to.equal(null);
  });

  it('calls the callback with an error when the dht gives an error', () => {
    callback.reset();

    Download.__Rewire__('dht', {
      get: (_, fn) => fn('404 DOGE NOT FOUND')
    });
    Download.download('tweet', callback);

    expect(callback.getCall(0).args[0]).to.equal('404 DOGE NOT FOUND');
  });

  it('has an empty array as next when next is null', () => {
    callback.reset();

    const withoutNextResponse = {
      id: new Buffer([138, 77, 221, 23, 241, 16, 219, 114, 118, 255, 212, 115, 239, 100, 122, 70, 102, 112, 72, 78]),
      seq: 0,
      token: new Buffer([224, 103, 19, 182, 217, 173, 135, 131, 137, 52, 54, 117, 68, 29, 121, 120, 21, 99, 112, 24]),
      v: {
        next: new Buffer([]),
        t: new Buffer([98, 97, 122])
      }
    };

    Download.__Rewire__('dht', {
      get: (_, fn) => fn(null, withoutNextResponse)
    });
    Download.download('tweet', callback);

    expect(callback.getCall(0).args[1]).to.deep.equal({
      hash: 'tweet',
      t: 'baz',
      next: []
    });
  });

  it('has an empty array as next when next is not there', () => {
    callback.reset();

    const withoutNextResponse = {
      id: new Buffer([138, 77, 221, 23, 241, 16, 219, 114, 118, 255, 212, 115, 239, 100, 122, 70, 102, 112, 72, 78]),
      seq: 0,
      token: new Buffer([224, 103, 19, 182, 217, 173, 135, 131, 137, 52, 54, 117, 68, 29, 121, 120, 21, 99, 112, 24]),
      v: {
        t: new Buffer([98, 97, 122])
      }
    };

    Download.__Rewire__('dht', {
      get: (_, fn) => fn(null, withoutNextResponse)
    });
    Download.download('tweet', callback);

    expect(callback.getCall(0).args[1]).to.deep.equal({
      hash: 'tweet',
      t: 'baz',
      next: []
    });
  });
});
