import { hash } from './Api/Account';
import Tweets from './Api/Tweets';
import { initialData } from './Api/Account';
import { publish } from './Api/Publish';
import { download } from './Api/Download';

const pipePort = (input, transform, output) =>
  input.subscribe((data) => {
    transform(data, (err, result) => {
      output.send(result);
    });
  });

const addTweet = ({data, text}, resolve) =>
  resolve(null, Tweets.add(hash(), data)(text));

export const setup = (ports) => {
  const { requestAddTweet, dataStream,
          requestPublishHead, publishHeadStream,
          requestPublishTweet, publishTweetStream,
          requestDownloadHead, downloadHeadStream,
          requestDownloadTweet, downloadTweetStream } = ports;

  dataStream.send(initialData());

  pipePort(requestAddTweet, addTweet, dataStream);

  pipePort(requestPublishHead, publish, publishHeadStream);
  pipePort(requestPublishTweet, publish, publishTweetStream);

  pipePort(requestDownloadHead, download, downloadHeadStream);
  pipePort(requestDownloadTweet, download, downloadTweetStream);
};

export default { setup };
