const Utils = {
  isIos() {
    return /iPhone|iPad|iPod/i.test(navigator.userAgent);
  },

  isAppInstalled() {
    return (
      window.matchMedia("(display-mode: standalone)").matches ||
      window.navigator.standalone === true
    );
  },
};

export default Utils;
