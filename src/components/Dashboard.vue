<template>
  <div id="outer">
    <div>
      <img style="width:130px;height:100px;margin-top:100px" src="../assets/uf-university-of-florida.png" >
    </div>
    <h1>CertiBlocks </h1>
    <div>Certificates stored and validated in Blockchain</div>
    
    <div id="inner" style="">
      <p style="color:#2c3e50">CertiBlocks uses Ethereum blockchain to keep a record of all your certificates, and makes them permanent.</p><br>
      <div >
      <div>
      <router-link to="/authority"><button>Authority page</button></router-link>
      <router-link to="/recipientPage"><button>Recipient page </button></router-link>
      <router-link to="/issuerPage"><button>Issuer page</button></router-link>
      </div>
      </div>
    </div>
    <div>
    <div style="display:flex;margin-top:100px">
    <div style="float:left;text-align:left;margin-left:10px;">
      <div style="color:#007c56;width:215px;font-weight:bold;border-bottom:2px solid">Designed and developed by</div>
      <div style="margin-top:10px">Naga Ganesh Singh Kurcheti (1997-6921)</div>
      <div style="margin-top:5px">Madhuree Latha Allam (9468-1443)</div>
      <div style="margin-top:5px">Yugender Reddy Vadyala (5530-9071)</div>
      <div style="margin-top:5px">Abhiram Reddy Gangasani (3153-1365)</div>
    </div>
    <div style="margin-left:auto;text-align:right">
      <div style="color:#007c56;font-weight:bold;border-bottom:2px solid;margin-right:10px">Under the guidence of </div>
      <div style="margin-top:10px;margin-right:10px">My Thai</div>
      <div style="margin-top:10px;margin-right:10px">Truc Nguyen</div>
    </div>
    </div>
    </div>
  </div>
</template>
<script>
</script>
<style scoped>

#inner {
    width: 100%;

}
#outer {
    overflow: auto;
}

p {
  font-size: 25px;
  font-weight: bold;
  color: #2e7a58;
}
</style>
