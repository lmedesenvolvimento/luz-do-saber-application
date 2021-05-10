'use strict';
window.Aside = {
  toggle: function(event){
    var expanded = $('aside').attr('aria-expanded');
    sessionStorage.setItem('asideSession', expanded);
    $('aside').attr('aria-expanded', expanded === 'true' ? 'false' : 'true');
  },
  boostrap: function(){
    var screenWidth = $(document.body).width();

    $('.aside-toggle').click(this.toggle);

    $(".list-group-item").each(function(key, elem){
      var linkTo = $(elem).attr('href');
      var path = window.location.pathname;

      if(/\#/.test(linkTo)){
        return false;
      }
      
      if (path.includes(linkTo)){
        $(elem).addClass('active');
      }
    });

    if (screenWidth > 768){
      var asideSession = sessionStorage.getItem('asideSession')
      if (asideSession === 'false')
        window.Aside.toggle();
    }
  }
}