import contract from 'truffle-contract'
// import * as Ganache from 'ganache-core';
import CertiBlocksContract from '@contracts/CertiBlocks.json'

const CertiBlocks = {

  contract: null,

  instance: null,

  // Initialize

  init: function () {
    let self = this

    return new Promise(function (resolve, reject) {
      self.contract = contract(CertiBlocksContract)
      self.contract.setProvider(window.web3.currentProvider)
      self.contract.deployed().then(instance => {
        self.instance = instance
        resolve()
      }).catch(err => {
        reject(err)
      })
    })
  },

  // Setters

  // registerIssuer: function (hash) {
  //   let self = this
  //   return new Promise((resolve, reject) => {
  //     self.instance.AddNewIssuerAuthority(
  //       0x1369D3Ad3f1EAc91A1D09103139539Dc346A0f44, 'testing',
  //       {from: window.web3.eth.accounts[0]}
  //     ).then(tx => {
  //       resolve(tx)
  //     }).catch(err => {
  //       reject(err)
  //     })
  //   })
  // },

  registerAuthority: function (data) {
    let self = this
    return new Promise((resolve, reject) => {
      debugger
      self.instance.AddNewIssuerAuthority(
        data.addressOfAuthority,
        data.details,
        {from: window.web3.eth.accounts[0]}
      ).then(tx => {
        debugger
        resolve(tx)
      }).catch(err => {
        reject(err)
      })
    })
  },

  registerIssuer: function (data) {
    let self = this
    return new Promise((resolve, reject) => {
      self.instance.AddNewCertificateIssuer(
        data.addressOfIssuer,
        data.details,
        {from: window.web3.eth.accounts[0]}
      ).then(tx => {
        debugger
        resolve(tx)
      }).catch(err => {
        debugger
        reject(err)
      })
    })
  },

  registerRecipient: function (data) {
    let self = this
    return new Promise((resolve, reject) => {
      self.instance.AddNewReceiver(
        data.addressOfRecepient,
        data.details,
        {from: window.web3.eth.accounts[0]}
      ).then(tx => {
        resolve(tx)
      }).catch(err => {
        reject(err)
      })
    })
  },

  registerCertificate: function (data) {
    let self = this
    debugger
    return new Promise((resolve, reject) => {
      self.instance.AddNewCertificate(
        data._recipient,
        data._ipfsHash,
        data._sha256Value,
        data._expiryDate,
        data._notes,
        {from: window.web3.eth.accounts[0]}
      ).then(tx => {
        resolve(tx)
      }).catch(err => {
        reject(err)
      })
    })
  },

  issueCertificate: function (address, hash) {
    let self = this
    return new Promise((resolve, reject) => {
      self.instance.issueCertificate(
        address, hash,
        {from: window.web3.eth.accounts[0]}
      ).then(tx => {
        resolve(tx)
      }).catch(err => {
        reject(err)
      })
    })
  },

  // Getters

  getIssuerOfCertificate: function (hash) {
    let self = this

    return new Promise((resolve, reject) => {
      self.instance.getIssuerOfCertificate.call(
        hash,
        {from: window.web3.eth.accounts[0]}
      ).then(tx => {
        resolve(tx)
      }).catch(err => {
        reject(err)
      })
    })
  },

  getIssuer: function (address) {
    let self = this

    return new Promise((resolve, reject) => {
      self.instance.getIssuer.call(
        address,
        {from: window.web3.eth.accounts[0]}
      ).then(tx => {
        resolve(tx)
      }).catch(err => {
        reject(err)
      })
    })
  },

  getRecipient: function (address) {
    let self = this

    return new Promise((resolve, reject) => {
      self.instance.getRecipient.call(
        address,
        {from: window.web3.eth.accounts[0]}
      ).then(tx => {
        resolve(tx)
      }).catch(err => {
        reject(err)
      })
    })
  },

  getAllRecipientOfCertificate: function (hash) {
    let self = this

    return new Promise((resolve, reject) => {
      self.instance.getAllRecipientOfCertificate.call(
        hash,
        {from: window.web3.eth.accounts[0]}
      ).then(tx => {
        resolve(tx)
      }).catch(err => {
        reject(err)
      })
    })
  },

  getRecipientCertificates: function (address) {
    let self = this

    return new Promise((resolve, reject) => {
      self.instance.getReceivedCertificates.call(
        {from: window.web3.eth.accounts[0]}
      ).then(tx => {
        resolve(tx)
      }).catch(err => {
        reject(err)
      })
    })
  },

  getIssuerCertificates: function (address) {
    let self = this

    return new Promise((resolve, reject) => {
      self.instance.getIssuerCertificates.call(
        address,
        {from: window.web3.eth.accounts[0]}
      ).then(tx => {
        resolve(tx)
      }).catch(err => {
        reject(err)
      })
    })
  },

  getCertificateIdentifier: function (id) {
    let self = this
    return new Promise((resolve, reject) => {
      self.instance.getCertificateIPFSHashById.call(
        id,
        {from: window.web3.eth.accounts[0]}
      ).then(tx => {
        resolve(tx)
      }).catch(err => {
        reject(err)
      })
    })
  },

  // Events

  eventIssuerRegistered: function (address) {
    let self = this
    return new Promise((resolve, reject) => {
      console.log('at eventIssuerRegistered')
      let issuerRegisteredEvent = self.instance.IssuerRegistered({issuer: address}, {fromBlock: 0, toBlock: 'latest'})
      issuerRegisteredEvent.get((err, res) => {
        if (err) {
          reject(err)
        } else {
          resolve(res)
          console.log(res)
        }
      })
    })
  },
  eventRecipientRegistered: function (address) {
    let self = this
    return new Promise((resolve, reject) => {
      let recipientRegisteredEvent = self.instance.RecipientRegistered({recipient: address}, {fromBlock: 0, toBlock: 'latest'})
      recipientRegisteredEvent.get((err, res) => {
        if (err) {
          reject(err)
        } else {
          resolve(res)
        }
      })
    })
  },
  eventCertificateRegistered: function (address) {
    let self = this
    return new Promise((resolve, reject) => {
      let certificateRegisteredEvent = self.instance.CertificateRegistered({issuer: address}, {fromBlock: 0, toBlock: 'latest'})
      certificateRegisteredEvent.get((err, res) => {
        if (err) {
          reject(err)
        } else {
          resolve(res)
        }
      })
    })
  },
  eventCertificateIssuedByCertificate: function (id) {
    let self = this
    return new Promise((resolve, reject) => {
      let eventCertificateIssuedByCertificateEvent = self.instance.CertificateIssued({certificate: id}, {fromBlock: 0, toBlock: 'latest'})
      eventCertificateIssuedByCertificateEvent.get((err, res) => {
        if (err) {
          reject(err)
        } else {
          resolve(res)
        }
      })
    })
  },
  eventCertificateIssuedByIssuer: function (address) {
    let self = this
    return new Promise((resolve, reject) => {
      let eventCertificateIssuedByIssuerEvent = self.instance.CertificateIssued({issuer: address}, {fromBlock: 0, toBlock: 'latest'})
      eventCertificateIssuedByIssuerEvent.get((err, res) => {
        if (err) {
          reject(err)
        } else {
          resolve(res)
        }
      })
    })
  },
  eventCertificateIssuedByRecipient: function (address) {
    let self = this
    return new Promise((resolve, reject) => {
      let eventCertificateIssuedByRecipientEvent = self.instance.CertificateIssued({recipient: address}, {fromBlock: 0, toBlock: 'latest'})
      eventCertificateIssuedByRecipientEvent.get((err, res) => {
        if (err) {
          reject(err)
        } else {
          resolve(res)
        }
      })
    })
  }
}

export default CertiBlocks
