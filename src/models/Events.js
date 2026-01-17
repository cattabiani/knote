const Events = {
  makeAddNewNode(title, parentId) {
    return { type: 'addNewNode', title, parentId }
  },

  makeRemoveNode(nodeId) {
    return { type: 'removeNode', nodeId }
  },

  makeEditTitle(newTitle, nodeId) {
    return { type: 'editTitle', newTitle, nodeId }
  },

  makeFlipDone(nodeId) {
    return { type: 'flipDone', nodeId }
  },

  makeMoveNode(nodeId, newParentId, newIndex) {
    return { type: 'moveNode', nodeId, newParentId, newIndex }
  },

  makeMoveChild(nodeId, idx0, idx1) {
    return { type: 'moveChild', nodeId, idx0, idx1 }
  },

  makeRestoreNodes(nodes, rootIndex) {
    return { type: 'restoreNodes', nodes, rootIndex }
  },
}

export default Events
