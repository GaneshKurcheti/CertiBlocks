<template>
    <div style="margin-top:5%; padding-bottom:50px;">
        <div >
          <h1></h1>
            <h1>Register new recipient here..</h1>
            Enter address :<input v-model="recipient_addr" type="text"/><br><br>
            enter details  :<input v-model="recipient_detail" type="text"/><br><br>
            <button @click="registerRecipient">Submit</button>
        </div>
         <div >
          <h1></h1>
            <h1>Register new certificate here..</h1>
            upload document : <input @change="onFileChange" type="file"/><br><br>
            Enter address :<input v-model="cert_recipient_addr" type="text"/><br><br>
            Expiry date :<input v-model="cert_expiry" type="date"/><br><br>
            Enter notes :<textarea rows="4" cols="50" v-model="cert_notes" type="textarea"/><br><br>
            sha hash  :<input v-model="cert_SHA256" type="text" style="width:500px" disabled/><br><br>
            ipfs hash  :<input v-model="cert_ipfs" type="text" style="width:500px" disabled/><br><br>
            <button @click="registerCertificate">Submit</button>
        </div>
    </div>
</template>

<script>
import CertBlocks from '@/js/certiBlocks'
import CryptoJS from 'crypto-js'
const ipfs = require('nano-ipfs-store').at('https://ipfs.infura.io:5001')
export default {
  name: 'issuerPage',
  data () {
    return {
      is_registered: null,
      cert_expiry: null,
      cert_notes: null,
      cert_ipfs: null,
      certificate_doc: null,
      cert_recipient_addr: null,
      cert_SHA256: null,
      recipient_addr: null,
      recipient_detail: null
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
      CertBlocks.getIssuerDetails(this.user).then((ans) => {
        this.is_registered = false
      })
    }).catch(err => {
      console.log(err)
    })
  },
  methods: {
    onFileChange (e) {
      var files = e.target.files || e.dataTransfer.files
      if (!files.length) {
        return
      }
      this.createImage(files[0])
    },

    createImage (file) {
      var reader = new FileReader()
      var vm = this

      reader.onload = (e) => {
        vm.certificate_doc = e.target.result
        var encrypted = CryptoJS.SHA256(e.target.result)
        vm.cert_SHA256 = encrypted
        console.log('encrypted: ' + encrypted)
      }
      reader.readAsDataURL(file)
    },
    registerRecipient: function () {
      let data = {'addressOfRecepient': this.recipient_addr, 'details': this.recipient_detail}
      console.log(data)
      CertBlocks.registerRecipient(data).then(tx => {
        console.log(tx)
        alert('recipient registered')
        this.is_registered = true
      })
    },
    registerCertificate: function () {
      var vm = this
      ipfs.add(this.certificate_doc).then(ipfsHash => {
        console.log(ipfsHash)
        vm.cert_ipfs = ipfsHash
        let data = {'_recipient': this.cert_recipient_addr, '_ipfsHash': this.cert_ipfs, '_sha256Value': this.cert_SHA256.toString(), '_expiryDate': Date.parse(this.cert_expiry), '_notes': this.cert_notes}
        console.log(data)
        CertBlocks.registerCertificate(data).then(tx => {
          console.log(tx)
          alert('recipient registered')
          this.is_registered = true
        })
      })
    },
    issueCertificate: function () {
      CertBlocks.issueCertificate(this.address_recipient, this.cert_hash).then(tx => {
        console.log(tx)
        alert('Certificate issued')
      })
    },
    getRecipient: function () {
      CertBlocks.getRecipient(this.view_address_recipient).then((tx) => {
        ipfs.cat(tx).then((data) => {
          this.data_getRecipient = JSON.parse(data)
          console.log(JSON.stringify(this.data_getRecipient))
        })
      })
    },
    getIssuerCertificates: function () {
      CertBlocks.getIssuerCertificates(this.user).then((tx) => {
        this.all_certs = tx
      })
    },
    getCertificateIdentifier: function () {
      console.log(this.certID)
      CertBlocks.getCertificateIdentifier(this.certID).then((tx) => {
        if (tx[0] !== '') {
          this.data_getCertificateIdentifier = tx
        }
        console.log(this.data_getCertificateIdentifier)
      })
    },
    getAllRecipientOfCertificate: function () {
      console.log('here')
      CertBlocks.getAllRecipientOfCertificate(this.view_cert_hash).then((tx) => {
        this.data_getAllRecipientOfCertificate = tx
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
