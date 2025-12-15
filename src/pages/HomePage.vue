<template>
  <q-header elevated class="bg-primary text-white">
    <q-toolbar>
      <q-btn
        flat
        icon="arrow_back"
        @click="goBack"
        aria-label="Go Back"
        class="bg-white text-primary q-mr-md"
      />
      <q-space />
      <q-btn flat icon="undo" @click="store.undo()" class="q-ml-md bg-white text-primary"> </q-btn>
      <q-btn flat icon="redo" @click="store.redo()" class="q-ml-md bg-white text-primary"> </q-btn>

      <q-btn flat icon="add" @click="activateModalMode" class="q-ml-md bg-white text-primary"> </q-btn>
    </q-toolbar>
    <q-toolbar>
      {{ store.currentPath }}
      <q-space />
      <q-btn
        v-if="store.currentChildren.length > 0"
        flat
        :icon="store.showDone ? 'visibility' : 'visibility_off'"
        @click="store.showDone = !store.showDone"
        class="q-ml-md bg-white text-primary"
      >
      </q-btn>
      <q-btn
        flat
        :icon="nestMode ? 'folder_open' : 'folder'"
        @click="nestMode = !nestMode"
        class="q-ml-md bg-white text-primary"
      >
      </q-btn>

      <!-- <q-btn
        flat
        class="q-ml-md bg-white text-primary"
        icon="add"
        color="transparent"
        @click="activateModalMode"
      >
        <q-icon
          name="add"
          style="position: absolute; top: 5%; left: 7%; font-size: 1.2em; color: var(--q-primary)"
        />
        <q-icon
          name="add"
          style="
            position: absolute;
            bottom: 0%;
            left: 18%;
            font-size: 1.6em;
            color: var(--q-primary);
          "
        />
        <q-icon
          name="add"
          style="position: absolute; top: -5%; left: 40%; font-size: 2.5em; color: var(--q-primary)"
        />
      </q-btn> -->
    </q-toolbar>
  </q-header>

  <q-page class="column">
    <q-input
      v-if="store.currentNode.id !== `root`"
      outlined
      label="Title"
      v-model="title"
      class="q-ml-sm q-mr-sm q-mt-sm text-h5"
      ref="titleInput"
      @blur="editTitle"
    >
      <template #append>
        <q-btn dense color="green" icon="check" text-color="white" @click="titleOk" />
      </template>
    </q-input>

    <draggable
      :list="childrenList.slice()"
      item-key="id"
      handle=".drag-handle"
      animation="200"
      :ghost-class="nestMode ? 'hidden-ghost' : ''"
      @change="onChange"
      class="q-ma-sm"
    >
      <template #item="{ element: child, index: i }">
        <q-slide-item
          @left="(reset) => onLeft(child.id, reset)"
          @right="(reset) => onRight(child.id, reset)"
          left-color="red"
          right-color="green"
          v-show="store.showDone || !child.done"
        >
          <template v-slot:left>
            <q-icon name="delete" />
          </template>
          <template v-slot:right>
            <q-icon name="done" />
          </template>
          <q-item
            clickable
            v-ripple
            :class="
              child.isMoveUpItem
                ? 'bg-grey-4'
                : store.showDone
                  ? i % 2 === 0
                    ? 'bg-white'
                    : 'bg-grey-2'
                  : child.visibleIndex % 2 === 0
                    ? 'bg-white'
                    : 'bg-grey-2'
            "
            class="q-py-md text-h5"
            @dblclick="store.goTo(child.id)"
            v-show="!(child.isMoveUpItem && store.currentNode.id === 'root')"
          >
            <q-icon v-if="child.isMoveUpItem" name="arrow_upward" class="q-mr-sm self-center" />

            <q-icon
              v-if="!child.isMoveUpItem && store.showDone"
              :name="child.done ? 'check_circle' : 'radio_button_unchecked'"
              :color="child.done ? 'green' : 'grey-5'"
              class="q-mr-sm self-center"
            />
            <q-icon v-if="child.isFolder" name="folder_open" class="q-mr-sm self-center" />

            <q-item-section>
              <q-item-label>
                <q-item-label>{{ child.title || '(untitled)' }} </q-item-label>
                <!-- <q-input
                dense
                borderless
                v-model="child.title"
                placeholder="(untitled)"
                :disable="child.isMoveUpItem"
                @blur="!child.isMoveUpItem && editNodeTitle(child)"
                @keyup.enter="!child.isMoveUpItem && editNodeTitle(child)"
              /> -->
              </q-item-label>
            </q-item-section>

            <q-btn v-if="!child.isMoveUpItem" dense icon="drag_handle" class="drag-handle" />
          </q-item>
        </q-slide-item>
      </template>
    </draggable>

    <q-dialog v-model="modalMode" position="top">
      <q-card
        class="q-pa-none"
        style="
          width: 80%;
          min-height: 45vh;
          display: flex;
          flex-direction: column;
          margin-top: 15vh;
        "
      >
        <div style="flex: 1; display: flex; flex-direction: column; padding: 1em">
          <textarea
            ref="modalTextarea"
            v-model="modalText"
            placeholder="Your notes. Each row is a note."
            class="text-h5"
            style="flex: 1; min-height: 0; width: 100%; resize: none; box-sizing: border-box"
          ></textarea>
        </div>

        <q-card-actions align="center" class="q-pa-sm">
          <q-btn class="q-ml-md bg-red text-white" flat icon="close" @click="modalMode = false" />
          <q-btn flat class="q-ml-md bg-green text-white" icon="check" @click="okModalMode" />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script setup>
