var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
var player;
var seconds = 0;
var size = 'medium'

function onYouTubeIframeAPIReady() {
  player = new YT.Player('player', {
    height: '405',
    width: '720',
    videoId: videoId,
    events: {
      'onReady': onPlayerReady,
      'onPlaybackQualityChange': onPlayerPlaybackQualityChange,
      'onStateChange': onPlayerStateChange,
      'onError': onPlayerError
    }
  });
}

function onPlayerReady(event) {
}

function onPlayerPlaybackQualityChange(event) {
}
function onPlayerStateChange(event) {
}
function onPlayerError(event) {
}

function seek(half, sec, videoId){
  if(player){
    if(half==1){
      player.seekTo(sec+firstHalf, true);
    } else {
      player.seekTo(sec+secondHalf, true);
    }
    //player.loadVideoById({videoId:String,startSeconds:Number,endSeconds:Number,suggestedQuality:String}):Void
  }
}

function reverse(){
  if(player){
    seconds = player.getCurrentTime() - 15;
    player.seekTo(seconds, true);
  }
}

function forward(){
  if(player){
    seconds = player.getCurrentTime() + 15;
    player.seekTo(seconds, true);
  }
}

function changeSize(){
  if(player){
    switch (size) {
      case "medium":
        player.setSize(720,405)
        size = "small"
        break;
      case "small":
        player.setSize(480,270)
        size = "large"
        break;
        case "large":
          player.setSize(1200,675)
          size = "medium"
          break;
      default:
        player.setSize(720,405)
        size = "medium"
    }
  }
}
