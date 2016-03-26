export const getLocalStorage = () =>
  (typeof window !== 'undefined' && window.localStorage) || global.localStorage;

export const openLinksInBrowser = () => {
  document.addEventListener('click', (event) => {
    const { target } = event;

    if (target.tagName === 'A' && target.href.match(/^http/)) {
      require('electron').shell.openExternal(target.href);
      event.returnValue = false;
    }
  }, false);
};
