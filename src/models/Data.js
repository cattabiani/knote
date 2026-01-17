import Node from './Node.js'
import Events from './Events.js'

const Data = {
  make() {
    const root = Node.make('root', 'root')
    const data = { root }
    return data
  },

  has(data, id) {
    return id in data
  },

  getNode(data, id) {
    const node = data[id]
    if (!node) return data['root']
    return node
  },

  getNodeByTitle(data, title) {
    for (const node of Object.values(data)) {
      if (node.title === title) {
        return node
      }
    }
    return null
  },

  // post-order traversal for safe deletion. parent 0 with children 1 2 3 yields 3 2 1 0
  *walk(data, id) {
    const node = this.getNode(data, id)
    for (let i = node.children.length - 1; i >= 0; i--) {
      yield* this.walk(data, node.children[i])
    }
    yield node
  },

  addNode(data, node) {
    if (data[node.id]) {
      throw new Error(`Node with id ${node.id} already exists`)
    }
    data[node.id] = node
    return node
  },

  addNewNode(data, title, parentId) {
    const parent = this.getNode(data, parentId)
    const node = Node.make(title)
    Node.addChild(parent, node)
    data[node.id] = node
    return node
  },

  restoreNodes(data, nodes, rootIndex) {
    if (!nodes.length) return

    // pop the root node
    const root = nodes.pop()
    const parent = this.getNode(data, root.parentId)
    Node.addChild(parent, root, rootIndex)
    this.addNode(data, root)

    // pop and add remaining nodes
    let node
    while ((node = nodes.pop())) {
      this.addNode(data, node)
    }
    return root
  },

  removeNode(data, id) {
    const node = this.getNode(data, id)
    if (node.id === 'root') throw new Error('Cannot remove root node')

    // unlink root node from parent
    const parent = this.getNode(data, node.parentId)
    const rootIndex = Node.removeChild(parent, node, false) // the parent in the root node remains

    // collect all nodes in post-order
    const deletedNodes = Array.from(this.walk(data, id))

    for (const child of deletedNodes) {
      delete data[child.id]
    }

    return { deletedNodes, rootIndex }
  },

  // newIndex < 0 means append to newParent's children
  moveNode(data, nodeId, newParentId, newIndex = -1) {
    const node = this.getNode(data, nodeId)
    const oldParent = this.getNode(data, node.parentId)
    const newParent = this.getNode(data, newParentId)

    // remove from old parent
    const oldIndex = Node.removeChild(oldParent, node)

    // add to new parent
    Node.addChild(newParent, node, newIndex)

    return { oldParent, oldIndex }
  },

  moveChild(data, nodeId, idx0, idx1) {
    const node = this.getNode(data, nodeId)
    Node.moveChild(node, idx0, idx1)
  },

  flipDone(data, nodeId) {
    if (nodeId === 'root') {
      throw new Error('Cannot flip done state of root node')
    }
    const node = this.getNode(data, nodeId)
    Node.flipDone(node)

    if (node.parentId === 'root') {
      return
    }

    const parentNode = this.getNode(data, node.parentId)
    if (parentNode.done === node.done) {
      return
    }

    const recurse = parentNode.children.every((childId) => {
      const child = this.getNode(data, childId)
      return child.done || child.id === node.id
    })

    if (recurse) {
      this.flipDone(data, parentNode.id)
    }
  },

  editTitle(data, nodeId, newTitle) {
    if (nodeId === 'root') {
      throw new Error('Cannot edit title of root node')
    }
    const node = this.getNode(data, nodeId)
    return Node.editTitle(node, newTitle)
  },

  currentPath(data, id) {
    const node = this.getNode(data, id)
    if (node.id === 'root') return '/'
    const parts = []
    let current = node
    while (current && current.id !== 'root') {
      parts.push(current.title || '(untitled)')
      current = this.getNode(data, current.parentId)
    }
    parts.push('') // leading slash
    return parts.reverse().join('/')
  },

  applyEvent(data, event) {
    switch (event.type) {
      case 'addNewNode': {
        const newNode = this.addNewNode(data, event.title, event.parentId)
        return Events.makeRemoveNode(newNode.id)
      }
      case 'removeNode': {
        const { deletedNodes, rootIndex } = this.removeNode(data, event.nodeId)
        return Events.makeRestoreNodes(deletedNodes, rootIndex)
      }
      case 'restoreNodes': {
        const root = this.restoreNodes(data, event.nodes, event.rootIndex)
        return Events.makeRemoveNode(root.id)
      }
      case 'editTitle': {
        const oldTitle = this.editTitle(data, event.nodeId, event.newTitle)
        event.newTitle = oldTitle
        return event
      }
      case 'moveNode': {
        const { oldParent, oldIndex } = this.moveNode(
          data,
          event.nodeId,
          event.newParentId,
          event.newIndex,
        )
        return Events.makeMoveNode(event.nodeId, oldParent.id, oldIndex)
      }
      case 'moveChild': {
        this.moveChild(data, event.nodeId, event.idx0, event.idx1)
        return Events.makeMoveChild(event.nodeId, event.idx1, event.idx0)
      }
      case 'flipDone': {
        this.flipDone(data, event.nodeId)
        return event
      }
      default:
        throw new Error(`Unknown event type: ${event.type}`)
    }
  },

  checkIntegrity(data) {
    const visited = new Set()

    for (const node of this.walk(data, 'root')) {
      if (visited.has(node.id)) {
        throw new Error(`Integrity error: cycle detected at ${node.id}`)
      }
      visited.add(node.id)

      for (const childId of node.children) {
        const child = this.getNode(data, childId)
        if (child.parentId !== node.id) {
          throw new Error(`Integrity error: child ${childId} parentId mismatch`)
        }
      }
    }

    // ensure all nodes are reachable from root
    for (const id in data) {
      if (!visited.has(id)) {
        throw new Error(`Integrity error: orphan node ${id}`)
      }
    }
  },
}

export default Data
