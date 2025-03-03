
<template>
   <img :src="image" alt="Logo"  class="xpens-logo"/>
   <h1>Xpens </h1>
   <div>v{{ config?.currentVersion }}</div>
   <a class="download-link" href="app-release.apk">Download App</a>
</template>


<script >

export default {
  data() {
    return {
      config: null,
      image:"release.png"
    };
  },
  async mounted() {
    try {
      const response = await fetch("./version.json");
      
      this.config = await response.json();
    } catch (error) {
      console.error("Error loading JSON:", error);
    }
  }
};
</script>

  
