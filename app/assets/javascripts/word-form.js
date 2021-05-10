jQuery(function($){
  var hideAll = function(){
    $('.substantivo, .letra').hide();
  }

  var showLetras = function() {
    $('.letra').show();
  }

  var showSubstantivo = function() {
    $('.substantivo').show();
  }

  var showSelected = function() {
    option = $('#word_type').val();

    if (option != 'substantivo_proprio' && option != 'substantivo_comum') {
      showLetras();
    } else {
      showSubstantivo();

    }
  }

  $('#word_type').on('change', function(){
    hideAll()
    showSelected();
  });

  hideAll();
  showSelected();
});
