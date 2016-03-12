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

const downloadTweet = ({headHash, tweetHash}, resolve) =>
  download(tweetHash, (err, tweet) => resolve(err, { headHash, tweet }));

export const setup = (ports) => {
  const pipe = pipePort(ports);

  ports.accountStream.send(initialAccount());

  pipe('requestAddTweet', addTweet, 'accountStream');
  pipe('requestAddFollower', addFollower, 'accountStream');

  pipe('requestPublishHead', publish, 'publishHeadStream');
  pipe('requestPublishTweet', publish, 'publishTweetStream');

  pipe('requestDownloadHead', download, 'downloadHeadStream');
  pipe('requestDownloadTweet', downloadTweet, 'downloadTweetStream');
};

export default { setup };
