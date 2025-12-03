import { v4 as uuidv4 } from "uuid";

const Node = {
  make(title = "", id = "") {
    if (!id) {
      id = uuidv4();
    }
    let done = false;
    let children = [];
    let parentId = null;
    return { id, parentId, title, done, children };
  },

  addChild(parent, child, index = -1) {
    if (index < 0 || index > parent.children.length) {
      parent.children.push(child.id);
    } else {
      parent.children.splice(index, 0, child.id);
    }
    child.parentId = parent.id;
  },

  removeChild(parent, child, removeParent = true) {
    const index = parent.children.findIndex((c) => c === child.id);
    if (index === -1) {
      throw new Error(
        `Node ${child.id} not found in parent ${parent.id}'s children`,
      );
    }
    parent.children.splice(index, 1);
    if (removeParent) {
      // remove parent reference from child
      child.parentId = null;
    }

    return index;
  },

  swapChildren(parent, idx0, idx1) {
    if (
      idx0 < 0 ||
      idx1 < 0 ||
      idx0 >= parent.children.length ||
      idx1 >= parent.children.length
    ) {
      return;
    }

    [parent.children[idx0], parent.children[idx1]] = [
      parent.children[idx1],
      parent.children[idx0],
    ];
  },

  flipDone(node) {
    const old = node.done;
    node.done = !node.done;
    return old;
  },

  editTitle(node, newTitle) {
    const oldTitle = node.title;
    node.title = newTitle;
    return oldTitle;
  },
};

export default Node;
