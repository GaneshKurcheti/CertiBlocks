<template>
  <div id="app" style="padding-bottom:50px;">
    
      <div class="nav-bar" bis_skin_checked="1"><a class="logo-text" href="/home">
      CertiBlocks</a>
      <router-link to="/" class="nav-element">Home Page</router-link>
      <router-link to="/authority" class="nav-element">Authority</router-link>
      <router-link to="/issuerPage" class="nav-element">Issuer</router-link>
      <router-link to="/recipientPage" class="nav-element">Recipient</router-link>
      
      </div>
      <!-- <table>
        <tr>
          <td><router-link to="/" style="color: #58dba0;">Home Page</router-link></td>
          <td><router-link to="/issuerPage" style="color: #58dba0;">Issuer Page</router-link></td>
          <td><router-link to="/recipientPage" style="color: #58dba0;">Recipient Page</router-link></td>
          <td><router-link to="/eventsPage" style="color: #58dba0;">Events</router-link></td>
      </tr> -->
      <!-- </table> -->
      
    <router-view></router-view>
    
  </div>
</template>

<script>
export default {
  name: 'app'
}
</script>

<style>
.logo-text, .nav-element {
    font-size: 1rem;
    font-weight: 700;
    font-family: Raleway,sans-serif;
    text-decoration: none;
    display: -webkit-flex;
    display: flex;
    -webkit-align-items: center;
    align-items: center;
}
input[type=text]{
    outline: none;
    width: 35%;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
    height: 22px;
    border-radius: 10px;
}
input[type=date]{
    outline: none;
    width: 10%;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
    height: 22px;
    border-radius: 10px;
}
button{
    background: #007c56;
    height: 43px;
    width: 160px;
    border-radius: 10px;
    color: white;
    font-weight: bold;
}
.nav-element {
    color: #efefef;
    margin-right: 20px;
    letter-spacing: 1px;
    word-wrap: break-word;
}
.logo-text {
    color: #fff;
    letter-spacing: 3px;
    margin-right: auto;
    margin-left: 15px;
}
.nav-bar {
    overflow-x:hidden;
    /* position: fixed; */
    background: #232624;
    display: -webkit-flex;
    display: flex;
    padding-right: 20px;
    /* width: 100%; */
    z-index: 99;
    height: 50px;
}
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  /* margin-top: 48px; */
  width: 100%;
  height: 100%;
}
</style>
