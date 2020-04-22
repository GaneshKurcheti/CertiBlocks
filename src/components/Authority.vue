<template>
    <div style="margin-top:18%, padding-bottom:50px;">
        <div v-if="is_registered!==''">
            <h1></h1>
            <h1>Register new authority here..</h1>
            <label>Enter address :</label><input v-model="authority_addr" type="text"/><br><br>
            <label>enter details  :</label><input v-model="authority_detail" type="text"/><br><br>
            <button @click="registerAuthority">Submit</button>
        </div>

        <div v-if="is_registered!==''">
            <h1></h1>
            <h1>Register new issuer here..</h1>
            <label>Enter address :</label><input v-model="issuer_addr" type="text"/><br><br>
            <label>enter details  :</label><input v-model="issuer_detail" type="text"/><br><br>
            <button @click="registerIssuer">Submit</button>
        </div>

         <div v-if="is_registered!==''">
            <h1></h1>
            <h1>Register new recipient here..</h1>
            <label>Enter address :</label><input v-model="recipient_addr" type="text"/><br><br>
            <label>enter details  :</label><input v-model="recipient_detail" type="text"/><br><br>
            <button @click="registerRecipient">Submit</button>
        </div>
    </div>
</template>

<script>
import CertBlocks from '@/js/certiBlocks'
export default {
  name: 'recipientPage',
  data () {
    return {
      is_registered: null,
      authority_addr: null,
      authority_detail: null,
      issuer_addr: null,
      issuer_detail: null,
      recipient_addr: null,
      recipient_detail: null
    }
  },
  beforeCreate: function () {
    CertBlocks.init().then(() => {
      console.log('contract: ' + CertBlocks.contract.address)
      console.log('user: ' + window.web3.eth.accounts[0])
      this.user = window.web3.eth.accounts[0]
      this.is_registered = 'killer'
    }).catch(err => {
      console.log(err)
    })
  },
  methods: {
    registerAuthority: function () {
      let data = {'addressOfAuthority': this.authority_addr, 'details': this.authority_detail}
      CertBlocks.registerAuthority(data).then(tx => {
        alert('authority registered')
        this.is_registered = true
      })
    },

    registerIssuer: function () {
      let data = {'addressOfIssuer': this.issuer_addr, 'details': this.issuer_detail}
      CertBlocks.registerIssuer(data).then(tx => {
        alert('issuer registered')
        this.is_registered = true
      })
    },

    registerRecipient: function () {
      let data = {'addressOfRecepient': this.recipient_addr, 'details': this.recipient_detail}
      CertBlocks.registerRecipient(data).then(tx => {
        alert('recipient registered')
        this.is_registered = true
      })
    }
  }
}
</script>

<style scoped>
span {
    color: white;
    font-weight: bold;
    font-size: 25px;
}
</style>
