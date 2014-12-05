function setupCrossRefs()
{
  var crossReferences = document.getElementsByTagName('cref');
  var crossRefId;
  var crossRefText;
  for(var i=0; i<crossReferences.length; i++ ){
  	crossRefId = crossReferences[i].getAttribute('object');
	if(document.getElementById(crossRefId)!=null){
  		crossRefText = document.getElementById(crossRefId).getAttribute('cref');
  		crossReferences[i].innerHTML = ""+crossRefText+"";
	} else {
		crossReferences[i].innerHTML = "???";
	}
  }
}
