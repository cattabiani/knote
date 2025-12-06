import { describe, it, expect, beforeEach } from "vitest";
import Data from "../src/models/Data.js";
import History from "../src/models/History.js";
import Events from "../src/models/Events.js";

describe("History module - basic push test", () => {
  let data;
  let history;

  const checkStack = () =>
    history.stack.map((e) => (e ? (data[e.nodeId]?.title ?? e.type) : null));

  const getTitles = () =>
    Object.values(data)
      .map((n) => n.title)
      .filter(Boolean);

  beforeEach(() => {
    data = Data.make(); // fresh root data
    history = History.make(5); // small circular buffer for testing
  });

  it("push adds events and prints internal state", () => {
    for (let i = 0; i < 13; i++) {
      History.push(history, Events.makeAddNewNode(`c${i}`, "root"), data);
    }
    const titles = history.stack.map((e) => (e ? data[e.nodeId]?.title : null));
    expect(titles).toEqual(["c10", "c11", "c12", "c8", "c9"]);
  });

  it("undo moves idx back and keeps events intact", () => {
    // push 5 events
    for (let i = 0; i < 5; i++) {
      History.push(history, Events.makeAddNewNode(`c${i}`, "root"), data);
    }

    const prevIdx = history.idx;

    // perform undo
    History.undo(history, data);

    // idx should decrease by 1
    expect(history.idx).toBe(prevIdx - 1);

    History.redo(history, data);

    // stack should still contain the same events
    const titles = history.stack.map((e) => (e ? data[e.nodeId]?.title : null));
    expect(titles).toEqual(["c0", "c1", "c2", "c3", "c4"]);
  });

  it("undo and redo correctly update idx and preserve events", () => {
    // push 5 events
    for (let i = 0; i < 5; i++) {
      History.push(history, Events.makeAddNewNode(`c${i}`, "root"), data);
    }

    // Step sequence
    History.undo(history, data); // undo last
    expect(history.idx).toBe(4);
    History.redo(history, data);
    expect(checkStack()).toEqual(["c0", "c1", "c2", "c3", "c4"]);

    // Step sequence
    History.undo(history, data); // undo last
    expect(history.idx).toBe(4);
    History.redo(history, data);
    expect(checkStack()).toEqual(["c0", "c1", "c2", "c3", "c4"]);
  });

  it("undo and redo correctly update idx and preserve events", () => {
    // push 5 events
    History.undo(history, data);

    const checkStack = () =>
      history.stack.map((e) => (e ? (data[e.nodeId]?.title ?? e.type) : null));
    expect(checkStack()).toEqual([null, null, null, null, null]);
  });

  it("undo and redo edit title", () => {
    History.push(history, Events.makeAddNewNode(`A`, "root"), data);
    const A = Data.getNodeByTitle(data, "A");
    expect(A.title).toBe("A");
    History.push(history, Events.makeEditTitle(`B`, A.id), data);
    expect(A.title).toBe("B");
    History.undo(history, data);
    expect(A.title).toBe("A");
    History.redo(history, data);
    expect(A.title).toBe("B");
    History.undo(history, data);
    expect(A.title).toBe("A");
    History.redo(history, data);
    expect(A.title).toBe("B");
    History.undo(history, data);
    History.undo(history, data);
    expect(A.title).toBe("A");
    History.redo(history, data);
    History.redo(history, data);
    expect(A.title).toBe("B");
  });

  it("swap children", () => {
    History.push(history, Events.makeAddNewNode("A", "root"), data);
    History.push(history, Events.makeAddNewNode("B", "root"), data);
    History.push(history, Events.makeAddNewNode("C", "root"), data);

    const root = data["root"];
    const A = data[root.children[0]];
    expect(A.title).toBe("A");
    const B = data[root.children[1]];
    expect(B.title).toBe("B");
    const C = data[root.children[2]];
    expect(C.title).toBe("C");

    History.push(history, Events.makeSwapChildren("root", 0, 1), data);

    let titles = root.children.map((id) => data[id].title);
    expect(titles).toEqual(["B", "A", "C"]);
    History.undo(history, data);
    titles = root.children.map((id) => data[id].title);
    expect(titles).toEqual(["A", "B", "C"]);
    History.redo(history, data);
    titles = root.children.map((id) => data[id].title);
    expect(titles).toEqual(["B", "A", "C"]);
  });
});
