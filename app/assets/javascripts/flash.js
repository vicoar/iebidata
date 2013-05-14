var Flash = new Object();

Flash.data = {};

Flash.transferFromCookies = function() {
  var data = $.parseJSON(unescape(Cookie.get("flash")));
  if(!data) data = {};
  Flash.data = data;
  Cookie.erase("flash");
};

Flash.writeDataTo = function(name, element) {
  element = $(element);
  var content = "";
  if(Flash.data[name]) {
    content = Flash.data[name].toString().replaceAll(/\+/, ' ');
	element.addClass('ver');
  }
  element.find('.message').html( unescape(content) );
};

