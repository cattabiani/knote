<template>
  <q-page class="flex flex-center">
    hello there
    {{store.data}}
  </q-page>
</template>

<script setup>

import { useStore } from "src/stores/store";
const store = useStore();
//
</script>
