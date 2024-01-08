var Notices = [];
function getSharedVariable (){
  return Notices;
}

function  setSharedVariable (newValue){
  Notices = newValue;
};
function pushSharedVariable(newValue){
  Notices.push(newValue)
  console.log(Notices)
}
module.exports = {
  getSharedVariable, setSharedVariable,pushSharedVariable
}