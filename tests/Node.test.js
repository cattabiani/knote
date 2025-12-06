import { describe, it, expect } from "vitest";
import Node from "../src/models/Node.js";

describe("Node", () => {
  it("makes a node with defaults", () => {
    const n = Node.make();
    expect(n.id).toBeTypeOf("string");
    expect(n.title).toBe("");
    expect(n.done).toBe(false);
    expect(n.children).toEqual([]);
    expect(n.parentId).toBe(null);
  });

  it("makes a node with custom title and id", () => {
    const n = Node.make("hello", "123");
    expect(n.title).toBe("hello");
    expect(n.id).toBe("123");
  });

  it("adds a child", () => {
    const parent = Node.make("p");
    const child = Node.make("c");
    Node.addChild(parent, child);
    expect(parent.children).toContain(child.id);
    expect(child.parentId).toBe(parent.id);
  });

  it("removes a child", () => {
    const parent = Node.make();
    const child = Node.make();
    Node.addChild(parent, child);
    Node.removeChild(parent, child);
    expect(parent.children).not.toContain(child.id);
    expect(child.parentId).toBe(null);
  });

  it("throws when removing a non-child", () => {
    const parent = Node.make();
    const child = Node.make();
    expect(() => Node.removeChild(parent, child)).toThrow();
  });

  it("moves a child", () => {
    const parent = Node.make();
    const a = Node.make("a");
    const b = Node.make("b");
    const c = Node.make("c");
    Node.addChild(parent, a);
    Node.addChild(parent, b);
    Node.addChild(parent, c);

    Node.swapChildren(parent, 1, 0);
    expect(parent.children).toEqual([b.id, a.id, c.id]);
  });

  it("flips deleted", () => {
    const n = Node.make();
    const old = Node.flipDone(n);
    expect(old).toBe(false);
    expect(n.done).toBe(true);
  });

  it("edits title", () => {
    const n = Node.make("old");
    const old = Node.editTitle(n, "new");
    expect(old).toBe("old");
    expect(n.title).toBe("new");
  });
});
