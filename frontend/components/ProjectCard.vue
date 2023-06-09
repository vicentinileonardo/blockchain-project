<script setup lang="ts">
import type { NFT } from '@/model/nft';
import { Icon } from '@iconify/vue';
import AppButton from '@/components/AppButton.vue';
import { ref, computed, onMounted } from "vue";
import { useAccountStore } from "@/stores/account.store";
import { useNFTsStore } from "@/stores/nfts.store";

const nftsStore = useNFTsStore();
const accountStore = useAccountStore();

const props = defineProps<{
  project: NFT
  hideBuyButton?: boolean;
}>();

const price = ref<number | null>(null);

onMounted(async () => {
  const buyPrice = await nftsStore.getBuyPrice(props.project.tokenId!);
  price.value = buyPrice.base + buyPrice.royaltyPrice;
})

const emits = defineEmits(['info']);

const bought = computed(() => {
  return props.project.ipfsLink != null;
})

function getThumbnail() {
  return new URL('../public/' + props.project.imageLink, import.meta.url);
}

</script>

<template>
  <div class="card">
    <div class="card-image-container">
      <img :src="getThumbnail().toString()" class="card-image" />
    </div>

    <div class="card-title">
      <h4>{{ props.project?.name }}</h4>
      <p v-if="!props.hideBuyButton && price">{{ nftsStore.convertToEth(price) }}ETH</p>
    </div>

    <div class="card-buttons">
      <RouterLink :to="`/checkout/${props.project?.tokenId}`" v-if="!props.hideBuyButton && !bought">
        <AppButton class="centered" >
          <Icon icon="material-symbols:shopping-cart" />
          Buy
        </AppButton>
      </RouterLink>

      <AppButton @click="emits('info', props.project)" class="centered">
        <Icon icon="ep:info-filled" />
        Info
      </AppButton>
    </div>
  </div>
</template>

<style scoped>
.card {
  width: fit-content;
  padding: 0 0 0.5rem 0;
  background-color: #fff;
  border: #f3f3f3;
  border-radius: 5px;
  flex: 0 1 10%;
  -webkit-box-shadow: 5px 5px 10px 0px #7E7E7E;
  -moz-box-shadow: 5px 5px 10px 0px #7E7E7E;
  -o-box-shadow: 5px 5px 10px 0px #7E7E7E;
  box-shadow: 5px 5px 10px 0px #7E7E7E;
}

.card-image {
  border-radius: 5px 5px 0 0;
  width: 100%;
  height: auto;
  display: block;
  margin-left: auto;
  margin-right: auto;
}

.card-title {
  text-align: center;
  margin: 1rem 0;
  padding: 0 4rem;
}

.card-title h4,
p {
  margin: 0;
  width: 10vw;
}

.card-buttons {
  display: flex;
  width: fit-content;
  margin-left: auto;
  margin-right: auto;
  align-items: center;
  justify-content: center;
  gap: 0.5em;
}
</style>