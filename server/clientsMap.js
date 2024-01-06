var clientsMap = new Map();
function getSharedVariable (){
  return clientsMap;
}

function  setSharedVariable (newValue){
  clientsMap = newValue;
};
module.exports = {
  getSharedVariable, setSharedVariable
}