import { expect } from 'chai';
import { spy } from 'sinon';
import Ports from '../src/Ports';

describe('Ports', () => {
  let ports, requests, responses;

  beforeEach(() => {
    global.localStorage = {
      publicKey: '1b5a526a05953cff95dbf6c160cc3c621a4c12f360c111c5c44b01c925d24167',
      secretKey: 'b80cb5444cd32ca171381244bc34fe0950740cbbd4c9c7eee7730822071382588cb57de6a8d71a1d48e7290061eb667be454986ca0b8553599abaa43761fb9a4'
    };

    Ports.__Rewire__('initialAccount', () => 'initialAccount');
    Ports.__Rewire__('publish', (item, fn) => fn(null, item.hash));
    Ports.__Rewire__('download', (hash, fn) => fn(null, { hash: hash } ));

    requests = {};
    responses = {};
    ports = {};

    const addInboundPort = (name) =>
      ports[name] = {subscribe: (fn) => { requests[name] = fn }};

    const addOutboundPort = (name) =>
      ports[name] = {send: (data) => { responses[name] = data }};

    [ 'requestAddTweet', 'requestAddFollower', 'requestPublishHead', 'requestPublishTweet', 'requestPublishFollowBlock'
    , 'requestDownloadHead', 'requestDownloadTweet', 'requestDownloadFollowBlock', 'requestCreateKeys', 'requestLogin', 'setStorage' ].
      forEach(addInboundPort);

    [ 'accountStream', 'publishHeadStream', 'publishTweetStream', 'publishFollowBlockStream', 'downloadErrorStream'
    , 'downloadHeadStream', 'downloadTweetStream', 'downloadFollowBlockStream', 'createdKeysStream', 'doneLoginStream' ].
      forEach(addOutboundPort);
  });

  it('adds a tweet, sending the account back to the accountStream port', () => {
    Ports.setup(ports);

    Date.now = () => 1457409506204;

    requests['requestAddTweet']({ account: { head: { hash: 'myhash', next: [] }, tweets: [] }, text: 'hello world' });

    expect(responses['accountStream']).to.deep.equal({
      head: { hash: 'myhash', d: 1457409506204, next: ['6048a8a05b82c3ad229e897788f339c02449660e'] },
      tweets: [
        { hash: '6048a8a05b82c3ad229e897788f339c02449660e', d: 1457409506204, t: 'hello world', next: [] }
      ]
    });
  });

  it('adds a follower, sending the account back to the accountStream port', () => {
    Ports.setup(ports);

    Date.now = () => 1457409506204;

    requests['requestAddFollower']({ account: { head: { hash: 'myhash', next: [], f: [] }, followBlocks: [] }, hash: '6048a8a05b82c3ad229e897788f339c02449660e' });

    expect(responses['accountStream']).to.deep.equal({
      head: { hash: 'myhash', d: 1457409506204, next: [], f: ['d703c79f640a8443d288e58d9f31dae2df4a3179'] },
      followBlocks: [
        { hash: 'd703c79f640a8443d288e58d9f31dae2df4a3179', l: ['6048a8a05b82c3ad229e897788f339c02449660e'], next: [] }
      ]
    });
  });

  it('publishes head, sending the hashes of account being published back', () => {
    Ports.setup(ports);

    requests['requestPublishHead']({ hash: 'foo' });

    expect(responses['publishHeadStream']).to.equal('foo');
  });

  it('publishes tweet, sending the hashes of account being published back', () => {
    Ports.setup(ports);

    requests['requestPublishTweet']({ headHash: 'foo', tweet: {hash: 'bar'} });

    expect(responses['publishTweetStream']).to.deep.equal({ headHash: 'foo', tweetHash: 'bar' });
  });

  it('publishes followBlock, sending the hashes of account being published back', () => {
    Ports.setup(ports);

    requests['requestPublishFollowBlock']({ headHash: 'foo', followBlock: {hash: 'bar'} });

    expect(responses['publishFollowBlockStream']).to.deep.equal({ headHash: 'foo', followBlockHash: 'bar' });
  });

  it('downloads head, sending account back when there is no error', () => {
    Ports.setup(ports);

    requests['requestDownloadHead']('foo');

    expect(responses['downloadHeadStream']).to.deep.equal({ hash: 'foo' });
  });

  it('downloads head, sending error back when there is an error', () => {
    Ports.__Rewire__('download', (hash, fn) => fn('DOGE NOT FOUND', null));

    Ports.setup(ports);
    requests['requestDownloadHead']('foo');

    expect(responses['downloadErrorStream']).to.deep.equal([ 'foo', 'DOGE NOT FOUND' ]);
  });

  it('downloads tweet, sending the hash with error back when there is an error', () => {
    Ports.__Rewire__('download', (hash, fn) => fn('DOGE NOT FOUND', null));

    Ports.setup(ports);
    requests['requestDownloadHead']({ headHash: 'bar', tweetHash: 'baz' });

    expect(responses['downloadErrorStream']).to.deep.equal([ 'bar', 'DOGE NOT FOUND' ]);
  });

  it('downloads tweet by hash, sending tweet back', () => {
    Ports.setup(ports);

    requests['requestDownloadTweet']({ headHash: 'foo', tweetHash: 'bar' });

    expect(responses['downloadTweetStream']).to.deep.equal({ headHash: 'foo', tweet: { hash:'bar' } });
  });

  it('creates keys, sending the hash and the keys back', () => {
    Ports.setup(ports);

    requests['requestCreateKeys']();

    expect(responses['createdKeysStream'].keys).to.deep.equal(global.localStorage);
    expect(responses['createdKeysStream'].hash.length).to.equal(40);
  });

  it('request login, setting the public and secret keys, and sending the hash back', () => {
    Ports.setup(ports);

    requests['requestLogin']({publicKey: '4ab783316d341ebcfc4476fafb5d6b330faf61ece2932f77f82b08d9768da81a', secretKey: '08a3287eebbe8dada17052020d409e4e9c3974ba3722f913744a9b819650e0688d65631fdc1042bd22127dcd9ea69bd990af8d1eda378bb083d5fb76b60304cd'});

    expect(responses['doneLoginStream']).to.deep.equal('61d323b6e262992538cc514c2d209deec0c519fe');
  });

  it('updates the localStorage accounts as JSON', () => {
    Ports.setup(ports);

    requests['setStorage'](['abc', 'def']);

    expect(global.localStorage.accounts).to.equal('["abc","def"]');
  });
});