defineOptions({
  name: 'HomePage',
})

import { useRouter } from 'vue-router'
import { useStore } from 'src/stores/store'
import { ref, computed, watch, nextTick } from 'vue'
import draggable from 'vuedraggable'

const router = useRouter()
const store = useStore()

const nestMode = ref(false)
const titleInput = ref(null)
const title = ref(String(store.currentNode.title))
const modalMode = ref(false)
const modalText = ref('')
const modalTextarea = ref(null)

const okModalMode = () => {
  modalText.value
    .split('\n') // split by newline
    .map((s) => s.trim()) // trim whitespace
    .filter((s) => s.length) // remove empty strings
    .forEach((title) => store.addNode(title)) // call addNode for each

  modalMode.value = false
  modalText.value = ''
}

const activateModalMode = () => {
  modalMode.value = true

  nextTick(() => {
    modalTextarea.value?.focus()
  })
}

const onRight = (id, { reset }) => {
  store.flipDone(id)
  reset()
}

const onLeft = (id, { reset }) => {
  if (!store.removeNode(id)) {
    reset()
  }
}

watch(
  () => store.currentNode.title,
  (newTitle) => {
    title.value = newTitle
  },
)

const titleOk = () => {
  editTitle()
  store.goBack()
}

const editTitle = () => {
  if (store.currentNode.title !== title.value) {
    store.editNodeTitle(title.value, store.currentNode.id)
  }
}

// const addNode = () => {
//   store.addNode()
//   store.goTo(store.currentChildren[store.currentChildren.length - 1].id)
// }

watch(
  () => store.currentNode.id,
  async (newId) => {
    if (newId !== 'root') {
      await nextTick() // wait until the input is rendered
      titleInput.value?.focus() // focus it
    }
  },
)

const goBack = () => {
  if (!store.goBack()) {
    router.replace({ name: 'LandingPage' })
  }
}

const childrenList = computed(() => {
  let visibleIndex = 0
  const baseList = store.currentChildren.map((c) => {
    const item = {
      title: c.title,
      id: c.id,
      done: c.done,
      isFolder: c.children.length > 0,
    }

    if (!c.done) {
      item.visibleIndex = visibleIndex
      visibleIndex++
    } else {
      item.visibleIndex = -1 // optional: mark done items
    }

    return item
  })

  if (nestMode.value) {
    // Add the "Move to parent" item at the start
    return [
      {
        id: store.currentNode.parentId,
        title: 'Move to parent',
        done: false,
        isMoveUpItem: true,
      },
      ...baseList,
    ]
  }

  return baseList
})

const onChange = (evt) => {
  if (evt.moved) {
    if (nestMode.value) {
      const nodeId = childrenList.value[evt.moved.oldIndex].id
      const parentId = childrenList.value[evt.moved.newIndex].id
      store.moveNode(nodeId, parentId)
    } else {
      store.swapChildren(evt.moved.oldIndex, evt.moved.newIndex)
    }
  }
}
</script>
