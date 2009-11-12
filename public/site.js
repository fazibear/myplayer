window.addEvent('domready', function(){
  var input = $('query');
  var submit = $('submit');

  var search = $('search');
  var similar = $('similar');  
  var player = $('player'); 
  
  var refreshPlayer = function(profile){
    if(!profile) return;
    var url = '/player/'+profile;
    player.empty();
    new Request.HTML({
      url: url,
      method: 'get',
      evalScripts: false,
      onComplete: function(response){
        player.adopt(response);
      }
    }).send()
  }
   
  var refreshSearch = function(query){
    if(!query) return;
    var url = '/search/'+query+'/1';
    search.empty(); 
    search.addClass('loading');
    new Request.HTML({
      url: url,
      method: 'get',
      evalScripts: false,
      onSuccess: function(response1, response2){
      response2.each(function(el){
        if(el.match('a')){
          el.addEvent('click', function(){
            refreshPlayer(el.className);
            return false;
         });
        }
      });
      search.adopt(response1);
      search.removeClass('loading');
      }
    }).send()
  }

  var refreshSimilar = function(query){
    if(!query) return;
    var url = '/similar/'+query;
    similar.empty(); 
    similar.addClass('loading');
    new Request.HTML({
      url: url,
      method: 'get',
      evalScripts: false,
      onComplete: function(response1, response2){
        response2.each(function(el){
          if(el.match('a')){
            el.addEvent('click', function(){
              input.value = el.innerHTML;
              refreshSearch(el.innerHTML);
              refreshSimilar(el.innerHTML); 
          });
          }
        });
        similar.adopt(response1);
        similar.removeClass('loading');
      }
    }).send()
  }
 
  submit.addEvent('click', function(){
    refreshSearch(input.value); 
    refreshSimilar(input.value); 
  });
});
