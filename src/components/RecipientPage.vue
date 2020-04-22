<template>
    <div style="margin-top:18%, padding-bottom:50px;">
        <div v-if="is_registered===''">
            <h1>You are not a registered recipient</h1>
            <h1>Register here..</h1>
            Enter your Name:<input v-model="recipient_name" type="text"/><br><br>
            Enter your email:<input v-model="recipient_email" type="text"/><br><br>
            Enter your phone:<input v-model="recipient_phone" type="text"/><br><br>
            <button @click="registerRecipient">Submit</button>
        </div>
        <div v-else>
            <h1>View your certificates</h1>
            <button @click="getRecipientCertificates">Get All Certificates</button>
            <br>
            <div style="margin-top:20px"><span style="color:green" v-if="data_getRecipientCertificates != null"> Cetificate Ids : {{data_getRecipientCertificates.join(", ")}}</span></div><br><br>
          
            <input type="text" v-model="certID" placeholder="Enter certificate id"/>
            <button style="width:200px" @click="getCertificateIdentifier">Get Certificate Ipfshash</button>
            <br><div style="margin-top:20px"><span  style="color:green" v-if="data_getCertificateIdentifier!=null">{{data_getCertificateIdentifier}}  <button @click="downloadCertificate">Download certificate</button> </span></div><br><br>
        </div>
    </div>
</template>

<script>
import CertBlocks from '@/js/certiBlocks'
const ipfs = require('nano-ipfs-store').at('https://ipfs.infura.io:5001')
export default {
  name: 'recipientPage',
  data () {
    return {
      user: null,
      is_registered: null,
      recipient_name: null,
      recipient_email: null,
      recipient_phone: null,
      data_getRecipientCertificates: null,
      data_getProfileDetails: null,
      data_getCertificateIdentifier: null,
      certID: null,
      address_issuer: null,
      data_getIssuer: null,
      data_getIssuerOfCertificate: null
    }
  },
  filters: {
    details (user) {
      return `Name: ${user.recipient_name}, Email: ${user.recipient_email}, Phone: ${user.recipient_phone}`
    }
  },
  beforeCreate: function () {
    CertBlocks.init().then(() => {
      console.log('contract: ' + CertBlocks.contract.address)
      console.log('user: ' + window.web3.eth.accounts[0])
      this.user = window.web3.eth.accounts[0]
      CertBlocks.getRecipient(this.user).then((ans) => {
        this.is_registered = ans
      })
    }).catch(err => {
      console.log(err)
    })
  },
  methods: {
    registerRecipient: function () {
      let data = JSON.stringify({'recipient_name': this.recipient_name, 'recipient_email': this.recipient_email, 'recipient_phone': this.recipient_phone})
      console.log(data)
      ipfs.add(data).then(ipfsHash => {
        console.log(ipfsHash)
        CertBlocks.registerRecipient(ipfsHash).then(tx => {
          console.log(tx)
          alert('Recipient registered')
          this.is_registered = true
        })
      })
    },
    getRecipientCertificates: function () {
      var vm = this
      CertBlocks.getRecipientCertificates().then((tx) => {
        vm.data_getRecipientCertificates = tx
        console.log(JSON.stringify(this.data_getRecipientCertificates))
      })
    },
    getCertificateIdentifier: function () {
      console.log(this.certID)
      try {
        CertBlocks.getCertificateIdentifier(this.certID).then((tx) => {
          this.data_getCertificateIdentifier = tx
          console.log(this.data_getCertificateIdentifier)
        })
      } catch (err) {
        this.data_getCertificateIdentifier = null
      }
    },
    downloadCertificate: function () {
      if (this.data_getCertificateIdentifier != null) {
        ipfs.cat(this.data_getCertificateIdentifier).then((data) => {
          console.log(data)
          var a = document.createElement('a')
          a.href = data
          a.download = ''
          a.click()
        })
      }
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
