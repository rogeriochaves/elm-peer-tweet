import { initialAccount, hash, createKeysWithHash, setKeys } from './Api/Account';
import Tweets from './Api/Tweets';
import FollowBlocks from './Api/FollowBlocks';
import { publish } from './Api/Publish';
import { download } from './Api/Download';

const pipePort = (ports) => (input, transform, output, errorOutput = null) =>
  ports[input].subscribe((data) => {
    transform(data, (err, result) => {
      if (err && errorOutput)
        ports[errorOutput].send([data, err]);

      if (!err)
        ports[output].send(result);
    });
  });

const addTweet = ({account, text}, resolve) =>
  resolve(null, Tweets.add(account)(text));

const addFollower = ({account, hash}, resolve) =>
  resolve(null, FollowBlocks.add(account)(hash));

const createKeys = (_, resolve) =>
  resolve(null, createKeysWithHash());

const login = (keys, resolve) =>
  resolve(null, setKeys(keys));

const wireDownload = (hashKey, itemKey) => (data, resolve) =>
  download(data[hashKey], (err, item) => resolve(err, { headHash: data.headHash, [itemKey]: item }));

const wirePublish = (hashKey, itemKey) => (data, resolve) =>
  publish(data[itemKey], (err, hash) => resolve(err, { headHash: data.headHash, [hashKey]: hash }));

export const setup = (ports) => {
  const pipe = pipePort(ports);

  pipe('requestAddTweet', addTweet, 'accountStream');
  pipe('requestAddFollower', addFollower, 'accountStream');

  pipe('requestPublishHead', publish, 'publishHeadStream');
  pipe('requestPublishTweet', wirePublish('tweetHash', 'tweet'), 'publishTweetStream');
  pipe('requestPublishFollowBlock', wirePublish('followBlockHash', 'followBlock'), 'publishFollowBlockStream');

  pipe('requestDownloadHead', download, 'downloadHeadStream', 'downloadErrorStream');
  pipe('requestDownloadTweet', wireDownload('tweetHash', 'tweet'), 'downloadTweetStream', 'downloadErrorStream');
  pipe('requestDownloadFollowBlock', wireDownload('followBlockHash', 'followBlock'), 'downloadFollowBlockStream', 'downloadErrorStream');

  pipe('requestCreateKeys', createKeys, 'createdKeysStream');
  pipe('requestLogin', login, 'doneLoginStream');
};

export default { setup };
