import { hash } from './Api/Account';
import Tweets from './Api/Tweets';
import FollowBlocks from './Api/FollowBlocks';
import { initialAccount } from './Api/Account';
import { publish } from './Api/Publish';
import { download } from './Api/Download';

const pipePort = (ports) => (input, transform, output) =>
  ports[input].subscribe((account) => {
    transform(account, (err, result) => {
      ports[output].send(result);
    });
  });

const addTweet = ({account, text}, resolve) =>
  resolve(null, Tweets.add(account)(text));

const addFollower = ({account, hash}, resolve) =>
  resolve(null, FollowBlocks.add(account)(hash));

const wireDownload = (hashKey, itemKey) => (data, resolve) =>
  download(data[hashKey], (err, item) => resolve(err, { headHash: data.headHash, [itemKey]: item }));

const wirePublish = (hashKey, itemKey) => (data, resolve) =>
  publish(data[itemKey], (err, hash) => resolve(err, { headHash: data.headHash, [hashKey]: hash }));

export const setup = (ports) => {
  const pipe = pipePort(ports);

  ports.accountStream.send(initialAccount());

  pipe('requestAddTweet', addTweet, 'accountStream');
  pipe('requestAddFollower', addFollower, 'accountStream');

  pipe('requestPublishHead', publish, 'publishHeadStream');
  pipe('requestPublishTweet', wirePublish('tweetHash', 'tweet'), 'publishTweetStream');
  pipe('requestPublishFollowBlock', wirePublish('followBlockHash', 'followBlock'), 'publishFollowBlockStream');

  pipe('requestDownloadHead', download, 'downloadHeadStream');
  pipe('requestDownloadTweet', wireDownload('tweetHash', 'tweet'), 'downloadTweetStream');
  pipe('requestDownloadFollowBlock', wireDownload('followBlockHash', 'followBlock'), 'downloadFollowBlockStream');
};

export default { setup };
