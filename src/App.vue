<script setup>
import axios from 'axios';
import {computed, onMounted, ref, watch } from 'vue';
import dayjs from 'dayjs'
import useClipboard from 'vue-clipboard3'

const images = ref([])
const currentDay = ref(new dayjs())
const dayAgo = ref(0)
const canNext = ref(true)
const month = ref(new dayjs().format("YYYYMM"))

const timeToString = (t) => { 
  return new dayjs(t).format("YYYY年MM月DD日")
}

onMounted(() => {
  load()
})

// 点击复制
function touchCopy (text) {
  // 调用
  copy(text)
  ElMessage({
    showClose: false,
    duration:2000,
    message: '图片路径已添加至剪切板',
    type: 'success',
  })
  
}
// 使用插件
const { toClipboard } = useClipboard()
const copy = async (msg) => {
  try {
    // 复制
    await toClipboard(msg)
    // 复制成功
  } catch (e) {
    // 复制失败
  }
}
const changeCarousel = (index) => {
  if (images.value.length <= index + 1) {
    load()
  }
}
const load = () => {
  canNext.value && axios.get(`https://raw.githubusercontent.com/go-bineanshi/crawler-bind-wrapper/main/pictures/${month.value}.json`)
    .then((res) => { 
      if (Object.keys(res.data).length > 0) {
        while (month.value == currentDay.value.subtract(dayAgo.value, "day").format("YYYYMM")) {
          images.value.push(res.data[currentDay.value.subtract(dayAgo.value, "day").format("YYYYMMDD")])
          dayAgo.value += 1
        }
      }
      month.value = new dayjs().subtract(dayAgo.value,"day").format("YYYYMM")
    })
    .catch((res) => { 
      canNext.value = false
    })
    .finally(() => { 

    })
}
</script>

<template>
    <el-carousel :interval="2000" height="100vh" indicator-position="none" arrow="always" @change="changeCarousel">
      <el-carousel-item v-for="(image,key) in images" :key="key">
        <div class="image-main">
          <div class="">
            <div class="title text">
              {{ `${image.title}` }}
            </div>
            <el-image :src="`https://bing.com${image.url}`" fit="contain" class="item-center"  @click="touchCopy(`https://bing.com${image.url}`)"></el-image>
            <div class="footer text">
              {{ `${image.copyright}-${timeToString(image.enddate)}` }}
            </div>
          </div>
       </div>
      </el-carousel-item>
    </el-carousel>
</template>

<style scoped>
  .image-main {
    display:flex;
    height: 100vh;
    justify-items: center;
    align-items: center; /*指定垂直居中*/
    position: relative;
    .title {
      position: absolute;
      padding: 5px 10px;
      color: white;
      top: 10%;
      left: 10px;
      z-index: 1000;
    }
    .footer {
      position: absolute;
      bottom: 5%;
      padding: 5px 10px;
      right: 10px;
    }
    .text::before {
      content: "";
      background-color: rgba(255, 255, 255, 0.5); /* 半透明白色 */
      position: absolute;
      top: 0;
      left: 0;
      bottom: 0;
      right: 0;
      font-size: 20px;
      padding: 10px;
      filter: blur(10px); /* 高斯模糊 */
    }
    .title:hover,.footer:hover {
      font-size: 28px;
      color: white;
      background-color: rgb(152, 152, 152);
      border-radius: 10px;
    }

  }
  :deep .el-carousel__arrow {
    background-color: black
  }
</style>
