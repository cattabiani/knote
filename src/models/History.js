import Data from "./Data.js";
const History = {
  make(max) {
    const idx = 0; // first not done
    const head = 0;
    const len = 0;
    const stack = new Array(max).fill(null);
    return { head, len, idx, stack, max };
  },

  _at(h, idx) {
    return (h.head + idx) % h.max;
  },

  push(h, event, data) {
    // drop tail
    h.len = h.idx;

    // add item at len
    h.stack[this._at(h, h.len)] = event;

    // update head and idx if overflow
    if (h.len === h.max) {
      h.head = this._at(h, 1);
    } else {
      // otherwise, increase len
      ++h.len;
    }

    h.idx = h.len - 1;
    this.redo(h, data);
  },

  redo(h, data) {
    if (h.idx >= h.len) return;

    const idx = this._at(h, h.idx);
    try {
      h.stack[idx] = Data.applyEvent(data, h.stack[idx]);
      ++h.idx;
    } catch (e) {
      --h.len;
      h.idx = h.len;
      throw e;
    }
  },

  undo(h, data) {
    if (h.idx <= 0) return;
    --h.idx;
    const idx = this._at(h, h.idx);
    try {
      h.stack[idx] = Data.applyEvent(data, h.stack[idx]);
    } catch (e) {
      const stop = this._at(h, h.len);
      if (idx < stop) {
        h.stack.copyWithin(idx, idx + 1, h.len);
      } else {
        h.stack.copyWithin(idx, idx + 1, h.stack.length);
        h.stack[h.stack.length - 1] = h.stack[0];
        h.stack.copyWithin(0, 1, stop);
      }
      --h.len;
      throw e;
    }
  },
};

export default History;
