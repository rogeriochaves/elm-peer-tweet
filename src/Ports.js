import { hash } from './Api/Account';
import Tweets from './Api/Tweets';
import { initialData } from './Api/Account';
import { publish } from './Api/Publish';
import { download } from './Api/Download';

const pipePort = (ports) => (input, transform, output) =>
  ports[input].subscribe((data) => {
    transform(data, (err, result) => {
      ports[output].send(result);
    });
  });

const addTweet = ({data, text}, resolve) =>
  resolve(null, Tweets.add(data)(text));

export const setup = (ports) => {
  const pipe = pipePort(ports);

  ports.dataStream.send(initialData());

  pipe('requestAddTweet', addTweet, 'dataStream');

  pipe('requestPublishHead', publish, 'publishHeadStream');
  pipe('requestPublishTweet', publish, 'publishTweetStream');

  pipe('requestDownloadHead', download, 'downloadHeadStream');
  pipe('requestDownloadTweet', download, 'downloadTweetStream');
};

export default { setup };
