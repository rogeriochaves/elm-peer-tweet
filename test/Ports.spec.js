import { expect } from 'chai';
import { spy } from 'sinon';
import Ports from '../src/Ports';

describe('Ports', () => {
  let ports, requestAddTweet, receivedData;

  beforeEach(() => {
    Ports.__Rewire__('hash', () => 'myhash');
    Ports.__Rewire__('initialData', () => 'initialData');

    ports = {
      requestAddTweet: {
        subscribe: (fn) => { requestAddTweet = fn }
      },
      setData: {
        send: (data) => { receivedData = data }
      }
    };
  });

  it('sets data as initial data on setup', () => {
    Ports.setup(ports);

    expect(receivedData).to.equal('initialData');
  });

  it('adds a tweet, sending the data back to the setData port', () => {
    Ports.setup(ports);

    requestAddTweet({ data: { head: { hash: 'myhash', next: [] }, tweets: [] }, text: 'hello world' });

    expect(receivedData).to.deep.equal({
      head: { hash: 'myhash', next: ['65131bd315f30324b0c0d6cbf2ccc058ea7523ec'] },
      tweets: [
        { hash: '65131bd315f30324b0c0d6cbf2ccc058ea7523ec', t: 'hello world', next: [] }
      ]
    });
  });
});
