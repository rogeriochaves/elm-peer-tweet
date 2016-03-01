import { expect } from 'chai';
import { spy } from 'sinon';
import Ports from '../src/Ports';

describe('Ports', () => {
  let ports, requestAddTweet, receivedData, requestPublishHead, receivedPublish;

  beforeEach(() => {
    Ports.__Rewire__('hash', () => 'myhash');
    Ports.__Rewire__('initialData', () => 'initialData');
    Ports.__Rewire__('publish', (item, fn) => fn(null, item));

    ports = {
      requestAddTweet: {
        subscribe: (fn) => { requestAddTweet = fn }
      },
      dataStream: {
        send: (data) => { receivedData = data }
      },
      requestPublishHead: {
        subscribe: (fn) => { requestPublishHead = fn }
      },
      publishStream: {
        send: (data) => { receivedPublish = data }
      }
    };
  });

  it('sets data as initial data on setup', () => {
    Ports.setup(ports);

    expect(receivedData).to.equal('initialData');
  });

  it('adds a tweet, sending the data back to the dataStream port', () => {
    Ports.setup(ports);

    requestAddTweet({ data: { head: { hash: 'myhash', next: [] }, tweets: [] }, text: 'hello world' });

    expect(receivedData).to.deep.equal({
      head: { hash: 'myhash', next: ['65131bd315f30324b0c0d6cbf2ccc058ea7523ec'] },
      tweets: [
        { hash: '65131bd315f30324b0c0d6cbf2ccc058ea7523ec', t: 'hello world', next: [] }
      ]
    });
  });

  it('publishes data, sending the hashes of data being published back', () => {
    Ports.setup(ports);

    requestPublishHead({ data: 'foo' });

    expect(receivedPublish).to.deep.equal({ data: 'foo' });
  });
});
