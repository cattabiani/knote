import { describe, it, expect, beforeEach } from "vitest";
import Data from "../src/models/Data.js";

describe("Data module", () => {
  let data;

  beforeEach(() => {
    data = Data.make(); // fresh root
  });

  it("should create root node", () => {
    expect(data.root).toBeDefined();
    expect(data.root.id).toBe("root");
    expect(data.root.children).toEqual([]);
  });

  it("should add new nodes", () => {
    const node1 = Data.addNewNode(data, "child1", "root");
    const node2 = Data.addNewNode(data, "child2", "root");

    expect(data[node1.id]).toBe(node1);
    expect(data[node2.id]).toBe(node2);
    expect(data.root.children).toEqual([node1.id, node2.id]);
  });

  it("walk yields nodes in post-order", () => {
    const n1 = Data.addNewNode(data, "n1", "root");
    const n2 = Data.addNewNode(data, "n2", "root");
    const n3 = Data.addNewNode(data, "n3", n1.id);

    const walked = Array.from(Data.walk(data, "root")).map((n) => n.id);
    // post-order: children first (right-to-left), then parent
    expect(walked).toEqual([n2.id, n3.id, n1.id, data.root.id]);
  });

  it("removeNode deletes nodes and returns them", () => {
    const n1 = Data.addNewNode(data, "n1", "root");
    const n2 = Data.addNewNode(data, "n2", n1.id);

    const { deletedNodes, rootIndex } = Data.removeNode(data, n1.id);

    const deletedIds = deletedNodes.map((n) => n.id);
    expect(deletedIds).toContain(n1.id);
    expect(deletedIds).toContain(n2.id);
    expect(data[n1.id]).toBeUndefined();
    expect(data[n2.id]).toBeUndefined();
    expect(data.root.children.includes(n1.id)).toBe(false);
    expect(typeof rootIndex).toBe("number");

    Data.checkIntegrity(data);
  });

  it("restoreNodes restores deleted nodes", () => {
    const n1 = Data.addNewNode(data, "n1", "root");
    const n2 = Data.addNewNode(data, "n2", n1.id);

    const { deletedNodes, rootIndex } = Data.removeNode(data, n1.id);
    Data.restoreNodes(data, deletedNodes, rootIndex);

    expect(data[n1.id]).toBeDefined();
    expect(data[n2.id]).toBeDefined();
    expect(data.root.children.includes(n1.id)).toBe(true);
    expect(data[n1.id].children.includes(n2.id)).toBe(true);

    Data.checkIntegrity(data);
  });

  it("removeNode restore nested deleted nodes", () => {
    const A = Data.addNewNode(data, "A", "root");
    const B = Data.addNewNode(data, "B", "root");
    const A1 = Data.addNewNode(data, "A1", A.id);
    const A2 = Data.addNewNode(data, "A2", A.id);
    const A2a = Data.addNewNode(data, "A2a", A2.id);
    const A2a1 = Data.addNewNode(data, "A2a1", A2a.id);
    const A2a1a = Data.addNewNode(data, "A2a1a", A2a1.id);

    Data.checkIntegrity(data);

    const snapshot = structuredClone(data);

    let { deletedNodes, rootIndex } = Data.removeNode(data, A2.id);

    Data.checkIntegrity(data);

    let removedNode = Data.restoreNodes(data, deletedNodes, rootIndex);

    expect(removedNode).toEqual(A2);

    expect(data).toEqual(snapshot);

    Data.checkIntegrity(data);

    ({ deletedNodes, rootIndex } = Data.removeNode(data, A2.id));
    Data.checkIntegrity(data);
    removedNode = Data.restoreNodes(data, deletedNodes, rootIndex);
    Data.checkIntegrity(data);
    expect(data).toEqual(snapshot);
  });

  it("moveNode moves node between parents and within same parent", () => {
    const A = Data.addNewNode(data, "A", "root");
    const B = Data.addNewNode(data, "B", "root");
    const A1 = Data.addNewNode(data, "A1", A.id);
    const A2 = Data.addNewNode(data, "A2", A.id);

    Data.checkIntegrity(data);

    // move A2 under B
    const { oldParent, oldIndex } = Data.moveNode(data, A2.id, B.id);
    expect(typeof oldIndex).toBe("number");
    expect(oldParent.id).toBe(A.id);
    expect(data[B.id].children).toContain(A2.id);
    expect(data[A.id].children).not.toContain(A2.id);
    expect(data[A2.id].parentId).toBe(B.id);

    Data.checkIntegrity(data);

    // move A2 back under A
    Data.moveNode(data, A2.id, A.id, oldIndex);
    expect(data[A.id].children[oldIndex]).toBe(A2.id);
    expect(data[B.id].children).not.toContain(A2.id);
    expect(data[A2.id].parentId).toBe(A.id);

    Data.checkIntegrity(data);
  });

  it("currentPath returns correct paths", () => {
    const A = Data.addNewNode(data, "A", "root");
    const B = Data.addNewNode(data, "B", A.id);
    const C = Data.addNewNode(data, "C", B.id);
    const Untitled = Data.addNewNode(data, "", C.id);

    expect(Data.currentPath(data, "root")).toBe("/");
    expect(Data.currentPath(data, A.id)).toBe("/A");
    expect(Data.currentPath(data, B.id)).toBe("/A/B");
    expect(Data.currentPath(data, C.id)).toBe("/A/B/C");
    expect(Data.currentPath(data, Untitled.id)).toBe("/A/B/C/(untitled)");

    Data.checkIntegrity(data);
  });
});
